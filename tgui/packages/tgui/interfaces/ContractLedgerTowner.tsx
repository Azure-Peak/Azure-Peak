import { useState } from 'react';
import { Button } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';

type Tier = 'medium' | 'hard';

type TierSummary = {
  bearer_summary: string;
  poster_summary: string;
};

type Posting = {
  type: string;
  label: string;
  blurb: string;
  rules?: string[];
  eligible: BooleanLike;
  eligible_jobs: string[];
  cost_medium: number;
  cost_hard: number;
  tiers: Record<Tier, TierSummary>;
};

type TownerData = {
  balance: number;
  towner_postings: Posting[];
};

const tierButtonStyle = (selected: boolean): React.CSSProperties =>
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

const TierSummaryBlock = (props: { summary: TierSummary }) => (
  <div
    className="ContractLedger__CardObjective"
    style={{ marginTop: 6, fontSize: '0.9em', opacity: 0.85 }}
  >
    <div>
      <b>To bearer:</b> {props.summary.bearer_summary}.
    </div>
    <div>
      <b>To poster:</b> {props.summary.poster_summary}.
    </div>
  </div>
);

const ActivePostingCard = (props: {
  posting: Posting;
  balance: number;
  onPost: (tier: Tier) => void;
}) => {
  const [tier, setTier] = useState<Tier>('hard');
  const cost =
    tier === 'medium' ? props.posting.cost_medium : props.posting.cost_hard;
  const canAfford = props.balance >= cost;
  const summary = props.posting.tiers[tier];
  return (
    <div className="ContractLedger__Card" style={{ width: 300 }}>
      <div className="ContractLedger__CardTitle">{props.posting.label}</div>
      <div className="ContractLedger__CardObjective">{props.posting.blurb}</div>
      <RulesBlock rules={props.posting.rules} />
      {summary && <TierSummaryBlock summary={summary} />}
      <div className="ContractLedger__CardRow" style={{ marginTop: 8 }}>
        <Button
          selected={tier === 'medium'}
          onClick={() => setTier('medium')}
          style={tierButtonStyle(tier === 'medium')}
        >
          Medium ({props.posting.cost_medium}m)
        </Button>
        <Button
          selected={tier === 'hard'}
          onClick={() => setTier('hard')}
          style={tierButtonStyle(tier === 'hard')}
        >
          Hard ({props.posting.cost_hard}m)
        </Button>
      </div>
      <div className="ContractLedger__CardFooter">
        <button
          type="button"
          className="ContractLedger__SignButton"
          disabled={!canAfford}
          title={!canAfford ? `You need ${cost}m on account.` : undefined}
          onClick={() => props.onPost(tier)}
        >
          Post ({cost}m)
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
  return (
    <div className="ContractLedger__Card" style={{ width: 300, opacity: 0.65 }}>
      <div className="ContractLedger__CardTitle">{props.posting.label}</div>
      <div className="ContractLedger__CardObjective">{props.posting.blurb}</div>
      <RulesBlock rules={props.posting.rules} />
      <div
        className="ContractLedger__CardObjective"
        style={{ marginTop: 6, fontSize: '0.9em', opacity: 0.85 }}
      >
        <b>Medium ({props.posting.cost_medium}m):</b>
      </div>
      <TierSummaryBlock summary={props.posting.tiers.medium} />
      <div
        className="ContractLedger__CardObjective"
        style={{ marginTop: 6, fontSize: '0.9em', opacity: 0.85 }}
      >
        <b>Hard ({props.posting.cost_hard}m):</b>
      </div>
      <TierSummaryBlock summary={props.posting.tiers.hard} />
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

  const post = (postingType: string, tier: Tier) => {
    act('compose_towner', { type: postingType, tier });
  };

  const yourPostings = postings.filter((p) => !!p.eligible);
  const otherPostings = postings.filter((p) => !p.eligible);

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
        <span>Balance: {data.balance}m</span>
      </div>
      <div style={blurbStyle}>
        Post a contract on your own coin. The fellowship that takes it must
        bring you along - and you only get paid if you live to collect.
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
                onPost={(t) => post(p.type, t)}
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
