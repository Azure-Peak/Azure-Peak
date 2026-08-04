import Juke from '../juke/index.js';

export function bunWithCwd(
  cwd: string,
): (...args: any[]) => Promise<Juke.ExecReturn> {
  return (...args: any[]) => {
    return Juke.exec(
      'bun',
      [...args.filter((arg) => typeof arg === 'string')],
      {
        cwd,
        shell: true,
      },
    );
  };
}

export const bun = bunWithCwd('./tgui');
export const bunRoot = bunWithCwd('./');
export const bunTgfont = bunWithCwd('./tgui/packages/tgfont');
