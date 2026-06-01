import { useState } from 'react';

import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
} from '../../common/parchment';
import type {
  ActFn,
  CatalogData,
  FavorData,
  FavorLedgerEntry,
  HarborData,
} from '../types';

const labelStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: SEAL_AMBER,
  letterSpacing: '0.04em',
};

const valueStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  color: INK,
};

const noteStyle = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  fontStyle: 'italic' as const,
  color: INK_SOFT,
  lineHeight: 1.4,
};

const LevyControl = (props: {
  current: number;
  cap: number;
  act: ActFn;
}) => {
  const { current, cap, act } = props;
  const [draft, setDraft] = useState<string>(String(current));
  const numeric = Number(draft);
  const valid = !Number.isNaN(numeric) && numeric >= 0 && numeric <= cap;
  const dirty = valid && numeric !== current;
  return (
    <div style={{ ...cardStyle, marginTop: '8px' }}>
      <div style={sectionHeaderStyle}>Merchant&apos;s Levy</div>
      <div style={{ ...noteStyle, marginBottom: '8px' }}>
        Your cut on every export sold through the public Navigator and the ship
        fulfillment crate. The Crown taxes your cut as income at the prevailing
        export duty rate. Capped at {cap}%.
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '12px',
          paddingBottom: '6px',
        }}
      >
        <span style={labelStyle}>Current</span>
        <span style={{ ...valueStyle, fontWeight: 'bold' }}>{current}%</span>
        <span style={{ flex: 1 }} />
        <span style={labelStyle}>Set to</span>
        <input
          type="number"
          min={0}
          max={cap}
          step={1}
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          style={{
            width: '64px',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK,
            background: 'var(--p-button-bg)',
            border: `1px solid ${INK_FAINT}`,
            borderRadius: '2px',
            padding: '2px 6px',
          }}
        />
        <button
          type="button"
          disabled={!dirty}
          style={inkButtonStyle({ disabled: !dirty })}
          onClick={() => {
            if (!dirty) return;
            act('set_levy', { percent: numeric });
          }}
        >
          Set
        </button>
      </div>
    </div>
  );
};

const GnomeMarginControl = (props: {
  current: number;
  act: ActFn;
}) => {
  const { current, act } = props;
  const [draft, setDraft] = useState<string>(String(current));
  const numeric = Number(draft);
  const valid = !Number.isNaN(numeric) && numeric >= 0 && numeric <= 100;
  const dirty = valid && numeric !== current;
  return (
    <div style={{ ...cardStyle, marginTop: '8px' }}>
      <div style={sectionHeaderStyle}>Silverface Margin</div>
      <div style={{ ...noteStyle, marginBottom: '8px' }}>
        The Company Gnomes price every Silverface stall at base cost plus this
        margin. The margin flows to the Merchant Fund. Higher rates earn more per
        sale but drive customers off; lower rates win volume.
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '12px',
          paddingBottom: '6px',
        }}
      >
        <span style={labelStyle}>Current</span>
        <span style={{ ...valueStyle, fontWeight: 'bold' }}>{current}%</span>
        <span style={{ flex: 1 }} />
        <span style={labelStyle}>Set to</span>
        <input
          type="number"
          min={0}
          max={100}
          step={1}
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          style={{
            width: '64px',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK,
            background: 'var(--p-button-bg)',
            border: `1px solid ${INK_FAINT}`,
            borderRadius: '2px',
            padding: '2px 6px',
          }}
        />
        <button
          type="button"
          disabled={!dirty}
          style={inkButtonStyle({ disabled: !dirty })}
          onClick={() => {
            if (!dirty) return;
            act('set_gnome_margin', { percent: numeric });
          }}
        >
          Set
        </button>
      </div>
    </div>
  );
};

const outcomeStyles: Record<FavorLedgerEntry['outcome'], { label: string; color: string }> = {
  honored: { label: 'HONORED', color: SEAL_GREEN },
  partial: { label: 'PARTIAL', color: SEAL_AMBER },
  dishonored: { label: 'DISHONORED', color: SEAL_RED },
};

const TriumphLever = (props: { favor: FavorData }) => {
  const { favor } = props;
  const { high_water, triumph_bonus, triumph_cap, bracket_next, brackets } = favor;
  const atCap = triumph_bonus >= triumph_cap || bracket_next === 0;
  return (
    <div style={{ marginBottom: '10px' }}>
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          marginBottom: '4px',
        }}
      >
        <span style={labelStyle}>Triumph Bonus</span>
        <span style={{ ...valueStyle, fontWeight: 'bold' }}>
          +{triumph_bonus}
          <span style={{ color: INK_SOFT, fontWeight: 'normal' }}> / +{triumph_cap}</span>
        </span>
      </div>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: `repeat(${brackets.length}, 1fr)`,
          gap: '2px',
        }}
      >
        {brackets.map((threshold, idx) => {
          const prev = idx === 0 ? 0 : brackets[idx - 1];
          const earned = high_water >= threshold;
          const active = !earned && high_water >= prev;
          const span = Math.max(1, threshold - prev);
          const fill = earned
            ? 1
            : active
              ? Math.min(1, Math.max(0, (high_water - prev) / span))
              : 0;
          return (
            <div
              key={idx}
              title={`+${idx + 1} Triumph at ${threshold}m volume`}
              style={{
                position: 'relative',
                height: '12px',
                background: 'var(--p-card-bg)',
                border: `1px solid ${earned ? SEAL_GREEN : PARCHMENT_SHADOW}`,
                borderRadius: '2px',
                overflow: 'hidden',
              }}
            >
              <div
                style={{
                  width: `${fill * 100}%`,
                  height: '100%',
                  background: earned ? SEAL_GREEN : SEAL_AMBER,
                  transition: 'width 200ms ease',
                }}
              />
            </div>
          );
        })}
      </div>
      <div
        style={{
          ...noteStyle,
          display: 'flex',
          justifyContent: 'space-between',
          marginTop: '3px',
          fontStyle: 'normal',
        }}
      >
        <span>{high_water}m volume earned</span>
        <span>
          {atCap
            ? 'Bonus maxed out'
            : `Next +${triumph_bonus + 1} at ${bracket_next}m`}
        </span>
      </div>
    </div>
  );
};

const LedgerRow = (props: { entry: FavorLedgerEntry }) => {
  const { entry } = props;
  const style = outcomeStyles[entry.outcome] || outcomeStyles.dishonored;
  const sign = entry.awarded >= 0 ? '+' : '';
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: '70px minmax(0, 1fr) 70px',
        columnGap: '8px',
        alignItems: 'baseline',
        padding: '2px 0',
        fontSize: FONT_BODY,
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
      }}
    >
      <span style={{ color: style.color, fontWeight: 'bold' }}>
        {style.label}
      </span>
      <span style={{ color: INK, overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' }}>
        {entry.ship_name} <span style={{ color: INK_SOFT }}>- {entry.realm_label}</span>
        {entry.refunded_hail ? (
          <span style={{ color: SEAL_GREEN }}> (hail refunded)</span>
        ) : null}
      </span>
      <span
        style={{
          textAlign: 'right',
          color: entry.awarded >= 0 ? SEAL_GREEN : SEAL_RED,
          fontWeight: 'bold',
        }}
      >
        {sign}{entry.awarded}m
      </span>
    </div>
  );
};

const SinkButton = (props: {
  label: string;
  flavor: string;
  cost: number;
  current: number;
  done: boolean;
  doneLabel: string;
  action: string;
  params?: Record<string, unknown>;
  act: ActFn;
}) => {
  const { label, flavor, cost, current, done, doneLabel, action, params, act } =
    props;
  const canAfford = current >= cost;
  const disabled = done || !canAfford;
  return (
    <div
      style={{
        padding: '8px 10px',
        border: `1px solid ${INK_FAINT}`,
        background: done ? 'rgba(180,200,160,0.18)' : 'var(--p-card-bg)',
        borderRadius: '2px',
        marginTop: '6px',
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          marginBottom: '4px',
        }}
      >
        <span style={{ ...labelStyle, color: INK, fontSize: FONT_BODY }}>{label}</span>
        <span style={{ ...valueStyle, fontWeight: 'bold' }}>
          {done ? (
            <span style={{ color: SEAL_GREEN }}>{doneLabel}</span>
          ) : (
            <>
              {cost}m
              <span style={{ color: canAfford ? INK_SOFT : SEAL_RED, fontWeight: 'normal' }}>
                {' '}({current}m on hand)
              </span>
            </>
          )}
        </span>
      </div>
      <div style={{ ...noteStyle, marginBottom: '6px' }}>{flavor}</div>
      <button
        type="button"
        disabled={disabled}
        style={inkButtonStyle({ disabled })}
        onClick={() => {
          if (disabled) return;
          act(action, params);
        }}
      >
        {done ? 'Already in effect' : canAfford ? 'Spend favor' : 'Not enough favor'}
      </button>
    </div>
  );
};

const FavorCard = (props: {
  favor: FavorData;
  catalogs: CatalogData[];
  act: ActFn;
}) => {
  const { favor, catalogs, act } = props;
  return (
    <div style={{ ...cardStyle, marginTop: '8px' }}>
      <div style={sectionHeaderStyle}>Standing with the Company</div>
      <div style={{ ...noteStyle, marginBottom: '8px' }}>
        Earned by sending ships off satisfied or passive trades through Silverface, Goldface and Navigator (At 0.5x value). Spent on Company favors. Volume hit
        also determines the Merchant and Shopshands end of round triumph bonus - spending favor does not subtract from it.
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          marginBottom: '8px',
        }}
      >
        <span style={labelStyle}>Favor on hand</span>
        <span style={{ ...valueStyle, fontWeight: 'bold', fontSize: '16px' }}>
          {favor.current}m
        </span>
      </div>
      <TriumphLever favor={favor} />
      <div
        style={{
          ...labelStyle,
          marginTop: '10px',
          marginBottom: '4px',
          color: INK,
          fontSize: FONT_BODY,
        }}
      >
        Favor sources this week
      </div>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: '1fr auto',
          rowGap: '3px',
          columnGap: '12px',
          fontSize: FONT_BODY,
          marginBottom: '6px',
        }}
      >
        <span style={{ color: INK }}>Ship send-offs</span>
        <span style={{ color: SEAL_GREEN, fontWeight: 'bold', textAlign: 'right' }}>
          +{favor.from_sendoffs}m
        </span>
        <span style={{ color: INK }}>Navigator trade</span>
        <span style={{ color: SEAL_GREEN, fontWeight: 'bold', textAlign: 'right' }}>
          +{favor.from_navigator}m
        </span>
        <span style={{ color: INK }}>Goldface imports</span>
        <span style={{ color: SEAL_GREEN, fontWeight: 'bold', textAlign: 'right' }}>
          +{favor.from_goldface}m
        </span>
        <span style={{ color: INK }}>Silverface imports</span>
        <span style={{ color: SEAL_GREEN, fontWeight: 'bold', textAlign: 'right' }}>
          +{favor.from_silverface}m
        </span>
        {favor.penalties > 0 && (
          <>
            <span style={{ color: INK }}>Dishonor penalties</span>
            <span style={{ color: SEAL_RED, fontWeight: 'bold', textAlign: 'right' }}>
              -{favor.penalties}m
            </span>
          </>
        )}
        <span style={{ color: INK_SOFT }}>Lyfetime peak</span>
        <span style={{ color: SEAL_AMBER, fontWeight: 'bold', textAlign: 'right' }}>
          {favor.high_water}m
        </span>
      </div>
      <div
        style={{
          ...labelStyle,
          marginTop: '10px',
          marginBottom: '4px',
          color: INK,
          fontSize: FONT_BODY,
        }}
      >
        Recent send-offs
      </div>
      {favor.ledger.length === 0 ? (
        <div style={{ ...noteStyle, padding: '4px 0' }}>
          No ships sent off yet this week.
        </div>
      ) : (
        favor.ledger.map((entry, idx) => (
          <LedgerRow key={idx} entry={entry} />
        ))
      )}
      <div
        style={{
          ...labelStyle,
          marginTop: '10px',
          marginBottom: '4px',
          color: INK,
          fontSize: FONT_BODY,
        }}
      >
        Spend favor
      </div>
      <SinkButton
        label="Rent the fishermen's pier"
        flavor="Use your influence to rent an additional pier at the dock for this week, letting more ships dock. It is not like the fishermen are using it, anyway."
        cost={favor.pier_cost}
        current={favor.current}
        done={!!favor.pier_rented}
        doneLabel="LET THIS WEEK"
        action="rent_pier"
        act={act}
      />
      <SinkButton
        label="Call in the Company Gnomes"
        flavor="Invoke the contract with the Azurean Guild of Gnomes Porters, letting them handle Silverface sales and recovering the margins for yourself. For some odd reasons no one have ever spotted these gnomes. Do not let this deter you, you shall profit greatly without lifting a finger for the rest of the week."
        cost={favor.gnome_cost}
        current={favor.current}
        done={!!favor.gnome_unlocked}
        doneLabel="ON THE PAYROLL"
        action="unlock_gnomes"
        act={act}
      />
      {!favor.auto_hailer_unlocked ? (
        <SinkButton
          label="Retain the Harbor Crew"
          flavor="Put the Captain of Stevedores on a permanent retainer. Once paid up, you may set them at the docks at any time, hailing ships randomly and dismissing those that have lingered too long. Useful when the wharf must run without you - but beware: Ships that fail to meet their trade obligations will still drag your favor down with the Company, even into the red."
          cost={favor.auto_hailer_cost}
          current={favor.current}
          done={false}
          doneLabel="ON RETAINER"
          action="unlock_auto_hailer"
          act={act}
        />
      ) : (
        <AutoHailerToggle
          on={!!favor.auto_hailer_on}
          act={act}
        />
      )}
      {/* TODO: flavor - charter button label + flavor (catalog.desc from DM, origin note inline) */}
      {catalogs.map((catalog) => (
        <SinkButton
          key={catalog.id}
          label={`Open the ${catalog.name}`}
          flavor={
            catalog.desc +
            (catalog.origin_access
              ? ` Your ${catalog.home_label} already opens it to you at ${catalog.discount_pct}% off; pay to extend the charter to the whole company.`
              : '')
          }
          cost={catalog.favor_cost}
          current={favor.current}
          done={!!catalog.unlocked}
          doneLabel="CHARTER OPEN"
          action="unlock_catalog"
          params={{ catalog: catalog.id }}
          act={act}
        />
      ))}
    </div>
  );
};

const AutoHailerToggle = (props: {
  on: boolean;
  act: ActFn;
}) => {
  const { on, act } = props;
  return (
    <div
      style={{
        padding: '8px 10px',
        border: `1px solid ${INK_FAINT}`,
        background: on ? 'rgba(180,200,160,0.18)' : 'var(--p-card-bg)',
        borderRadius: '2px',
        marginTop: '6px',
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          marginBottom: '4px',
        }}
      >
        <span style={{ ...labelStyle, color: INK, fontSize: FONT_BODY }}>
          Auto-Hailer (Harbor Crew)
        </span>
        <span style={{ ...valueStyle, fontWeight: 'bold' }}>
          {on ? (
            <span style={{ color: SEAL_GREEN }}>WORKING</span>
          ) : (
            <span style={{ color: INK_SOFT }}>STANDING DOWN</span>
          )}
        </span>
      </div>
      <div style={{ ...noteStyle, marginBottom: '6px' }}>
        While the crew works, ships are hailed up to the daily cap and dismissed once they have honored their tonnage or sat in port a full day. <b>Dishonored dismissals will sink your favor into the red</b> - leave it on, and you may return to a debt.
      </div>
      <button
        type="button"
        style={inkButtonStyle({})}
        onClick={() => act('toggle_auto_hailer')}
      >
        {on ? 'Stand down' : 'Set the crew to work'}
      </button>
    </div>
  );
};

export const ManagementTab = (props: {
  harbor?: HarborData;
  act: ActFn;
}) => {
  const { harbor, act } = props;
  if (!harbor) {
    return (
      <div style={pageStyle}>
        <div style={{ ...cardStyle, textAlign: 'center', color: INK_SOFT }}>
          The ledgers are not yet drawn up.
        </div>
      </div>
    );
  }
  return (
    <div style={pageStyle}>
      <FavorCard
        favor={harbor.favor}
        catalogs={harbor.catalogs ?? []}
        act={act}
      />
      <LevyControl
        current={harbor.merchant_levy_percent}
        cap={harbor.merchant_levy_cap}
        act={act}
      />
      {!!harbor.favor.gnome_unlocked && (
        <GnomeMarginControl
          current={harbor.ledger.silverface_margin_percent}
          act={act}
        />
      )}
    </div>
  );
};
