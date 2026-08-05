import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  FONT_BODY,
  rulerStyle,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { BucketsSection } from './EconomicChronicle/BucketsSection';
import { ContractsSection } from './EconomicChronicle/ContractsSection';
import { EconomySection } from './EconomicChronicle/EconomySection';
import { ShipsSection } from './EconomicChronicle/ShipsSection';
import { compactPageStyle } from './EconomicChronicle/styles';
import { TreasurySection } from './EconomicChronicle/TreasurySection';
import type { EconomicChronicleData } from './EconomicChronicle/types';

export const EconomicChronicle = () => {
  const { data } = useBackend<EconomicChronicleData>();
  return (
    <Window title="Realm Economics" width={920} height={660} theme="parchment">
      <Window.Content scrollable>
        <div style={{ zoom: 1.15 }}>
          <div style={compactPageStyle}>
            <div
              style={{ ...titleStyle, fontSize: '18px', margin: '0 0 2px 0' }}
            >
              Realm Economics
            </div>
            <div
              style={{
                ...subtitleStyle,
                fontSize: FONT_BODY,
                marginBottom: '6px',
              }}
            >
              A chronicle of mammons, ships, and crowns.
            </div>
            <hr style={{ ...rulerStyle, margin: '4px 0 8px 0' }} />
            <TreasurySection
              t={data.treasury}
              balance={data.treasury_balance}
            />
            <EconomySection e={data.economy} />
            <ShipsSection s={data.ships} />
            <BucketsSection b={data.buckets} />
            <ContractsSection c={data.contracts} rf={data.royal_favors} />
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
