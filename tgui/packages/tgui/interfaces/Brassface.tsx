import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Header } from './Brassface/Header';
import { MammonRow } from './Brassface/MammonRow';
import { PacksGrid } from './Brassface/PacksGrid';
import { SearchBar } from './Brassface/SearchBar';
import { SecretsPanel } from './Brassface/SecretsPanel';
import type { BrassfaceData, HoardEntry } from './Brassface/types';
import { starsIfIlliterate } from './Brassface/util';
import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  pageStyle,
  PARCHMENT_SHADOW,
  rulerStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  sectionHeaderStyle,
  SERIF,
  subTabBarStyle,
  subTabStyle,
  tabBarStyle,
  tabStyle,
  titleStyle,
} from './common/parchment';

const HoardRow = (props: { entry: HoardEntry }) => {
  const { entry } = props;
  const isPayout = entry.kind === 'payout';
  const isPolicy = entry.kind === 'policy';
  const color = isPolicy ? INK_FAINT : isPayout ? SEAL_GREEN : SEAL_AMBER;
  const whoLabel = isPolicy
    ? 'by'
    : isPayout
      ? 'by'
      : 'by';

  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: '52px minmax(0, 1fr) 72px',
        columnGap: '8px',
        padding: '3px 4px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        fontSize: FONT_BODY,
        color: INK,
      }}
    >
      <span style={{ color: INK_FAINT }}>{entry.time}</span>
      <span
        style={{
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          whiteSpace: 'nowrap',
        }}
      >
        {`${entry.text}${entry.who ? ` - ${whoLabel} ${entry.who}` : ''}`}
      </span>
      <span style={{ textAlign: 'right', color, fontWeight: 'bold' }}>
        {!isPolicy && (isPayout ? `+${entry.amount}m` : `${entry.amount}m`)}
      </span>
    </div>
  );
};

const HoardTab = (props: { entries: HoardEntry[]; canRead: boolean }) => {
  const { entries, canRead } = props;

  return (
    <div style={{ marginTop: '8px' }}>
      <div style={{ ...sectionHeaderStyle, marginTop: '4px' }}>
        {starsIfIlliterate(`Hoard Ledger (${entries.length})`, canRead)}
      </div>
      {entries.length === 0 ? (
        <div style={{ ...cardStyle, textAlign: 'center', color: INK_SOFT }}>
          {starsIfIlliterate('The hoard keeps no records yet.', canRead)}
        </div>
      ) : (
        entries.map((entry, i) => <HoardRow key={i} entry={entry} />)
      )}
    </div>
  );
};

const LockedView = (props: { motto: string; canRead: boolean }) => (
  <div style={pageStyle}>
    <div style={titleStyle}>
      {starsIfIlliterate(props.motto, props.canRead)}
    </div>
    <div style={rulerStyle} />
    <div
      style={{
        ...cardStyle,
        textAlign: 'center',
        fontStyle: 'italic',
        color: INK_SOFT,
      }}
    >
      It is locked. Of course.
    </div>
  </div>
);

export const Brassface = () => {
  const { act, data } = useBackend<BrassfaceData>();
  const [tab, setTab] = useState<'shop' | 'hoard'>('shop');
  const canRead = !!data.can_read;
  const isPublic = !!data.is_public;
  const locked = !!data.locked;
  const isProprietor = !!data.is_proprietor;
  const canAccessSecrets = isProprietor && !isPublic;
  const inSearchMode = !!data.search_mode;

  if (locked && !isPublic) {
    return (
      <Window width={720} height={760} theme="parchment">
        <Window.Content scrollable>
          <LockedView motto={data.motto} canRead={canRead} />
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window width={720} height={760} theme="parchment">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <Header
            motto={data.motto}
            canRead={canRead}
            ordinanceActive={!!data.ordinance_active}
            titheRatePct={data.tithe_rate_pct}
            tariffRatePct={data.tariff_rate_pct}
            churchTithePaid={data.church_tithe_paid}
            tariffPaid={data.tariff_paid}
            tariffEvaded={data.tariff_evaded}
            isProprietor={isProprietor}
            dodging={!!data.dodging}
          />
          <div style={tabBarStyle}>
            <button
              type="button"
              style={tabStyle(tab === 'shop')}
              onClick={() => setTab('shop')}
            >
              Shop
            </button>
            {canAccessSecrets && (
              <button
                type="button"
                style={tabStyle(tab === 'hoard')}
                onClick={() => setTab('hoard')}
              >
                Hoard
              </button>
            )}
          </div>
          {(tab === 'shop' || !canAccessSecrets) && (
            <>
              <MammonRow budget={data.budget} act={act} />
              {canAccessSecrets && (
                <SecretsPanel dodging={!!data.dodging} act={act} />
              )}
              <div style={subTabBarStyle}>
                {data.categories.map((cat) => {
                  const isActive = data.current_category === cat;
                  return (
                    <button
                      type="button"
                      key={cat}
                      style={subTabStyle(isActive)}
                      onClick={() =>
                        act('changecat', { category: isActive ? '' : cat })
                      }
                      title={
                        isActive
                          ? `Click again to clear the category filter`
                          : `Browse ${cat}`
                      }
                    >
                      {cat}
                    </button>
                  );
                })}
                {!!data.current_category && (
                  <button
                    type="button"
                    style={subTabStyle(false)}
                    onClick={() => act('changecat', { category: '' })}
                    title="Clear category filter (keeps any active search)"
                  >
                    × Clear
                  </button>
                )}
              </div>
              <SearchBar serverSearch={data.search} act={act} />
              <PacksGrid
                packs={data.packs}
                budget={data.budget}
                canRead={canRead}
                inSearchMode={inSearchMode}
                serverSearch={data.search}
                hasCategory={!!data.current_category}
                resultCap={data.result_cap}
                totalMatches={data.total_matches}
                act={act}
              />
            </>
          )}
          {tab === 'hoard' && canAccessSecrets && (
            <HoardTab entries={data.hoard_log} canRead={canRead} />
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
