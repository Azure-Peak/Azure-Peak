import type { CSSProperties } from 'react';
import { DmIcon } from 'tgui-core/components';

import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  FONT_BODY,
  FONT_SMALL,
  INK,
  INK_FAINT,
  INK_SOFT,
  sectionHeaderStyle,
  SERIF,
  titleStyle,
} from './parchment';

export type StatRow = {
  label: string;
  value?: string;
  tier?: number;
  max_tier?: number;
};

export type StatIntent = {
  name: string;
  desc: string;
  rows: StatRow[];
  pattern?: string | null;
};

export type StatGroup = {
  title: string;
  note: string;
  changes: string[];
  intents: StatIntent[];
};

export type ItemStatCardData = {
  name: string;
  desc: string;
  icon: string;
  icon_state: string;
  stats: StatRow[];
  skills: string[];
  armor: StatRow[];
  coverage: string[];
  groups: StatGroup[];
  special?: { name: string; desc: string; lines?: string[] } | null;
};

const Html = (props: { text: string }) => (
  <span
    style={{ whiteSpace: 'pre-line' }}
    dangerouslySetInnerHTML={{ __html: props.text }}
  />
);

const TierDots =(props: { tier: number; max: number }) => {
  const dots: React.ReactNode[] = [];
  for (let i = 1; i <= props.max; i++) {
    dots.push(
      <span
        key={i}
        style={{ color: i <= props.tier ? INK : INK_FAINT, marginRight: '1px' }}
      >
        {i <= props.tier ? '●' : '○'}
      </span>,
    );
  }
  return (
    <span title={`Tier ${props.tier} of ${props.max}`}>{dots}</span>
  );
};

const narrowLabelStyle: CSSProperties = {
  ...fieldLabelStyle,
  flex: '0 0 190px',
};

const wideLabelStyle: CSSProperties = {
  ...fieldLabelStyle,
  flex: 1,
};

const Rows = (props: { rows: StatRow[] }) => (
  <>
    {props.rows.map((row, i) => {
      const labelOnly = row.value === undefined && row.tier === undefined;
      return (
        <div key={`${row.label}-${i}`} style={fieldRowStyle}>
          <div style={labelOnly ? wideLabelStyle : narrowLabelStyle}>
            {row.label}
          </div>
          {!labelOnly && (
            <div style={fieldValueStyle}>
              {row.value}
              {row.tier !== undefined && (
                <span style={{ marginLeft: row.value ? '8px' : 0 }}>
                  <TierDots tier={row.tier} max={row.max_tier || 4} />
                </span>
              )}
            </div>
          )}
        </div>
      );
    })}
  </>
);

const intentNameStyle: CSSProperties = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  fontWeight: 'bold',
  color: INK,
};

export const ItemStatCard = (props: {
  card: ItemStatCardData;
  hideHeader?: boolean;
}) => {
  const { card, hideHeader } = props;
  const stats = card.stats || [];
  const skills = card.skills || [];
  const armor = card.armor || [];
  const coverage = card.coverage || [];
  const groups = card.groups || [];
  const hasAnything =
    stats.length > 0 || armor.length > 0 || groups.length > 0;
  return (
    <div style={{ fontFamily: SERIF, color: INK, fontSize: FONT_BODY }}>
      {!hideHeader && (
        <div
          style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '8px',
          }}
        >
          {!!card.icon && !!card.icon_state && (
            <span
              style={{ display: 'inline-block', width: '32px', height: '32px' }}
            >
              <DmIcon
                icon={card.icon}
                icon_state={card.icon_state}
                width={2}
                height={2}
              />
            </span>
          )}
          <div style={{ ...titleStyle, margin: 0 }}>{card.name}</div>
        </div>
      )}
      {!hideHeader && !!card.desc && (
        <div
          style={{
            color: INK_SOFT,
            fontStyle: 'italic',
            textAlign: 'center',
            margin: '4px 0 8px 0',
          }}
        >
          <Html text={card.desc} />
        </div>
      )}
      {!hasAnything && (
        <div style={{ ...cardStyle, textAlign: 'center', color: INK_SOFT }}>
          This item has no combat properties.
        </div>
      )}

      {armor.length > 0 && (
        <>
          <div style={sectionHeaderStyle}>Protection</div>
          <Rows rows={armor} />
        </>
      )}

      {coverage.length > 0 && (
        <div style={fieldRowStyle}>
          <div style={narrowLabelStyle}>COVERAGE</div>
          <div style={fieldValueStyle}>{coverage.join(' | ')}</div>
        </div>
      )}

      {stats.length > 0 && (
        <>
          <div style={sectionHeaderStyle}>Properties</div>
          <Rows rows={stats} />
        </>
      )}

      {skills.length > 0 && (
        <div style={fieldRowStyle}>
          <div style={narrowLabelStyle}>ASSOCIATED SKILLS</div>
          <div style={fieldValueStyle}>{skills.join(', ')}</div>
        </div>
      )}

      {!!card.special && (
        <>
          <div style={sectionHeaderStyle}>SPECIAL: {card.special.name}</div>
          <div style={{ color: INK_SOFT, fontStyle: 'italic' }}>
            <Html text={card.special.desc || ''} />
            {(card.special.lines || []).map((line) => (
              <div key={line}>{line}</div>
            ))}
          </div>
        </>
      )}

      {groups.map((group, gi) => (
        <div key={`${group.title}-${gi}`}>
          <div style={sectionHeaderStyle}>
            {group.title}
            {!!group.note && (
              <span
                style={{
                  color: INK_SOFT,
                  fontWeight: 'normal',
                  fontSize: FONT_SMALL,
                  marginLeft: '8px',
                }}
              >
                {group.note}
              </span>
            )}
          </div>
          {(group.changes || []).length > 0 && (
            <div style={{ fontWeight: 'bold' }}>Weapon Stat Changes:</div>
          )}
          {(group.changes || []).map((change) => (
            <div key={change} style={{ color: INK_SOFT }}>
              {change}
            </div>
          ))}
          {(group.intents || []).length === 0 && (
            <div style={{ color: INK_SOFT }}>
              Uses the weapon&apos;s normal intents.
            </div>
          )}
          {(group.intents || []).map((intent, ii) => (
            <div key={`${intent.name}-${ii}`} style={cardStyle}>
              <div style={intentNameStyle}>{intent.name}</div>
              {!!intent.desc && (
                <div
                  style={{
                    color: INK_SOFT,
                    fontStyle: 'italic',
                    marginBottom: '2px',
                  }}
                >
                  <Html text={intent.desc} />
                </div>
              )}
              <Rows rows={intent.rows || []} />
              {!!intent.pattern && (
                <pre
                  style={{ margin: '4px 0 0 0', lineHeight: 1.1 }}
                  dangerouslySetInnerHTML={{ __html: intent.pattern }}
                />
              )}
            </div>
          ))}
        </div>
      ))}
    </div>
  );
};
