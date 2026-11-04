import type { ReactNode } from 'react';

const CATEGORY_COLORS = [
  '#5baaff',
  '#ffa64d',
  '#ff6b6b',
  '#7ee081',
  '#c78bff',
  '#ffd84d',
  '#4dd4c4',
  '#ff8fc8',
  '#a0a0ff',
  '#b5d96b',
];

export const categoryColor = (cat: string) => {
  let hash = 0;
  for (let i = 0; i < cat.length; i++) {
    hash = (hash * 31 + cat.charCodeAt(i)) | 0;
  }
  return CATEGORY_COLORS[Math.abs(hash) % CATEGORY_COLORS.length];
};

export const formatBytes = (bytes: number) => {
  if (bytes >= 1024 * 1024) {
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
  }
  if (bytes >= 1024) {
    return `${Math.round(bytes / 1024)} KB`;
  }
  return `${bytes} B`;
};

export const clockOf = (ts: string) => ts.slice(11, 19);

export const roundLabel = (name: string) => name.replace(/^round-/, '');

export const buildMarker = (
  marks: string[],
  search: string,
  pattern: boolean,
): RegExp | null => {
  const parts = marks
    .filter((mark) => mark)
    .map((mark) => mark.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
  if (pattern && search) {
    parts.push(`(?:${search})`);
  }
  if (!parts.length) {
    return null;
  }
  try {
    return new RegExp(parts.join('|'), 'gi');
  } catch {
    return null;
  }
};

export const highlight = (text: string, marker: RegExp | null): ReactNode => {
  if (!marker) {
    return text;
  }
  const out: ReactNode[] = [];
  let last = 0;
  marker.lastIndex = 0;
  let match = marker.exec(text);
  while (match) {
    if (!match[0].length) {
      marker.lastIndex++;
    } else {
      if (match.index > last) {
        out.push(text.slice(last, match.index));
      }
      out.push(
        <span
          key={match.index}
          style={{ background: 'rgba(255, 200, 0, 0.35)', borderRadius: 2 }}
        >
          {match[0]}
        </span>,
      );
      last = match.index + match[0].length;
    }
    match = marker.exec(text);
  }
  if (last < text.length) {
    out.push(text.slice(last));
  }
  return out;
};

export const prettyData = (data: string) => {
  try {
    return JSON.stringify(JSON.parse(data), null, 2);
  } catch {
    return data;
  }
};
