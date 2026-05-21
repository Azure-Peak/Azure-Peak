import { useState } from 'react';

import {
  badgeStyle,
  cardStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
} from '../../common/parchment';
import { type Charter, type NoticeboardData } from '../types';

export const ChartersSection = ({ data }: { data: NoticeboardData }) => {
  const charters = (data.charters ?? []).slice().sort((a, b) => {
    if (!!a.active !== !!b.active) {
      return a.active ? -1 : 1;
    }
    return a.name.localeCompare(b.name);
  });
  if (charters.length === 0) {
    return (
      <EmptyMessage text="No charters of the realm have been put to seal." />
    );
  }
  return (
    <>
      {charters.map((c, i) => (
        <CharterRow key={i} charter={c} />
      ))}
    </>
  );
};

const CharterRow = ({ charter }: { charter: Charter }) => {
  const [open, setOpen] = useState(false);
  return (
    <div
      style={{
        ...cardStyle,
        paddingTop: 4,
        paddingBottom: 4,
        marginBottom: 4,
        cursor: 'pointer',
      }}
      onClick={() => setOpen((v) => !v)}
    >
      <div
        style={{ display: 'flex', alignItems: 'center', gap: 8 }}
      >
        <span
          style={{
            color: INK_FAINT,
            fontSize: '11px',
            width: 10,
          }}
        >
          {open ? '▾' : '▸'}
        </span>
        <span
          style={{
            flex: 1,
            fontSize: '14px',
            fontWeight: 'bold',
            color: INK,
            fontFamily: SERIF,
          }}
        >
          {charter.name}
          <span
            style={{
              marginLeft: 8,
              color: INK_SOFT,
              fontStyle: 'italic',
              fontSize: '12px',
              fontWeight: 'normal',
            }}
          >
            of {charter.year}
          </span>
        </span>
        {!!charter.active ? (
          <span style={badgeStyle(SEAL_GREEN)}>IN FORCE</span>
        ) : (
          <span style={badgeStyle(SEAL_RED)}>SUSPENDED</span>
        )}
      </div>
      {open && (
        <div
          style={{
            marginTop: 6,
            paddingLeft: 18,
            whiteSpace: 'pre-wrap',
            color: INK,
            fontSize: '12px',
          }}
        >
          {charter.flavor_text}
        </div>
      )}
    </div>
  );
};

const EmptyMessage = ({ text }: { text: string }) => (
  <div
    style={{
      color: INK_FAINT,
      textAlign: 'center',
      padding: '24px 0',
    }}
  >
    {text}
  </div>
);
