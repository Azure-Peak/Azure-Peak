import type { CSSProperties } from 'react';

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
  gearBasePct?: number;
  blockadeMultPct?: number;
  blockadePopHalf?: number;
  blockadePopFull?: number;
};

const blockadeRowText = (row: BlockadeRow, pct: number) =>
  row.categories.length > 0
    ? `+${pct}% on ${row.categories.join(' / ')}`
    : `+${pct}% on all goods${row.reason ? ` ${row.reason}` : ''}`;

const demandNote = (multPct: number, popHalf: number, popFull: number) => {
  if (multPct <= 0) {
    return {
      label: 'Demands too low - price unaffected',
      tooltip: `OOC: Fewer than ${popHalf} active players - blockade surcharges do not apply.`,
    };
  }
  if (multPct < 100) {
    return {
      label: 'Demands low - price effects halved',
      tooltip: `OOC: ${popHalf}-${popFull - 1} active players - blockade surcharges are halved. Full effect at ${popFull}+.`,
    };
  }
  return null;
};

const waivedStyle: CSSProperties = {
  textDecoration: 'line-through',
  opacity: 0.6,
};

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
    gearBasePct,
    blockadeMultPct,
    blockadePopHalf,
    blockadePopFull,
  } = props;
  const blockadeRows = blockades ?? [];
  const hasBlockades = blockadeRows.length > 0;
  const multPct = blockadeMultPct ?? 100;
  const waived = multPct <= 0;
  const note = demandNote(multPct, blockadePopHalf ?? 0, blockadePopFull ?? 0);
  const shownGearPct = waived ? gearBasePct : gearPct;
  const hasGearPct = !!shownGearPct && shownGearPct > 0;
  const rowStyle = waived ? waivedStyle : undefined;
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
          {note && (
            <div
              title={note.tooltip}
              style={{ fontStyle: 'italic', cursor: 'help' }}
            >
              {note.label}
            </div>
          )}
          {blockadeRows.map((row) => (
            <div key={row.region} style={rowStyle}>
              <b>{row.region}:</b>{' '}
              {blockadeRowText(row, waived ? row.base_pct : row.pct)}
            </div>
          ))}
          {hasGearPct && (
            <div style={rowStyle}>
              <b>Gear demand:</b> +{shownGearPct}% on all arms and armor
            </div>
          )}
        </div>
      )}
      <div style={rulerStyle} />
    </>
  );
};
