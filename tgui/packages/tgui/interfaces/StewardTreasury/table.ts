import type { CSSProperties } from 'react';

import { FONT_SMALL, INK_SOFT, PARCHMENT_SHADOW } from '../common/parchment';

type Align = 'left' | 'right';

export const tableStyle = (columns: string): CSSProperties => ({
  display: 'grid',
  gridTemplateColumns: columns,
});

export const rowStyle: CSSProperties = { display: 'contents' };

export const headCell = (align: Align = 'left'): CSSProperties => ({
  fontSize: FONT_SMALL,
  color: INK_SOFT,
  padding: '0 6px 2px 6px',
  textAlign: align,
  whiteSpace: 'nowrap',
});

export const bodyCell = (first: boolean, align: Align = 'left'): CSSProperties => ({
  display: 'flex',
  flexDirection: 'column',
  justifyContent: 'center',
  alignItems: align === 'right' ? 'flex-end' : 'flex-start',
  minWidth: 0,
  padding: '4px 6px',
  borderTop: `1px ${first ? 'solid' : 'dashed'} ${PARCHMENT_SHADOW}`,
});

export const buttonCell = (first: boolean): CSSProperties => ({
  ...bodyCell(first),
  flexDirection: 'row',
  alignItems: 'center',
  justifyContent: 'flex-end',
  gap: '4px',
});
