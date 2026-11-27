import { storage } from 'common/storage';
import { useCallback, useEffect, useState } from 'react';
import type { BooleanLike } from 'tgui-core/react';

export type PinMap = Record<string, string>;
export type PinMenu = 'crafting' | 'anvil';

export type PinData = {
  pins?: PinMap;
  pin_key?: string | null;
  pins_imported?: BooleanLike;
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

export const pinGlyph = (scope?: string): string =>
  scope === 'saved' ? '📌' : scope === 'round' ? '★' : '☆';

export const pinTitle = (scope?: string): string =>
  scope === 'saved'
    ? 'Saved to this character. Click to unpin.'
    : scope === 'round'
      ? 'Pinned for this round. Click to save to this character.'
      : 'Pin for this round';

export type OpenView = 'pinned' | 'all';

const openViewCache: Partial<Record<PinMenu, OpenView>> = {};

export const useOpenView = (menu: PinMenu) => {
  const storageKey = `recipe_open_view:${menu}`;
  const [openView, setOpenView] = useState<OpenView | undefined>(
    openViewCache[menu],
  );

  useEffect(() => {
    if (openViewCache[menu]) {
      return;
    }
    storage.get(storageKey).then((saved) => {
      const value: OpenView = saved === 'all' ? 'all' : 'pinned';
      openViewCache[menu] = value;
      setOpenView(value);
    });
  }, [menu]);

  const toggle = useCallback(() => {
    const next: OpenView = openView === 'all' ? 'pinned' : 'all';
    openViewCache[menu] = next;
    storage.set(storageKey, next);
    setOpenView(next);
  }, [menu, openView]);

  return [openView, toggle] as const;
};

export const pinnedFirst =
  (pins: PinMap) => (a: { path: string }, b: { path: string }) =>
    Number(!!pins[b.path]) - Number(!!pins[a.path]);

export const usePinSync = (act: ActFn, menu: PinMenu, data: PinData) => {
  const storageKey = `recipe_pins:${menu}:${data.pin_key || 'default'}`;
  const imported = !!data.pins_imported;
  const pins = data.pins || {};
  const savedPaths = Object.keys(pins)
    .filter((path) => pins[path] === 'saved')
    .sort()
    .join('\n');

  useEffect(() => {
    if (imported) {
      return;
    }
    storage.get(storageKey).then((saved) => {
      act('import_pins', {
        paths: Array.isArray(saved)
          ? saved.filter((p): p is string => typeof p === 'string')
          : [],
      });
    });
  }, [storageKey]);

  useEffect(() => {
    if (!imported) {
      return;
    }
    if (savedPaths) {
      storage.set(storageKey, savedPaths.split('\n'));
    } else {
      storage.remove(storageKey);
    }
  }, [imported, storageKey, savedPaths]);

  return useCallback((path: string) => act('cycle_pin', { path }), [act]);
};
