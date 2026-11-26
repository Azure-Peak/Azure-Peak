import { useBackend } from '../backend';
import { Window } from '../layouts';
import { formatRatioPct } from './common/format';
import {
  cardStyle,
  FONT_BODY,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  INK,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  RateSeals,
  rulerStyle,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { MarketView } from './Noticeboard/AvisaSections/MarketSection';
import type { MarketData } from './Noticeboard/types';

type NavigatorData = {
  motto: string;
  next_airlift_seconds: number;
  handler_fee_percent: number;
  duty_rate: number;
  pay_taxes: boolean;
  levy_rate: number;
  pay_merchant_share: boolean;
  duty_collected_here: number;
  duty_evaded_here: number;
  levy_collected_here: number;
  is_proprietor: boolean;
  is_smuggler: boolean;
  is_readable: boolean;
  facilitator_present: boolean;
  market_data: MarketData;
};

const formatCountdown = (totalSeconds: number): string => {
  if (totalSeconds <= 0) return '00:00';
  const m = Math.floor(totalSeconds / 60);
  const s = totalSeconds % 60;
  return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
};

const obscure = (s: string): string => s.replace(/[^\s]/g, '?');

export const Navigator = () => {
  const { data, act } = useBackend<NavigatorData>();
  const readable = !!data.is_readable;
  const motto = readable ? data.motto : obscure(data.motto);
  const dutyRatePct = formatRatioPct(data.duty_rate || 0);
  const isProprietor = !!data.is_proprietor;
  const isSmuggler = !!data.is_smuggler;
  const levyWaived = !data.pay_merchant_share;
  const dodging = isProprietor && !data.pay_taxes;
  const keepPercent = Math.max(
    0,
    Math.round(
      100 -
        (levyWaived ? 0 : data.levy_rate) -
        (dodging ? 0 : (data.duty_rate || 0) * 100),
    ),
  );

  return (
    <Window title="Navigator" width={720} height={760} theme="parchment">
      <Window.Content scrollable>
        <div style={{ ...pageStyle, position: 'relative' }}>
          <button
            type="button"
            title="Open the economy guidebook"
            style={{
              ...inkButtonStyle({}),
              position: 'absolute',
              top: 8,
              right: 8,
            }}
            onClick={() => act('help')}
          >
            ?
          </button>
          <button
            type="button"
            title="Refresh market data (5s cooldown)"
            style={{
              ...inkButtonStyle({}),
              position: 'absolute',
              top: 8,
              right: 40,
            }}
            onClick={() => act('refresh_market')}
          >
            ↻
          </button>
          <div style={titleStyle}>{motto}</div>
          <div style={subtitleStyle}>
            Next balloon in {formatCountdown(data.next_airlift_seconds)}
            {data.handler_fee_percent > 0 && (
              <> - handler&apos;s fee {data.handler_fee_percent}%</>
            )}
          </div>
          <hr style={rulerStyle} />

          {isSmuggler ? (
            <>
              <RateSeals
                seals={[
                  {
                    label: "Handler's fee",
                    value: `${data.handler_fee_percent}%`,
                    color: SEAL_RED,
                  },
                  {
                    label: 'Crown export duty',
                    value: 'None',
                    color: SEAL_BLUE,
                  },
                  {
                    label: 'You keep',
                    value: `${Math.max(0, 100 - data.handler_fee_percent)}%`,
                    color: SEAL_GREEN,
                  },
                ]}
              />
              <div style={cardStyle}>
                <div style={fieldRowStyle}>
                  <div style={fieldLabelStyle}>Facilitator</div>
                  <div
                    style={{
                      ...fieldValueStyle,
                      color: data.facilitator_present ? SEAL_GREEN : SEAL_RED,
                      fontWeight: 'bold',
                    }}
                  >
                    {data.facilitator_present
                      ? 'Present - handler waiving fee'
                      : 'Absent - handler skimming 50%'}
                  </div>
                </div>
              </div>
            </>
          ) : (
            <>
              <RateSeals
                seals={[
                  {
                    label: "Merchant's levy",
                    value: `${data.levy_rate}%`,
                    color: SEAL_AMBER,
                    struck: levyWaived,
                    note: levyWaived ? 'WAIVED' : undefined,
                  },
                  {
                    label: 'Crown export duty',
                    value: dutyRatePct,
                    color: SEAL_BLUE,
                    struck: dodging,
                    note: dodging ? 'DODGING' : undefined,
                    noteColor: SEAL_RED,
                  },
                  {
                    label: 'You keep',
                    value: `${keepPercent}%`,
                    color: SEAL_GREEN,
                  },
                ]}
              />
              {isProprietor && (
                <div style={cardStyle}>
                  <div style={fieldRowStyle}>
                    <div style={fieldLabelStyle}>Crown export duty</div>
                    <div style={fieldValueStyle}>
                      <span
                        style={{
                          color: data.pay_taxes ? SEAL_GREEN : SEAL_RED,
                          fontWeight: 'bold',
                        }}
                      >
                        {data.pay_taxes ? '(PAYING)' : '(DODGING)'}
                      </span>
                      <button
                        type="button"
                        style={{ ...inkButtonStyle(), marginLeft: 12 }}
                        onClick={() => act('toggle_duty')}
                      >
                        {data.pay_taxes ? 'Stop paying' : 'Resume paying'}
                      </button>
                    </div>
                  </div>
                  <div style={fieldRowStyle}>
                    <div style={fieldLabelStyle}>Merchant&apos;s levy</div>
                    <div style={fieldValueStyle}>
                      <span
                        style={{
                          color: data.pay_merchant_share
                            ? SEAL_GREEN
                            : SEAL_AMBER,
                          fontWeight: 'bold',
                        }}
                      >
                        {data.pay_merchant_share ? '(COLLECTING)' : '(WAIVED)'}
                      </span>
                      <button
                        type="button"
                        style={{ ...inkButtonStyle(), marginLeft: 12 }}
                        onClick={() => act('toggle_levy')}
                      >
                        {data.pay_merchant_share ? 'Waive levy' : 'Resume levy'}
                      </button>
                    </div>
                  </div>
                  <div style={fieldRowStyle}>
                    <div style={fieldLabelStyle}>Tally</div>
                    <div style={fieldValueStyle}>
                      <span style={{ color: SEAL_GREEN }}>
                        Export duty paid: {data.duty_collected_here}m
                      </span>
                      <span style={{ color: INK_SOFT }}> &middot; </span>
                      <span style={{ color: SEAL_RED }}>
                        Export duty evaded: {data.duty_evaded_here}m
                      </span>
                      <span style={{ color: INK_SOFT }}> &middot; </span>
                      <span style={{ color: INK }}>
                        Levy paid: {data.levy_collected_here}m
                      </span>
                    </div>
                  </div>
                </div>
              )}
            </>
          )}

          {!isSmuggler && (
            <div
              style={{
                marginTop: 10,
                marginBottom: 10,
                padding: '8px 12px',
                border: `1px dashed ${SEAL_AMBER}`,
                color: INK_SOFT,
                fontSize: FONT_BODY,
                fontStyle: 'italic',
                lineHeight: 1.4,
              }}
            >
              <b style={{ color: SEAL_AMBER }}>Saturated valuables?</b> If the
              Valuables warehouse is choked and no ship hungers for them,
              consider the Stewardry&apos;s stockpile for minting, the
              bathhouse, or a shadier facilitator willing to take such things
              off your hands.
            </div>
          )}

          <MarketView
            market={data.market_data}
            headerLabel={
              isSmuggler ? 'State of the Shadow Market' : 'State of the Markets'
            }
            headerNote={isSmuggler ? 'Shadow pool - off the books' : undefined}
          />
        </div>
      </Window.Content>
    </Window>
  );
};
