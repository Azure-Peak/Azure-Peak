import { Component, type ReactNode } from 'react';

import { INK_SOFT, SEAL_RED } from '../common/parchment';

type Props = { children: ReactNode; resetKey?: string };
type State = { error: Error | null };

/**
 * Keeps a rendering error in one ledger view from taking the whole Steward
 * window down. Shows the message and stack instead, so it can be reported.
 */
export class LedgerBoundary extends Component<Props, State> {
  state: State = { error: null };

  static getDerivedStateFromError(error: Error): State {
    return { error };
  }

  componentDidUpdate(prev: Props) {
    if (prev.resetKey !== this.props.resetKey && this.state.error) {
      this.setState({ error: null });
    }
  }

  render() {
    const { error } = this.state;
    if (!error) return this.props.children;
    return (
      <div style={{ padding: '8px 0' }}>
        <div style={{ color: SEAL_RED, fontWeight: 'bold' }}>
          This ledger view failed to draw: {String(error.message)}
        </div>
        <pre
          style={{
            color: INK_SOFT,
            whiteSpace: 'pre-wrap',
            fontSize: '11px',
            maxHeight: '260px',
            overflowY: 'auto',
          }}
        >
          {String(error.stack || '')}
        </pre>
      </div>
    );
  }
}
