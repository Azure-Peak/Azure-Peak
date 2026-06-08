import type { CSSProperties } from 'react';

import {
  FONT_BODY,
  INK,
  INK_FAINT,
  inkButtonStyle,
  SERIF,
} from '../common/parchment';

const navRowStyle: CSSProperties = {
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'space-between',
  gap: '8px',
  margin: '6px 0 4px 0',
};

const monthTitleStyle: CSSProperties = {
  flex: 1,
  textAlign: 'center',
  fontFamily: SERIF,
  letterSpacing: '3px',
  fontSize: '18px',
  color: INK,
};

const monthSubStyle: CSSProperties = {
  textAlign: 'center',
  color: INK_FAINT,
  fontStyle: 'italic',
  fontSize: FONT_BODY,
  marginBottom: '8px',
};

const returnRowStyle: CSSProperties = {
  textAlign: 'center',
  marginBottom: '8px',
};

type NavProps = {
  monthName: string;
  seasonLine: string;
  showReturn: boolean;
  onPrev: () => void;
  onNext: () => void;
  onReturn: () => void;
};

export const Nav = (props: NavProps) => {
  const { monthName, seasonLine, showReturn, onPrev, onNext, onReturn } = props;
  return (
    <>
      <div style={navRowStyle}>
        <button type="button" style={inkButtonStyle({})} onClick={onPrev}>
          {'< Prev'}
        </button>
        <div style={monthTitleStyle}>{monthName}</div>
        <button type="button" style={inkButtonStyle({})} onClick={onNext}>
          {'Next >'}
        </button>
      </div>
      <div style={monthSubStyle}>{seasonLine}</div>
      {showReturn && (
        <div style={returnRowStyle}>
          <button type="button" style={inkButtonStyle({})} onClick={onReturn}>
            Return to Today
          </button>
        </div>
      )}
    </>
  );
};
