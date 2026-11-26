import { SEAL_GREEN, SEAL_RED } from './parchment';

export const formatPct = (n: number | null) => (n === null ? 'n/a' : `${n}%`);

export const formatRatioPct = (n: number) => `${Math.round(n * 100)}%`;

export const withPct = (value: number | string, pct: number | null) =>
  pct === null ? `${value}` : `${value} (${pct}%)`;

export const formatSigned = (n: number) => (n >= 0 ? `+${n}` : `${n}`);

export const signColor = (n: number) => (n >= 0 ? SEAL_GREEN : SEAL_RED);
