import { useState } from 'react';

import {
  badgeStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_RED,
  SERIF,
} from '../../common/parchment';
import { type NoticeboardData, type ScoutRegion } from '../types';

const tableStyle: React.CSSProperties = {
  width: '100%',
  borderCollapse: 'collapse',
  fontFamily: SERIF,
  fontSize: FONT_BODY,
};

const headerCellStyle: React.CSSProperties = {
  textAlign: 'left',
  padding: '4px 8px 6px 8px',
  color: SEAL_AMBER,
  borderBottom: `1px solid ${INK_FAINT}`,
};

const headerCellWithDivider: React.CSSProperties = {
  ...headerCellStyle,
  borderLeft: `1px dashed ${PARCHMENT_SHADOW}`,
};

const cellStyle: React.CSSProperties = {
  padding: '6px 8px',
  borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
  verticalAlign: 'top',
  color: INK,
};

const cellWithDivider: React.CSSProperties = {
  ...cellStyle,
  borderLeft: `1px dashed ${PARCHMENT_SHADOW}`,
};

export const ScoutsSection = ({ data }: { data: NoticeboardData }) => {
  const regions = data.scout_regions ?? [];
  const [helpOpen, setHelpOpen] = useState(false);

  return (
    <>
      <div style={{ marginBottom: 10 }}>
        <button
          type="button"
          style={{
            ...inkButtonStyle({}),
            fontSize: FONT_BODY,
            padding: '2px 6px',
          }}
          onClick={() => setHelpOpen((v) => !v)}
        >
          {helpOpen ? 'Hide About Scout Reports' : 'About Scout Reports'}
        </button>
        {helpOpen && <HelpPanel />}
      </div>

      {regions.length === 0 ? (
        <EmptyMessage text="The wardens have sent no word from the wilds." />
      ) : (
        <table style={tableStyle}>
          <thead>
            <tr>
              <th style={headerCellStyle}>Region</th>
              <th style={headerCellWithDivider}>Danger</th>
              <th style={headerCellWithDivider}>Blockade</th>
              <th style={headerCellWithDivider}>Wardens' Word</th>
            </tr>
          </thead>
          <tbody>
            {regions.map((r) => (
              <RegionRow key={r.region_name} region={r} />
            ))}
          </tbody>
        </table>
      )}
    </>
  );
};

const RegionRow = ({ region }: { region: ScoutRegion }) => {
  return (
    <tr>
      <td style={cellStyle}>
        <div style={{ fontWeight: 'bold' }}>{region.region_name}</div>
      </td>
      <td style={cellWithDivider}>
        <span
          style={{
            color: region.danger_color,
            fontWeight: 'bold',
          }}
        >
          {region.danger_level}
        </span>
      </td>
      <td style={cellWithDivider}>
        {!!region.blockaded ? (
          <>
            <div
              style={{
                fontSize: FONT_BODY,
                color: SEAL_RED,
                fontWeight: 'bold',
              }}
            >
              {region.blockade_faction_label || 'unknown raiders'}
              <span
                style={{
                  marginLeft: 6,
                  color: INK_SOFT,
                  fontSize: FONT_BODY,
                  fontWeight: 'normal',
                }}
              >
                {region.blockade_days_active}d
              </span>
            </div>
            {!!region.blockade_region_label && (
              <div
                style={{
                  color: INK_SOFT,
                  fontSize: FONT_BODY,
                  marginTop: 1,
                }}
              >
                blocking {region.blockade_region_label}
              </div>
            )}
            {!!region.blockade_writ_out ? (
              <div style={{ marginTop: 3 }}>
                <span style={badgeStyle(SEAL_AMBER)}>WRIT OUT</span>
              </div>
            ) : (
              <div
                style={{
                  marginTop: 3,
                  color: SEAL_AMBER,
                  fontSize: FONT_BODY,
                }}
              >
                Awaiting writ
              </div>
            )}
          </>
        ) : (
          <span style={{ color: INK_FAINT }}>-</span>
        )}
      </td>
      <td
        style={{ ...cellWithDivider, fontStyle: 'italic', color: INK_SOFT }}
      >
        {region.ic_descriptions.length > 0
          ? region.ic_descriptions.join('; ')
          : '- the wardens have nothing to add -'}
      </td>
    </tr>
  );
};

const EmptyMessage = ({ text }: { text: string }) => (
  <div
    style={{
      color: INK_FAINT,
      textAlign: 'center',
      padding: '24px 0',
    }}
  >
    {text}
  </div>
);

const HelpPanel = () => (
  <div
    style={{
      marginTop: 8,
      padding: '8px 12px',
      background: 'var(--p-card-bg)',
      border: `1px solid ${INK_FAINT}`,
      color: INK_SOFT,
      fontSize: FONT_BODY,
      lineHeight: 1.5,
    }}
  >
    <p style={{ margin: '0 0 6px 0' }}>
      Scouts rate how dangerous a region is from <b>Safe</b> to <b>Low</b> to{' '}
      <b>Moderate</b> to <b>Dangerous</b> to <b>Bleak</b>.
    </p>
    <p style={{ margin: '0 0 6px 0' }}>
      A safe region is unlikely to spawn ambushes from common creechurs and
      brigands. A low-threat region may yield lone foes. Only Azure Basin,
      Azure Grove, and the Terrorbog can be rendered fully safe; regions not
      listed are beyond the wardens' charge and remain dangerous.
    </p>
    <p style={{ margin: '0 0 6px 0' }}>
      Danger is reduced by luring villains and creechurs and killing them when
      they ambush. Traveling in groups draws larger ambushes; each additional
      companion contributes less per head than a lone traveler would.
    </p>
    <p style={{ margin: 0 }}>
      A warden's signal horn provokes a sizeable fight matched to the region's
      danger - the surest way to tame it. Bandits and creechurs trickle back in
      over time, generally overnight. Take care with the horn, and bring
      friends.
    </p>
  </div>
);
