import type { CSSProperties } from 'react';
import { useState } from 'react';

import {
  FONT_BODY,
  INK,
  INK_FAINT,
  inkButtonStyle,
  SEAL_GREEN,
  SEAL_RED,
} from '../common/parchment';
import type { LogEntry } from './types';

const PAGE_SIZE = 20;

const logRowStyle: CSSProperties = {
  display: 'flex',
  fontSize: FONT_BODY,
  lineHeight: 1.3,
  padding: '1px 0',
  color: INK,
};

const logAmountStyle = (color: string): CSSProperties => ({
  flex: '0 0 60px',
  textAlign: 'right',
  paddingRight: 8,
  color,
  fontWeight: 'bold',
});

const logBodyStyle: CSSProperties = {
  flex: 1,
  whiteSpace: 'nowrap',
  overflow: 'hidden',
  textOverflow: 'ellipsis',
};

type Props = {
  entries: LogEntry[];
  emptyMessage?: string;
};

export const PaginatedLog = ({
  entries,
  emptyMessage = 'No transactions on record.',
}: Props) => {
  const [page, setPage] = useState<number>(0);

  if (!entries.length) {
    return (
      <div style={{ color: INK_FAINT, fontSize: FONT_BODY }}>
        {emptyMessage}
      </div>
    );
  }

  const total = entries.length;
  const lastPage = Math.max(0, Math.ceil(total / PAGE_SIZE) - 1);
  const safePage = Math.min(page, lastPage);
  const start = safePage * PAGE_SIZE;
  const slice = entries.slice(start, start + PAGE_SIZE);

  return (
    <>
      {slice.map((entry, i) => {
        const isIn = entry.direction === 'in';
        const isOut = entry.direction === 'out';
        const sign = isIn ? '+' : isOut ? '-' : '';
        const color = isIn ? SEAL_GREEN : isOut ? SEAL_RED : INK_FAINT;
        const preposition = isIn ? 'from' : isOut ? 'to' : '';
        return (
          <div key={start + i} style={logRowStyle}>
            <div style={logAmountStyle(color)}>
              {sign}
              {entry.amount}m
            </div>
            <div style={logBodyStyle} title={entry.reason}>
              {!!entry.counterparty && (
                <span>
                  {preposition} <b>{entry.counterparty}</b>
                  {!!entry.reason && (
                    <span style={{ color: INK_FAINT }}> &middot; </span>
                  )}
                </span>
              )}
              {!!entry.reason && (
                <span style={{ color: INK_FAINT }}>{entry.reason}</span>
              )}
            </div>
          </div>
        );
      })}
      {lastPage > 0 && (
        <div
          style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            marginTop: 4,
            fontSize: FONT_BODY,
          }}
        >
          <button
            type="button"
            style={inkButtonStyle({ disabled: safePage === 0 })}
            disabled={safePage === 0}
            onClick={() => setPage(safePage - 1)}
          >
            Newer
          </button>
          <span style={{ color: INK_FAINT }}>
            {start + 1}-{Math.min(start + PAGE_SIZE, total)} of {total}
          </span>
          <button
            type="button"
            style={inkButtonStyle({ disabled: safePage >= lastPage })}
            disabled={safePage >= lastPage}
            onClick={() => setPage(safePage + 1)}
          >
            Older
          </button>
        </div>
      )}
    </>
  );
};
