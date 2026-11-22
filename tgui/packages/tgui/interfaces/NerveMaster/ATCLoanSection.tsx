import { useState } from 'react';
import { Button, NumberInput } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  FONT_BODY,
  INK,
  INK_FAINT,
  SEAL_RED_SOFT,
  sectionHeaderStyle,
} from '../common/parchment';
import type { AtcLoanState, Data } from './types';

export const ATCLoanSection = (props: { atc_loan: AtcLoanState }) => {
  const { act } = useBackend<Data>();
  const { atc_loan } = props;
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

  return (
    <div>
      <div style={{ ...sectionHeaderStyle, marginTop: 0 }}>ATC Loan</div>
      <div style={{ color: INK, marginBottom: '6px' }}>
        {atc_loan.available ? (
          <>
            The ATC receives applications for an emergency loan of{' '}
            <b>
              {atc_loan.min}m to {atc_loan.max}m
            </b>
            , at <b>{atc_loan.interest_pct}% interest</b>. While you owe the ATC,
            the Burghers won&apos;t cover a missed payroll. Miss one and the
            realm is sequestered. Loans close on Day{' '}
            {atc_loan.closed_day}.
          </>
        ) : (
          atc_loan.blocker || 'No loan available right now.'
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
          You owe the ATC <b>{atc_loan.outstanding}m</b>. Everything paid into
          the Treasury goes to them until it&apos;s repaid, and the Burghers
          won&apos;t cover a missed payroll.
        </div>
      )}
      {atc_loan.loans_drawn > 0 && (
        <div
          style={{ color: INK_FAINT, fontSize: FONT_BODY, marginBottom: '6px' }}
        >
          Loans taken this week: {atc_loan.loans_drawn}.
        </div>
      )}
      {!!atc_loan.available && (
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
          }}
        >
          <span>Amount:</span>
          <NumberInput
            value={amount}
            minValue={atc_loan.min}
            maxValue={atc_loan.max}
            step={50}
            stepPixelSize={4}
            width="80px"
            onChange={(v: number) => setAmount(v)}
          />
          <span>m</span>
          <span style={{ color: SEAL_RED_SOFT }}>
            (owe {Math.round(amount * (1 + atc_loan.interest_pct / 100))}m)
          </span>
          <Button.Confirm onClick={() => act('take_atc_loan', { amount })}>
            Take Loan
          </Button.Confirm>
        </div>
      )}
    </div>
  );
};
