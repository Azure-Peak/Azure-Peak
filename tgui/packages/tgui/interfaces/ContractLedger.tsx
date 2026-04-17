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
  objective: string;
};

type ActiveContract = {
  ref: string;
  title: string;
  type: string;
  difficulty: string;
  area: string;
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
};

// Pluggable grouping: change the `key` field to regroup by type, origin, etc.
type TabDef = {
  id: string;
  label: string;
  filter: (c: Contract) => boolean;
};

const DIFFICULTY_TABS: TabDef[] = [
  { id: 'Easy', label: 'Easy', filter: (c) => c.difficulty === 'Easy' },
  { id: 'Medium', label: 'Medium', filter: (c) => c.difficulty === 'Medium' },
  { id: 'Hard', label: 'Hard', filter: (c) => c.difficulty === 'Hard' },
];

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
  const [activeTab, setActiveTab] = useState(DIFFICULTY_TABS[0].id);
  const tabs = DIFFICULTY_TABS;
  const currentTab = tabs.find((t) => t.id === activeTab) || tabs[0];
  const filtered = data.pool.filter(currentTab.filter);

  return (
    <Window
      title="Grand Contract Ledger"
      width={780}
      height={620}
      theme="grimoire"
    >
      <Window.Content fitted>
        <div className="ContractLedger">
          <div className="ContractLedger__Header">
            Grand Contract Ledger
          </div>

          <div className="ContractLedger__TabBar">
            {tabs.map((tab) => {
              const count = data.pool.filter(tab.filter).length;
              const isActive = tab.id === activeTab;
              return (
                <div
                  key={tab.id}
                  className={
                    'ContractLedger__Tab' +
                    (isActive ? ' ContractLedger__Tab--active' : '')
                  }
                  onClick={() => setActiveTab(tab.id)}
                >
                  {tab.label} ({count})
                </div>
              );
            })}
          </div>

          <div className="ContractLedger__Board">
            {filtered.length === 0 ? (
              <div className="ContractLedger__Empty">
                No {currentTab.label.toLowerCase()} contracts posted. Return
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
        <span className="ContractLedger__CardLabel">Type</span>
        <span className="ContractLedger__CardValue">{c.type}</span>
      </div>
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Region</span>
        <span className="ContractLedger__CardValue">
          {c.area || 'Unknown'}
        </span>
      </div>
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Reward</span>
        <span className="ContractLedger__CardValue">{c.reward} mammon</span>
      </div>
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Deposit</span>
        <span className="ContractLedger__CardValue">{c.deposit} mammon</span>
      </div>
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
            <span className="ContractLedger__ActiveRow__Title">
              {a.title}
            </span>
            <span className="ContractLedger__ActiveRow__Meta">
              {a.type} &middot; {a.difficulty} &middot; {a.area || 'Unknown'}
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
