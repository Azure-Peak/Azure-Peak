import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  subtitleStyle,
  titleStyle,
} from './common/parchment';
import { MarketView } from './Noticeboard/AvisaSections/MarketSection';
import { type MarketData } from './Noticeboard/types';

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
  const dutyRatePct = Math.round((data.duty_rate || 0) * 100);
  const isProprietor = !!data.is_proprietor;
  const isSmuggler = !!data.is_smuggler;

  return (
    <Window title="Navigator" width={720} height={760} theme="parchment">
      <Window.Content scrollable>
        <div style={{ ...pageStyle, position: 'relative' }}>
          <button
            type="button"
            title="Open the economy guidebook"
            style={{ ...inkButtonStyle({}), position: 'absolute', top: 8, right: 8 }}
            onClick={() => act('help')}
          >
            ?
          </button>
          <button
            type="button"
            title="Refresh market data (5s cooldown)"
            style={{ ...inkButtonStyle({}), position: 'absolute', top: 8, right: 40 }}
            onClick={() => act('refresh_market')}
          >
            ↻
          </button>
          <div style={titleStyle}>{motto}</div>
          <div style={subtitleStyle}>
            Next balloon in {formatCountdown(data.next_airlift_seconds)}
            {data.handler_fee_percent > 0 && (
              <>
                {' '}- handler&apos;s fee {data.handler_fee_percent}%
              </>
            )}
          </div>
          <hr style={rulerStyle} />

          {isSmuggler ? (
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
              <div style={fieldRowStyle}>
                <div style={fieldLabelStyle}>Crown duty</div>
                <div style={{ ...fieldValueStyle, color: INK_FAINT, fontStyle: 'italic' }}>
                  None - the balloon flies dark.
                </div>
              </div>
            </div>
          ) : (
            <div style={cardStyle}>
              <div style={fieldRowStyle}>
                <div style={fieldLabelStyle}>Crown export duty</div>
                <div style={fieldValueStyle}>
                  <span style={{ fontWeight: 'bold' }}>{dutyRatePct}%</span>
                  {isProprietor && (
                    <span
                      style={{
                        marginLeft: 10,
                        color: data.pay_taxes ? SEAL_GREEN : SEAL_RED,
                        fontWeight: 'bold',
                      }}
                    >
                      {data.pay_taxes ? '(PAYING)' : '(DODGING)'}
                    </span>
                  )}
                  {isProprietor && (
                    <button
                      type="button"
                      style={{ ...inkButtonStyle(), marginLeft: 12 }}
                      onClick={() => act('toggle_duty')}
                    >
                      {data.pay_taxes ? 'Stop paying' : 'Resume paying'}
                    </button>
                  )}
                </div>
              </div>
              <div style={fieldRowStyle}>
                <div style={fieldLabelStyle}>Merchant&apos;s levy</div>
                <div style={fieldValueStyle}>
                  <span style={{ fontWeight: 'bold' }}>{data.levy_rate}%</span>
                  {isProprietor && (
                    <span
                      style={{
                        marginLeft: 10,
                        color: data.pay_merchant_share ? SEAL_GREEN : SEAL_AMBER,
                        fontWeight: 'bold',
                      }}
                    >
                      {data.pay_merchant_share ? '(COLLECTING)' : '(WAIVED)'}
                    </span>
                  )}
                  {isProprietor && (
                    <button
                      type="button"
                      style={{ ...inkButtonStyle(), marginLeft: 12 }}
                      onClick={() => act('toggle_levy')}
                    >
                      {data.pay_merchant_share ? 'Waive levy' : 'Resume levy'}
                    </button>
                  )}
                </div>
              </div>
              {isProprietor && (
                <div style={fieldRowStyle}>
                  <div style={fieldLabelStyle}>Tally</div>
                  <div style={fieldValueStyle}>
                    <span style={{ color: SEAL_GREEN }}>
                      Crown paid: {data.duty_collected_here}m
                    </span>
                    <span style={{ color: INK_SOFT }}> &middot; </span>
                    <span style={{ color: SEAL_RED }}>
                      Crown evaded: {data.duty_evaded_here}m
                    </span>
                    <span style={{ color: INK_SOFT }}> &middot; </span>
                    <span style={{ color: INK }}>
                      Levy paid: {data.levy_collected_here}m
                    </span>
                  </div>
                </div>
              )}
            </div>
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
              <b style={{ color: SEAL_AMBER }}>Saturated valuables?</b> If the Valuables warehouse is choked and no ship hungers for them, consider the Stewardry&apos;s stockpile for minting, the bathhouse, or a shadier facilitator willing to take such things off your hands.
            </div>
          )}

          <MarketView
            market={data.market_data}
            headerLabel={
              isSmuggler ? 'State of the Shadow Market' : 'State of the Markets'
            }
            headerNote={
              isSmuggler ? 'Shadow pool - off the books' : undefined
            }
          />
        </div>
      </Window.Content>
    </Window>
  );
};
