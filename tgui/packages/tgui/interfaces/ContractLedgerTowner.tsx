import { useState } from 'react';
import { Button } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';

type TownerData = {
  balance: number;
  towner_caravan_eligible: BooleanLike;
  towner_orevein_eligible: BooleanLike;
  towner_posting_costs: Record<string, number>;
  towner_caravan_eligible_jobs: string[];
  towner_orevein_eligible_jobs: string[];
};

type PostingType = 'Smith Caravan' | 'Ore Vein';
type Tier = 'easy' | 'hard';

const POSTING_LABELS: Record<PostingType, string> = {
  'Smith Caravan': 'A Caravan Gone Missing',
  'Ore Vein': "A Miner's Lead",
};

const POSTING_BLURBS: Record<PostingType, string> = {
  'Smith Caravan':
    'A wagon of yours was lost on the road. Hire hands to escort you to the wreck.',
  'Ore Vein':
    'You have scented an elemental-guarded vein. Hire hands to clear the guardians while you work the rock.',
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

const ActivePostingCard = (props: {
  postingType: PostingType;
  balance: number;
  costs: Record<string, number>;
  onPost: (tier: Tier) => void;
}) => {
  const [tier, setTier] = useState<Tier>('hard');
  const cost = props.costs[tier] ?? (tier === 'easy' ? 50 : 100);
  const easyCost = props.costs.easy ?? 50;
  const hardCost = props.costs.hard ?? 100;
  const canAfford = props.balance >= cost;
  return (
    <div className="ContractLedger__Card">
      <div className="ContractLedger__CardTitle">
        {POSTING_LABELS[props.postingType]}
      </div>
      <div className="ContractLedger__CardObjective">
        {POSTING_BLURBS[props.postingType]}
      </div>
      <div className="ContractLedger__CardRow" style={{ marginTop: 8 }}>
        <Button
          selected={tier === 'easy'}
          onClick={() => setTier('easy')}
          style={tierButtonStyle(tier === 'easy')}
        >
          Easy ({easyCost}m)
        </Button>
        <Button
          selected={tier === 'hard'}
          onClick={() => setTier('hard')}
          style={tierButtonStyle(tier === 'hard')}
        >
          Hard ({hardCost}m)
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

const ViewOnlyPostingCard = (props: {
  postingType: PostingType;
  costs: Record<string, number>;
  eligibleJobs: string[];
}) => {
  const easyCost = props.costs.easy ?? 50;
  const hardCost = props.costs.hard ?? 100;
  const jobs =
    props.eligibleJobs.length > 0
      ? props.eligibleJobs.join(', ')
      : 'unknown';
  return (
    <div className="ContractLedger__Card" style={{ opacity: 0.65 }}>
      <div className="ContractLedger__CardTitle">
        {POSTING_LABELS[props.postingType]}
      </div>
      <div className="ContractLedger__CardObjective">
        {POSTING_BLURBS[props.postingType]}
      </div>
      <div className="ContractLedger__CardRow" style={{ marginTop: 8 }}>
        <span className="ContractLedger__CardLabel">Cost:</span>
        <span className="ContractLedger__CardValue">
          {easyCost}m or {hardCost}m
        </span>
      </div>
      <div className="ContractLedger__CardRow">
        <span className="ContractLedger__CardLabel">Posted by:</span>
        <span className="ContractLedger__CardValue">{jobs}</span>
      </div>
    </div>
  );
};

export const TownerPostingPanel = () => {
  const { act, data } = useBackend<TownerData>();
  const costs = data.towner_posting_costs || { easy: 50, hard: 100 };

  const post = (postingType: PostingType, tier: Tier) => {
    act('compose_towner', { type: postingType, tier });
  };

  const yourPostings: PostingType[] = [];
  const otherPostings: PostingType[] = [];
  if (data.towner_caravan_eligible) {
    yourPostings.push('Smith Caravan');
  } else {
    otherPostings.push('Smith Caravan');
  }
  if (data.towner_orevein_eligible) {
    yourPostings.push('Ore Vein');
  } else {
    otherPostings.push('Ore Vein');
  }

  const sectionStyle: React.CSSProperties = {
    marginTop: 12,
    marginBottom: 6,
    fontWeight: 'bold',
    letterSpacing: '0.05em',
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
                key={p}
                postingType={p}
                balance={data.balance}
                costs={costs}
                onPost={(t) => post(p, t)}
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
              <ViewOnlyPostingCard
                key={p}
                postingType={p}
                costs={costs}
                eligibleJobs={
                  p === 'Smith Caravan'
                    ? data.towner_caravan_eligible_jobs || []
                    : data.towner_orevein_eligible_jobs || []
                }
              />
            ))}
          </div>
        </>
      )}
    </div>
  );
};
