import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Header } from './Brassface/Header';
import { MammonRow } from './Brassface/MammonRow';
import { PacksGrid } from './Brassface/PacksGrid';
import { SearchBar } from './Brassface/SearchBar';
import { SecretsPanel } from './Brassface/SecretsPanel';
import type { BrassfaceData } from './Brassface/types';
import { starsIfIlliterate } from './Brassface/util';
import {
  cardStyle,
  INK_SOFT,
  pageStyle,
  rulerStyle,
  subTabBarStyle,
  subTabStyle,
  titleStyle,
} from './common/parchment';

const LockedView = (props: { motto: string; canRead: boolean }) => (
  <div style={pageStyle}>
    <div style={titleStyle}>{starsIfIlliterate(props.motto, props.canRead)}</div>
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
  const canRead = !!data.can_read;
  const isPublic = !!data.is_public;
  const locked = !!data.locked;
  const isProprietor = !!data.is_proprietor;
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
          <MammonRow budget={data.budget} act={act} />
          {isProprietor && !isPublic && (
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
        </div>
      </Window.Content>
    </Window>
  );
};
