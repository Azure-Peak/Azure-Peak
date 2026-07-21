import { useState } from 'react';
import { Button, NumberInput } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  bannerStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  INK_FAINT,
  SEAL_AMBER,
  SEAL_RED_SOFT,
} from '../common/parchment';
import type { AtcLoanState, Data } from './types';

export const ATCLoanBanner = (props: { atc_loan: AtcLoanState }) => {
  const { act, data } = useBackend<Data>();
  const { atc_loan } = props;
  const aldermanActing = !!data.is_alderman_acting;

  const [amount, setAmount] = useState(atc_loan.min);

  if (!atc_loan.can_view) {
    return null;
  }
  if (
    !atc_loan.available &&
    atc_loan.loans_drawn === 0 &&
    !atc_loan.arrears_consumed
  ) {
    return null;
  }

  const accent = atc_loan.arrears_consumed ? SEAL_RED_SOFT : SEAL_AMBER;

  return (
    <div
      style={{
        ...bannerStyle(accent),
        padding: '10px 14px',
        textAlign: 'left',
        fontVariant: 'normal',
      }}
    >
      <div
        style={{
          fontSize: FONT_TITLE,
          fontWeight: 'bold',
          marginBottom: '4px',
          color: accent,
        }}
      >
        Azurian Trading Company - Company Clerk's Bench
      </div>
      <div style={{ color: INK, marginBottom: '6px' }}>
        {atc_loan.available ? (
          <>
            The clerk receives applications for emergency loan of{' '}
            <b>
              {atc_loan.min}m to {atc_loan.max}m
            </b>{' '}
            on the Company&apos;s standing credit, at the customary{' '}
            <b>{atc_loan.interest_pct}% interest</b> charged against the
            principal. The arrears grace stands forfeit on draw - should the
            Crown miss its next payroll, the realm enters sequestration without
            warning. Window closes on Day {atc_loan.closed_day}.
          </>
        ) : (
          atc_loan.blocker || 'The clerk is unavailable.'
        )}
      </div>
      {!!atc_loan.arrears_consumed && (
        <div
          style={{
            color: SEAL_RED_SOFT,
            fontSize: FONT_BODY,
            marginBottom: '6px',
          }}
        >
          Outstanding to the Company: <b>{atc_loan.outstanding}m</b>. All inflow
          into the Crown&apos;s Purse is skimmed against the debt until it is
          settled. The Burghers&apos; grace is forfeit; the next missed payroll
          skips arrears and goes straight to sequestration.
        </div>
      )}
      {atc_loan.loans_drawn > 0 && (
        <div
          style={{ color: INK_FAINT, fontSize: FONT_BODY, marginBottom: '6px' }}
        >
          Loans drawn this week: {atc_loan.loans_drawn}.
        </div>
      )}
      {!!atc_loan.available && (
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            opacity: aldermanActing ? 0.55 : 1,
            textDecoration: aldermanActing ? 'line-through' : undefined,
          }}
          title={
            aldermanActing
              ? "The Alderman's writ does not extend to drawing loans against the Crown."
              : undefined
          }
        >
          <span>Draw:</span>
          <NumberInput
            value={amount}
            minValue={atc_loan.min}
            maxValue={atc_loan.max}
            step={50}
            stepPixelSize={4}
            width="80px"
            disabled={aldermanActing}
            onChange={(v: number) => setAmount(v)}
          />
          <span>m</span>
          <span style={{ color: SEAL_RED_SOFT }}>
            (owe {Math.round(amount * (1 + atc_loan.interest_pct / 100))}m)
          </span>
          <Button.Confirm
            disabled={aldermanActing}
            onClick={() => act('take_atc_loan', { amount })}
          >
            Approach the Clerk
          </Button.Confirm>
        </div>
      )}
    </div>
  );
};
