import { atom } from 'jotai';
import { store } from './events/store';

export const themeAtom = atom('dark');

export function setChatTheme(payload: string): void {
  store.set(themeAtom, payload);
}
