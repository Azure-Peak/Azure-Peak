import { useState } from 'react';
import { Button } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';

export type IssuedContract = {
  ref: string;
  title: string;
  type: string;
  region: string;
  issued_by: string;
  minutes_elapsed: number;
  reward: number;
  is_directive: BooleanLike;
  status: string;
  cancel_blocker: string | null;
  refund: string;
};

const STATUS_LABELS: Record<string, string> = {
  lapsed: 'lapsed untaken',
  withdrawn: 'withdrawn',
};

export const issueStatusSuffix = (status?: string, refund?: string) => {
  if (!status) return '';
  const label = STATUS_LABELS[status] || status;
  return refund ? ` · ${label}, refunded ${refund}` : ` · ${label}`;
};

export const LedgerSubTabBar = <T extends string>(props: {
  tabs: { id: T; label: string }[];
  active: T;
  onSelect: (t: T) => void;
}) => (
  <div className="ContractLedger__InnkeeperSubTabBar">
    {props.tabs.map((t) => (
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

const CANCEL_DEBOUNCE_MS = 500;

export const IssuedContractsView = (props: {
  entries: IssuedContract[];
  windowMinutes: number;
  notTakenPct: number;
  failurePct: number;
}) => {
  const { act } = useBackend();
  const [inflight, setInflight] = useState<string | null>(null);
  const { entries, windowMinutes, notTakenPct, failurePct } = props;

  const cancel = (ref: string) => {
    setInflight(ref);
    act('cancel_issued', { ref });
    setTimeout(() => setInflight(null), CANCEL_DEBOUNCE_MS);
  };

  return (
    <>
      <div className="ContractLedger__ActiveRow">
        <span className="ContractLedger__ActiveRow__Meta">
          You can withdraw a contract no one has taken at any time. Once someone
          takes it, you must wait {windowMinutes} minutes. You can&apos;t
          withdraw it once the work has begun. {notTakenPct}% of the cost is
          refunded. If the contract fails, {failurePct}% is refunded
          automatically. If its holder abandons it, you get {notTakenPct}% back
          before the work begins and {failurePct}% after. A Request&apos;s daily
          slot is not restored.
        </span>
      </div>
      {entries.length === 0 ? (
        <div className="ContractLedger__ActiveRow">
          <span className="ContractLedger__ActiveRow__Meta">
            You have no postings in circulation.
          </span>
        </div>
      ) : (
        entries.map((c) => (
          <div key={c.ref} className="ContractLedger__ActiveRow">
            <span className="ContractLedger__ActiveRow__Title">{c.title}</span>
            <span className="ContractLedger__ActiveRow__Meta">
              {c.type} &middot; {c.region} &middot; by{' '}
              {c.issued_by || 'unknown'} &middot; {c.minutes_elapsed}m elapsed
              &middot; {c.is_directive ? 'Request' : `${c.reward}m reward`}{' '}
              &middot; {c.status}
              {c.cancel_blocker
                ? ` · locked: ${c.cancel_blocker}`
                : c.refund
                  ? ` · refunds ${c.refund}`
                  : ''}
            </span>
            <Button
              icon="undo"
              color="bad"
              disabled={!!c.cancel_blocker || inflight === c.ref}
              tooltip={c.cancel_blocker || undefined}
              onClick={() => cancel(c.ref)}
            >
              Withdraw
            </Button>
          </div>
        ))
      )}
    </>
  );
};
