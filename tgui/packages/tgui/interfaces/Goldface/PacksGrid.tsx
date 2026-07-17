import { cardStyle, FONT_BODY, INK_SOFT, SERIF } from '../common/parchment';
import { PackRow } from './PackRow';
import type { ActFn, VendingPack } from './types';

type Props = {
  packs: VendingPack[];
  budget: number;
  canRead: boolean;
  inSearchMode: boolean;
  serverSearch: string;
  hasCategory: boolean;
  browseOnly: boolean;
  resultCap: number;
  totalMatches: number;
  act: ActFn;
};

const HintCard = (props: { children: React.ReactNode }) => (
  <div
    style={{
      ...cardStyle,
      textAlign: 'center',
      color: INK_SOFT,
    }}
  >
    {props.children}
  </div>
);

export const PacksGrid = (props: Props) => {
  const {
    packs,
    budget,
    canRead,
    inSearchMode,
    serverSearch,
    hasCategory,
    browseOnly,
    resultCap,
    totalMatches,
    act,
  } = props;

  if (!hasCategory && !inSearchMode) {
    return (
      <HintCard>
        Select a category above, or type in the search to find goods.
      </HintCard>
    );
  }
  if (packs.length === 0) {
    return (
      <HintCard>
        {inSearchMode
          ? `No goods match "${serverSearch}".`
          : 'No goods stocked in this category.'}
      </HintCard>
    );
  }

  const overflowed = inSearchMode && totalMatches > resultCap;
  return (
    <>
      <div
        style={{
          columnCount: 3,
          columnGap: '12px',
        }}
      >
        {packs.map((p) => (
          <div key={p.ref} style={{ breakInside: 'avoid' }}>
            <PackRow
              pack={p}
              budget={budget}
              canRead={canRead}
              showCategory={inSearchMode}
              browseOnly={browseOnly}
              act={act}
            />
          </div>
        ))}
      </div>
      {overflowed && (
        <div
          style={{
            marginTop: '8px',
            textAlign: 'center',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            color: INK_SOFT,
          }}
        >
          Showing {resultCap} of {totalMatches} matches. Refine your search to
          narrow the list.
        </div>
      )}
    </>
  );
};
