import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK_SOFT,
  inkButtonStyle,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';
import type { MercContractEntry, TabProps } from './types';

const ContractCard = ({
  contract,
  act,
}: {
  contract: MercContractEntry;
  act: TabProps['act'];
}) => {
  const waiting = !!contract.end_wait;
  const pending = !!contract.agreed_end_pending;
  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>{contract.title}</div>
      {contract.lines.map((line) => (
        <div key={line} style={{ marginBottom: 6 }}>
          {line}
        </div>
      ))}
      <div style={{ marginTop: 10, textAlign: 'right' }}>
        <div style={{ color: INK_SOFT, marginBottom: 6 }}>
          {waiting ? contract.end_wait : contract.end_note}
        </div>
        <button
          type="button"
          style={inkButtonStyle({ color: SEAL_RED, disabled: waiting })}
          disabled={waiting}
          onClick={() => act('merc_end_contract', { ref: contract.ref })}
        >
          End contract early
        </button>
        <div style={{ color: INK_SOFT, marginTop: 10, marginBottom: 6 }}>
          {pending ? 'Waiting for an answer.' : contract.agreed_end_terms}
        </div>
        <button
          type="button"
          style={inkButtonStyle({ disabled: pending })}
          disabled={pending}
          onClick={() => act('merc_propose_end', { ref: contract.ref })}
        >
          Ask to end by agreement
        </button>
      </div>
    </div>
  );
};

export const MercenaryTab = ({ data, act }: TabProps) => {
  const merc = data.merc;
  if (!merc) {
    return null;
  }
  const hired = !!merc.hired;
  const contracts = merc.contracts || [];

  return (
    <>
      {contracts.map((contract) => (
        <ContractCard key={contract.ref} contract={contract} act={act} />
      ))}
      {!!merc.is_merc && (
        <div style={cardStyle}>
          <div style={sectionHeaderStyle}>Mercenary Contracts</div>
          <div style={fieldRowStyle}>
            <div style={fieldLabelStyle}>Status</div>
            <div style={fieldValueStyle}>
              {hired ? 'Under contract' : 'Not under contract'}
            </div>
          </div>
          {!!merc.cooldown_text && (
            <div style={fieldRowStyle}>
              <div style={fieldLabelStyle}>Cooldown</div>
              <div style={fieldValueStyle}>{merc.cooldown_text}</div>
            </div>
          )}
          <div style={{ marginTop: 6, color: INK_SOFT }}>
            Print a new contract here once your last one has ended. Printing
            one voids any unsigned contract you still have, wherever it is.
          </div>
          <div style={{ marginTop: 6, textAlign: 'right' }}>
            <button
              type="button"
              style={inkButtonStyle({ disabled: hired })}
              disabled={hired}
              title={hired ? 'You are under contract.' : undefined}
              onClick={() => act('request_merc_contract')}
            >
              Print a contract
            </button>
          </div>
        </div>
      )}
    </>
  );
};
