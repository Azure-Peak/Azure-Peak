import { type ReactNode, useState } from 'react';

import { useBackend } from '../backend';

type DefenseLogEntry = {
  title: string;
  type: string;
  region: string;
  cost: number;
  day: number;
};

type BlockadeRecallEntry = {
  region: string;
  recall_eligible: number | boolean;
  recall_blocker: string | null;
  seconds_until_recallable: number;
  refund: number;
  refund_fund: string | null;
};

type StewardData = {
  pledge_balance: number;
  pledge_refill_base: number;
  pledge_refill_per_player: number;
  pledge_active_players: number;
  pledge_available: number | boolean;
  pledge_guild_bonus: number;
  pledge_golden_active: number | boolean;
  crown_purse_balance: number;
  defense_costs: Record<string, number>;
  defense_regions_by_type: Record<string, string[]>;
  region_tp_multipliers: Record<string, number>;
  defense_destinations: string[];
  defense_log: DefenseLogEntry[];
  blockade_recall_list: BlockadeRecallEntry[];
  blockade_recall_window_seconds: number;
  bonus_pay_light_mult: number;
  bonus_pay_full_mult: number;
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

// Reduces a decimal (like 0.5, 0.2, 0.25) to a simple X/Y fraction via gcd on
// percentage integers. Works cleanly for the multipliers we ship (0.75, 1.2, 1.5).
const toSimpleFraction = (decimal: number): { num: number; denom: number } => {
  const whole = Math.round(decimal * 100);
  const gcd = (a: number, b: number): number => (b === 0 ? a : gcd(b, a % b));
  const g = gcd(Math.abs(whole), 100) || 1;
  return { num: Math.abs(whole) / g, denom: 100 / g };
};

// Turns a region's TP multiplier into a short flavor line. Returns null for baseline
// (mult=1) so the UI doesn't clutter itself with "nothing special" chrome.
const regionRewardFlavor = (
  regionName: string,
  mult: number | undefined,
): string | null => {
  if (typeof mult !== 'number' || mult === 1) return null;
  if (mult > 1) {
    const descriptor = mult >= 1.4 ? 'bleak' : 'dangerous';
    const { num, denom } = toSimpleFraction(mult - 1);
    return `${regionName} is a ${descriptor} region - contracts from that region tend to be ${num}/${denom} more lucrative.`;
  }
  const { num, denom } = toSimpleFraction(1 - mult);
  return `${regionName} is a settled region - contracts from that region tend to be ${num}/${denom} less lucrative.`;
};

const FormRow = (props: { label: string; children: ReactNode }) => (
  <div className="ContractLedger__InnkeeperFormRow">
    <label className="ContractLedger__InnkeeperLabel">{props.label}</label>
    {props.children}
  </div>
);

const BonusPayOption = (props: {
  active: boolean;
  onClick: () => void;
  label: string;
  sublabel: string;
}) => (
  <button
    type="button"
    onClick={props.onClick}
    style={{
      padding: '3px 10px',
      border: `1px solid ${props.active ? '#7a5616' : '#8a7250'}`,
      background: props.active ? 'rgba(200,170,100,0.25)' : 'transparent',
      color: props.active ? '#3a2a14' : '#6b4e2a',
      fontWeight: props.active ? 'bold' : 'normal',
      cursor: 'pointer',
      borderRadius: '2px',
      fontSize: '12px',
      display: 'flex',
      flexDirection: 'column',
      alignItems: 'center',
      minWidth: '60px',
    }}
  >
    <span>{props.label}</span>
    <span style={{ fontSize: '10px', color: '#8a7250' }}>{props.sublabel}</span>
  </button>
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
  // 0 = none, 1 = light (1.25x), 2 = full (1.5x). Matches COMMISSION_BONUS_PAY_* defines.
  const [bonusPayLevel, setBonusPayLevel] = useState<0 | 1 | 2>(0);
  const [funding, setFunding] = useState<FundingSource>('pledge');
  const [inflight, setInflight] = useState<boolean>(false);

  const regionsForType = data.defense_regions_by_type?.[type] || [];
  const cost = data.defense_costs?.[type] ?? 0;
  const needsDestination = type === RECOVERY_TYPE;
  const isBlockade = type === BLOCKADE_TYPE;
  // The picked blockade's recall entry, if any. Present when a writ is already in
  // circulation for that region - the entry tells us whether it is still recallable
  // and drives the Recall button below.
  const recallEntry =
    isBlockade && region
      ? (data.blockade_recall_list || []).find((e) => e.region === region)
      : undefined;
  const regionHasActiveWrit = !!recallEntry;
  const directivesRemaining =
    (data.directives_per_day ?? 0) - (data.directives_issued_today ?? 0);
  const pledgeAvailable = !!data.pledge_available;
  const bonusLightMult = data.bonus_pay_light_mult ?? 1.25;
  const bonusFullMult = data.bonus_pay_full_mult ?? 1.5;
  // Bonus Pay is disabled for Requests (no reward to sweeten, no coin to burn).
  const bonusPayEligible = funding !== 'directive';
  const effectiveLevel = bonusPayEligible ? bonusPayLevel : 0;
  const bonusMult =
    effectiveLevel === 2 ? bonusFullMult : effectiveLevel === 1 ? bonusLightMult : 1;
  const scaledCost = effectiveLevel !== 0 ? Math.round(cost * bonusMult) : cost;
  const effectiveCost = funding === 'directive' ? 0 : scaledCost;

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
    funding === 'pledge' && data.pledge_balance < scaledCost
      ? `Insufficient Pledge (need ${coin(scaledCost)}, have ${coin(data.pledge_balance)}).`
      : funding === 'crown' && data.crown_purse_balance < scaledCost
        ? `Insufficient Crown's Purse (need ${coin(scaledCost)}, have ${coin(data.crown_purse_balance)}).`
        : funding === 'directive' && directivesRemaining <= 0
          ? "Today's directive quota is spent."
          : undefined;

  const disabledReason = inflight
    ? 'Drafting...'
    : !type
      ? 'Pick a commission type.'
      : !region
        ? isBlockade
          ? 'No blockade to clear.'
          : 'Pick a region.'
        : isBlockade && regionHasActiveWrit
          ? 'A writ is already in circulation for this blockade.'
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
      // Bonus Pay forced off for Requests (directive) server-side as well.
      bonus_pay_level: effectiveLevel,
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
        <select
          className="ContractLedger__InnkeeperSelect"
          value={region}
          onChange={(e) => setRegion(e.target.value)}
          disabled={regionsForType.length === 0}
        >
          <option value="">
            {regionsForType.length === 0
              ? isBlockade
                ? 'No blockades are active.'
                : 'No region will host this type'
              : isBlockade
                ? '- pick a blockade -'
                : '- pick a region -'}
          </option>
          {regionsForType.map((r) => {
            const mult = data.region_tp_multipliers?.[r];
            // Only annotate non-blockade regions - blockade rows route through economic
            // regions, which don't carry a TP multiplier.
            const suffix =
              !isBlockade && typeof mult === 'number' && mult !== 1
                ? ` (×${mult} reward)`
                : '';
            return (
              <option key={r} value={r}>
                {r}
                {suffix}
              </option>
            );
          })}
        </select>
      </FormRow>

      {!isBlockade &&
        region &&
        (() => {
          const flavor = regionRewardFlavor(
            region,
            data.region_tp_multipliers?.[region],
          );
          if (!flavor) return null;
          return (
            <div
              style={{
                fontSize: '11px',
                fontStyle: 'italic',
                color: '#6b4e2a',
                padding: '2px 0 6px 0',
                marginLeft: '6px',
              }}
            >
              {flavor}
            </div>
          );
        })()}

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

      {bonusPayEligible && (
        <FormRow label="Bonus Pay">
          <div style={{ display: 'flex', gap: '6px', flexWrap: 'wrap' }}>
            <BonusPayOption
              active={bonusPayLevel === 0}
              onClick={() => setBonusPayLevel(0)}
              label="None"
              sublabel="x1.0"
            />
            <BonusPayOption
              active={bonusPayLevel === 1}
              onClick={() => setBonusPayLevel(1)}
              label="Light"
              sublabel={`x${bonusLightMult}`}
            />
            <BonusPayOption
              active={bonusPayLevel === 2}
              onClick={() => setBonusPayLevel(2)}
              label="Full"
              sublabel={`x${bonusFullMult}`}
            />
          </div>
        </FormRow>
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

      {isBlockade && recallEntry && (
        <div className="ContractLedger__InnkeeperFlavor">
          {recallEntry.recall_eligible
            ? `A writ is in circulation for ${recallEntry.region} and has gone unanswered. It can be recalled now${
                recallEntry.refund > 0 && recallEntry.refund_fund
                  ? ` (refunds ${coin(recallEntry.refund)} to ${recallEntry.refund_fund})`
                  : ''
              }.`
            : `A writ is in circulation for ${recallEntry.region}. It cannot be recalled: ${recallEntry.recall_blocker ?? 'unknown reason'}.`}
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
        {isBlockade && recallEntry?.recall_eligible && (
          <button
            type="button"
            className="ContractLedger__SignButton"
            onClick={() => act('recall_blockade_writ', { region })}
          >
            Recall Writ
            {recallEntry.refund > 0 ? ` (refund ${coin(recallEntry.refund)})` : ''}
          </button>
        )}
      </div>
    </>
  );
};

export const StewardDefensePanel = () => {
  const { data } = useBackend<StewardData>();
  const [subTab, setSubTab] = useState<SubTab>('compose');

  const guildBonus = data.pledge_guild_bonus || 0;
  const baseDailyRefill =
    data.pledge_refill_base +
    data.pledge_refill_per_player * data.pledge_active_players;
  const dailyRefill = baseDailyRefill + guildBonus;

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
            {data.pledge_active_players}
            {guildBonus > 0
              ? `, +${coin(guildBonus)} Guild of Arms tribute`
              : ''}{' '}
            = {coin(dailyRefill)}/day, cap {coin(2 * dailyRefill)})
          </span>
        </div>
        {!data.pledge_golden_active && (
          <div
            className="ContractLedger__InnkeeperBalanceFormula"
            style={{ color: '#c84' }}
          >
            Golden Bull suspended - the Pledge does not refill.
          </div>
        )}
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
