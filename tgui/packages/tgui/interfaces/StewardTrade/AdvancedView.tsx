import { useBackend } from '../../backend';
import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  sectionHeaderStyle,
} from '../common/parchment';
import type { Data } from './types';

export const AdvancedView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const { data } = props;
  const aldermanActing = !!data.is_alderman_acting;
  const blockTitle =
    "Reserved to the Steward's office.";
  const barred = data.autoexport_barred;
  const shortageOpen = data.shortage_goods_open;
  return (
    <div
      style={{
        ...cardStyle,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
        color: INK,
      }}
    >
      <div style={sectionHeaderStyle}>Autoexport</div>
      <div style={{ color: INK_SOFT, marginBottom: '8px' }}>
        Every dae, goods above the export threshold is shipped away daily. If you bar them, they will be hoarded. And deposit into a full stock while auto-export is disabled will hoard the good. This can be useful to save the arbitrage profit for the Crown and prevent overbuying. Exporting a good under
        shortage counts toward ending that shortage early.
      </div>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '6px',
          flexWrap: 'wrap',
          marginBottom: '8px',
        }}
      >
        <button
          type="button"
          style={inkButtonStyle({
            color: SEAL_RED,
            disabled: aldermanActing || shortageOpen <= 0,
          })}
          disabled={aldermanActing || shortageOpen <= 0}
          onClick={() => act('bar_autoexport_shortages')}
          title={
            aldermanActing
              ? blockTitle
              : 'Bar autoexport on every good currently under a shortage, so the sweep cannot sell off the scarcity or shorten the shortage.'
          }
        >
          Bar Autoexport On Shortages ({shortageOpen})
        </button>
        <button
          type="button"
          style={inkButtonStyle({
            color: SEAL_GREEN,
            disabled: aldermanActing || barred <= 0,
          })}
          disabled={aldermanActing || barred <= 0}
          onClick={() => act('allow_autoexport_all')}
          title={
            aldermanActing
              ? blockTitle
              : 'Clear every autoexport bar across the whole warehouse.'
          }
        >
          Allow Autoexport On All
        </button>
        <span style={{ color: barred > 0 ? SEAL_AMBER : INK_SOFT }}>
          {barred} barred
        </span>
      </div>
    </div>
  );
};
