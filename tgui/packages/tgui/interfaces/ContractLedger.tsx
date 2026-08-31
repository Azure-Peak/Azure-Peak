import { useState } from 'react';
import { Button, Dialog } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { formatRatioPct } from './common/format';
import { InnkeeperRumorPanel } from './ContractLedgerInnkeeper';
import { StewardDefensePanel } from './ContractLedgerSteward';
import { TownerPostingPanel } from './ContractLedgerTowner';

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
  guild_cut_exempt: BooleanLike;
  is_rumor: BooleanLike;
  is_defense: BooleanLike;
  is_towner: BooleanLike;
  is_standing: BooleanLike;
  required_fellowship_size: number;
  lapse_minutes: number;
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

type HoardRecoveryRegion = {
  region: string;
  hoard: number;
  danger: string;
  active: BooleanLike;
};

type ScoutRegion = {
  region_name: string;
  danger_level: string;
  danger_color: string;
  ic_descriptions: string[];
  blockaded: BooleanLike;
  blockade_writ_out: BooleanLike;
  blockade_faction_label: string;
  blockade_region_label: string;
  blockade_days_active: number;
};

type ContractLedgerData = {
  is_handler: BooleanLike;
  balance: number;
  has_account: BooleanLike;
  active_count: number;
  active_max: number;
  active_max_base: number;
  active_fellowship_bonus: number;
  townie_gate_remaining: number;
  townie_contract_gate_exempt_jobs: string[];
  take_cooldown_remaining: number;
  user_fellowship_size: number;
  pool: Contract[];
  active: ActiveContract[];
  regions: string[];
  hoard_recovery_regions: HoardRecoveryRegion[];
  hoard_recovery_pledge: number;
  hoard_recovery_fellowship_min: number;
  hoard_recovery_hoard_min: number;
  scout_regions: ScoutRegion[];
  spoils_tax_rate: number;
  tax_rate: number;
  guild_cut_rate: number;
  can_proxy_turnin: BooleanLike;
  dynamic_role: string | null;
  dynamic_roles?: string[];
  rumor_points?: number;
  rumor_costs?: Record<string, number>;
  rumor_regions_by_type?: Record<string, string[]>;
  rumor_destinations?: string[];
};

const ALL_REGIONS = 'All';
const ALL_DIFFICULTIES = 'All';
const STANDING_FILTER = 'Standing';
const DIFFICULTIES = ['Easy', 'Medium', 'Hard', 'Notorious'];
const FILTER_BUTTONS = [ALL_DIFFICULTIES, STANDING_FILTER, ...DIFFICULTIES];

type LedgerMode =
  | { kind: 'contracts' }
  | { kind: 'scouts' }
  | { kind: 'dynamic'; role: string };

const DYNAMIC_TAB_LABELS: Record<string, string> = {
  innkeeper: 'Rumors',
  steward: 'Commissions',
  towner: 'Postings',
};

const renderDynamicPanel = (role: string) => {
  switch (role) {
    case 'innkeeper':
      return <InnkeeperRumorPanel />;
    case 'steward':
      return <StewardDefensePanel />;
    case 'towner':
      return <TownerPostingPanel />;
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
    case 'Notorious':
      return 'ContractLedger__Pin ContractLedger__Pin--notorious';
    default:
      return 'ContractLedger__Pin';
  }
};

export const ContractLedger = () => {
  const { data } = useBackend<ContractLedgerData>();
  const [mode, setMode] = useState<LedgerMode>({ kind: 'contracts' });
  const [activeRegion, setActiveRegion] = useState<string>(ALL_REGIONS);
  const [activeDifficulty, setActiveDifficulty] =
    useState<string>(ALL_DIFFICULTIES);

  const dynamicRoles =
    data.dynamic_roles && data.dynamic_roles.length > 0
      ? data.dynamic_roles
      : data.dynamic_role
        ? [data.dynamic_role]
        : [];
  const showingDynamic = mode.kind === 'dynamic';
  const showingContracts = mode.kind === 'contracts';
  const activeDynamicRole = mode.kind === 'dynamic' ? mode.role : null;

  const matchesRegion = (c: Contract) =>
    activeRegion === ALL_REGIONS || c.region === activeRegion;
  const matchesDifficulty = (c: Contract) => {
    if (activeDifficulty === ALL_DIFFICULTIES) return true;
    if (activeDifficulty === STANDING_FILTER) return !!c.is_standing;
    return c.difficulty === activeDifficulty;
  };

  const filtered = data.pool
    .filter((c) => matchesRegion(c) && matchesDifficulty(c))
    .sort((a, b) => {
      const sa = a.is_standing ? 0 : 1;
      const sb = b.is_standing ? 0 : 1;
      return sa - sb;
    });

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
            <span
              className={
                'ContractLedger__HeaderMode' +
                (showingContracts ? ' ContractLedger__HeaderMode--active' : '')
              }
              onClick={() => setMode({ kind: 'contracts' })}
            >
              Grand Contract Ledger
            </span>
            <span className="ContractLedger__HeaderSep">|</span>
            <span
              className={
                'ContractLedger__HeaderMode' +
                (mode.kind === 'scouts'
                  ? ' ContractLedger__HeaderMode--active'
                  : '')
              }
              onClick={() => setMode({ kind: 'scouts' })}
            >
              Scout Reports
            </span>
            {dynamicRoles.map((role) => (
              <span key={role}>
                <span className="ContractLedger__HeaderSep">|</span>
                <span
                  className={
                    'ContractLedger__HeaderMode' +
                    (activeDynamicRole === role
                      ? ' ContractLedger__HeaderMode--active'
                      : '')
                  }
                  onClick={() => setMode({ kind: 'dynamic', role })}
                >
                  {DYNAMIC_TAB_LABELS[role] || role}
                </span>
              </span>
            ))}
          </div>

          {showingContracts && (
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

          {showingContracts && (
            <div className="ContractLedger__FilterBar">
              {FILTER_BUTTONS.map((diff) => {
                const isActive = diff === activeDifficulty;
                const count = data.pool.filter((c) => {
                  if (!matchesRegion(c)) return false;
                  if (diff === ALL_DIFFICULTIES) return true;
                  if (diff === STANDING_FILTER) return !!c.is_standing;
                  return c.difficulty === diff;
                }).length;
                return (
                  <Button
                    key={diff}
                    selected={isActive}
                    onClick={() => setActiveDifficulty(diff)}
                  >
                    {diff} ({count})
                  </Button>
                );
              })}
            </div>
          )}

          {showingContracts && <HoardRecoveryCallStrip />}

          <div className="ContractLedger__Board">
            {mode.kind === 'scouts' ? (
              <ScoutsPanel />
            ) : showingDynamic && activeDynamicRole ? (
              renderDynamicPanel(activeDynamicRole)
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

const HoardRecoveryCallStrip = () => {
  const { act, data } = useBackend<ContractLedgerData>();
  const regions = data.hoard_recovery_regions || [];
  if (regions.length === 0) return null;
  const minFellows = data.hoard_recovery_fellowship_min || 3;
  const pledge = data.hoard_recovery_pledge || 0;
  const hoardMin = data.hoard_recovery_hoard_min || 0;
  const fellowshipShort = (data.user_fellowship_size || 0) < minFellows;
  const noAccount = !data.has_account;
  const cantAfford = data.balance < pledge;
  const taxPct = formatRatioPct(data.spoils_tax_rate || 0);
  const blockReason = noAccount
    ? 'No bank account. Register with a Meister first.'
    : fellowshipShort
      ? `Requires a Fellowship of ${minFellows}, you have ${data.user_fellowship_size || 0}.`
      : cantAfford
        ? `Requires a pledge of ${pledge} mammon in your account.`
        : undefined;
  return (
    <div
      style={{
        margin: '0 8px 4px 8px',
        padding: '5px 10px',
        border: '1px solid #6b4a2a',
        background: 'rgba(120, 60, 30, 0.12)',
        fontSize: '0.95em',
      }}
    >
      <div style={{ fontWeight: 'bold', marginBottom: '3px' }}>
        Hoard Recovery - a Fellowship of {minFellows}+ may call a recovery writ
        after pledging {pledge}m on any region whose banditry hoard has reached {hoardMin}m. Pays the standard blockade reward; the reclaimed
        hoard is taxed {taxPct} as Recovered Spoils.
      </div>
      {regions.map((r) => (
        <div
          key={r.region}
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            padding: '2px 0',
          }}
        >
          <span>
            {r.region} ({r.danger}) - hoard of {r.hoard}m
          </span>
          {r.active ? (
            <span style={{ fontStyle: 'italic', color: '#7a6a4a' }}>
              writ already abroad
            </span>
          ) : (
            <Button
              disabled={!!blockReason}
              tooltip={blockReason}
              onClick={() => act('request_hoard_recovery', { region: r.region })}
            >
              Call for Recovery
            </Button>
          )}
        </div>
      ))}
    </div>
  );
};

const scoutCellStyle: React.CSSProperties = {
  padding: '6px 8px',
  borderBottom: '1px dashed #6b4a2a',
  verticalAlign: 'top',
};

const scoutHeaderCellStyle: React.CSSProperties = {
  ...scoutCellStyle,
  textAlign: 'left',
  fontWeight: 'bold',
  borderBottom: '1px solid #6b4a2a',
};

const ScoutsPanel = () => {
  const { data } = useBackend<ContractLedgerData>();
  const regions = data.scout_regions || [];
  if (regions.length === 0) {
    return (
      <div className="ContractLedger__Empty">
        {/* TODO: flavor - plain placeholder, rewrite */}
        No scout reports are available.
      </div>
    );
  }
  return (
    <div style={{ padding: '4px 8px' }}>
      <table
        style={{
          width: '100%',
          borderCollapse: 'collapse',
          fontSize: '0.95em',
        }}
      >
        <thead>
          <tr>
            <th style={scoutHeaderCellStyle}>Region</th>
            <th style={scoutHeaderCellStyle}>Danger</th>
            <th style={scoutHeaderCellStyle}>Blockade</th>
            <th style={scoutHeaderCellStyle}>Scout Report</th>
          </tr>
        </thead>
        <tbody>
          {regions.map((r) => (
            <tr key={r.region_name}>
              <td style={{ ...scoutCellStyle, fontWeight: 'bold' }}>
                {r.region_name}
              </td>
              <td style={scoutCellStyle}>
                <span style={{ color: r.danger_color, fontWeight: 'bold' }}>
                  {r.danger_level}
                </span>
              </td>
              <td style={scoutCellStyle}>
                {r.blockaded ? (
                  <>
                    <div style={{ color: '#8b1a1a', fontWeight: 'bold' }}>
                      {r.blockade_faction_label || 'unknown raiders'}
                      <span
                        style={{
                          marginLeft: 6,
                          fontWeight: 'normal',
                          color: '#7a6a4a',
                        }}
                      >
                        {r.blockade_days_active}d
                      </span>
                    </div>
                    {!!r.blockade_region_label && (
                      <div style={{ color: '#7a6a4a' }}>
                        blocking {r.blockade_region_label}
                      </div>
                    )}
                    <div style={{ color: '#a06000' }}>
                      {r.blockade_writ_out ? 'Writ out' : 'Awaiting writ'}
                    </div>
                  </>
                ) : (
                  <span style={{ color: '#7a6a4a' }}>-</span>
                )}
              </td>
              <td
                style={{
                  ...scoutCellStyle,
                  fontStyle: 'italic',
                  color: '#7a6a4a',
                }}
              >
                {r.ic_descriptions.length > 0
                  ? r.ic_descriptions.join('; ')
                  : 'nothing to report'}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
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
  if (c.is_defense)
    stamps.push({ label: 'COMMISSIONED', modifier: 'commissioned' });
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
        const guildRate =
          c.is_defense || c.guild_cut_exempt ? 0 : data.guild_cut_rate || 0;
        const levy = Math.round(c.reward * levyRate);
        const guild = Math.round(c.reward * guildRate);
        const purse = c.reward - levy - guild;
        return (
          <>
            {!c.levy_exempt && data.tax_rate > 0 && (
              <div className="ContractLedger__CardRow">
                <span className="ContractLedger__CardLabel">
                  Crown Levy ({formatRatioPct(data.tax_rate)})
                </span>
                <span
                  className="ContractLedger__CardValue"
                  style={{ color: '#c44' }}
                >
                  -{levy}
                </span>
              </div>
            )}
            {guildRate > 0 && (
              <div className="ContractLedger__CardRow">
                <span className="ContractLedger__CardLabel">
                  Guild Cut ({formatRatioPct(guildRate)})
                </span>
                <span
                  className="ContractLedger__CardValue"
                  style={{ color: '#c44' }}
                >
                  -{guild}
                </span>
              </div>
            )}
            {(levy > 0 || guild > 0) && (
              <div className="ContractLedger__CardRow">
                <span className="ContractLedger__CardLabel">Purse</span>
                <span
                  className="ContractLedger__CardValue"
                  style={{ fontWeight: 'bold' }}
                >
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
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Lapses</span>
        <span className="ContractLedger__CardValue">
          {c.lapse_minutes > 0 ? `~${c.lapse_minutes}m` : '<1m'}
        </span>
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
  const [showFellowshipHelp, setShowFellowshipHelp] = useState(false);
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
  const fellowshipBonus = data.active_fellowship_bonus || 0;
  const fellowshipNote =
    fellowshipBonus > 0
      ? `+${fellowshipBonus} from leading your Fellowship`
      : 'Form a Fellowship for more contract slots.';
  return (
    <div className="ContractLedger__ActiveStrip">
      <div className="ContractLedger__ActiveStripHeader">
        <span>
          Your Contracts ({props.active.length} / {props.activeMax})
          <span
            style={{
              marginLeft: '10px',
              fontSize: '0.85em',
              color: fellowshipBonus > 0 ? '#2a6b2a' : '#7a6a4a',
              fontWeight: 'normal',
            }}
          >
            {fellowshipNote}
          </span>
          <Button
            compact
            ml={0.5}
            icon="question-circle"
            selected={showFellowshipHelp}
            tooltip="Fellowship benefits"
            onClick={() => setShowFellowshipHelp(true)}
          />
        </span>
        <span>Balance: {props.balance} mammon</span>
      </div>
      {!!data.can_proxy_turnin && (
        <div
          style={{
            fontSize: '0.85em',
            fontStyle: 'italic',
            color: '#7a6a4a',
            marginBottom: '4px',
          }}
        >
          You may turn in any completed contract here on its holder&apos;s
          behalf - the reward is credited to the holder, and you take no cut.
        </div>
      )}
      {showFellowshipHelp && (
        <Dialog
          title="Form a Fellowship for more benefits"
          width="420px"
          onClose={() => setShowFellowshipHelp(false)}
        >
          <div style={{ padding: '10px 14px', fontSize: '0.95em' }}>
            <div style={{ marginBottom: '6px' }}>
              Open the IC tab to form a fellowship and invite people nearby.
            </div>
            <div style={{ marginBottom: '6px' }}>
              Lead a fellowship of 2+ for more contract slots (+1 at 2 members,
              +2 at 3+).
            </div>
            <div>
              Fellowship members may turn in each other&apos;s contracts. It is
              credited to the one turning it in, using their tax exemption
              status, if any.
            </div>
          </div>
        </Dialog>
      )}
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
