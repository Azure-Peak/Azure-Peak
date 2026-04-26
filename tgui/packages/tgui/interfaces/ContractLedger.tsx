import { useState } from 'react';
import { Button } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { InnkeeperRumorPanel } from './ContractLedgerInnkeeper';
import { StewardDefensePanel } from './ContractLedgerSteward';

type Contract = {
  ref: string;
  title: string;
  type: string;
  difficulty: string;
  reward: number;
  deposit: number;
  area: string;
  region: string;
  objective: string;
  expected_count: number;
  threat_bands: number;
  levy_exempt: BooleanLike;
  is_rumor: BooleanLike;
  is_defense: BooleanLike;
  required_fellowship_size: number;
};

type ActiveContract = {
  ref: string;
  title: string;
  type: string;
  difficulty: string;
  area: string;
  region: string;
  progress_current: number;
  progress_required: number;
  complete: BooleanLike;
};

type ContractLedgerData = {
  is_handler: BooleanLike;
  balance: number;
  has_account: BooleanLike;
  active_count: number;
  active_max: number;
  townie_gate_remaining: number;
  townie_contract_gate_exempt_jobs: string[];
  take_cooldown_remaining: number;
  user_fellowship_size: number;
  pool: Contract[];
  active: ActiveContract[];
  regions: string[];
  tax_rate: number;
  guild_cut_rate: number;
  dynamic_role: string | null;
  rumor_points?: number;
  rumor_costs?: Record<string, number>;
  rumor_regions_by_type?: Record<string, string[]>;
  rumor_destinations?: string[];
};

const ALL_REGIONS = 'All';
const ALL_DIFFICULTIES = 'All';
const DIFFICULTIES = ['Easy', 'Medium', 'Hard'];

type LedgerMode = 'contracts' | 'dynamic';

const DYNAMIC_TAB_LABELS: Record<string, string> = {
  innkeeper: 'Rumors',
  steward: 'Commissions',
};

const renderDynamicPanel = (role: string) => {
  switch (role) {
    case 'innkeeper':
      return <InnkeeperRumorPanel />;
    case 'steward':
      return <StewardDefensePanel />;
    default:
      return null;
  }
};

const difficultyPinClass = (difficulty: string) => {
  switch (difficulty) {
    case 'Easy':
      return 'ContractLedger__Pin ContractLedger__Pin--easy';
    case 'Medium':
      return 'ContractLedger__Pin ContractLedger__Pin--medium';
    case 'Hard':
      return 'ContractLedger__Pin ContractLedger__Pin--hard';
    default:
      return 'ContractLedger__Pin';
  }
};

export const ContractLedger = () => {
  const { data } = useBackend<ContractLedgerData>();
  const [mode, setMode] = useState<LedgerMode>('contracts');
  const [activeRegion, setActiveRegion] = useState<string>(ALL_REGIONS);
  const [activeDifficulty, setActiveDifficulty] =
    useState<string>(ALL_DIFFICULTIES);

  const dynamicRole = data.dynamic_role || null;
  const dynamicLabel = dynamicRole
    ? DYNAMIC_TAB_LABELS[dynamicRole] || dynamicRole
    : null;
  const showingDynamic = mode === 'dynamic' && !!dynamicRole;

  const matchesRegion = (c: Contract) =>
    activeRegion === ALL_REGIONS || c.region === activeRegion;
  const matchesDifficulty = (c: Contract) =>
    activeDifficulty === ALL_DIFFICULTIES || c.difficulty === activeDifficulty;

  const filtered = data.pool.filter(
    (c) => matchesRegion(c) && matchesDifficulty(c),
  );

  const regionTabs = [ALL_REGIONS, ...(data.regions || [])];

  return (
    <Window
      title="Grand Contract Ledger"
      width={1000}
      height={760}
      theme="grimoire"
    >
      <Window.Content fitted>
        <div className="ContractLedger">
          <div className="ContractLedger__Header">
            {dynamicRole ? (
              <>
                <span
                  className={
                    'ContractLedger__HeaderMode' +
                    (!showingDynamic ? ' ContractLedger__HeaderMode--active' : '')
                  }
                  onClick={() => setMode('contracts')}
                >
                  Grand Contract Ledger
                </span>
                <span className="ContractLedger__HeaderSep">|</span>
                <span
                  className={
                    'ContractLedger__HeaderMode' +
                    (showingDynamic ? ' ContractLedger__HeaderMode--active' : '')
                  }
                  onClick={() => setMode('dynamic')}
                >
                  {dynamicLabel}
                </span>
              </>
            ) : (
              <span className="ContractLedger__HeaderStatic">
                Grand Contract Ledger
              </span>
            )}
          </div>

          {!showingDynamic && (
            <div className="ContractLedger__TabBar">
              {regionTabs.map((region) => {
                const count = data.pool.filter(
                  (c) => region === ALL_REGIONS || c.region === region,
                ).length;
                const isActive = region === activeRegion;
                return (
                  <div
                    key={region}
                    className={
                      'ContractLedger__Tab' +
                      (isActive ? ' ContractLedger__Tab--active' : '')
                    }
                    onClick={() => setActiveRegion(region)}
                  >
                    {region} ({count})
                  </div>
                );
              })}
            </div>
          )}

          {!showingDynamic && (
            <div className="ContractLedger__FilterBar">
              {[ALL_DIFFICULTIES, ...DIFFICULTIES].map((diff) => {
                const isActive = diff === activeDifficulty;
                return (
                  <Button
                    key={diff}
                    selected={isActive}
                    onClick={() => setActiveDifficulty(diff)}
                  >
                    {diff}
                  </Button>
                );
              })}
            </div>
          )}

          <div className="ContractLedger__Board">
            {showingDynamic && dynamicRole ? (
              renderDynamicPanel(dynamicRole)
            ) : filtered.length === 0 ? (
              <div className="ContractLedger__Empty">
                No contracts match this filter. Broaden your search or return
                later.
              </div>
            ) : (
              <div className="ContractLedger__Grid">
                {filtered.map((c) => (
                  <ContractCard key={c.ref} contract={c} />
                ))}
              </div>
            )}
          </div>

          <ActiveStrip
            active={data.active}
            activeMax={data.active_max}
            balance={data.balance}
          />
        </div>
      </Window.Content>
    </Window>
  );
};

const ContractCard = (props: { contract: Contract }) => {
  const { act, data } = useBackend<ContractLedgerData>();
  const c = props.contract;
  const noAccount = !data.has_account;
  const gateRemaining = data.townie_gate_remaining || 0;
  const takeCooldown = data.take_cooldown_remaining || 0;
  const atCap = data.active_count >= data.active_max;
  const cantAfford = data.balance < c.deposit;
  const fellowshipShort =
    c.required_fellowship_size > 0 &&
    (data.user_fellowship_size || 0) < c.required_fellowship_size;
  const disabled =
    noAccount ||
    gateRemaining > 0 ||
    takeCooldown > 0 ||
    atCap ||
    cantAfford ||
    fellowshipShort;
  const exemptList = (data.townie_contract_gate_exempt_jobs || []).join(', ');
  const title = noAccount
    ? 'No bank account. Register with a Meister first.'
    : gateRemaining > 0
      ? `By Guild precedence, the first two daes of a week fall to masterless hands: ${exemptList}. Townfolk in trade or charter may sign in ${Math.ceil(gateRemaining / 60)}m.`
      : takeCooldown > 0
        ? `Guild cooldown, wait ${takeCooldown}s before signing another.`
        : atCap
          ? `You already hold ${data.active_max} contracts.`
          : cantAfford
            ? `Requires ${c.deposit} mammon in your account.`
            : fellowshipShort
              ? `Requires a Fellowship of ${c.required_fellowship_size}, you have ${data.user_fellowship_size || 0}.`
              : undefined;
  const stamps: { label: string; modifier: string }[] = [];
  if (c.is_rumor) stamps.push({ label: 'RUMORED!', modifier: 'rumor' });
  if (c.is_defense) stamps.push({ label: 'COMMISSIONED', modifier: 'commissioned' });
  if (c.levy_exempt) stamps.push({ label: 'LEVY EXEMPT', modifier: 'exempt' });
  const contentTopPad = stamps.length > 0 ? 8 + stamps.length * 16 : 0;
  return (
    <div className="ContractLedger__Card">
      <div className={difficultyPinClass(c.difficulty)} />
      {stamps.map((s, i) => (
        <div
          key={s.modifier}
          className={`ContractLedger__Stamp ContractLedger__Stamp--${s.modifier}`}
          style={{ top: `${6 + i * 16}px` }}
        >
          {s.label}
        </div>
      ))}
      <div
        className="ContractLedger__CardTitle"
        style={{ marginTop: `${contentTopPad}px` }}
      >
        {c.title}
      </div>
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Locale</span>
        <span className="ContractLedger__CardValue">
          {c.area || c.region || 'Unknown'}
        </span>
      </div>
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Type</span>
        <span className="ContractLedger__CardValue">{c.type}</span>
      </div>
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Difficulty</span>
        <span className="ContractLedger__CardValue">{c.difficulty}</span>
      </div>
      {c.required_fellowship_size > 0 && (
        <div className="ContractLedger__CardRow">
          <span className="ContractLedger__CardLabel">Fellowship</span>
          <span
            className="ContractLedger__CardValue"
            style={{
              color: fellowshipShort ? '#c44' : '#8b1a1a',
              fontWeight: 'bold',
            }}
          >
            {data.user_fellowship_size || 0} / {c.required_fellowship_size}
            {fellowshipShort ? ' (short)' : ''}
          </span>
        </div>
      )}
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Reward</span>
        <span className="ContractLedger__CardValue">{c.reward}</span>
      </div>
      {(() => {
        const levyRate = c.levy_exempt ? 0 : data.tax_rate;
        const guildRate = c.is_defense ? 0 : data.guild_cut_rate || 0;
        const levy = Math.round(c.reward * levyRate);
        const guild = Math.round(c.reward * guildRate);
        const purse = c.reward - levy - guild;
        return (
          <>
            {!c.levy_exempt && data.tax_rate > 0 && (
              <div className="ContractLedger__CardRow">
                <span className="ContractLedger__CardLabel">
                  Crown Levy ({Math.round(data.tax_rate * 100)}%)
                </span>
                <span className="ContractLedger__CardValue" style={{ color: '#c44' }}>
                  -{levy}
                </span>
              </div>
            )}
            {guildRate > 0 && (
              <div className="ContractLedger__CardRow">
                <span className="ContractLedger__CardLabel">
                  Guild Cut ({Math.round(guildRate * 100)}%)
                </span>
                <span className="ContractLedger__CardValue" style={{ color: '#c44' }}>
                  -{guild}
                </span>
              </div>
            )}
            {(levy > 0 || guild > 0) && (
              <div className="ContractLedger__CardRow">
                <span className="ContractLedger__CardLabel">Purse</span>
                <span className="ContractLedger__CardValue" style={{ fontWeight: 'bold' }}>
                  {purse}
                </span>
              </div>
            )}
          </>
        );
      })()}
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Deposit</span>
        <span className="ContractLedger__CardValue">{c.deposit}</span>
      </div>
      {c.threat_bands > 0 && (
        <div className="ContractLedger__CardRow">
          <span className="ContractLedger__CardLabel">Clears</span>
          <span className="ContractLedger__CardValue">
            {c.threat_bands} band{c.threat_bands === 1 ? '' : 's'} of threat
          </span>
        </div>
      )}
      {c.objective && (
        <div className="ContractLedger__CardObjective">{c.objective}</div>
      )}
      <div className="ContractLedger__CardFooter">
        <button
          type="button"
          className="ContractLedger__SignButton"
          disabled={disabled}
          title={title}
          onClick={() => act('sign', { ref: c.ref })}
        >
          Sign
        </button>
      </div>
    </div>
  );
};

const ActiveStrip = (props: {
  active: ActiveContract[];
  activeMax: number;
  balance: number;
}) => {
  const { act, data } = useBackend<ContractLedgerData>();
  const gateRemaining = data.townie_gate_remaining || 0;
  const takeCooldown = data.take_cooldown_remaining || 0;
  const exemptList = (data.townie_contract_gate_exempt_jobs || []).join(', ');
  const blockReason = !data.has_account
    ? 'You have no bank account. Register with a Meister before signing any contract.'
    : gateRemaining > 0
      ? `The Guild observes the precedence of the masterless hand. The first two daes of the week fall to: ${exemptList}. Townfolk in trade or charter may sign in ${Math.ceil(gateRemaining / 60)}m.`
      : takeCooldown > 0
        ? `Guild cooldown active, wait ${takeCooldown}s before signing another contract.`
        : null;
  return (
    <div className="ContractLedger__ActiveStrip">
      <div className="ContractLedger__ActiveStripHeader">
        <span>
          Your Contracts ({props.active.length} / {props.activeMax})
        </span>
        <span>Balance: {props.balance} mammon</span>
      </div>
      {blockReason && (
        <div
          className="ContractLedger__ActiveRow"
          style={{ color: '#c44', fontWeight: 'bold' }}
        >
          {blockReason}
        </div>
      )}
      {props.active.length === 0 ? (
        <div className="ContractLedger__ActiveRow">
          <span className="ContractLedger__ActiveRow__Meta">
            You hold no active contracts.
          </span>
        </div>
      ) : (
        props.active.map((a) => (
          <div key={a.ref} className="ContractLedger__ActiveRow">
            <span className="ContractLedger__ActiveRow__Title">{a.title}</span>
            <span className="ContractLedger__ActiveRow__Meta">
              {a.type} &middot; {a.difficulty} &middot;{' '}
              {a.region || a.area || 'Unknown'}
              {a.progress_required > 1 &&
                ` - ${a.progress_current}/${a.progress_required}`}
              {!!a.complete && ' - ready to turn in'}
            </span>
            {!a.complete && (
              <Button
                icon="times"
                color="bad"
                tooltip="Forfeit deposit and void the contract."
                onClick={() => act('abandon', { ref: a.ref })}
              >
                Abandon
              </Button>
            )}
          </div>
        ))
      )}
    </div>
  );
};
