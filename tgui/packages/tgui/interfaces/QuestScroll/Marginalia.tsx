import { useEffect, useState } from 'react';

import {
  formatMinSec,
  marginalia,
  marginaliaLabel,
  marginaliaLine,
} from './shared';

export const WhisperLine = (props: { compass: string; zHint?: string }) => (
  <div style={marginaliaLine}>
    <span style={marginaliaLabel}>The scroll whispers:</span>
    the quarry is{props.compass}
    {props.zHint ? ` (${props.zHint})` : ''}.
  </div>
);

export const ProgressLine = (props: {
  done: number;
  total: number;
  noun: string;
}) => {
  const remaining = Math.max(0, props.total - props.done);
  return (
    <div style={marginaliaLine}>
      <span style={marginaliaLabel}>Of the {props.noun} accused,</span>
      <b>{props.done}</b> lie slain; <b>{remaining}</b> remain.
    </div>
  );
};

export const BlockadeTimer = (props: { label: string; seconds: number }) => {
  const [remaining, setRemaining] = useState(props.seconds);
  useEffect(() => {
    setRemaining(props.seconds);
  }, [props.seconds]);
  useEffect(() => {
    if (remaining <= 0) return;
    const t = setTimeout(() => setRemaining((s) => Math.max(0, s - 1)), 1000);
    return () => clearTimeout(t);
  }, [remaining]);
  const danger = remaining <= 30;
  return (
    <div style={marginaliaLine}>
      <span style={marginaliaLabel}>{props.label}:</span>
      <span
        style={{
          color: danger ? 'hsl(0, 65%, 35%)' : 'hsl(25, 55%, 22%)',
          fontFamily: "'Courier New', monospace",
          fontWeight: 'bold',
        }}
      >
        {formatMinSec(remaining)}
      </span>
    </div>
  );
};

export const Marginalia = (props: { children: React.ReactNode }) => (
  <div style={marginalia}>{props.children}</div>
);
