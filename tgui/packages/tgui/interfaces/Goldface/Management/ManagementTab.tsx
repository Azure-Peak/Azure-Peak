import { type CSSProperties, useState } from 'react';

import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  inkInputStyle,
  PARCHMENT_SHADOW,
  pageStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  sectionHeaderStyle,
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

const subLabelStyle = {
  ...labelStyle,
  color: INK,
  marginTop: '10px',
  marginBottom: '4px',
};

const gridCardStyle: CSSProperties = { ...cardStyle, marginBottom: 0 };

const tileStyle = (active: boolean): CSSProperties => ({
  padding: '6px 10px',
  border: `1px solid ${INK_FAINT}`,
  background: active ? 'rgba(180,200,160,0.18)' : 'var(--p-card-bg)',
  borderRadius: '2px',
});

const tileHeaderStyle: CSSProperties = {
  display: 'flex',
  flexWrap: 'wrap',
  alignItems: 'center',
  gap: '8px',
  marginBottom: '3px',
};

const tileTitleStyle: CSSProperties = {
  ...labelStyle,
  color: INK,
  flex: 1,
  minWidth: 0,
};

const doneTagStyle: CSSProperties = {
  ...valueStyle,
  fontWeight: 'bold',
  color: SEAL_GREEN,
  whiteSpace: 'nowrap',
};

const RateRow = (props: {
  label: string;
  current: number;
  max: number;
  onSet: (percent: number) => void;
}) => {
  const { label, current, max, onSet } = props;
  const [draft, setDraft] = useState<string>(String(current));
  const numeric = Number(draft);
  const valid =
    draft !== '' && !Number.isNaN(numeric) && numeric >= 0 && numeric <= max;
  const dirty = valid && numeric !== current;
  const submit = () => {
    if (dirty) onSet(numeric);
  };
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        padding: '4px 0',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
      }}
    >
      <span style={{ ...labelStyle, flex: 1 }}>{label}</span>
      <span
        style={{
          ...valueStyle,
          fontWeight: 'bold',
          minWidth: '40px',
          textAlign: 'right',
        }}
      >
        {current}%
      </span>
      <input
        type="number"
        min={0}
        max={max}
        step={1}
        value={draft}
        onChange={(e) => setDraft(e.target.value)}
        onKeyDown={(e) => {
          if (e.key === 'Enter') submit();
        }}
        style={{ ...inkInputStyle, width: '56px' }}
      />
      <button
        type="button"
        disabled={!dirty}
        style={inkButtonStyle({ disabled: !dirty })}
        onClick={submit}
      >
        Set
      </button>
    </div>
  );
};

const RatesCard = (props: { harbor: HarborData; act: ActFn }) => {
  const { harbor, act } = props;
  const cap = harbor.merchant_levy_cap;
  return (
    <div style={gridCardStyle}>
      <div style={{ ...sectionHeaderStyle, marginTop: '4px' }}>
        Merchant&apos;s Levy
      </div>
      <div style={{ ...noteStyle, marginBottom: '6px' }}>
        Your cut on every export sold through the public Navigator and the ship
        fulfillment crate. The Crown taxes your cut as income at the prevailing
        export duty rate. Capped at {cap}%.
      </div>
      <RateRow
        label="Navigator sales"
        current={harbor.navigator_levy_percent}
        max={cap}
        onSet={(percent) => act('set_levy', { kind: 'navigator', percent })}
      />
      <RateRow
        label="Ship exports"
        current={harbor.fulfillment_levy_percent}
        max={cap}
        onSet={(percent) => act('set_levy', { kind: 'fulfillment', percent })}
      />
      {!!harbor.favor.gnome_unlocked && (
        <>
          <div style={{ ...sectionHeaderStyle, marginTop: '14px' }}>
            Silverface Margin
          </div>
          <div style={{ ...noteStyle, marginBottom: '6px' }}>
            The Company Gnomes price every Silverface stall at base cost plus
            this margin. The margin flows to the Merchant Fund. Higher rates
            earn more per sale and drive customers off. Lower rates win volume.
          </div>
          <RateRow
            label="Margin"
            current={harbor.ledger.silverface_margin_percent}
            max={100}
            onSet={(percent) => act('set_gnome_margin', { percent })}
          />
        </>
      )}
    </div>
  );
};

const outcomeStyles: Record<
  FavorLedgerEntry['outcome'],
  { label: string; color: string }
> = {
  honored: { label: 'HONORED', color: SEAL_GREEN },
  partial: { label: 'PARTIAL', color: SEAL_AMBER },
  dishonored: { label: 'DISHONORED', color: SEAL_RED },
};

const TriumphLever = (props: { favor: FavorData }) => {
  const { favor } = props;
  const { high_water, triumph_bonus, triumph_cap, bracket_next, brackets } =
    favor;
  const atCap = triumph_bonus >= triumph_cap || bracket_next === 0;
  return (
    <div style={{ marginBottom: '6px' }}>
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
          <span style={{ color: INK_SOFT, fontWeight: 'normal' }}>
            {' '}
            / +{triumph_cap}
          </span>
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
              title={`+${idx + 1} Triumph at ${threshold} favor`}
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
        <span>{high_water} favor earned</span>
        <span>
          {atCap
            ? 'Bonus maxed out'
            : `Next +${triumph_bonus + 1} at ${bracket_next} favor`}
        </span>
      </div>
    </div>
  );
};

const FavorSources = (props: { favor: FavorData }) => {
  const { favor } = props;
  const rows = [
    { label: 'Ship send-offs', value: `+${favor.from_sendoffs}`, color: SEAL_GREEN },
    { label: 'Navigator trade', value: `+${favor.from_navigator}`, color: SEAL_GREEN },
    { label: 'Goldface imports', value: `+${favor.from_goldface}`, color: SEAL_GREEN },
    { label: 'Silverface imports', value: `+${favor.from_silverface}`, color: SEAL_GREEN },
  ];
  if (favor.penalties > 0) {
    rows.push({
      label: 'Dishonor penalties',
      value: `-${favor.penalties}`,
      color: SEAL_RED,
    });
  }
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(2, minmax(0, 1fr))',
        columnGap: '20px',
        rowGap: '3px',
        fontSize: FONT_BODY,
      }}
    >
      {rows.map((row) => (
        <div
          key={row.label}
          style={{
            display: 'flex',
            justifyContent: 'space-between',
            gap: '8px',
          }}
        >
          <span style={{ color: INK }}>{row.label}</span>
          <span style={{ color: row.color, fontWeight: 'bold' }}>
            {row.value}
          </span>
        </div>
      ))}
    </div>
  );
};

const StandingCard = (props: { favor: FavorData }) => {
  const { favor } = props;
  return (
    <div style={gridCardStyle}>
      <div
        style={{
          ...sectionHeaderStyle,
          marginTop: '4px',
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          gap: '8px',
        }}
      >
        <span>Standing with the Company</span>
        <span style={{ whiteSpace: 'nowrap' }}>
          <span style={{ ...labelStyle, fontWeight: 'normal' }}>
            Favor on hand{' '}
          </span>
          <span style={{ fontSize: '16px' }}>{favor.current}</span>
        </span>
      </div>
      <div style={{ ...noteStyle, marginBottom: '8px' }}>
        Earned by sending ships off satisfied and from trades through
        Silverface, Goldface and the Navigator at {favor.passive_pct}% of their
        value. Spend it on the ATC favors below. Your highest favor this week
        sets the end of round triumph bonus for the Merchant and Shophands.
        Spending favor doesn&apos;t lower it.
      </div>
      <TriumphLever favor={favor} />
      <div style={subLabelStyle}>Favor sources this week</div>
      <FavorSources favor={favor} />
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
        gridTemplateColumns: '78px minmax(0, 1fr) 50px',
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
      <span
        style={{
          color: INK,
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          whiteSpace: 'nowrap',
        }}
      >
        {entry.ship_name}{' '}
        <span style={{ color: INK_SOFT }}>- {entry.realm_label}</span>
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
        {sign}
        {entry.awarded}
      </span>
    </div>
  );
};

const SendoffsCard = (props: { favor: FavorData }) => {
  const { favor } = props;
  return (
    <div style={gridCardStyle}>
      <div style={{ ...sectionHeaderStyle, marginTop: '4px' }}>
        Recent sendoffs
      </div>
      {favor.ledger.length === 0 ? (
        <div style={{ ...noteStyle, padding: '2px 0' }}>
          No ships sent off yet this week.
        </div>
      ) : (
        favor.ledger.map((entry, idx) => <LedgerRow key={idx} entry={entry} />)
      )}
    </div>
  );
};

const SinkTile = (props: {
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
    <div style={tileStyle(done)}>
      <div style={tileHeaderStyle}>
        <span style={tileTitleStyle}>{label}</span>
        {done ? (
          <span style={doneTagStyle}>{doneLabel}</span>
        ) : (
          <button
            type="button"
            disabled={disabled}
            title={canAfford ? 'Spend favor' : 'Not enough favor'}
            style={inkButtonStyle({
              disabled,
              color: canAfford ? undefined : SEAL_RED,
            })}
            onClick={() => {
              if (disabled) return;
              act(action, params);
            }}
          >
            {cost} favor
          </button>
        )}
      </div>
      <div style={noteStyle}>{flavor}</div>
    </div>
  );
};

const SendForShip = (props: { favor: FavorData; act: ActFn }) => {
  const { favor, act } = props;
  const [picked, setPicked] = useState<string | null>(null);
  const realms = favor.send_for_realms ?? [];
  const usedToday = !!favor.send_for_ship_used_today;
  const canAfford = favor.current >= favor.send_for_ship_cost;
  const pickedRealm = realms.find((r) => r.id === picked && !r.available);
  const disabled = usedToday || !canAfford || !pickedRealm;
  return (
    <div style={tileStyle(usedToday)}>
      <div style={tileHeaderStyle}>
        <span style={tileTitleStyle}>Send the zads for a ship</span>
        {usedToday ? (
          <span style={doneTagStyle}>SENT TODAY</span>
        ) : (
          <span
            style={{
              ...valueStyle,
              fontWeight: 'bold',
              color: canAfford ? INK : SEAL_RED,
            }}
          >
            {favor.send_for_ship_cost} favor
          </span>
        )}
      </div>
      <div style={{ ...noteStyle, marginBottom: '6px' }}>
        Send for a ship from the realm of your choosing. She waits offshore for
        your hail until the next dae. Once per dae.
      </div>
      <div
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          alignItems: 'center',
          gap: '4px',
        }}
      >
        {realms.map((r) => {
          const blocked = !!r.available;
          const selected = picked === r.id && !blocked;
          return (
            <button
              key={r.id}
              type="button"
              disabled={blocked}
              title={blocked ? 'A ship from here is already offshore.' : ''}
              style={inkButtonStyle({
                disabled: blocked,
                color: selected ? SEAL_AMBER : undefined,
              })}
              onClick={() => !blocked && setPicked(r.id)}
            >
              {r.name}
            </button>
          );
        })}
        <button
          type="button"
          disabled={disabled}
          style={{ ...inkButtonStyle({ disabled }), marginLeft: 'auto' }}
          onClick={() => {
            if (disabled || !pickedRealm) return;
            act('send_for_ship', { realm: pickedRealm.id });
            setPicked(null);
          }}
        >
          {usedToday
            ? 'Already sent today'
            : !canAfford
              ? 'Not enough favor'
              : pickedRealm
                ? `Send the zads for a ${pickedRealm.name} ship`
                : 'Choose a realm'}
        </button>
      </div>
    </div>
  );
};

const AutoHailerToggle = (props: {
  on: boolean;
  favor: FavorData;
  act: ActFn;
}) => {
  const { on, favor, act } = props;
  return (
    <div style={tileStyle(on)}>
      <div style={tileHeaderStyle}>
        <span style={tileTitleStyle}>Harbor Crew</span>
        <span
          style={{
            ...valueStyle,
            fontWeight: 'bold',
            color: on ? SEAL_GREEN : INK_SOFT,
          }}
        >
          {on ? 'WORKING' : 'STANDING DOWN'}
        </span>
        <button
          type="button"
          style={inkButtonStyle({})}
          onClick={() => act('toggle_auto_hailer')}
        >
          {on ? 'Stand down' : 'Set the crew to work'}
        </button>
      </div>
      <div style={noteStyle}>
        While the crew works, they spend your daily hails and send each ship off
        once she meets her target or has sat in port a full day.{' '}
        <b>
          A ship sent off below {favor.sendoff_partial_pct}% of her target costs
          you favor. Your favor can go below zero.
        </b>
      </div>
    </div>
  );
};

const SpendFavorCard = (props: {
  favor: FavorData;
  catalogs: CatalogData[];
  act: ActFn;
}) => {
  const { favor, catalogs, act } = props;
  return (
    <div style={{ ...cardStyle, marginTop: '10px' }}>
      <div style={{ ...sectionHeaderStyle, marginTop: '4px' }}>Spend favor</div>
      <SendForShip favor={favor} act={act} />
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fill, minmax(300px, 1fr))',
          gap: '6px',
          marginTop: '6px',
        }}
      >
        <SinkTile
          label="Rent the fishermen's pier"
          flavor="Use your influence to rent an additional pier at the dock for this week so more ships can dock. It is not like the fishermen are using it, anyway."
          cost={favor.pier_cost}
          current={favor.current}
          done={!!favor.pier_rented}
          doneLabel="LET THIS WEEK"
          action="rent_pier"
          act={act}
        />
        <SinkTile
          label="Petition for increased monopoly rights on export"
          flavor={`The law against cabotage bars re-exporting town goods. Unless you're part of the Azurian Trading Company, who have a special monopoly on doing so. ${favor.licence_left}m of ${favor.licence_total}m is left today. Expanding it doubles the allowance for the rest of the week.`}
          cost={favor.licence_cost}
          current={favor.current}
          done={!!favor.licence_extended}
          doneLabel="EXPANDED"
          action="extend_export_licence"
          act={act}
        />
        <SinkTile
          label="Call in the Company Gnomes"
          flavor="Invoke the contract with the Azurian Guild of Porters and Stevedores. They handle Silverface sales and you recover the margins for yourself. For some odd reason, no one has ever spotted these gnomes. Do not let this deter you. You will profit greatly without lifting a finger for the rest of the week."
          cost={favor.gnome_cost}
          current={favor.current}
          done={!!favor.gnome_unlocked}
          doneLabel="ON THE PAYROLL"
          action="unlock_gnomes"
          act={act}
        />
        {!favor.auto_hailer_unlocked ? (
          <SinkTile
            label="Retain the Harbor Crew"
            flavor="Put the Captain of Stevedores on a permanent retainer. Once paid, you can set the crew to work at the docks at any time. They hail ships at random and send off those that have stayed too long. That is useful when you are away from the wharf. Ships that leave short of their target still cost you favor. Your favor can drop below zero."
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
            favor={favor}
            act={act}
          />
        )}
        {/* TODO: flavor - charter button label + flavor (catalog.desc from DM, origin note inline) */}
        {catalogs.map((catalog) => (
          <SinkTile
            key={catalog.id}
            label={`Open the ${catalog.name}`}
            flavor={
              catalog.desc +
              (catalog.origin_access
                ? ` Your ${catalog.home_label} already opens it to you at ${catalog.discount_pct}% off. Pay to open it to everyone who trades at your Goldface.`
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
    </div>
  );
};

export const ManagementTab = (props: { harbor?: HarborData; act: ActFn }) => {
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
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(340px, 1fr))',
          gap: '10px',
          alignItems: 'start',
          marginTop: '8px',
        }}
      >
        <StandingCard favor={harbor.favor} />
        <div style={{ display: 'grid', gap: '10px' }}>
          <RatesCard harbor={harbor} act={act} />
          <SendoffsCard favor={harbor.favor} />
        </div>
      </div>
      <SpendFavorCard
        favor={harbor.favor}
        catalogs={harbor.catalogs ?? []}
        act={act}
      />
    </div>
  );
};
