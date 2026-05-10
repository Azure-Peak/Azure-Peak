import {
  INK_FAINT,
  rulerStyle,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  subtitleStyle,
  titleStyle,
} from '../common/parchment';
import { starsIfIlliterate } from './util';

type Props = {
  motto: string;
  canRead: boolean;
  tariffRatePct: number;
  tariffPaid: number;
  tariffEvaded: number;
  profitable: boolean;
  dodging: boolean;
};

export const TariffHeader = (props: Props) => {
  const {
    motto,
    canRead,
    tariffRatePct,
    tariffPaid,
    tariffEvaded,
    profitable,
    dodging,
  } = props;
  return (
    <>
      <div style={titleStyle}>{starsIfIlliterate(motto, canRead)}</div>
      <div style={subtitleStyle}>
        Crown Import Tariff: <b>{tariffRatePct}%</b>
        {profitable && dodging && (
          <span style={{ color: SEAL_RED, marginLeft: '8px' }}>
            <b>(TAX DODGING)</b>
          </span>
        )}
      </div>
      {profitable && (
        <div
          style={{
            textAlign: 'center',
            fontFamily: SERIF,
            fontSize: '11px',
            marginBottom: '4px',
          }}
        >
          <span style={{ color: SEAL_GREEN }}>Paid: {tariffPaid}m</span>
          <span style={{ color: INK_FAINT, margin: '0 6px' }}>·</span>
          <span style={{ color: SEAL_RED }}>Evaded: {tariffEvaded}m</span>
        </div>
      )}
      <div style={rulerStyle} />
    </>
  );
};
