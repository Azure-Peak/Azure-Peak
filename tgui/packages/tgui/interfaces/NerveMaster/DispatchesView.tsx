import type { CSSProperties } from 'react';

import { formatMammon } from '../common/format';
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
import { ATCLoanSection } from './ATCLoanSection';
import type { Data, EconomicEvent } from './types';

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
  const events = data.events || [];
  const blockades = data.blockades || [];

  const p = data.banditry_projection;
  const hasBrigands = !!p && (p.total > 0 || p.debt > 0 || p.hoard_total > 0);

  const loan = data.atc_loan;
  const hasLoan =
    !!loan?.can_view &&
    (!!loan.available || loan.loans_drawn > 0 || !!loan.arrears_consumed);

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
          events.map((e) => <EventRow key={e.name} event={e} />)
        ) : (
          <div style={{ color: INK_FAINT }}>None.</div>
        )}
      </div>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
        {hasLoan && <ATCLoanSection atc_loan={loan} />}

        {blockades.length > 0 && (
          <div>
            <div style={headerStyle}>Blockaded Regions</div>
            {blockades.map((route) => (
              <div key={route.name} style={{ marginBottom: '6px' }}>
                <b>{route.name}</b>
                {route.legs.map((leg) => (
                  <div key={leg.name} style={{ paddingLeft: '10px' }}>
                    <div>
                      {[leg.name, leg.threat_region, leg.raiders]
                        .filter(Boolean)
                        .join(' - ')}
                    </div>
                    <div style={smallSoft}>{leg.regions.join(', ')}</div>
                  </div>
                ))}
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

const EventRow = (props: { event: EconomicEvent }) => {
  const e = props.event;
  const scarce = e.shortage_goods || [];
  const cheap = e.glut_goods || [];
  const target = e.saturation_target || 0;
  const progress = e.saturation_progress || 0;
  const pct =
    scarce.length > 0 && target > 0
      ? Math.min(100, Math.round((progress / target) * 100))
      : 0;
  const scarceNames = scarce.join(', ');
  const cheapNames = cheap.join(', ');
  const relief = `Relief: ${formatMammon(Math.round(progress))}m / ${formatMammon(Math.round(target))}m sold (${pct}%). Accepts: ${scarceNames}`;
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
        {scarce.length > 0 && (
          <span style={{ fontSize: FONT_SMALL, color: SEAL_RED }}>Shortage</span>
        )}
        {cheap.length > 0 && (
          <span style={{ fontSize: FONT_SMALL, color: SEAL_GREEN }}>Glut</span>
        )}
        <b style={{ ...ellipsisCellStyle, color: INK }}>{e.name}</b>
        <span style={{ flex: '0 0 auto', color: INK_SOFT }}>
          {e.days_left}d left
        </span>
      </div>
      <div style={smallSoft}>{e.description}</div>
      {cheap.length > 0 && <div style={smallSoft}>Cheap: {cheapNames}</div>}
      {scarce.length > 0 && target > 0 && (
        <div
          style={{
            display: 'flex',
            alignItems: 'flex-start',
            gap: '8px',
            ...smallSoft,
          }}
        >
          <span style={{ flex: '1 1 auto', minWidth: 0, overflowWrap: 'anywhere' }}>
            {relief}
          </span>
          <div
            style={{
              flex: '0 0 100px',
              marginTop: '6px',
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
