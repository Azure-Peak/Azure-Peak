import { useState } from 'react';
import { Button } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';

type Tier = 'medium' | 'hard';

type Delivery = 'hand' | 'board';

const TIER_ORDER: Tier[] = ['medium', 'hard'];

const TIER_LABELS: Record<Tier, string> = {
  medium: 'Medium',
  hard: 'Hard',
};

type TierSummary = {
  bearer_summary: string;
  cost: number;
};

type Variety = {
  key: string;
  label: string;
  blurb: string;
  poster_summaries: Record<Tier, string>;
};

type Posting = {
  type: string;
  label: string;
  blurb: string;
  rules?: string[];
  eligible: BooleanLike;
  eligible_jobs: string[];
  crown_funded: BooleanLike;
  tiers: Record<Tier, TierSummary>;
  varieties: Variety[];
};

type TownerData = {
  balance: number;
  towner_purse_balance: number;
  towner_postings: Posting[];
};

const toggleStyle = (selected: boolean): React.CSSProperties =>
  selected
    ? {
        backgroundColor: 'hsl(28, 40%, 22%)',
        color: 'hsl(46, 55%, 92%)',
        border: '2px solid hsl(28, 40%, 12%)',
        fontWeight: 'bold',
      }
    : {
        backgroundColor: 'hsl(34, 28%, 70%)',
        color: 'hsl(28, 40%, 18%)',
        border: '2px solid hsl(28, 40%, 22%)',
      };

const RulesBlock = (props: { rules?: string[] }) => {
  if (!props.rules || props.rules.length === 0) return null;
  return (
    <div
      className="ContractLedger__CardObjective"
      style={{ marginTop: 4, fontSize: '0.85em', opacity: 0.8 }}
    >
      {props.rules.map((r, i) => (
        <div key={i}>- {r}</div>
      ))}
    </div>
  );
};

const SummaryBlock = (props: { bearer?: string; poster?: string }) => {
  if (!props.bearer && !props.poster) return null;
  return (
    <div
      className="ContractLedger__CardObjective"
      style={{ marginTop: 6, fontSize: '0.9em', opacity: 0.85 }}
    >
      {props.bearer && (
        <div>
          <b>To bearer:</b> {props.bearer}.
        </div>
      )}
      {props.poster && (
        <div>
          <b>To poster:</b> {props.poster}.
        </div>
      )}
    </div>
  );
};

const ActivePostingCard = (props: {
  posting: Posting;
  balance: number;
  purseBalance: number;
  onPost: (tier: Tier, delivery: Delivery, variety: string) => void;
}) => {
  const [tier, setTier] = useState<Tier>('medium');
  const [delivery, setDelivery] = useState<Delivery>('hand');
  const varieties = props.posting.varieties || [];
  const [varietyKey, setVarietyKey] = useState<string>(
    varieties.length > 0 ? varieties[0].key : '',
  );
  const selectedVariety =
    varieties.find((v) => v.key === varietyKey) || varieties[0];
  const summary = props.posting.tiers[tier];
  const cost = summary ? summary.cost : 0;
  const crown = !!props.posting.crown_funded;
  const purse = crown ? props.purseBalance : props.balance;
  const canAfford = purse >= cost;
  return (
    <div className="ContractLedger__Card" style={{ width: 300 }}>
      <div className="ContractLedger__CardTitle">{props.posting.label}</div>
      <div className="ContractLedger__CardObjective">{props.posting.blurb}</div>
      {crown && (
        <div
          className="ContractLedger__CardObjective"
          style={{ marginTop: 4, fontSize: '0.85em', fontWeight: 'bold' }}
        >
          Crown commission - drawn from the Crown&apos;s Purse at double price.
        </div>
      )}
      <RulesBlock rules={props.posting.rules} />
      {varieties.length > 1 && (
        <div
          className="ContractLedger__CardRow"
          style={{ marginTop: 8, flexWrap: 'wrap', justifyContent: 'flex-start' }}
        >
          {varieties.map((v) => (
            <Button
              key={v.key}
              selected={selectedVariety?.key === v.key}
              onClick={() => setVarietyKey(v.key)}
              style={toggleStyle(selectedVariety?.key === v.key)}
              tooltip={v.blurb}
            >
              {v.label}
            </Button>
          ))}
        </div>
      )}
      <SummaryBlock
        bearer={summary?.bearer_summary}
        poster={selectedVariety?.poster_summaries?.[tier]}
      />
      <div
        className="ContractLedger__CardRow"
        style={{ marginTop: 8, justifyContent: 'flex-start' }}
      >
        {TIER_ORDER.map((t) => (
          <Button
            key={t}
            selected={tier === t}
            onClick={() => setTier(t)}
            style={toggleStyle(tier === t)}
          >
            {TIER_LABELS[t]} ({props.posting.tiers[t]?.cost}m)
          </Button>
        ))}
      </div>
      <div
        className="ContractLedger__CardRow"
        style={{ marginTop: 6, justifyContent: 'flex-start' }}
      >
        <Button
          selected={delivery === 'hand'}
          onClick={() => setDelivery('hand')}
          style={toggleStyle(delivery === 'hand')}
          tooltip="Take the writ in hand and give it to someone yourself."
        >
          Writ in hand
        </Button>
        <Button
          selected={delivery === 'board'}
          onClick={() => setDelivery('board')}
          style={toggleStyle(delivery === 'board')}
          tooltip="Pin it to the ledger."
        >
          Post to board
        </Button>
      </div>
      <div className="ContractLedger__CardFooter">
        <button
          type="button"
          className="ContractLedger__SignButton"
          disabled={!canAfford}
          title={
            !canAfford
              ? crown
                ? `The Crown's Purse needs ${cost}m.`
                : `You need ${cost}m on account.`
              : undefined
          }
          onClick={() =>
            props.onPost(tier, delivery, selectedVariety?.key || '')
          }
        >
          {delivery === 'hand' ? 'Draw up' : 'Post'} ({cost}m)
        </button>
      </div>
    </div>
  );
};

const ViewOnlyPostingCard = (props: { posting: Posting }) => {
  const jobs =
    props.posting.eligible_jobs.length > 0
      ? props.posting.eligible_jobs.join(', ')
      : 'unknown';
  const varieties = props.posting.varieties || [];
  return (
    <div className="ContractLedger__Card" style={{ width: 300, opacity: 0.65 }}>
      <div className="ContractLedger__CardTitle">{props.posting.label}</div>
      <div className="ContractLedger__CardObjective">{props.posting.blurb}</div>
      <RulesBlock rules={props.posting.rules} />
      {TIER_ORDER.map((t) => (
        <div key={t}>
          <div
            className="ContractLedger__CardObjective"
            style={{ marginTop: 6, fontSize: '0.9em', opacity: 0.85 }}
          >
            <b>
              {TIER_LABELS[t]} ({props.posting.tiers[t]?.cost}m):
            </b>{' '}
            {props.posting.tiers[t]?.bearer_summary}.
          </div>
        </div>
      ))}
      {varieties.length > 0 && (
        <div
          className="ContractLedger__CardObjective"
          style={{ marginTop: 6, fontSize: '0.85em', opacity: 0.8 }}
        >
          <b>Veins:</b>
          {varieties.map((v) => (
            <div key={v.key}>
              - {v.label}: {v.blurb}
            </div>
          ))}
        </div>
      )}
      <div className="ContractLedger__CardRow" style={{ marginTop: 8 }}>
        <span className="ContractLedger__CardLabel">Posted by:</span>
        <span className="ContractLedger__CardValue">{jobs}</span>
      </div>
    </div>
  );
};

export const TownerPostingPanel = () => {
  const { act, data } = useBackend<TownerData>();
  const postings = data.towner_postings || [];

  const post = (
    postingType: string,
    tier: Tier,
    delivery: Delivery,
    variety: string,
  ) => {
    act('compose_towner', { type: postingType, tier, delivery, variety });
  };

  const yourPostings = postings.filter((p) => !!p.eligible);
  const otherPostings = postings.filter((p) => !p.eligible);
  const anyCrown = yourPostings.some((p) => !!p.crown_funded);

  const sectionStyle: React.CSSProperties = {
    marginTop: 12,
    marginBottom: 6,
    fontWeight: 'bold',
    opacity: 0.85,
  };
  const blurbStyle: React.CSSProperties = {
    marginBottom: 8,
    opacity: 0.85,
  };

  return (
    <div style={{ padding: 12 }}>
      <div
        style={{
          display: 'flex',
          alignItems: 'baseline',
          justifyContent: 'space-between',
          marginBottom: 6,
        }}
      >
        <span style={{ fontSize: '1.1em', fontWeight: 'bold' }}>
          Towner Postings
        </span>
        <span>
          Balance: {data.balance}m
          {anyCrown && <> | Purse: {data.towner_purse_balance ?? 0}m</>}
        </span>
      </div>
      <div style={blurbStyle}>
        Post a contract with your own mammons. Whomever takes it must deliver the parcel to you, who is the only one that can open the package.
      </div>

      {yourPostings.length > 0 && (
        <>
          <div style={sectionStyle}>YOUR POSTINGS</div>
          <div className="ContractLedger__Grid">
            {yourPostings.map((p) => (
              <ActivePostingCard
                key={p.type}
                posting={p}
                balance={data.balance}
                purseBalance={data.towner_purse_balance ?? 0}
                onPost={(t, d, v) => post(p.type, t, d, v)}
              />
            ))}
          </div>
        </>
      )}

      {otherPostings.length > 0 && (
        <>
          <div style={sectionStyle}>OTHER POSTINGS</div>
          <div className="ContractLedger__Grid">
            {otherPostings.map((p) => (
              <ViewOnlyPostingCard key={p.type} posting={p} />
            ))}
          </div>
        </>
      )}
    </div>
  );
};
