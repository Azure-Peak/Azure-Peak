import { useEffect, useState } from 'react';
import { Input } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_BODY,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_RED,
  SERIF,
  subTabBarStyle,
  subTabStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type Boon = {
  ref: string;
  name: string;
  desc?: string;
  category: string;
  price: number;
};

type Data = {
  psila: number;
  spent: number;
  categories: string[];
  exclusive: string[];
  category: string;
  search: string;
  items: Boon[];
};

const noticeStyle = {
  ...cardStyle,
  textAlign: 'center' as const,
  fontStyle: 'italic',
  color: INK_SOFT,
};

export const RenegadeBoons = () => {
  const { act, data } = useBackend<Data>();
  const [draft, setDraft] = useState(data.search);

  useEffect(() => {
    if (draft === data.search) return;
    const id = setTimeout(() => act('search', { search: draft }), 250);
    return () => clearTimeout(id);
  }, [draft, data.search, act]);

  const browsing = !!data.category || !!data.search;

  return (
    <Window width={760} height={720} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>RENEGADE BOONS</div>
          <div style={subtitleStyle}>
            The Vile Vheslie hears you. Psila on the tongue:{' '}
            <b style={{ color: SEAL_AMBER }}>{data.psila}</b>
            <span style={{ color: INK_FAINT, marginLeft: '8px' }}>
              · Spent: {data.spent}
            </span>
          </div>
          <div style={rulerStyle} />
          <div style={subTabBarStyle}>
            {data.categories.map((cat) => {
              const active = data.category === cat;
              return (
                <button
                  type="button"
                  key={cat}
                  style={{
                    ...subTabStyle(active),
                    ...(!active && data.exclusive.includes(cat)
                      ? { color: SEAL_RED }
                      : {}),
                  }}
                  onClick={() =>
                    act('category', { category: active ? '' : cat })
                  }
                >
                  {cat}
                </button>
              );
            })}
          </div>
          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              margin: '8px 0',
            }}
          >
            <span
              style={{
                fontFamily: SERIF,
                fontSize: FONT_BODY,
                color: INK_SOFT,
              }}
            >
              Search:
            </span>
            <Input
              value={draft}
              onChange={setDraft}
              placeholder="Search every boon..."
              width="280px"
            />
            {!!draft && (
              <button
                type="button"
                style={inkButtonStyle()}
                onClick={() => {
                  setDraft('');
                  act('search', { search: '' });
                }}
              >
                Clear
              </button>
            )}
          </div>
          {!browsing && (
            <div style={noticeStyle}>
              Pick a category or search. Red categories are offered to Renegades
              alone.
            </div>
          )}
          {browsing && !data.items.length && (
            <div style={noticeStyle}>Nothing here.</div>
          )}
          {data.items.map((boon) => {
            const cantAfford = data.psila < boon.price;
            return (
              <div key={boon.ref} style={denseRowStyle}>
                <div style={{ ...ellipsisCellStyle, color: INK }}>
                  <div style={{ fontSize: FONT_TITLE }}>{boon.name}</div>
                  {(!!boon.desc || !data.category) && (
                    <div style={{ fontSize: FONT_SMALL, color: INK_SOFT }}>
                      {!data.category && <i>{boon.category}. </i>}
                      {boon.desc}
                    </div>
                  )}
                </div>
                <div
                  style={{
                    fontSize: FONT_LEAD,
                    color: cantAfford ? INK_FAINT : INK,
                    flexShrink: 0,
                    whiteSpace: 'nowrap',
                  }}
                >
                  {boon.price} psila
                </div>
                <button
                  type="button"
                  style={compactButtonStyle({ disabled: cantAfford })}
                  disabled={cantAfford}
                  onClick={() => act('buy', { ref: boon.ref })}
                  title={`Buy ${boon.name} for ${boon.price} psila`}
                >
                  Buy
                </button>
              </div>
            );
          })}
        </div>
      </Window.Content>
    </Window>
  );
};
