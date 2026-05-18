import { useState } from 'react';

import {
  cardStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
  SERIF,
} from '../../common/parchment';
import type { ActFn, HarborData } from '../types';

const labelStyle = {
  fontFamily: SERIF,
  fontSize: '11px',
  fontVariant: 'small-caps' as const,
  color: SEAL_AMBER,
  letterSpacing: '0.04em',
};

const valueStyle = {
  fontFamily: SERIF,
  fontSize: '13px',
  color: INK,
};

const noteStyle = {
  fontFamily: SERIF,
  fontSize: '11px',
  fontStyle: 'italic' as const,
  color: INK_SOFT,
  lineHeight: 1.4,
};

const LevyControl = (props: {
  current: number;
  cap: number;
  act: ActFn;
}) => {
  const { current, cap, act } = props;
  const [draft, setDraft] = useState<string>(String(current));
  const numeric = Number(draft);
  const valid = !Number.isNaN(numeric) && numeric >= 0 && numeric <= cap;
  const dirty = valid && numeric !== current;
  return (
    <div style={{ ...cardStyle, marginTop: '8px' }}>
      <div style={sectionHeaderStyle}>Merchant&apos;s Levy</div>
      <div style={{ ...noteStyle, marginBottom: '8px' }}>
        Your cut on every export sold through the public Navigator and the ship
        fulfillment crate. The Crown taxes your cut as income at the prevailing
        export duty rate. Capped at {cap}%.
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '12px',
          paddingBottom: '6px',
        }}
      >
        <span style={labelStyle}>Current</span>
        <span style={{ ...valueStyle, fontWeight: 'bold' }}>{current}%</span>
        <span style={{ flex: 1 }} />
        <span style={labelStyle}>Set to</span>
        <input
          type="number"
          min={0}
          max={cap}
          step={1}
          value={draft}
          onChange={(e) => setDraft(e.target.value)}
          style={{
            width: '64px',
            fontFamily: SERIF,
            fontSize: '13px',
            color: INK,
            background: 'rgba(255,248,220,0.6)',
            border: `1px solid ${INK_FAINT}`,
            borderRadius: '2px',
            padding: '2px 6px',
          }}
        />
        <button
          type="button"
          disabled={!dirty}
          style={inkButtonStyle({ disabled: !dirty })}
          onClick={() => {
            if (!dirty) return;
            act('set_levy', { percent: numeric });
          }}
        >
          Set
        </button>
      </div>
    </div>
  );
};

const AuditCard = (props: { harbor: HarborData }) => {
  const { harbor } = props;
  return (
    <div style={{ ...cardStyle, marginTop: '8px' }}>
      <div style={sectionHeaderStyle}>Week Audit</div>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: '1fr 1fr',
          rowGap: '4px',
          columnGap: '12px',
          paddingTop: '4px',
        }}
      >
        <span style={labelStyle}>Share collected</span>
        <span style={{ ...valueStyle, textAlign: 'right' }}>
          {harbor.merchant_levy_collected}m
        </span>
        <span style={labelStyle}>Income tax paid on levy</span>
        <span style={{ ...valueStyle, textAlign: 'right' }}>
          {harbor.merchant_levy_taxed}m
        </span>
      </div>
      <div style={{ ...noteStyle, marginTop: '6px' }}>
        Levy is deposited directly into the Merchant Fund at your Jawbank.
      </div>
    </div>
  );
};

export const ManagementTab = (props: {
  harbor?: HarborData;
  act: ActFn;
}) => {
  const { harbor, act } = props;
  if (!harbor) {
    return (
      <div style={pageStyle}>
        <div style={{ ...cardStyle, textAlign: 'center', color: INK_SOFT }}>
          The ledgers are not yet drawn up.
        </div>
      </div>
    );
  }
  return (
    <div style={pageStyle}>
      <LevyControl
        current={harbor.merchant_levy_percent}
        cap={harbor.merchant_levy_cap}
        act={act}
      />
      <AuditCard harbor={harbor} />
    </div>
  );
};
