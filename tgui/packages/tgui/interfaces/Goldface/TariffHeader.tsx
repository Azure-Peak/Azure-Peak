import {
  bannerStyle,
  FONT_BODY,
  INK_FAINT,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  subtitleStyle,
  titleStyle,
} from '../common/parchment';
import type { BlockadeRow } from './types';
import { starsIfIlliterate } from './util';

type Props = {
  motto: string;
  canRead: boolean;
  tariffRatePct: number;
  tariffPaid: number;
  tariffEvaded: number;
  isProprietor: boolean;
  dodging: boolean;
  publicMarginPct?: number;
  publicMarginLabel?: string;
  blockades?: BlockadeRow[];
  gearPct?: number;
};

const blockadeRowText = (row: BlockadeRow) =>
  row.categories.length > 0
    ? `+${row.pct}% on ${row.categories.join(' / ')}`
    : `+${row.pct}% on all goods${row.reason ? ` ${row.reason}` : ''}`;

export const TariffHeader = (props: Props) => {
  const {
    motto,
    canRead,
    tariffRatePct,
    tariffPaid,
    tariffEvaded,
    isProprietor,
    dodging,
    publicMarginPct,
    publicMarginLabel,
    blockades,
    gearPct,
  } = props;
  const blockadeRows = blockades ?? [];
  const hasBlockades = blockadeRows.length > 0;
  const hasGearPct = !!gearPct && gearPct > 0;
  return (
    <>
      <div style={titleStyle}>{starsIfIlliterate(motto, canRead)}</div>
      <div style={subtitleStyle}>
        Crown Import Tariff: <b>{tariffRatePct}%</b>
        {isProprietor && dodging && (
          <span style={{ color: SEAL_RED, marginLeft: '8px' }}>
            <b>(TAX DODGING)</b>
          </span>
        )}
        {publicMarginPct !== undefined && (
          <span style={{ color: SEAL_AMBER, marginLeft: '8px' }}>
            · {publicMarginLabel || 'Public Margin'}: <b>+{publicMarginPct}%</b>
          </span>
        )}
      </div>
      {isProprietor && (
        <div
          style={{
            textAlign: 'center',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            marginBottom: '4px',
          }}
        >
          <span style={{ color: SEAL_GREEN }}>Paid: {tariffPaid}m</span>
          <span style={{ color: INK_FAINT, margin: '0 6px' }}>·</span>
          <span style={{ color: SEAL_RED }}>Evaded: {tariffEvaded}m</span>
        </div>
      )}
      {hasBlockades && (
        <div
          style={{
            ...bannerStyle(SEAL_RED, true),
            textAlign: 'left',
            fontWeight: 'normal',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
          }}
        >
          <b>ACTIVE BLOCKADES:</b>
          {blockadeRows.map((row) => (
            <div key={row.region}>
              <b>{row.region}:</b> {blockadeRowText(row)}
            </div>
          ))}
          {hasGearPct && (
            <div>
              <b>Gear demand:</b> +{gearPct}% on all arms and armor
            </div>
          )}
        </div>
      )}
      <div style={rulerStyle} />
    </>
  );
};
