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
  subTabBarStyle,
  subTabStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type StockRow = {
  ref: string;
  name: string;
  desc: string;
  category: string;
  amount: number;
  limit: number;
  withdraw_price: number;
  deposit_price: number;
  export_price: number;
  import_price: number;
  withdraw_disabled: BooleanLike;
  accept_enabled: BooleanLike;
  event_tag: string;
  shortage_progress: number;
  shortage_target: number;
  shortage_affected: string;
};

type Bounty = {
  name: string;
  payout_price: number;
  percent: BooleanLike;
};

type Data = {
  budget: number;
  compact: BooleanLike;
  categories: string[];
  category: string;
  food_stipend: BooleanLike;
  treasury_floor: number;
  below_floor: BooleanLike;
  charter_unlocked: BooleanLike;
  charter_active: BooleanLike;
  charter_margin: number;
  charter_volume: number;
  charter_threshold: number;
  stocks: StockRow[];
  bounties: Bounty[];
  no_deposit: BooleanLike;
  title: string;
  subtitle: string;
};

type ActFn = (action: string, params?: Record<string, unknown>) => void;

const CharterChip = (props: { data: Data }) => {
  const { data } = props;
  let label: string;
  let color: string;
  if (!data.charter_unlocked) {
    label = `CHARTER ${data.charter_volume}/${data.charter_threshold}`;
    color = INK_FAINT;
  } else if (data.charter_active) {
    label = `CHARTER INVOKED ${data.charter_margin}%`;
    color = SEAL_GREEN;
  } else {
    label = `CHARTER SUSPENDED ${data.charter_margin}%`;
    color = SEAL_RED;
  }
  return (
    <span
      style={{
        color,
        fontWeight: 'bold',
        fontSize: FONT_BODY,
        fontFamily: SERIF,
      }}
    >
      {label}
    </span>
  );
};

const StockRowView = (props: {
  row: StockRow;
  data: Data;
  act: ActFn;
  compact: boolean;
}) => {
  const { row, data, act, compact } = props;
  const noDeposit = !!data.no_deposit;
  const canWithdraw =
    !row.withdraw_disabled &&
    row.amount > 0 &&
    (row.withdraw_price <= data.budget || !!data.food_stipend);
  const canImport =
    !row.withdraw_disabled &&
    row.import_price > 0 &&
    row.import_price <= data.budget;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        flexWrap: 'wrap',
        gap: '6px',
        padding: '2px 6px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
      }}
    >
      <div style={{ flex: '1 1 200px', minWidth: 0 }}>
        <span style={{ color: INK, fontWeight: 'bold' }}>{row.name}</span>
        <span style={{ color: INK_SOFT, marginLeft: '6px' }}>
          {row.amount}/{row.limit}
        </span>
        {!!row.event_tag && (
          <span
            style={{
              color: row.event_tag === 'GLUT' ? SEAL_GREEN : SEAL_RED,
              fontWeight: 'bold',
              fontSize: FONT_BODY,
              marginLeft: '6px',
              padding: '0 4px',
              border: `1px solid ${row.event_tag === 'GLUT' ? SEAL_GREEN : SEAL_RED}`,
              borderRadius: '2px',
            }}
            title={
              row.event_tag === 'SHORTAGE' && row.shortage_target > 0
                ? `Export or sell ${row.shortage_target - row.shortage_progress} more units to end the shortage. Any of these count: ${row.shortage_affected}.`
                : undefined
            }
          >
            {row.event_tag}
            {row.event_tag === 'SHORTAGE' && row.shortage_target > 0 && (
              <span style={{ marginLeft: '4px', fontWeight: 'normal' }}>
                ({row.shortage_progress} / {row.shortage_target})
              </span>
            )}
          </span>
        )}
        {!row.accept_enabled && !noDeposit && (
          <span
            style={{
              color: INK_FAINT,
              fontSize: FONT_BODY,
              marginLeft: '4px',
            }}
          >
            (no deposits)
          </span>
        )}
        {!compact && row.desc && (
          <span
            style={{
              color: INK_SOFT,
              fontSize: FONT_BODY,
              marginLeft: '6px',
            }}
          >
            - {row.desc}
          </span>
        )}
      </div>
      <div
        style={{
          flex: noDeposit ? '0 0 210px' : '0 0 304px',
          display: 'flex',
          gap: '4px',
          justifyContent: 'flex-end',
          alignItems: 'center',
        }}
      >
        {!noDeposit && (
          <span
            style={{
              display: 'inline-block',
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              fontWeight: 'bold',
              padding: '1px 8px',
              color: SEAL_AMBER,
              background: 'transparent',
              border: `1px dashed ${SEAL_AMBER}`,
              borderRadius: '2px',
              width: '90px',
              textAlign: 'center',
              boxSizing: 'border-box',
            }}
            title={
              row.export_price > 0
                ? `Deposit price ${row.deposit_price}m. When the stockpile is full, the Crown exports your deposit to local regions (export rate ${row.export_price}m per unit, kept by the Crown).`
                : 'Deposit price - drop matching goods at the machine to sell.'
            }
          >
            Sell {row.deposit_price}m
          </span>
        )}
        <button
          type="button"
          style={{
            ...inkButtonStyle({ disabled: !canWithdraw }),
            width: '90px',
            textAlign: 'center',
            boxSizing: 'border-box',
          }}
          disabled={!canWithdraw}
          onClick={() => act('withdraw', { ref: row.ref })}
        >
          {row.withdraw_disabled ? 'Closed' : `Buy ${row.withdraw_price}m`}
        </button>
        <button
          type="button"
          style={{
            ...inkButtonStyle({ disabled: !canImport }),
            width: '110px',
            textAlign: 'center',
            boxSizing: 'border-box',
          }}
          disabled={!canImport}
          onClick={() => act('direct_import', { ref: row.ref })}
          title={
            row.import_price <= 0
              ? 'No region has supply of this good today.'
              : data.charter_active
                ? 'Import directly. Pays duty to the Crown.'
                : 'Import directly. The surcharge covers transport.'
          }
        >
          {row.import_price > 0 ? `Import ${row.import_price}m` : 'NO SUPPLY'}
        </button>
      </div>
    </div>
  );
};

const CONDITIONS_KEY = '__conditions__';

export const Stockpile = () => {
  const { act, data } = useBackend<Data>();
  const compact = !!data.compact;
  const conditionsCount = data.stocks.filter((r) => !!r.event_tag).length;
  const isConditionsTab = data.category === CONDITIONS_KEY;
  const filtered = isConditionsTab
    ? data.stocks.filter((r) => !!r.event_tag)
    : data.stocks.filter((r) => r.category === data.category);
  const noDeposit = !!data.no_deposit;
  return (
    <Window width={780} height={720} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>{data.title || 'Town Stockpile'}</div>
          <div style={subtitleStyle}>
            {data.subtitle ||
              'The Town Stockpile. Deposit goods at the machine, coins here fund withdrawals and import.'}
          </div>
          <div style={rulerStyle} />

          <div
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px',
              padding: '4px 8px',
              borderBottom: `1px solid ${PARCHMENT_SHADOW}`,
              fontFamily: SERIF,
              fontSize: FONT_BODY,
              marginBottom: '6px',
              flexWrap: 'wrap',
            }}
          >
            <span style={{ color: SEAL_AMBER }}>
              Coinpouch
            </span>
            <span
              style={{
                color: data.budget > 0 ? INK : INK_FAINT,
                fontWeight: 'bold',
              }}
            >
              {data.budget}m
            </span>
            {!!data.food_stipend && (
              <span style={{ color: SEAL_GREEN }}>
                treasury-line
              </span>
            )}
            {!!data.below_floor && (
              <span style={{ color: SEAL_RED }}>
                crown ledger thin
              </span>
            )}
            <CharterChip data={data} />
            <div style={{ marginLeft: 'auto', display: 'flex', gap: '4px' }}>
              <button
                type="button"
                style={inkButtonStyle({ disabled: data.budget <= 0 })}
                disabled={data.budget <= 0}
                onClick={() => act('refund_budget')}
              >
                Refund
              </button>
              <button
                type="button"
                style={inkButtonStyle()}
                onClick={() => act('toggle_compact')}
              >
                {compact ? 'Detailed' : 'Compact'}
              </button>
            </div>
          </div>

          <div style={subTabBarStyle}>
            <div
              style={subTabStyle(isConditionsTab)}
              onClick={() => act('set_category', { category: CONDITIONS_KEY })}
            >
              Conditions {conditionsCount > 0 && `(${conditionsCount})`}
            </div>
            {data.categories.map((c) => (
              <div
                key={c}
                style={subTabStyle(c === data.category)}
                onClick={() => act('set_category', { category: c })}
              >
                {c}
              </div>
            ))}
          </div>

          <div style={sectionHeaderStyle}>
            {isConditionsTab
              ? `Market Conditions (${filtered.length})`
              : `${data.category} (${filtered.length})`}
          </div>
          {filtered.length === 0 ? (
            <div
              style={{
                ...cardStyle,
                textAlign: 'center',
                fontStyle: 'italic',
                color: INK_SOFT,
              }}
            >
              No stock in this category.
            </div>
          ) : (
            filtered.map((row) => (
              <StockRowView
                key={row.ref}
                row={row}
                data={data}
                act={act}
                compact={compact}
              />
            ))
          )}

          {!noDeposit && data.bounties.length > 0 && (
            <>
              <div style={{ ...sectionHeaderStyle, marginTop: '16px' }}>
                Standing Bounties
              </div>
              {data.bounties.map((b) => (
                <div
                  key={b.name}
                  style={{
                    display: 'flex',
                    gap: '8px',
                    padding: '4px 8px',
                    borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
                    fontFamily: SERIF,
                    fontSize: FONT_BODY,
                  }}
                >
                  <span style={{ flex: 1, color: INK }}>{b.name}</span>
                  <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                    {b.payout_price}
                    {b.percent ? '%' : 'm'}
                  </span>
                </div>
              ))}
            </>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
