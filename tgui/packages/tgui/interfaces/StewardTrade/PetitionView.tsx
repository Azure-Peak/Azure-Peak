import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  badgeStyle,
  cardStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';
import type { Data, PetitionCategory } from './types';

const PETITION_PURPLE = '#a872c4';

export const PetitionView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const {
    petition_categories,
    petition_tax_pct,
    petitions_per_day,
    petition,
    region_catalog,
  } = props.data;

  const [selectedCategory, setSelectedCategory] = useState<string | null>(
    petition_categories[0]?.id ?? null,
  );

  const selectedCat = petition_categories.find((c) => c.id === selectedCategory);

  const cannotAct =
    !petition.is_steward_role || !!petition.is_alderman_acting;

  const cannotActReason = petition.is_alderman_acting
    ? "The Alderman's writ does not extend to petitioning the trade hall."
    : !petition.is_steward_role
      ? 'Only the Steward, Clerk, or Grand Duke may petition the trade hall.'
      : '';

  return (
    <div>
      <div style={sectionHeaderStyle}>Petition the Trade Hall</div>

      <div
        style={{
          color: INK_SOFT,
          fontSize: '12px',
          marginBottom: '10px',
          fontStyle: 'italic',
          lineHeight: '1.5em',
        }}
      >
        Send envoys to a regional trade hall to commission a Standing Order of
        your choosing. Costs Burgher Pledge. The hall takes a {petition_tax_pct}%
        margin on petitioned orders &mdash; the price of certainty. The exact
        item mix is still set by the hall.
      </div>

      <PetitionStatusStrip data={props.data} />

      {cannotAct && (
        <div
          style={{
            ...cardStyle,
            borderLeft: `4px solid ${SEAL_RED}`,
            color: SEAL_RED,
            fontStyle: 'italic',
          }}
        >
          {cannotActReason}
        </div>
      )}

      <div style={{ display: 'flex', gap: '12px', marginTop: '8px' }}>
        <div style={{ flex: '0 0 220px' }}>
          <CategoryList
            categories={petition_categories}
            selected={selectedCategory}
            onSelect={setSelectedCategory}
          />
        </div>
        <div style={{ flex: '1 1 auto', minWidth: 0 }}>
          {selectedCat ? (
            <RegionPicker
              category={selectedCat}
              eligibility={petition.eligibility[selectedCat.id] || {}}
              regionNames={region_catalog}
              petitionsRemaining={petition.petitions_remaining}
              pledgeBalance={petition.pledge_balance}
              cannotAct={cannotAct}
              onPetition={(region_id) =>
                act('petition_for_order', {
                  region_id,
                  category_id: selectedCat.id,
                })
              }
            />
          ) : (
            <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
              Select a category at left.
            </div>
          )}
        </div>
      </div>

      <div
        style={{
          marginTop: '14px',
          color: INK_FAINT,
          fontSize: '11px',
          fontStyle: 'italic',
          lineHeight: '1.5em',
        }}
      >
        Limit: {petitions_per_day} petition{petitions_per_day === 1 ? '' : 's'}{' '}
        per day &middot; Regions freshly cleared of blockade need a recovery
        window before envoys return &middot; Petitioned orders are visibly
        tagged on the noticeboard and in the orders panel.
      </div>
    </div>
  );
};

const PetitionStatusStrip = (props: { data: Data }) => {
  const { petition, petitions_per_day } = props.data;
  const remaining = petition.petitions_remaining;
  const remainingColor = remaining > 0 ? SEAL_GREEN : SEAL_RED;
  return (
    <div
      style={{
        display: 'flex',
        gap: '14px',
        padding: '6px 10px',
        marginBottom: '10px',
        background: 'rgba(120,90,40,0.08)',
        border: `1px solid ${INK_FAINT}`,
        fontSize: '12px',
        color: INK,
      }}
    >
      <div>
        Pledge balance:{' '}
        <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
          {petition.pledge_balance}p
        </span>
      </div>
      <div>
        Petitions today:{' '}
        <span style={{ color: remainingColor, fontWeight: 'bold' }}>
          {remaining}
        </span>{' '}
        / {petitions_per_day}
      </div>
    </div>
  );
};

const CategoryList = (props: {
  categories: PetitionCategory[];
  selected: string | null;
  onSelect: (id: string) => void;
}) => {
  const { categories, selected, onSelect } = props;
  return (
    <div>
      {categories.map((c) => {
        const isSel = c.id === selected;
        return (
          <div
            key={c.id}
            onClick={() => onSelect(c.id)}
            style={{
              cursor: 'pointer',
              padding: '6px 8px',
              marginBottom: '4px',
              border: `1px solid ${isSel ? PETITION_PURPLE : INK_FAINT}`,
              background: isSel
                ? 'rgba(168,114,196,0.12)'
                : 'rgba(120,90,40,0.05)',
              fontSize: '12px',
            }}
          >
            <div style={{ fontWeight: 'bold', color: INK, marginBottom: '2px' }}>
              {c.label}
            </div>
            <div style={{ color: SEAL_AMBER, fontSize: '11px' }}>
              {c.cost}p pledge
            </div>
          </div>
        );
      })}
    </div>
  );
};

const RegionPicker = (props: {
  category: PetitionCategory;
  eligibility: Record<string, string>;
  regionNames: Record<string, { name: string; description: string }>;
  petitionsRemaining: number;
  pledgeBalance: number;
  cannotAct: boolean;
  onPetition: (region_id: string) => void;
}) => {
  const {
    category,
    eligibility,
    regionNames,
    petitionsRemaining,
    pledgeBalance,
    cannotAct,
    onPetition,
  } = props;

  const regionIds = Object.keys(eligibility);

  return (
    <div>
      <div
        style={{
          ...cardStyle,
          borderLeft: `4px solid ${PETITION_PURPLE}`,
          marginBottom: '10px',
        }}
      >
        <div style={{ marginBottom: '4px' }}>
          <span style={{ fontWeight: 'bold', fontSize: '14px' }}>
            {category.label}
          </span>
          <span style={badgeStyle(SEAL_AMBER)}>{category.cost}p</span>
        </div>
        <div
          style={{ color: INK_SOFT, fontSize: '12px', fontStyle: 'italic' }}
        >
          {category.description}
        </div>
      </div>

      {regionIds.length === 0 ? (
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
          No regions configured.
        </div>
      ) : (
        regionIds.map((rid) => {
          const blocker = eligibility[rid];
          const eligible = blocker === '';
          const regionName = regionNames[rid]?.name ?? rid;
          const disabled =
            cannotAct ||
            !eligible ||
            petitionsRemaining <= 0 ||
            pledgeBalance < category.cost;
          const tooltip = cannotAct
            ? ''
            : !eligible
              ? blocker
              : petitionsRemaining <= 0
                ? 'no petitions remaining today'
                : pledgeBalance < category.cost
                  ? `pledge short ${category.cost - pledgeBalance}p`
                  : `petition the ${regionName} hall for a ${category.label} order`;
          return (
            <div
              key={rid}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                padding: '4px 6px',
                marginBottom: '3px',
                borderBottom: `1px dotted ${INK_FAINT}`,
              }}
            >
              <div style={{ flex: '1 1 auto', color: INK, fontSize: '12px' }}>
                <span style={{ fontWeight: 'bold' }}>{regionName}</span>
                {!eligible && (
                  <span
                    style={{
                      color: SEAL_RED,
                      fontStyle: 'italic',
                      fontSize: '11px',
                      marginLeft: '6px',
                    }}
                  >
                    {blocker}
                  </span>
                )}
              </div>
              <button
                type="button"
                disabled={disabled}
                title={tooltip}
                onClick={() => onPetition(rid)}
                style={inkButtonStyle({
                  color: PETITION_PURPLE,
                  disabled,
                })}
              >
                Petition
              </button>
            </div>
          );
        })
      )}
    </div>
  );
};
