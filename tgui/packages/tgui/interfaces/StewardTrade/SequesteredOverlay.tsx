import type { ReactNode } from 'react';

import { SEAL_RED } from '../common/parchment';

/// Wrapper that paints a SEQUESTERED stamp across its children when `active`,
/// dims them, and blocks pointer events so accidental clicks don't fire even
/// though the backend already gates the action handlers.
export const SequesteredOverlay = (props: {
  active: boolean;
  label: string;
  children: ReactNode;
}) => {
  if (!props.active) {
    return <>{props.children}</>;
  }
  return (
    <div style={{ position: 'relative' }}>
      <div
        style={{
          opacity: 0.35,
          pointerEvents: 'none',
          userSelect: 'none',
          filter: 'grayscale(60%)',
        }}
      >
        {props.children}
      </div>
      <div
        style={{
          position: 'absolute',
          top: '40%',
          left: '50%',
          transform: 'translate(-50%, -50%) rotate(-8deg)',
          border: `4px solid ${SEAL_RED}`,
          color: SEAL_RED,
          padding: '8px 24px',
          fontSize: '32px',
          fontWeight: 'bold',
          letterSpacing: '6px',
          fontVariant: 'small-caps',
          background: 'rgba(244,231,198,0.85)',
          textAlign: 'center',
          pointerEvents: 'none',
          boxShadow: '0 0 0 2px rgba(139,32,32,0.3)',
        }}
      >
        Sequestered
        <div
          style={{
            fontSize: '11px',
            fontWeight: 'normal',
            letterSpacing: '1px',
            fontStyle: 'italic',
            marginTop: '2px',
            color: SEAL_RED,
          }}
        >
          {props.label} held by the Azurian Trading Company
        </div>
      </div>
    </div>
  );
};
