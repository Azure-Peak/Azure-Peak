import type { CSSProperties } from 'react';

export type WaxSealColor = 'red' | 'green' | 'blue' | 'amber';

type Palette = {
  outer: string;
  inner: string;
  highlight: string;
  rim: string;
  detail: string;
  glyph: string;
  shine: string;
};

const PALETTES: Record<WaxSealColor, Palette> = {
  red: {
    outer: '#8b1a1a',
    inner: '#b42a24',
    highlight: '#f0a08a',
    rim: '#5c0c0c',
    detail: '#5c0c0c',
    glyph: '#f3c164',
    shine: '#ffd2bc',
  },
  green: {
    outer: '#2f5a2c',
    inner: '#4a7d3f',
    highlight: '#a8d098',
    rim: '#1d3a1a',
    detail: '#1d3a1a',
    glyph: '#f3c164',
    shine: '#d8efc8',
  },
  blue: {
    outer: '#1f3a6b',
    inner: '#2e4a78',
    highlight: '#9ab4d8',
    rim: '#0e1f3a',
    detail: '#0e1f3a',
    glyph: '#f3c164',
    shine: '#cfdcef',
  },
  amber: {
    outer: '#7a5616',
    inner: '#a37522',
    highlight: '#e7c890',
    rim: '#3a2a08',
    detail: '#3a2a08',
    glyph: '#fff3d4',
    shine: '#fbe6b8',
  },
};

type WaxSealProps = {
  label: string;
  mark?: string;
  royal?: boolean;
  color?: WaxSealColor;
  size?: number;
  style?: CSSProperties;
};

export const WaxSeal = (props: WaxSealProps) => {
  const {
    label,
    mark,
    royal = false,
    color = 'red',
    size = 54,
    style,
  } = props;
  const palette = PALETTES[color];
  const glyph = mark ?? label.trim().charAt(0).toUpperCase();

  const baseStyle: CSSProperties = {
    width: `${size}px`,
    height: `${size}px`,
    transform: 'rotate(-8deg)',
    filter: `drop-shadow(0 1px 2px ${palette.rim}59)`,
    ...style,
  };

  return (
    <svg
      aria-label={`Seal: ${label}`}
      role="img"
      style={baseStyle}
      viewBox="0 0 80 80"
    >
      <path
        d="M39 4 C45 2 48 8 53 8 C61 8 61 17 68 20 C75 23 70 32 74 38 C79 47 69 51 68 58 C67 67 56 64 51 72 C45 80 38 72 31 75 C22 79 20 68 13 66 C5 63 11 52 6 47 C-1 39 9 34 8 28 C7 19 18 19 22 12 C27 4 33 8 39 4 Z"
        fill={palette.outer}
      />
      <path
        d="M40 9 C46 7 49 12 54 13 C60 14 61 21 66 25 C70 29 66 36 69 41 C72 48 64 52 62 58 C60 65 52 63 47 68 C41 74 35 67 29 68 C21 69 20 60 15 57 C9 53 14 45 11 40 C7 33 15 29 15 23 C16 16 24 17 28 12 C32 8 36 11 40 9 Z"
        fill={palette.inner}
        opacity="0.72"
      />
      <circle
        cx="40"
        cy="40"
        fill="none"
        r="26"
        stroke={palette.highlight}
        strokeWidth="2"
      />
      <circle
        cx="40"
        cy="40"
        fill="none"
        opacity="0.55"
        r="20"
        stroke={palette.detail}
        strokeDasharray="2 3"
        strokeWidth="1.5"
      />
      <path
        d="M21 38 C27 27 33 25 40 31 C47 25 54 27 59 38"
        fill="none"
        opacity="0.65"
        stroke={palette.detail}
        strokeLinecap="round"
        strokeWidth="2"
      />
      <path
        d="M21 45 C28 55 35 56 40 50 C46 56 53 55 59 45"
        fill="none"
        opacity="0.65"
        stroke={palette.detail}
        strokeLinecap="round"
        strokeWidth="2"
      />
      {royal ? (
        <g
          fill={palette.glyph}
          stroke={palette.detail}
          strokeLinejoin="round"
          strokeWidth="2"
        >
          <path d="M22 48 L25 28 L34 40 L40 24 L47 40 L56 28 L59 48 Z" />
          <path d="M24 51 H58 V57 H24 Z" />
          <circle cx="25" cy="27" r="3" />
          <circle cx="40" cy="23" r="3" />
          <circle cx="56" cy="27" r="3" />
        </g>
      ) : (
        <text
          fill={palette.glyph}
          fontFamily='"Palatino Linotype", "Times New Roman", serif'
          fontSize="30"
          fontWeight="700"
          stroke={palette.detail}
          strokeWidth="0.9"
          textAnchor="middle"
          x="40"
          y="51"
        >
          {glyph}
        </text>
      )}
      <path
        d="M19 22 C14 29 13 36 15 44 M61 22 C66 29 67 36 65 44 M22 61 C30 67 50 67 58 61"
        fill="none"
        opacity="0.38"
        stroke={palette.shine}
        strokeLinecap="round"
        strokeWidth="2"
      />
    </svg>
  );
};
