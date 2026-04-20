import { useState } from 'react';
import { Button } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

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
  active_count: number;
  active_max: number;
  pool: Contract[];
  active: ActiveContract[];
  regions: string[];
  tax_rate: number;
};

const ALL_REGIONS = 'All';
const ALL_DIFFICULTIES = 'All';
const DIFFICULTIES = ['Easy', 'Medium', 'Hard'];

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
  const [activeRegion, setActiveRegion] = useState<string>(ALL_REGIONS);
  const [activeDifficulty, setActiveDifficulty] =
    useState<string>(ALL_DIFFICULTIES);

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
          <div className="ContractLedger__Header">Grand Contract Ledger</div>

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

          <div className="ContractLedger__Board">
            {filtered.length === 0 ? (
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
  const atCap = data.active_count >= data.active_max;
  const cantAfford = data.balance < c.deposit;
  const disabled = atCap || cantAfford;
  const title = atCap
    ? `You already hold ${data.active_max} contracts.`
    : cantAfford
      ? `Requires ${c.deposit} mammon in your account.`
      : undefined;
  return (
    <div className="ContractLedger__Card">
      <div className={difficultyPinClass(c.difficulty)} />
      <div className="ContractLedger__CardTitle">{c.title}</div>
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
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Reward</span>
        <span className="ContractLedger__CardValue">{c.reward} mammon</span>
      </div>
      {!c.levy_exempt && data.tax_rate > 0 && (
        <>
          <div className="ContractLedger__CardRow">
            <span className="ContractLedger__CardLabel">
              Crown Levy ({Math.round(data.tax_rate * 100)}%)
            </span>
            <span className="ContractLedger__CardValue" style={{ color: '#c44' }}>
              -{Math.round(c.reward * data.tax_rate)} mammon
            </span>
          </div>
          <div className="ContractLedger__CardRow">
            <span className="ContractLedger__CardLabel">Take-home</span>
            <span className="ContractLedger__CardValue" style={{ fontWeight: 'bold' }}>
              {c.reward - Math.round(c.reward * data.tax_rate)} mammon
            </span>
          </div>
        </>
      )}
      {!!c.levy_exempt && (
        <div className="ContractLedger__CardRow">
          <span className="ContractLedger__CardLabel">Stamp</span>
          <span className="ContractLedger__CardValue" style={{ color: '#4a4' }}>
            LEVY EXEMPT
          </span>
        </div>
      )}
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Deposit</span>
        <span className="ContractLedger__CardValue">{c.deposit} mammon</span>
      </div>
      {c.expected_count > 0 && (
        <div className="ContractLedger__CardRow">
          <span className="ContractLedger__CardLabel">Expected</span>
          <span className="ContractLedger__CardValue">
            ~{c.expected_count} target{c.expected_count === 1 ? '' : 's'}
          </span>
        </div>
      )}
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
  return (
    <div className="ContractLedger__ActiveStrip">
      <div className="ContractLedger__ActiveStripHeader">
        <span>
          Your Contracts ({props.active.length} / {props.activeMax})
        </span>
        <span>Balance: {props.balance} mammon</span>
      </div>
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
      {!!data.is_handler && (
        <div style={{ marginTop: '8px' }}>
          <Button
            icon="print"
            color="transparent"
            onClick={() => act('print_active')}
          >
            Print Active Contracts
          </Button>
        </div>
      )}
    </div>
  );
};
