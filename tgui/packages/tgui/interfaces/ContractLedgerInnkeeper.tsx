import { type ReactNode, useState } from 'react';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';

type RumorLogEntry = {
  title: string;
  type: string;
  region: string;
  in_hands: BooleanLike;
  day: number;
};

type InnkeeperData = {
  rumor_points: number;
  rumor_refill_base: number;
  rumor_refill_per_player: number;
  rumor_active_players: number;
  rumor_costs: Record<string, number>;
  rumor_regions_by_type: Record<string, string[]>;
  rumor_destinations: string[];
  rumor_log: RumorLogEntry[];
  rumor_lucrative_mult: number;
};

type DispatchMode = 'board' | 'hands';
type SubTab = 'compose' | 'history';
const RECOVERY_TYPE = 'Recovery';
const DISPATCH_DEBOUNCE_MS = 500;

const pts = (n: number) => `${n}\u00A0pt${n === 1 ? '' : 's'}`;

const FormRow = (props: { label: string; children: ReactNode }) => (
  <div className="ContractLedger__InnkeeperFormRow">
    <label className="ContractLedger__InnkeeperLabel">{props.label}</label>
    {props.children}
  </div>
);

const Select = (props: {
  value: string;
  onChange: (v: string) => void;
  options: string[];
  placeholder: string;
  disabled?: boolean;
  disabledPlaceholder?: string;
}) => (
  <select
    className="ContractLedger__InnkeeperSelect"
    value={props.value}
    onChange={(e) => props.onChange(e.target.value)}
    disabled={props.disabled}
  >
    <option value="">
      {props.disabled && props.disabledPlaceholder
        ? props.disabledPlaceholder
        : props.placeholder}
    </option>
    {props.options.map((o) => (
      <option key={o} value={o}>
        {o}
      </option>
    ))}
  </select>
);

const ModeRadio = (props: {
  value: DispatchMode;
  selected: DispatchMode;
  onChange: (v: DispatchMode) => void;
  label: string;
}) => (
  <label>
    <input
      type="radio"
      name="rumorMode"
      checked={props.selected === props.value}
      onChange={() => props.onChange(props.value)}
    />
    &nbsp;{props.label}
  </label>
);

const SubTabBar = (props: {
  active: SubTab;
  onSelect: (t: SubTab) => void;
  historyCount: number;
}) => {
  const tabs: { id: SubTab; label: string }[] = [
    { id: 'compose', label: 'Compose' },
    { id: 'history', label: `History (${props.historyCount})` },
  ];
  return (
    <div className="ContractLedger__InnkeeperSubTabBar">
      {tabs.map((t) => (
        <div
          key={t.id}
          className={
            'ContractLedger__InnkeeperSubTab' +
            (t.id === props.active
              ? ' ContractLedger__InnkeeperSubTab--active'
              : '')
          }
          onClick={() => props.onSelect(t.id)}
        >
          {t.label}
        </div>
      ))}
    </div>
  );
};

const HistoryView = (props: { log: RumorLogEntry[] }) => {
  if (!props.log.length) {
    return (
      <div className="ContractLedger__InnkeeperEmpty">
        No rumors whispered yet this week.
      </div>
    );
  }
  const rows = [...props.log].reverse();
  return (
    <div className="ContractLedger__InnkeeperHistory">
      {rows.map((r, i) => (
        <div key={i} className="ContractLedger__InnkeeperHistoryRow">
          <span className="ContractLedger__InnkeeperHistoryTitle">
            {r.title}
          </span>
          <span className="ContractLedger__InnkeeperHistoryMeta">
            {r.type} &middot; {r.region} &middot; day {r.day} &middot;{' '}
            {r.in_hands ? 'in hands' : 'on board'}
          </span>
        </div>
      ))}
    </div>
  );
};

const ComposeView = () => {
  const { act, data } = useBackend<InnkeeperData>();

  const typeOptions = Object.keys(data.rumor_costs || {});
  const [type, setType] = useState<string>(typeOptions[0] || '');
  const [region, setRegion] = useState<string>('');
  const [destination, setDestination] = useState<string>('');
  const [mode, setMode] = useState<DispatchMode>('board');
  const [lucrative, setLucrative] = useState<boolean>(false);
  const [inflight, setInflight] = useState<boolean>(false);

  const regionsForType = data.rumor_regions_by_type?.[type] || [];
  const baseCost = data.rumor_costs?.[type] ?? 0;
  const lucrativeMult = data.rumor_lucrative_mult ?? 1.5;
  const cost = lucrative ? Math.round(baseCost * lucrativeMult) : baseCost;
  const needsDestination = type === RECOVERY_TYPE;

  const onTypeChange = (next: string) => {
    setType(next);
    const newRegions = data.rumor_regions_by_type?.[next] || [];
    if (!newRegions.includes(region)) setRegion('');
    if (next !== RECOVERY_TYPE) setDestination('');
  };

  const disabledReason = inflight
    ? 'Whispering...'
    : !type
      ? 'Pick a rumor type.'
      : !region
        ? 'Pick a region.'
        : needsDestination && !destination
          ? "Pick whose shipment it's rumored to be."
          : data.rumor_points < cost
            ? `Insufficient Rumor Points (need ${cost}, have ${data.rumor_points}).`
            : undefined;

  const dispatch = () => {
    if (disabledReason) return;
    setInflight(true);
    act('compose_rumor', {
      type,
      region,
      destination: needsDestination ? destination : null,
      in_hands: mode === 'hands' ? 1 : 0,
      lucrative: lucrative ? 1 : 0,
    });
    setTimeout(() => setInflight(false), DISPATCH_DEBOUNCE_MS);
  };

  return (
    <>
      <div className="ContractLedger__InnkeeperFlavor">
        A whisper to the Guild carries weight. Select a rumor to pass along;
        point cost scales with the trouble it will bring.
      </div>

      <FormRow label="Rumor Type">
        <select
          className="ContractLedger__InnkeeperSelect"
          value={type}
          onChange={(e) => onTypeChange(e.target.value)}
        >
          {typeOptions.map((t) => (
            <option key={t} value={t}>
              {t} ({pts(data.rumor_costs[t])})
            </option>
          ))}
        </select>
      </FormRow>

      <FormRow label="Region">
        <Select
          value={region}
          onChange={setRegion}
          options={regionsForType}
          placeholder="- pick a region -"
          disabled={regionsForType.length === 0}
          disabledPlaceholder="No region will host this type"
        />
      </FormRow>

      {needsDestination && (
        <FormRow label="Rumored Shipment">
          <Select
            value={destination}
            onChange={setDestination}
            options={data.rumor_destinations || []}
            placeholder="- pick a destination -"
          />
        </FormRow>
      )}

      <FormRow label="Deliver As">
        <div className="ContractLedger__InnkeeperModeRow">
          <ModeRadio
            value="board"
            selected={mode}
            onChange={setMode}
            label="Post on public board"
          />
          <ModeRadio
            value="hands"
            selected={mode}
            onChange={setMode}
            label="Put in my hands"
          />
        </div>
      </FormRow>

      <FormRow label="Lucrative">
        <label>
          <input
            type="checkbox"
            checked={lucrative}
            onChange={(e) => setLucrative(e.target.checked)}
          />
          &nbsp;Spend {pts(Math.round(baseCost * lucrativeMult))} instead of{' '}
          {pts(baseCost)} for a x{lucrativeMult} reward. Your referral cut grows
          with the payout.
        </label>
      </FormRow>

      <div className="ContractLedger__InnkeeperFormFooter">
        <button
          type="button"
          className="ContractLedger__SignButton"
          disabled={!!disabledReason}
          title={disabledReason}
          onClick={dispatch}
        >
          Whisper Rumor ({pts(cost)})
          {lucrative ? ' - lucrative' : ''}
        </button>
      </div>
    </>
  );
};

export const InnkeeperRumorPanel = () => {
  const { data } = useBackend<InnkeeperData>();
  const [subTab, setSubTab] = useState<SubTab>('compose');

  return (
    <div className="ContractLedger__Innkeeper">
      <div className="ContractLedger__InnkeeperHeader">
        <div className="ContractLedger__InnkeeperTitle">
          So I have heard&hellip;
        </div>
        <div className="ContractLedger__InnkeeperBalance">
          Rumor Points:&nbsp;<b>{data.rumor_points}</b>
          <span className="ContractLedger__InnkeeperBalanceFormula">
            {' '}
            (+{data.rumor_refill_base} base, +
            {data.rumor_refill_per_player.toFixed(2)}/player &times;{' '}
            {data.rumor_active_players} ={' '}
            {(
              data.rumor_refill_base +
              data.rumor_refill_per_player * data.rumor_active_players
            ).toFixed(2)}
            /day, cap{' '}
            {Math.round(
              2 *
                (data.rumor_refill_base +
                  data.rumor_refill_per_player * data.rumor_active_players),
            )}
            )
          </span>
        </div>
      </div>

      <SubTabBar
        active={subTab}
        onSelect={setSubTab}
        historyCount={(data.rumor_log || []).length}
      />

      {subTab === 'compose' ? (
        <ComposeView />
      ) : (
        <HistoryView log={data.rumor_log || []} />
      )}
    </div>
  );
};
