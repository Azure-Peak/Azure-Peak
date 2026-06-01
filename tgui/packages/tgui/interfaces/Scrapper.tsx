import { useState } from 'react';
import { NumberInput } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type MaterialRow = {
  path: string;
  name: string;
  price: number;
  cap: number;
  held: number;
  items: number;
  left: number;
  advertise: BooleanLike;
  enabled: BooleanLike;
};

type Data = {
  budget: number;
  is_keyholder: BooleanLike;
  materials: MaterialRow[];
  total_items: number;
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

const PriceCapEditor = (props: {
  row: MaterialRow;
  act: ActFn;
}) => {
  const { row, act } = props;
  const [priceDraft, setPriceDraft] = useState(row.price);
  const [capDraft, setCapDraft] = useState(row.cap);
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '6px',
      }}
    >
      <NumberInput
        value={priceDraft}
        minValue={0}
        maxValue={9999}
        step={1}
        stepPixelSize={4}
        width="60px"
        onChange={(v: number) => setPriceDraft(v)}
      />
      <button
        type="button"
        style={inkButtonStyle({ disabled: priceDraft === row.price })}
        disabled={priceDraft === row.price}
        onClick={() => act('set_price', { path: row.path, value: priceDraft })}
      >
        Price
      </button>
      <NumberInput
        value={capDraft}
        minValue={0}
        maxValue={9999}
        step={1}
        stepPixelSize={4}
        width="60px"
        onChange={(v: number) => setCapDraft(v)}
      />
      <button
        type="button"
        style={inkButtonStyle({ disabled: capDraft === row.cap })}
        disabled={capDraft === row.cap}
        onClick={() => act('set_cap', { path: row.path, value: capDraft })}
      >
        Cap
      </button>
    </div>
  );
};

const MaterialRowView = (props: {
  row: MaterialRow;
  isKeyholder: boolean;
  act: ActFn;
}) => {
  const { row, isKeyholder, act } = props;
  const advertising = !!row.advertise;
  const enabled = !!row.enabled;
  const capText =
    row.cap > 0 ? `${row.left} of ${row.cap}` : 'no cap';
  const full = row.cap > 0 && row.left === 0;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        padding: '6px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        opacity: enabled ? 1 : 0.5,
      }}
    >
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ fontSize: FONT_BODY, color: INK }}>
          <b>{row.name}</b>
          {!enabled && (
            <span
              style={{
                color: INK_FAINT,
                fontSize: FONT_BODY,
              }}
            >
              {' '}
              - disabled
            </span>
          )}
        </div>
        <div style={{ fontSize: FONT_BODY, color: INK_SOFT }}>
          <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            {row.price}m
          </span>{' '}
          each
          {' - '}
          <span style={{ color: full ? SEAL_RED : INK_SOFT }}>
            {capText}
          </span>
          {advertising && enabled && (
            <span style={{ color: SEAL_GREEN }}>
              {' '}
              - advertised
            </span>
          )}
        </div>
      </div>
      {isKeyholder ? (
        <>
          <PriceCapEditor row={row} act={act} />
          <button
            type="button"
            style={inkButtonStyle()}
            onClick={() =>
              act('toggle_enable', { path: row.path })
            }
          >
            {enabled ? 'Disable' : 'Enable'}
          </button>
          <button
            type="button"
            style={inkButtonStyle({ disabled: !enabled })}
            disabled={!enabled}
            onClick={() =>
              act('toggle_advertise', { path: row.path })
            }
          >
            {advertising ? 'Quiet' : 'Advertise'}
          </button>
          {row.items > 0 && (
            <button
              type="button"
              style={inkButtonStyle()}
              onClick={() => act('dump_held', { path: row.path })}
            >
              Empty ({row.items})
            </button>
          )}
        </>
      ) : null}
    </div>
  );
};

export const Scrapper = () => {
  const { act, data } = useBackend<Data>();
  const isKeyholder = !!data.is_keyholder;
  return (
    <Window width={isKeyholder ? 780 : 480} height={620} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>The Scrapper</div>
          <div style={subtitleStyle}>
            Bring rag and broken stock. The scrapper weighs, pays, and melts
            down. The proprietor sets the rate.
          </div>
          <div style={rulerStyle} />

          <div
            style={{
              ...cardStyle,
              display: 'flex',
              alignItems: 'baseline',
              gap: '12px',
              fontFamily: SERIF,
              marginBottom: '12px',
            }}
          >
            <div style={{ flex: 1 }}>
              <div
                style={{
                  fontSize: FONT_BODY,
                  color: SEAL_AMBER,
                }}
              >
                Coffer
              </div>
              <div
                style={{
                  fontSize: '16px',
                  color: data.budget > 0 ? INK : INK_FAINT,
                  fontWeight: 'bold',
                }}
              >
                {data.budget}m
              </div>
            </div>
            {isKeyholder && (
              <div
                style={{
                  fontSize: FONT_BODY,
                  color: INK_SOFT,
                  flex: 1,
                  textAlign: 'right',
                }}
              >
                Drop coins into the machine to fund payouts.
              </div>
            )}
            {isKeyholder && (
              <button
                type="button"
                style={inkButtonStyle({ disabled: data.budget <= 0 })}
                disabled={data.budget <= 0}
                onClick={() => act('withdraw')}
              >
                Withdraw
              </button>
            )}
            {isKeyholder && (
              <button
                type="button"
                style={inkButtonStyle({ disabled: data.total_items <= 0 })}
                disabled={data.total_items <= 0}
                onClick={() => act('dump_all')}
              >
                Empty All ({data.total_items})
              </button>
            )}
          </div>

          <div style={sectionHeaderStyle}>Materials Bought</div>
          {data.materials.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                color: INK_SOFT,
              }}
            >
              No materials configured.
            </div>
          ) : (
            data.materials.map((row) => (
              <MaterialRowView
                key={row.path}
                row={row}
                isKeyholder={isKeyholder}
                act={act}
              />
            ))
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
