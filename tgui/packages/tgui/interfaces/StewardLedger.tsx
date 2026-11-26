import { useBackend } from '../backend';
import { Window } from '../layouts';
import { formatMammon } from './common/format';
import { pageStyle, SEAL_AMBER } from './common/parchment';
import { StewardHeader } from './common/StewardHeader';
import { LedgerView } from './StewardLedger/LedgerView';
import type { Data } from './StewardLedger/types';

export const StewardLedger = () => {
  const { data } = useBackend<Data>();

  return (
    <Window title="Ledger" width={860} height={820} theme="parchment">
      <Window.Content scrollable>
        <div style={{ ...pageStyle, padding: '12px 20px 16px 20px' }}>
          <StewardHeader title="Ledger" current="ledger">
            <span>
              Treasury:{' '}
              <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                {formatMammon(data.treasury)}m
              </span>
            </span>
          </StewardHeader>
          <LedgerView data={data} />
        </div>
      </Window.Content>
    </Window>
  );
};
