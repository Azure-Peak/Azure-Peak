import { NumberInput } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_RED,
  subTabStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';

type Data = {
  merc_name: string;
  max_days: number;
  max_rate: number;
  days_prompt: string;
  rate_prompt: string;
  rules: string[];
  signed: BooleanLike;
  is_merc: BooleanLike;
  status_lines?: string[];
  is_hirer?: BooleanLike;
  end_early_wait?: string | null;
  agreed_end_terms?: string;
  agreed_end_pending?: BooleanLike;
  headline?: string;
  days?: number;
  rate?: number;
  can_edit?: BooleanLike;
  balance?: number | null;
  offer_lines?: string[];
  hire_blocker?: string | null;
};

const Lines = ({ lines }: { lines?: string[] }) => (
  <>
    {(lines || []).map((line) => (
      <div key={line} style={{ marginBottom: 6 }}>
        {line}
      </div>
    ))}
  </>
);

const SignedView = () => {
  const { act, data } = useBackend<Data>();
  const waiting = !!data.end_early_wait;
  const pending = !!data.agreed_end_pending;
  return (
    <>
      <Lines lines={data.status_lines} />
      {!!data.is_hirer && (
        <div style={{ marginTop: 10, textAlign: 'right' }}>
          {waiting && (
            <div style={{ color: INK_SOFT, marginBottom: 6 }}>
              {data.end_early_wait}
            </div>
          )}
          <button
            type="button"
            style={inkButtonStyle({ color: SEAL_RED, disabled: waiting })}
            disabled={waiting}
            onClick={() => act('end_early')}
          >
            End contract early
          </button>
          <div style={{ color: INK_SOFT, marginTop: 10, marginBottom: 6 }}>
            {pending
              ? `Waiting for ${data.merc_name} to answer.`
              : data.agreed_end_terms}
          </div>
          <button
            type="button"
            style={inkButtonStyle({ disabled: pending })}
            disabled={pending}
            onClick={() => act('propose_end')}
          >
            Ask to end by agreement
          </button>
        </div>
      )}
    </>
  );
};

const MercView = () => {
  const { act, data } = useBackend<Data>();
  const locked = !data.can_edit;
  const dayOptions = Array.from({ length: data.max_days }, (_, i) => i + 1);
  return (
    <>
      <div style={{ marginBottom: 4 }}>{data.days_prompt}</div>
      <div style={{ display: 'flex', gap: 6, marginBottom: 14 }}>
        {dayOptions.map((d) => (
          <button
            key={d}
            type="button"
            style={subTabStyle(d === data.days)}
            disabled={locked}
            onClick={() => act('set_days', { days: d })}
          >
            {d}
          </button>
        ))}
      </div>
      <div style={{ marginBottom: 4 }}>{data.rate_prompt}</div>
      <NumberInput
        step={1}
        minValue={0}
        maxValue={data.max_rate}
        unit="m"
        disabled={locked}
        value={data.rate || 0}
        onChange={(v: number) => act('set_rate', { rate: v })}
      />
    </>
  );
};

const HirerView = () => {
  const { act, data } = useBackend<Data>();
  const blocked = !!data.hire_blocker;
  const hasAccount = data.balance !== null && data.balance !== undefined;
  return (
    <>
      <Lines lines={data.offer_lines} />
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>MEISTER account</div>
        <div style={fieldValueStyle}>
          {hasAccount ? `${data.balance} mammon` : 'None'}
        </div>
      </div>
      {blocked && (
        <div style={{ color: SEAL_RED, marginTop: 8 }}>
          {data.hire_blocker}
        </div>
      )}
      <div style={{ marginTop: 10, textAlign: 'right' }}>
        <button
          type="button"
          style={inkButtonStyle({ disabled: blocked })}
          disabled={blocked}
          onClick={() => act('offer')}
        >
          Offer the contract
        </button>
      </div>
    </>
  );
};

export const MercContract = () => {
  const { data } = useBackend<Data>();
  return (
    <Window
      title="Mercenary Contract"
      width={460}
      height={600}
      theme="parchment"
    >
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div style={titleStyle}>Mercenary Contract</div>
          <div style={subtitleStyle}>{data.merc_name}</div>
          <hr style={rulerStyle} />
          {data.signed ? (
            <SignedView />
          ) : (
            <>
              <div style={{ fontWeight: 'bold', marginBottom: 10 }}>
                {data.headline}
              </div>
              {data.is_merc ? <MercView /> : <HirerView />}
              <hr style={rulerStyle} />
              <div style={{ color: INK_SOFT }}>
                <Lines lines={data.rules} />
              </div>
            </>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
