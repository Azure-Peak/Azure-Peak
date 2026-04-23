import { type ReactNode, useState } from 'react';

import { useBackend } from '../backend';

type DefenseLogEntry = {
  title: string;
  type: string;
  region: string;
  cost: number;
  day: number;
};

type StewardData = {
  pledge_balance: number;
  pledge_refill_base: number;
  pledge_refill_per_player: number;
  pledge_active_players: number;
  pledge_available: number | boolean;
  crown_purse_balance: number;
  defense_costs: Record<string, number>;
  defense_regions_by_type: Record<string, string[]>;
  defense_destinations: string[];
  defense_log: DefenseLogEntry[];
  blockade_global_busy: number | boolean;
  directives_per_day: number;
  directives_issued_today: number;
};

type FundingSource = 'pledge' | 'crown' | 'directive';

type SubTab = 'compose' | 'history';
const RECOVERY_TYPE = 'Recovery';
const BLOCKADE_TYPE = 'Blockade Defense';
const DISPATCH_DEBOUNCE_MS = 500;

const COMMISSION_LABELS: Record<string, string> = {
  'Blockade Defense': 'Clear Blockade',
};

const coin = (n: number) => `${n}m`;

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

const SubTabBar = (props: {
  active: SubTab;
  onSelect: (t: SubTab) => void;
  historyCount: number;
}) => {
  const tabs: { id: SubTab; label: string }[] = [
    { id: 'compose', label: 'Commission' },
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

const HistoryView = (props: { log: DefenseLogEntry[] }) => {
  if (!props.log.length) {
    return (
      <div className="ContractLedger__InnkeeperEmpty">
        No commissions have been drawn against the Pledge this week.
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
            {coin(r.cost)}
          </span>
        </div>
      ))}
    </div>
  );
};

type DispatchMode = 'board' | 'hands';

const ModeRadio = (props: {
  value: DispatchMode;
  selected: DispatchMode;
  onChange: (v: DispatchMode) => void;
  label: string;
}) => (
  <label>
    <input
      type="radio"
      name="defenseMode"
      checked={props.selected === props.value}
      onChange={() => props.onChange(props.value)}
    />
    &nbsp;{props.label}
  </label>
);

const ComposeView = () => {
  const { act, data } = useBackend<StewardData>();

  const typeOptions = Object.keys(data.defense_costs || {});
  const [type, setType] = useState<string>(typeOptions[0] || '');
  const [region, setRegion] = useState<string>('');
  const [destination, setDestination] = useState<string>('');
  const [mode, setMode] = useState<DispatchMode>('board');
  const [levyExempt, setLevyExempt] = useState<boolean>(false);
  const [funding, setFunding] = useState<FundingSource>('pledge');
  const [inflight, setInflight] = useState<boolean>(false);

  const regionsForType = data.defense_regions_by_type?.[type] || [];
  const cost = data.defense_costs?.[type] ?? 0;
  const needsDestination = type === RECOVERY_TYPE;
  const isBlockade = type === BLOCKADE_TYPE;
  const blockadeBusy = !!data.blockade_global_busy;
  const directivesRemaining =
    (data.directives_per_day ?? 0) - (data.directives_issued_today ?? 0);
  const pledgeAvailable = !!data.pledge_available;
  const effectiveCost = funding === 'directive' ? 0 : cost;

  // If the currently-selected funding disappears (pledge repealed, quota spent), fall back.
  if (funding === 'pledge' && !pledgeAvailable) {
    setFunding('crown');
  }
  if (funding === 'directive' && directivesRemaining <= 0) {
    setFunding(pledgeAvailable ? 'pledge' : 'crown');
  }

  const onTypeChange = (next: string) => {
    setType(next);
    const newRegions = data.defense_regions_by_type?.[next] || [];
    if (!newRegions.includes(region)) setRegion('');
    if (next !== RECOVERY_TYPE) setDestination('');
  };

  const fundingDisabledReason =
    funding === 'pledge' && data.pledge_balance < cost
      ? `Insufficient Pledge (need ${coin(cost)}, have ${coin(data.pledge_balance)}).`
      : funding === 'crown' && data.crown_purse_balance < cost
        ? `Insufficient Crown's Purse (need ${coin(cost)}, have ${coin(data.crown_purse_balance)}).`
        : funding === 'directive' && directivesRemaining <= 0
          ? "Today's directive quota is spent."
          : undefined;

  const disabledReason = inflight
    ? 'Drafting...'
    : !type
      ? 'Pick a commission type.'
      : isBlockade && blockadeBusy
        ? 'Another blockade writ is already in circulation.'
        : !region
          ? isBlockade
            ? 'No blockade to clear.'
            : 'Pick a region.'
          : needsDestination && !destination
            ? 'Pick the shipment destination.'
            : fundingDisabledReason;

  const dispatch = () => {
    if (disabledReason) return;
    setInflight(true);
    const isDirective = funding === 'directive';
    act('commission_defense', {
      type,
      region,
      destination: needsDestination ? destination : null,
      // Blockade + directive writs are always bearer-bond; ignore the mode control.
      in_hands: isBlockade || isDirective ? 1 : mode === 'hands' ? 1 : 0,
      // Directives skip the levy-exempt stamp (no reward to exempt).
      levy_exempt: isBlockade || isDirective ? 0 : levyExempt ? 1 : 0,
      funding,
    });
    setTimeout(() => setInflight(false), DISPATCH_DEBOUNCE_MS);
  };

  return (
    <>
      <div className="ContractLedger__InnkeeperFlavor">
        Commission adventurers against the Realm's enemies.
      </div>

      <FormRow label="Commission Type">
        <select
          className="ContractLedger__InnkeeperSelect"
          value={type}
          onChange={(e) => onTypeChange(e.target.value)}
        >
          {typeOptions.map((t) => (
            <option key={t} value={t}>
              {COMMISSION_LABELS[t] || t} ({coin(data.defense_costs[t])})
            </option>
          ))}
        </select>
      </FormRow>

      <FormRow label={isBlockade ? 'Blockaded Region' : 'Region'}>
        <Select
          value={region}
          onChange={setRegion}
          options={regionsForType}
          placeholder={isBlockade ? '- pick a blockade -' : '- pick a region -'}
          disabled={regionsForType.length === 0}
          disabledPlaceholder={
            isBlockade
              ? 'No blockades are active.'
              : 'No region will host this type'
          }
        />
      </FormRow>

      {needsDestination && (
        <FormRow label="Shipment Destination">
          <Select
            value={destination}
            onChange={setDestination}
            options={data.defense_destinations || []}
            placeholder="- pick a destination -"
          />
        </FormRow>
      )}

      <FormRow label="Fund">
        <div className="ContractLedger__InnkeeperModeRow">
          <label>
            <input
              type="radio"
              name="fundingSource"
              checked={funding === 'pledge'}
              disabled={!pledgeAvailable}
              onChange={() => setFunding('pledge')}
            />
            &nbsp;Burgher Pledge ({coin(data.pledge_balance)})
          </label>
          <label>
            <input
              type="radio"
              name="fundingSource"
              checked={funding === 'crown'}
              onChange={() => setFunding('crown')}
            />
            &nbsp;Crown's Purse ({coin(data.crown_purse_balance)})
          </label>
          <label>
            <input
              type="radio"
              name="fundingSource"
              checked={funding === 'directive'}
              disabled={directivesRemaining <= 0}
              onChange={() => setFunding('directive')}
            />
            &nbsp;Request ({directivesRemaining}/{data.directives_per_day ?? 0} left)
          </label>
        </div>
      </FormRow>

      {funding === 'directive' && (
        <div className="ContractLedger__InnkeeperFlavor">
          A Request calls upon someone to
          answer out of duty. No coin changes hands; the scroll is drawn to
          your hand and must be given directly to whoever will honour it.
        </div>
      )}

      {!isBlockade && funding !== 'directive' && (
        <>
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

          <FormRow label="Levy Stamp">
            <label>
              <input
                type="checkbox"
                checked={levyExempt}
                onChange={(e) => setLevyExempt(e.target.checked)}
              />
              &nbsp;Stamp as LEVY EXEMPT (waive Crown's Contract Levy)
            </label>
          </FormRow>
        </>
      )}
      {isBlockade && funding !== 'directive' && (
        <div className="ContractLedger__InnkeeperFlavor">
          Blockade writs are always drawn to your hand. Pin to a notice
          board to require a Fellowship of three; keep in hand to dispatch a
          trusted party directly.
        </div>
      )}

      <div className="ContractLedger__InnkeeperFormFooter">
        <button
          type="button"
          className="ContractLedger__SignButton"
          disabled={!!disabledReason}
          title={disabledReason}
          onClick={dispatch}
        >
          {funding === 'directive'
            ? 'Submit Request'
            : isBlockade
              ? `Print Writ (${coin(effectiveCost)})`
              : `Commission (${coin(effectiveCost)})`}
        </button>
      </div>
    </>
  );
};

export const StewardDefensePanel = () => {
  const { data } = useBackend<StewardData>();
  const [subTab, setSubTab] = useState<SubTab>('compose');

  const dailyRefill =
    data.pledge_refill_base +
    data.pledge_refill_per_player * data.pledge_active_players;

  return (
    <div className="ContractLedger__Innkeeper">
      <div className="ContractLedger__InnkeeperHeader">
        <div className="ContractLedger__InnkeeperTitle">
          By the Pledge of the Burghers&hellip;
        </div>
        <div className="ContractLedger__InnkeeperBalance">
          Burgher Pledge:&nbsp;<b>{coin(data.pledge_balance)}</b>
          <span className="ContractLedger__InnkeeperBalanceFormula">
            {' '}
            (+{coin(data.pledge_refill_base)} base, +
            {coin(data.pledge_refill_per_player)}/player &times;{' '}
            {data.pledge_active_players} = {coin(dailyRefill)}/day, cap{' '}
            {coin(2 * dailyRefill)})
          </span>
        </div>
      </div>

      <SubTabBar
        active={subTab}
        onSelect={setSubTab}
        historyCount={(data.defense_log || []).length}
      />

      {subTab === 'compose' ? (
        <ComposeView />
      ) : (
        <HistoryView log={data.defense_log || []} />
      )}
    </div>
  );
};
