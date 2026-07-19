import type { CSSProperties } from 'react';

import { FONT_BODY, INK, INK_FAINT, SERIF } from '../common/parchment';

export const AMBER_TINT_SOFT = 'rgba(200,170,100,0.08)';
export const AMBER_TINT = 'rgba(200,170,100,0.25)';
export const AMBER_TINT_STRONG = 'rgba(200,170,100,0.45)';
export const PARCHMENT_PANEL_FILL = 'rgba(124,91,16,0.05)';
export const RIBBON_TEXT = '#f7eccb';

export const detailPanelStyle: CSSProperties = {
  marginTop: '14px',
  padding: '10px 14px',
  border: `1px solid ${INK_FAINT}`,
  background: PARCHMENT_PANEL_FILL,
  minHeight: '60px',
};

export const dashedHeaderStyle: CSSProperties = {
  fontFamily: SERIF,
  letterSpacing: '2px',
  fontSize: FONT_BODY,
  color: INK,
  borderBottom: `1px dashed ${INK_FAINT}`,
  paddingBottom: '4px',
  marginBottom: '6px',
};

export const emptyHintStyle: CSSProperties = {
  textAlign: 'center',
  fontStyle: 'italic',
  color: INK_FAINT,
  fontSize: FONT_BODY,
  padding: '14px 0',
};
