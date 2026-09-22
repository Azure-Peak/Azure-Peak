import { useState } from 'react';
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

const CANCEL_DEBOUNCE_MS = 500;

export const IssuedContractsView = (props: {
  entries: IssuedContract[];
  windowMinutes: number;
  emptyText: string;
}) => {
  const { act } = useBackend();
  const [inflight, setInflight] = useState<string | null>(null);
  const { entries, windowMinutes, emptyText } = props;

  const cancel = (ref: string) => {
    setInflight(ref);
    act('cancel_issued', { ref });
    setTimeout(() => setInflight(null), CANCEL_DEBOUNCE_MS);
  };

  return (
    <>
      <div className="ContractLedger__InnkeeperFlavor">
        An untaken contract may be withdrawn anytime. Once taken up, its bearer
        has {windowMinutes} minutes before it can be withdrawn, and never once the contract has begun. Its full cost is refunded, except for a Request's daily slot.
      </div>
      {entries.length === 0 ? (
        <div className="ContractLedger__InnkeeperEmpty">{emptyText}</div>
      ) : (
        <div className="ContractLedger__InnkeeperHistory">
          {entries.map((c) => (
            <div key={c.ref} className="ContractLedger__IssuedRow">
              <div className="ContractLedger__IssuedInfo">
                <span className="ContractLedger__InnkeeperHistoryTitle">
                  {c.title}
                </span>
                <span className="ContractLedger__InnkeeperHistoryMeta">
                  {c.type} &middot; {c.region} &middot; by{' '}
                  {c.issued_by || 'unknown'} &middot; {c.minutes_elapsed}m
                  elapsed &middot;{' '}
                  {c.is_directive ? 'Request' : `${c.reward}m reward`}
                </span>
                <span className="ContractLedger__InnkeeperHistoryMeta">
                  {c.status}
                  {c.cancel_blocker
                    ? ` · locked: ${c.cancel_blocker}`
                    : c.refund
                      ? ` · refunds ${c.refund}`
                      : ''}
                </span>
              </div>
              <button
                type="button"
                className="ContractLedger__SignButton"
                disabled={!!c.cancel_blocker || inflight === c.ref}
                onClick={() => cancel(c.ref)}
              >
                Cancel
              </button>
            </div>
          ))}
        </div>
      )}
    </>
  );
};
