#!/usr/bin/env node
/**
 * Build script for /tg/station 13 codebase.
 *
 * This script uses Juke Build, read the docs here:
 * https://github.com/stylemistake/juke-build
 */

import Bun from "bun";
import fs from "node:fs";
import Juke from "./juke/index.js";
import { bun, bun_tgfont } from "./lib/bun";
import { DreamDaemon, DreamMaker, NamedVersionFile } from "./lib/byond";
import { downloadFile } from "./lib/download";
import { formatDeps } from "./lib/helpers";
import { prependDefines } from "./lib/tgs";

export const TGS_MODE = process.env.CBT_BUILD_MODE === "TGS";

export const DME_NAME = "roguetown";
const BrowserPanelHiddenVerbsFile = "code/_globalvars/browserpanel_hidden_verbs.dm";

Juke.chdir("../..", import.meta.url);

const dependencies: Record<string, any> = await Bun.file("dependencies.sh")
  .text()
  .then(formatDeps)
  .catch((err) => {
    Juke.logger.error(
      "Failed to read dependencies.sh, please ensure it exists and is formatted correctly.",
    );
    Juke.logger.error(err);
    throw new Juke.ExitCode(1);
  });

export const DefineParameter = new Juke.Parameter({
  type: "string[]",
  alias: "D",
});

export const PortParameter = new Juke.Parameter({
  type: "string",
  alias: "p",
});

export const DmVersionParameter = new Juke.Parameter({
  type: "string",
});

export const CiParameter = new Juke.Parameter({ type: "boolean" });

export const ForceRecutParameter = new Juke.Parameter({
  type: "boolean",
  name: "force-recut",
});

export const WarningParameter = new Juke.Parameter({
  type: "string[]",
  alias: "W",
});

export const NoWarningParameter = new Juke.Parameter({
  type: "string[]",
  alias: "I",
});

export const DmMapsIncludeTarget = new Juke.Target({
  executes: async () => {
    const folders = [
      ...Juke.glob("_maps/map_files/**/*.dmm"),
      ...Juke.glob("_maps/map_files/templates/**/*.dmm"),
    ];
    const content =
      folders
        .map((file) => file.replace("_maps/", ""))
        .map((file) => `#include "${file}"`)
        .join("\n") + "\n";
    fs.writeFileSync("_maps/templates.dm", content);
  },
});

export const DungeonGeneratorIncludeTarget = new Juke.Target({
  executes: async () => {
    const folders = [
      ...Juke.glob("_maps/dungeon_generator/**/*.dmm"),
    ];
    const content =
      folders
        .map((file) => file.replace("_maps/", ""))
        .map((file) => `#include "${file}"`)
        .join("\n") + "\n";
    fs.writeFileSync("_maps/dungeons.dm", content);
  }
})

function pathAtIndent(pathStack: Array<{ indent: number; path: string }>, indent: number): string {
  for (let i = pathStack.length - 1; i >= 0; i--) {
    if (pathStack[i].indent < indent) {
      return pathStack[i].path;
    }
  }
  return "";
}

function normalizeDmPath(path: string, parentPath = ""): string {
  if (path.startsWith("/")) {
    return path;
  }
  if (!parentPath) {
    return `/${path}`;
  }
  return `${parentPath}/${path}`;
}

function generateBrowserPanelHiddenVerbs(): void {
  const hiddenVerbs = new Set<string>();
  const definitionPattern = /^(?:(\/?[A-Za-z_][\w]*(?:\/[A-Za-z_][\w]*)*)\/)?(proc|verb)\/([A-Za-z_][\w]*)\s*\(/;
  const typePattern = /^(\/?[A-Za-z_][\w]*(?:\/[A-Za-z_][\w]*)+)\s*$/;
  const hiddenPattern = /^set\s+hidden\s*=\s*(TRUE|FALSE|1|0)\b/i;

  for (const file of [...Juke.glob("code/**/*.dm"), ...Juke.glob("modular/**/*.dm")]) {
    if (file.replace(/\\/g, "/") === BrowserPanelHiddenVerbsFile) {
      continue;
    }

    const lines = fs.readFileSync(file, "utf-8").split(/\r?\n/);
    const pathStack: Array<{ indent: number; path: string }> = [];
    let currentProc: { indent: number; path: string; hidden: boolean | null } | null = null;

    for (const rawLine of lines) {
      const uncommented = rawLine.replace(/\/\/.*$/, "");
      if (!uncommented.trim() || uncommented.trimStart().startsWith("#")) {
        continue;
      }

      const indent = rawLine.match(/^\s*/)?.[0].length ?? 0;
      const trimmed = uncommented.trim();

      if (currentProc && indent <= currentProc.indent) {
        if (currentProc.hidden) {
          hiddenVerbs.add(currentProc.path);
        }
        currentProc = null;
      }

      while (pathStack.length && pathStack[pathStack.length - 1].indent >= indent) {
        pathStack.pop();
      }

      const definitionMatch = trimmed.match(definitionPattern);
      if (definitionMatch) {
        const parentPath = definitionMatch[1]
          ? normalizeDmPath(definitionMatch[1], pathAtIndent(pathStack, indent))
          : pathAtIndent(pathStack, indent);
        const procPath = `${parentPath}/${definitionMatch[2]}/${definitionMatch[3]}`;
        currentProc = { indent, path: procPath, hidden: null };
        continue;
      }

      if (currentProc) {
        const hiddenMatch = trimmed.match(hiddenPattern);
        if (hiddenMatch) {
          currentProc.hidden = /^(TRUE|1)$/i.test(hiddenMatch[1]);
        }
        continue;
      }

      const typeMatch = trimmed.match(typePattern);
      if (typeMatch && !trimmed.includes("=")) {
        pathStack.push({
          indent,
          path: normalizeDmPath(typeMatch[1], pathAtIndent(pathStack, indent)),
        });
      }
    }

    if (currentProc?.hidden) {
      hiddenVerbs.add(currentProc.path);
    }
  }

  const hiddenVerbEntries = [...hiddenVerbs].sort().map((verbPath) => `\t"${verbPath}" = TRUE,`);
  fs.writeFileSync(
    BrowserPanelHiddenVerbsFile,
    `// This file is generated by tools/build/build.ts.\nGLOBAL_LIST_INIT(browserpanel_hidden_verbs, list(\n${hiddenVerbEntries.join("\n")}\n))\n`,
  );
}

export const BrowserPanelHiddenVerbsTarget = new Juke.Target({
  inputs: ["code/**/*.dm", "modular/**/*.dm"],
  outputs: [],
  executes: generateBrowserPanelHiddenVerbs,
});

export const DmTarget = new Juke.Target({
  parameters: [
    DefineParameter,
    DmVersionParameter,
    WarningParameter,
    NoWarningParameter,
  ],
  dependsOn: ({ get }) => [
    BrowserPanelHiddenVerbsTarget,
    get(DefineParameter).includes("ALL_TEMPLATES") && DmMapsIncludeTarget,
    get(DefineParameter).includes("ALL_DUNGEONS") && DungeonGeneratorIncludeTarget,
  ],
  inputs: [
    "_maps/**",
    "code/**",
    "html/**",
    "icons/**",
    "interface/**",
    "sound/**",
    "tgui/public/tgui.html",
    "modular/**",
    `${DME_NAME}.dme`,
    NamedVersionFile,
  ],
  outputs: ({ get }) => {
    if (get(DmVersionParameter)) {
      return []; // Always rebuild when dm version is provided
    }
    return [`${DME_NAME}.dmb`, `${DME_NAME}.rsc`];
  },
  executes: async ({ get }) => {
    await DreamMaker(`${DME_NAME}.dme`, {
      defines: ["CBT", ...get(DefineParameter)],
      warningsAsErrors: get(WarningParameter).includes("error"),
      ignoreWarningCodes: get(NoWarningParameter),
      namedDmVersion: get(DmVersionParameter),
    });
  },
});

export const DmTestTarget = new Juke.Target({
  parameters: [
    DefineParameter,
    DmVersionParameter,
    WarningParameter,
    NoWarningParameter,
  ],
  dependsOn: ({ get }) => [
    BrowserPanelHiddenVerbsTarget,
    get(DefineParameter).includes("ALL_MAPS") && DmMapsIncludeTarget,
  ],
  executes: async ({ get }) => {
    fs.copyFileSync(`${DME_NAME}.dme`, `${DME_NAME}.test.dme`);
    await DreamMaker(`${DME_NAME}.test.dme`, {
      defines: ["CBT", "CIBUILDING", ...get(DefineParameter)],
      warningsAsErrors: get(WarningParameter).includes("error"),
      ignoreWarningCodes: get(NoWarningParameter),
      namedDmVersion: get(DmVersionParameter),
    });
    Juke.rm("data/logs/ci", { recursive: true });
    const options = {
      dmbFile: `${DME_NAME}.test.dmb`,
      namedDmVersion: get(DmVersionParameter),
    };
    await DreamDaemon(
      options,
      "-close",
      "-trusted",
      "-verbose",
      "-params",
      "log-directory=ci",
    );
    Juke.rm("*.test.*");
    try {
      const cleanRun = fs.readFileSync("data/logs/ci/clean_run.lk", "utf-8");
      console.log(cleanRun);
    } catch (err) {
      Juke.logger.error("Test run was not clean, exiting");
      throw new Juke.ExitCode(1);
    }
  },
});

export const BunTarget = new Juke.Target({
  parameters: [CiParameter],
  inputs: ["tgui/**/package.json"],
  executes: () => {
    return bun("install", "--frozen-lockfile", "--ignore-scripts");
  },
});

export const TgFontTarget = new Juke.Target({
  dependsOn: [BunTarget],
  inputs: [
    "tgui/packages/tgfont/**/*.+(js|mjs|svg)",
    "tgui/packages/tgfont/package.json",
  ],
  outputs: [
    "tgui/packages/tgfont/dist/tgfont.css",
    "tgui/packages/tgfont/dist/tgfont.woff2",
  ],
  executes: async () => {
    await bun_tgfont("tgfont:build");
    fs.mkdirSync("tgui/packages/tgfont/static", { recursive: true });
    fs.copyFileSync(
      "tgui/packages/tgfont/dist/tgfont.css",
      "tgui/packages/tgfont/static/tgfont.css",
    );
    fs.copyFileSync(
      "tgui/packages/tgfont/dist/tgfont.woff2",
      "tgui/packages/tgfont/static/tgfont.woff2",
    );
  },
});

export const TguiTarget = new Juke.Target({
  dependsOn: [BunTarget],
  inputs: [
    "tgui/rspack.config.mjs",
    "tgui/**/package.json",
    "tgui/packages/**/*.+(js|cjs|ts|tsx|jsx|scss)",
  ],
  outputs: [
    "tgui/public/tgui.bundle.css",
    "tgui/public/tgui.bundle.js",
    "tgui/public/tgui-panel.bundle.css",
    "tgui/public/tgui-panel.bundle.js",
    "tgui/public/tgui-say.bundle.css",
    "tgui/public/tgui-say.bundle.js",
  ],
  executes: () => bun("tgui:build"),
});

export const TguiEslintTarget = new Juke.Target({
  parameters: [CiParameter],
  dependsOn: [BunTarget],
  executes: ({ get }) => bun("tgui:lint", !get(CiParameter) && "--fix"),
});

export const TguiPrettierTarget = new Juke.Target({
  dependsOn: [BunTarget],
  executes: () => bun("tgui:prettier"),
});

export const TguiSonarTarget = new Juke.Target({
  dependsOn: [BunTarget],
  executes: () => bun("tgui:sonar"),
});

export const TguiTscTarget = new Juke.Target({
  dependsOn: [BunTarget],
  executes: () => bun("tgui:tsc"),
});

export const TguiTestTarget = new Juke.Target({
  parameters: [CiParameter],
  dependsOn: [BunTarget],
  executes: () => bun("tgui:test"),
});

export const TguiLintTarget = new Juke.Target({
  dependsOn: [BunTarget, TguiPrettierTarget, TguiEslintTarget, TguiTscTarget],
});

export const TguiDevTarget = new Juke.Target({
  dependsOn: [BunTarget],
  executes: ({ args }) => bun("tgui:dev", ...args),
});

export const TguiAnalyzeTarget = new Juke.Target({
  dependsOn: [BunTarget],
  executes: () => bun("tgui:analyze"),
});

export const TguiBenchTarget = new Juke.Target({
  dependsOn: [BunTarget],
  executes: () => bun("tgui:bench"),
});

export const TestTarget = new Juke.Target({
  dependsOn: [DmTestTarget, TguiTestTarget],
});

export const LintTarget = new Juke.Target({
  dependsOn: [TguiLintTarget],
});

export const BuildTarget = new Juke.Target({
  dependsOn: [TguiTarget, DmTarget],
});

export const ServerTarget = new Juke.Target({
  parameters: [DmVersionParameter, PortParameter],
  dependsOn: [BuildTarget],
  executes: async ({ get }) => {
    const port = get(PortParameter) || "1337";
    const options = {
      dmbFile: `${DME_NAME}.dmb`,
      namedDmVersion: get(DmVersionParameter),
    };
    await DreamDaemon(options, port, "-trusted");
  },
});

export const AllTarget = new Juke.Target({
  dependsOn: [TestTarget, LintTarget, BuildTarget],
});

export const TguiCleanTarget = new Juke.Target({
  executes: async () => {
    Juke.rm("tgui/public/.tmp", { recursive: true });
    Juke.rm("tgui/public/*.map");
    Juke.rm("tgui/public/*.{chunk,bundle,hot-update}.*");
    Juke.rm("tgui/packages/tgfont/dist", { recursive: true });
    Juke.rm("tgui/node_modules", { recursive: true });
  },
});

export const CleanTarget = new Juke.Target({
  dependsOn: [TguiCleanTarget],
  executes: async () => {
    Juke.rm("*.{dmb,rsc}");
    Juke.rm("_maps/templates.dm");
  },
});

/**
 * Removes more junk at the expense of much slower initial builds.
 */
export const CleanAllTarget = new Juke.Target({
  dependsOn: [CleanTarget],
  executes: async () => {
    Juke.logger.info("Cleaning up data/logs");
    Juke.rm("data/logs", { recursive: true });
  },
});

export const TgsTarget = new Juke.Target({
  dependsOn: [TguiTarget],
  executes: async () => {
    Juke.logger.info("Prepending TGS define");
    prependDefines("TGS");
  },
});

Juke.setup({ file: import.meta.url }).then((code) => {
  // We're using the currently available quirk in Juke Build, which
  // prevents it from exiting on Windows, to wait on errors.
  if (code !== 0 && process.argv.includes("--wait-on-error")) {
    Juke.logger.error("Please inspect the error and close the window.");
    return;
  }

  if (TGS_MODE) {
    // workaround for ESBuild process lingering
    // Once https://github.com/privatenumber/esbuild-loader/pull/354 is merged and updated to, this can be removed
    setTimeout(() => process.exit(code), 10000);
  } else {
    process.exit(code);
  }
});

export default TGS_MODE ? TgsTarget : BuildTarget;
