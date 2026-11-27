import { useState } from 'react';
import { Tooltip } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  bannerStyle,
  cardStyle,
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TITLE,
  fieldRowStyle,
  fieldValueStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_RED,
  SERIF,
  subTabStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type MarquetteItem = {
  ref: string;
  name: string;
  category: string;
  cost: number;
  remaining: number | null;
  maximum: number | null;
};

type Data = {
  categories: string[];
  marques: number;
  locked: BooleanLike;
  is_puritan: BooleanLike;
  items: MarquetteItem[];
  contents: Record<string, string[]>;
};

const ItemRow = (props: {
  item: MarquetteItem;
  contents: string[];
  disabled: boolean;
  onBuy: () => void;
}) => {
  const { item, contents, disabled, onBuy } = props;
  const outOfStock = !!item.maximum && !item.remaining;
  return (
    <div style={denseRowStyle}>
      <div
        style={{
          ...ellipsisCellStyle,
          fontSize: FONT_TITLE,
          color: outOfStock ? INK_FAINT : INK,
        }}
      >
        {contents.length ? (
          <Tooltip
            position="bottom-start"
            content={contents.map((line) => (
              <div key={line}>{line}</div>
            ))}
          >
            <span>{item.name}</span>
          </Tooltip>
        ) : (
          item.name
        )}
      </div>
      <div
        style={{
          flex: '0 0 76px',
          textAlign: 'right',
          whiteSpace: 'nowrap',
          fontSize: FONT_SMALL,
          fontVariantNumeric: 'tabular-nums',
          color: outOfStock ? SEAL_RED : INK_SOFT,
        }}
      >
        {!!item.maximum &&
          (outOfStock
            ? 'out of stock'
            : `stock ${item.remaining} of ${item.maximum}`)}
      </div>
      <div
        style={{
          flex: '0 0 36px',
          display: 'flex',
          whiteSpace: 'nowrap',
          fontSize: FONT_LEAD,
          fontVariantNumeric: 'tabular-nums',
          color: disabled ? INK_FAINT : INK,
        }}
      >
        <span style={{ flex: 1, textAlign: 'right' }}>{item.cost}</span>
        <span style={{ color: SEAL_AMBER, marginLeft: '3px' }}>ᛉ</span>
      </div>
      <button
        type="button"
        style={compactButtonStyle({ disabled })}
        disabled={disabled}
        onClick={onBuy}
      >
        Buy
      </button>
    </div>
  );
};

export const Marquette = () => {
  const { act, data } = useBackend<Data>();
  const { categories, marques, items } = data;
  const [category, setCategory] = useState(categories[0]);
  const isPuritan = !!data.is_puritan;
  const lockedOut = !!data.locked && !isPuritan;
  const shown = items.filter((item) => item.category === category);

  return (
    <Window width={500} height={600} theme="marquette">
      <Window.Content>
        <div
          style={{
            ...pageStyle,
            height: '100%',
            boxSizing: 'border-box',
            padding: '12px 16px',
            display: 'flex',
            flexDirection: 'column',
          }}
        >
          <div style={{ flexShrink: 0 }}>
            <div style={titleStyle}>L'INQUISITION MARQUETTE D'OTAVA</div>
            <div style={subtitleStyle}>
              POUR L'ÉRADICATION DE L'HÉRÉSIE, TANT QUE PSYDON ENDURE.
            </div>
            <div style={rulerStyle} />
            <div style={{ ...fieldRowStyle, borderBottom: 'none' }}>
              <div
                style={{
                  flex: '0 0 auto',
                  fontFamily: SERIF,
                  color: SEAL_AMBER,
                  marginRight: '12px',
                }}
              >
                Marques Loaded:
              </div>
              <div style={{ ...fieldValueStyle, fontWeight: 'bold' }}>
                {marques} <span style={{ color: SEAL_AMBER }}>ᛉ</span>
              </div>
              <button
                type="button"
                style={inkButtonStyle({ disabled: marques <= 0 })}
                disabled={marques <= 0}
                onClick={() => act('eject')}
              >
                Eject Marques
              </button>
            </div>
            <div style={{ ...fieldRowStyle, borderBottom: 'none' }}>
              <div
                style={{
                  flex: '0 0 auto',
                  fontFamily: SERIF,
                  color: SEAL_AMBER,
                  marginRight: '12px',
                }}
              >
                Puritan's Lock:
              </div>
              <div style={{ ...fieldValueStyle, fontWeight: 'bold' }}>
                {data.locked ? 'OUI' : 'NON'}
              </div>
              {isPuritan && (
                <button
                  type="button"
                  style={inkButtonStyle()}
                  onClick={() => act('toggle_lock')}
                >
                  {data.locked ? 'Disengage' : 'Engage'}
                </button>
              )}
            </div>
            {lockedOut && (
              <div style={{ ...bannerStyle(SEAL_RED, true), marginTop: '8px' }}>
                The Puritan's Lock is engaged. Only the Puritan may spend
                Marques.
              </div>
            )}
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'repeat(3, 1fr)',
                gap: '4px',
                margin: '6px 0',
              }}
            >
              {categories.map((cat) => (
                <button
                  type="button"
                  key={cat}
                  style={{
                    ...subTabStyle(cat === category),
                    minWidth: 0,
                    padding: '3px 4px',
                    fontWeight: 'bold',
                  }}
                  onClick={() => setCategory(cat)}
                >
                  {cat}
                </button>
              ))}
            </div>
          </div>
          <div style={{ flex: 1, minHeight: 0, overflowY: 'auto' }}>
            {shown.length === 0 ? (
              <div
                style={{ ...cardStyle, textAlign: 'center', color: INK_SOFT }}
              >
                Nothing is stocked in this category.
              </div>
            ) : (
              shown.map((item) => (
                <ItemRow
                  key={item.ref}
                  item={item}
                  contents={data.contents[item.ref] ?? []}
                  disabled={
                    lockedOut ||
                    marques < item.cost ||
                    (!!item.maximum && !item.remaining)
                  }
                  onBuy={() => act('buy', { ref: item.ref })}
                />
              ))
            )}
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
