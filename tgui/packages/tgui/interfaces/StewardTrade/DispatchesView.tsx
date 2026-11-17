import type { CSSProperties } from 'react';

import {
  ellipsisCellStyle,
  FONT_BODY,
  FONT_SMALL,
  INK,
  INK_FAINT,
  INK_SOFT,
  PARCHMENT_SHADOW,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';
import { ATCLoanBanner } from './ATCLoanBanner';
import type { Data, EconomicEvent } from './types';

export const dispatchCount = (data: Data) =>
  (data.atc_loan?.available ? 1 : 0) +
  (data.active_events || []).filter(
    (e) => e.event_type === 'shortage' && e.saturation_target > 0,
  ).length;

const headerStyle: CSSProperties = {
  ...sectionHeaderStyle,
  marginTop: 0,
  display: 'flex',
  justifyContent: 'space-between',
  alignItems: 'baseline',
};

const smallSoft: CSSProperties = { fontSize: FONT_SMALL, color: INK_SOFT };

export const DispatchesView = (props: { data: Data }) => {
  const { data } = props;
  const events = data.active_events || [];
  const goodName = (id: string) => data.good_catalog[id]?.name || id;

  const blockades = (data.caravan_routes || [])
    .map((r) => ({
      name: r.name,
      regions: ([] as string[])
        .concat(...r.subroutes.map((s) => s.region_ids))
        .filter((id) => data.region_caravan[id]?.blockaded)
        .map((id) => data.region_catalog[id]?.name ?? id),
    }))
    .filter((r) => r.regions.length);

  const p = data.banditry_projection;
  const hasBrigands = !!p && (p.total > 0 || p.debt > 0 || p.hoard_total > 0);

  const loan = data.atc_loan;
  const hasLoan =
    !!loan?.can_view &&
    (!!loan.available || loan.loans_drawn > 0 || !!loan.arrears_consumed);

  if (!events.length && !blockades.length && !hasBrigands && !hasLoan) {
    return (
      <div style={{ padding: '12px 0', color: INK_FAINT }}>No dispatches.</div>
    );
  }

  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'minmax(0, 1.25fr) minmax(0, 1fr)',
        gap: '16px',
        alignItems: 'start',
        padding: '12px 0',
      }}
    >
      <div>
        <div style={headerStyle}>Active Economic Events</div>
        {events.length ? (
          events.map((e) => (
            <EventRow key={e.name} event={e} goodName={goodName} />
          ))
        ) : (
          <div style={{ color: INK_FAINT }}>None.</div>
        )}
      </div>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
        {hasLoan && <ATCLoanBanner atc_loan={loan} />}

        {blockades.length > 0 && (
          <div>
            <div style={headerStyle}>Blockaded Regions</div>
            {blockades.map((b) => (
              <div key={b.name} style={{ marginBottom: '4px' }}>
                <b>{b.name}</b>
                <div style={smallSoft}>{b.regions.join(', ')}</div>
              </div>
            ))}
          </div>
        )}

        {hasBrigands && (
          <div>
            <div style={headerStyle}>
              <span>Projected Losses to Brigands</span>
              {p.total > 0 && (
                <span style={{ color: SEAL_RED, fontSize: FONT_BODY }}>
                  -{p.total}m next dawn
                </span>
              )}
            </div>
            {p.debt > 0 && (
              <div style={{ color: SEAL_RED, marginBottom: '4px' }}>
                Brigand Debt: {p.debt}m, skimmed from all inflow
              </div>
            )}
            <div
              style={{
                display: 'grid',
                gridTemplateColumns: 'minmax(0, 1fr) auto',
                gap: '2px 12px',
              }}
            >
              {(p.rows || []).map((row) => (
                <div key={row.region} style={{ display: 'contents' }}>
                  <span title={row.detail}>
                    {row.region}{' '}
                    <span style={{ color: INK_SOFT }}>({row.level})</span>
                  </span>
                  <span style={{ color: SEAL_RED, textAlign: 'right' }}>
                    -{row.cost}m
                  </span>
                </div>
              ))}
            </div>
            {p.hoard_total > 0 && (
              <div style={{ ...smallSoft, marginTop: '4px' }}>
                Brigands are sitting on {p.hoard_total}m. When a hoard is
                recovered, the Crown taxes a share of it.
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

const EventRow = (props: {
  event: EconomicEvent;
  goodName: (id: string) => string;
}) => {
  const e = props.event;
  const isShortage = e.event_type === 'shortage';
  const target = e.saturation_target || 0;
  const progress = e.saturation_progress || 0;
  const pct =
    isShortage && target > 0
      ? Math.min(100, Math.round((progress / target) * 100))
      : 0;
  const affected = (e.affected_goods || []).map(props.goodName).join(', ');
  const relief = `Relief: ${progress} / ${target} units delivered (${pct}%). Accepts: ${affected}`;
  return (
    <div
      style={{
        padding: '6px 0',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        display: 'flex',
        flexDirection: 'column',
        gap: '2px',
      }}
    >
      <div style={{ display: 'flex', alignItems: 'baseline', gap: '8px' }}>
        <span
          style={{ fontSize: FONT_SMALL, color: isShortage ? SEAL_RED : SEAL_GREEN }}
        >
          {isShortage ? 'Shortage' : 'Glut'}
        </span>
        <b style={{ ...ellipsisCellStyle, color: INK }}>{e.name}</b>
        <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
          {e.days_left}d left
        </span>
      </div>
      <div style={smallSoft}>{e.description}</div>
      {isShortage && target > 0 && (
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            ...smallSoft,
          }}
        >
          <span style={ellipsisCellStyle} title={relief}>
            {relief}
          </span>
          <div
            style={{
              flex: '0 0 100px',
              height: '4px',
              background: '#3a2a1a',
              border: '1px solid #5a4a3a',
              borderRadius: '1px',
            }}
          >
            <div
              style={{ height: '100%', width: `${pct}%`, background: SEAL_GREEN }}
            />
          </div>
        </div>
      )}
    </div>
  );
};
