import type { CSSProperties } from 'react';

import { FONT_BODY, SERIF } from '../common/parchment';
import { RIBBON_TEXT } from './parchment_calendar';

type EventBarProps = {
  color: string;
  isStart: boolean;
  isEnd: boolean;
  label: string;
};

export const EventBar = ({ color, isStart, isEnd, label }: EventBarProps) => {
  const style: CSSProperties = {
    fontSize: FONT_BODY,
    fontFamily: SERIF,
    letterSpacing: '1px',
    color: RIBBON_TEXT,
    background: color,
    padding: '1px 4px',
    marginLeft: isStart ? '0' : '-4px',
    marginRight: isEnd ? '0' : '-4px',
    borderTopLeftRadius: isStart ? '2px' : '0',
    borderBottomLeftRadius: isStart ? '2px' : '0',
    borderTopRightRadius: isEnd ? '2px' : '0',
    borderBottomRightRadius: isEnd ? '2px' : '0',
    whiteSpace: 'nowrap',
    overflow: 'hidden',
    textOverflow: 'clip',
    textAlign: isStart ? 'left' : 'center',
    minHeight: '12px',
  };
  return <div style={style}>{isStart ? label : ' '}</div>;
};
