import { useEffect } from 'react';

// Pin and star icons
export type PinScope = 'round' | 'saved' | undefined;
export type PinMap = Record<string, string>;
export type PinMenu = 'crafting' | 'anvil';

type ActFn = (action: string, params?: Record<string, unknown>) => void;

export const pinGlyph = (scope?: string): string =>
  scope === 'saved' ? '📌' : scope === 'round' ? '★' : '☆';

export const pinTitle = (scope?: string): string =>
  scope === 'saved'
    ? 'Saved to this character. Click to unpin.'
    : scope === 'round'
      ? 'Pinned for this round. Click to save to this character.'
      : 'Pin for this round';

const readSaved = (storageKey: string): string[] => {
  try {
    const raw = window.localStorage.getItem(storageKey);
    const parsed = raw ? JSON.parse(raw) : [];
    return Array.isArray(parsed)
      ? parsed.filter((p): p is string => typeof p === 'string')
      : [];
  } catch {
    return [];
  }
};

const writeSaved = (storageKey: string, paths: string[]): void => {
  try {
    if (paths.length) {
      window.localStorage.setItem(storageKey, JSON.stringify(paths));
    } else {
      window.localStorage.removeItem(storageKey);
    }
  } catch {
    // storage unavailable or full; pins just won't persist
  }
};

export const usePinSync = (
  act: ActFn,
  menu: PinMenu,
  pinKey: string | null | undefined,
  pins: PinMap,
) => {
  const storageKey = `recipe_pins:${menu}:${pinKey || 'default'}`;

  useEffect(() => {
    const saved = readSaved(storageKey);
    if (saved.length) {
      act('import_pins', { paths: saved });
    }
  }, [storageKey]);

  return (path: string) => {
    const oldScope = pins[path];
    const saved = readSaved(storageKey);
    if (oldScope === 'saved') {
      writeSaved(
        storageKey,
        saved.filter((p) => p !== path),
      );
    } else if (oldScope === 'round' && !saved.includes(path)) {
      writeSaved(storageKey, [...saved, path]);
    }
    act('cycle_pin', { path });
  };
};
