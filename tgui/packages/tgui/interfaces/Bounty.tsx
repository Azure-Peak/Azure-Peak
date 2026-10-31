import { useState } from 'react';
import { Button, Dropdown, TextArea } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  INK_SOFT,
  pageStyle,
  rulerStyle,
  SEAL_GREEN,
  SERIF,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';

type BountyFaction = 'crown' | 'church' | 'inquisition';

type Bounty = {
  target: string;
  employer: string;
  faction: BountyFaction;
  unremovable: BooleanLike;
  amount: number;
  reason: string;
  race: string;
  height: string;
  body_type: string;
  body: string;
  voice: string;
  ref: string;
};

type Data = {
  bounties: Bounty[];
  can_manage: BooleanLike;
  manage_faction: BountyFaction | '';
  known_targets: string[];
  balance: number;
  has_account: BooleanLike;
};

const FACTION_TABS: { id: BountyFaction; label: string }[] = [
  { id: 'crown', label: 'The Crown' },
  { id: 'church', label: 'The Church' },
  { id: 'inquisition', label: 'The Inquisition' },
];

export const Bounty = () => {
  const { act, data } = useBackend<Data>();
  const { bounties } = data;
  const [faction, setFaction] = useState<BountyFaction>(
    data.manage_faction || 'crown',
  );
  const [target, setTarget] = useState('');
  const [amount, setAmount] = useState('100');
  const [reason, setReason] = useState('');
  const [confirmingRemoval, setConfirmingRemoval] = useState<string | null>(
    null,
  );
  const factionBounties = bounties.filter(
    (bounty) => bounty.faction === faction,
  );
  const existingTargetBounty = factionBounties.find(
    (bounty) => bounty.target === target,
  );
  const minimumAmount = existingTargetBounty ? 1 : 100;
  const maximumAmount = Math.max(0, 500 - (existingTargetBounty?.amount ?? 0));
  const canManageFaction = !!data.can_manage && data.manage_faction === faction;
  const numericAmount = Number(amount);
  const canSubmit =
    canManageFaction &&
    !!data.has_account &&
    data.known_targets.includes(target) &&
    Number.isInteger(numericAmount) &&
    numericAmount >= minimumAmount &&
    numericAmount <= maximumAmount &&
    numericAmount <= data.balance &&
    !!reason.trim();

  return (
    <Window width={560} height={480} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>Wanted by the Excidium</div>
          <div style={rulerStyle} />
          <div style={tabBarStyle}>
            {FACTION_TABS.map((tab) => (
              <button
                type="button"
                key={tab.id}
                style={tabStyle(faction === tab.id)}
                onClick={() => setFaction(tab.id)}
              >
                {tab.label}
              </button>
            ))}
          </div>
          {factionBounties.length ? (
            factionBounties.map((bounty) => (
              <div
                key={bounty.ref}
                style={{
                  ...cardStyle,
                  fontFamily: SERIF,
                  fontSize: FONT_BODY,
                }}
              >
                <div
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'baseline',
                    gap: '8px',
                    marginBottom: '6px',
                  }}
                >
                  <span
                    style={{
                      color: INK,
                      fontSize: FONT_TITLE,
                      fontWeight: 'bold',
                    }}
                  >
                    {bounty.target}
                  </span>
                  <span
                    style={{
                      color: SEAL_GREEN,
                      fontWeight: 'bold',
                      whiteSpace: 'nowrap',
                    }}
                  >
                    {bounty.amount} mammon
                  </span>
                  {canManageFaction && !bounty.unremovable && (
                    <Button
                      color="bad"
                      icon="trash"
                      onClick={() => {
                        if (confirmingRemoval === bounty.ref) {
                          act('remove_bounty', { ref: bounty.ref });
                          setConfirmingRemoval(null);
                          return;
                        }
                        setConfirmingRemoval(bounty.ref);
                      }}
                    >
                      {confirmingRemoval === bounty.ref
                        ? 'Confirm removal?'
                        : 'Remove'}
                    </Button>
                  )}
                </div>
                <div style={{ color: INK_SOFT }}>
                  Posted by {bounty.employer}
                </div>
                <div
                  style={{
                    color: INK,
                    marginTop: '4px',
                    whiteSpace: 'pre-line',
                  }}
                >
                  {bounty.reason}
                </div>
                <div style={{ color: INK_SOFT, marginTop: '6px' }}>
                  {bounty.race} · {bounty.height} · {bounty.body_type} build ·{' '}
                  {bounty.body} physique · {bounty.voice} voice
                </div>
                {!!bounty.unremovable && (
                  <div
                    style={{
                      color: 'var(--p-seal-red)',
                      fontSize: 'var(--p-font-small)',
                      marginTop: '4px',
                    }}
                  >
                    Penance is owed. These crimes may not be so easily forgiven.
                  </div>
                )}
              </div>
            ))
          ) : (
            <div
              style={{
                ...cardStyle,
                color: INK_SOFT,
                fontFamily: SERIF,
                fontSize: FONT_BODY,
                textAlign: 'center',
                fontStyle: 'italic',
              }}
            >
              No active bounties in this category.
            </div>
          )}
          {canManageFaction && (
            <div
              style={{ ...cardStyle, fontFamily: SERIF, fontSize: FONT_BODY }}
            >
              <div
                style={{
                  color: INK,
                  fontSize: FONT_TITLE,
                  fontWeight: 'bold',
                  marginBottom: '8px',
                  textAlign: 'center',
                }}
              >
                Create a bounty on behalf of{' '}
                {FACTION_TABS.find((tab) => tab.id === faction)?.label}
              </div>
              <div
                style={{
                  color: INK_SOFT,
                  marginBottom: '6px',
                  textAlign: 'center',
                }}
              >
                <div>
                  Your balance:{' '}
                  <span style={{ color: SEAL_GREEN, fontWeight: 'bold' }}>
                    {data.balance}
                  </span>{' '}
                  mammon.
                </div>
                <div>Bounty rewards may range between 100 and 500 mammon.</div>
              </div>
              {data.known_targets.length ? (
                <>
                  <Dropdown
                    fluid
                    selected={target}
                    options={[
                      { value: '', displayText: 'Select someone you know' },
                      ...data.known_targets,
                    ]}
                    onSelected={setTarget}
                  />
                  <input
                    type="number"
                    step={1}
                    min={minimumAmount}
                    max={maximumAmount}
                    value={amount}
                    onChange={(event) => setAmount(event.target.value)}
                    placeholder={
                      existingTargetBounty
                        ? 'Additional bounty amount'
                        : 'Bounty amount'
                    }
                    style={{
                      width: '100%',
                      boxSizing: 'border-box',
                      marginTop: '0.5rem',
                      padding: '0.4rem',
                      color: INK,
                      background: 'var(--p-bg-deep)',
                      border: '1px solid var(--p-ink-faint)',
                      borderRadius: '2px',
                      fontFamily: SERIF,
                      fontSize: FONT_BODY,
                    }}
                  />
                  {existingTargetBounty && (
                    <div
                      style={{
                        color: INK_SOFT,
                        fontSize: 'var(--p-font-small)',
                        marginTop: '4px',
                      }}
                    >
                      This will add to the existing bounty (up to{' '}
                      {maximumAmount} more mammon) and append the reason.
                    </div>
                  )}
                  <TextArea
                    fluid
                    mt={1}
                    height="4rem"
                    value={reason}
                    onChange={setReason}
                    placeholder="Reason for the bounty"
                  />
                  <div style={{ textAlign: 'right', marginTop: '8px' }}>
                    <Button
                      color="good"
                      disabled={!canSubmit}
                      onClick={() =>
                        act('set_bounty', {
                          target,
                          amount,
                          reason,
                        })
                      }
                    >
                      Post bounty
                    </Button>
                  </div>
                </>
              ) : (
                <div style={{ color: INK_SOFT }}>
                  You do not currently know anyone eligible for a bounty.
                </div>
              )}
              {!data.has_account && (
                <div style={{ color: INK_SOFT, marginTop: '6px' }}>
                  You need a bank account to post a bounty.
                </div>
              )}
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
