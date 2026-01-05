/**
 * Backfill changelog entries from merged PRs.
 * 
 * Usage:
 *   node backfill.js <pr_number> [<pr_number> ...]
 * 
 * Example:
 *   node backfill.js 4603 4593 4678
 * 
 * Prerequisites:
 *   - GitHub CLI (gh) must be installed and authenticated
 *   - Run from the repo root or tools/pull_request_hooks directory
 */

import { parseChangelog } from "./changelogParser.js";
import { changelogToYml } from "./autoChangelog.js";
import { execSync } from "child_process";
import { writeFileSync } from "fs";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(__dirname, "../..");

const prNumbers = process.argv.slice(2);

if (prNumbers.length === 0) {
  console.log("Usage: node backfill.js <pr_number> [<pr_number> ...]");
  console.log("Example: node backfill.js 4603 4593 4678");
  process.exit(1);
}

console.log(`Backfilling ${prNumbers.length} PR(s)...\n`);

for (const prNumber of prNumbers) {
  try {
    console.log(`\n--- PR #${prNumber} ---`);
    
    // Fetch PR data using GitHub CLI
    const prDataRaw = execSync(
      `gh pr view ${prNumber} --json body,author,title`,
      { encoding: "utf-8", cwd: repoRoot }
    );
    const prData = JSON.parse(prDataRaw);
    
    console.log(`Title: ${prData.title}`);
    console.log(`Author: ${prData.author.login}`);
    
    // Parse changelog from PR body
    const changelog = parseChangelog(prData.body || "");
    
    if (!changelog || changelog.changes.length === 0) {
      console.log(`⚠️  No changelog found in PR #${prNumber}, skipping.`);
      continue;
    }
    
    console.log(`Found ${changelog.changes.length} changelog entries:`);
    for (const change of changelog.changes) {
      console.log(`  - ${change.type.changelogKey}: ${change.description.substring(0, 50)}...`);
    }
    
    // Generate YAML
    const yml = changelogToYml(changelog, prData.author.login);
    
    // Write to file
    const outputPath = resolve(repoRoot, `html/changelogs/AutoChangeLog-pr-${prNumber}.yml`);
    writeFileSync(outputPath, yml, "utf-8");
    
    console.log(`✅ Created: html/changelogs/AutoChangeLog-pr-${prNumber}.yml`);
    
  } catch (error) {
    console.error(`❌ Error processing PR #${prNumber}:`, error.message);
  }
}

console.log("\n--- Done! ---");
console.log("Now run: python tools/ss13_genchangelog.py html/changelogs");
console.log("This will compile the YAML files into the archive.");
