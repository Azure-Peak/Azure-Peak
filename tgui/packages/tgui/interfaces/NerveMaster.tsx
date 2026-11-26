import { useBackend } from '../backend';
import { Window } from '../layouts';
import { formatMammon } from './common/format';
import {
  compactButtonStyle,
  pageStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
} from './common/parchment';
import { StewardHeader } from './common/StewardHeader';
import { DispatchesView } from './NerveMaster/DispatchesView';
import type { Data } from './NerveMaster/types';
import { ArrearsBanner } from './StewardTrade/ArrearsBanner';
import { SequestrationBanner } from './StewardTrade/SequestrationBanner';

export const NerveMaster = () => {
  const { act, data } = useBackend<Data>();

  const net = data.expected_rural_revenue - data.expected_wage_outlay;

  return (
    <Window title="Nerve Master" width={860} height={640} theme="parchment">
      <Window.Content scrollable>
        <div style={{ ...pageStyle, padding: '12px 20px 16px 20px' }}>
          <StewardHeader title="Nerve Master" current="front">
            <span>Day {data.day}</span>
            <span>
              Treasury:{' '}
              <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                {formatMammon(data.treasury)}m
              </span>
            </span>
            <span>
              At dawn:{' '}
              <span style={{ color: SEAL_AMBER }}>
                +{formatMammon(data.expected_rural_revenue)}m
              </span>{' '}
              <span
                style={{ cursor: 'help' }}
                title="A modest stipend from the countryside, sent while the city is devoid of people. Once there's enough, the selfless nobles contributing this funding will cease providing their precious savings."
              >
                rural subsidy
              </span>{' '}
              &middot;{' '}
              <span style={{ color: SEAL_AMBER }}>
                -{formatMammon(data.expected_wage_outlay)}m
              </span>{' '}
              wages &middot; Net{' '}
              <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
                {net >= 0 ? '+' : ''}
                {formatMammon(net)}m
              </span>
            </span>
          </StewardHeader>

          <SequestrationBanner sequestration={data.sequestration} />
          <ArrearsBanner sequestration={data.sequestration} />

          <DispatchesView data={data} />

          <div style={sectionHeaderStyle}>Letter of Citizenry</div>
          <div
            style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'baseline',
              gap: '12px',
            }}
          >
            <span>
              Print a Letter of Citizenry, giving someone Resident status.
              Useful as a reward.
            </span>
            <button
              type="button"
              style={compactButtonStyle()}
              onClick={() => act('print_residency')}
            >
              Print
            </button>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
