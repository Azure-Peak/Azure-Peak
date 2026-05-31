import {
  cardStyle,
  INK_SOFT,
  pageStyle,
  rulerStyle,
  subTabBarStyle,
  subTabStyle,
  titleStyle,
} from '../common/parchment';
import { PacksGrid } from './PacksGrid';
import { SearchBar } from './SearchBar';
import { TariffHeader } from './TariffHeader';
import type { ActFn, VendingData } from './types';
import { starsIfIlliterate } from './util';

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

export const VendingPanel = (props: { data: VendingData; act: ActFn }) => {
  const { data, act } = props;
  const canRead = !!data.can_read;
  const isPublic = !!data.is_public;
  const locked = !!data.locked;
  const isProprietor = !!data.is_proprietor;
  const inSearchMode = !!data.search_mode;
  const browseOnly = isPublic && locked;

  if (locked && !isPublic) {
    return <LockedView motto={data.motto} canRead={canRead} />;
  }

  return (
    <div style={pageStyle}>
      <TariffHeader
        motto={data.motto}
        canRead={canRead}
        tariffRatePct={data.tariff_rate_pct}
        tariffPaid={data.tariff_paid}
        tariffEvaded={data.tariff_evaded}
        isProprietor={isProprietor}
        dodging={!!data.dodging}
        publicMarginPct={data.public_margin_pct}
        publicMarginLabel={data.public_margin_label}
      />
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
        browseOnly={browseOnly}
        resultCap={data.result_cap}
        totalMatches={data.total_matches}
        act={act}
      />
    </div>
  );
};
