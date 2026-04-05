import { useState } from 'react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { GrimoireAspectDetail } from './Grimoire/GrimoireAspectDetail';
import { GrimoireChapterList } from './Grimoire/GrimoireChapterList';
import { GrimoireTabBar } from './Grimoire/GrimoireTabBar';
import { GrimoireUtilitiesDetail } from './Grimoire/GrimoireUtilitiesDetail';
import { GrimoireUtilityList } from './Grimoire/GrimoireUtilityList';
import { cls } from './Grimoire/helpers';
import { type Aspect, type Data, type Tab } from './Grimoire/types';

export const GrimoireAspectPicker = () => {
  const { data, act } = useBackend<Data>();
  const {
    read_only = false,
    major_aspects = [],
    minor_aspects = [],
    utility_spells = [],
    user_tier = 0,
    max_majors = 1,
    max_minors = 2,
    max_utilities = 0,
    initial_setup = true,
    attuned_majors = [],
    attuned_minors = [],
    selected_utilities = [],
    locked_aspects = [],
    staged_choices = {},
    pointbuy_selections = {},
    all_selected_spells = [],
    utility_points_spent = 0,
    reset_budget = 4,
    reset_budget_max = 4,
    staged_unbind_aspects = [],
    staged_unbind_utilities = [],
    known_utilities = [],
    given_utilities = [],
    variant_overrides = {},
  } = data;

  const [selectedPath, setSelectedPath] = useState<string | null>(null);
  const getDefaultTab = (): Tab => {
    if (max_majors > 0) return 'major';
    if (max_minors > 0) return 'minor';
    return 'utilities';
  };
  const [tab, setTab] = useState<Tab>(getDefaultTab);
  const [partialConfirmed, setPartialConfirmed] = useState(false);

  const aspects = tab === 'major' ? major_aspects : minor_aspects;
  const attuned = tab === 'major' ? attuned_majors : attuned_minors;
  const maxSlots = tab === 'major' ? max_majors : max_minors;
  const unbindCount = attuned.filter((p) =>
    staged_unbind_aspects.includes(p),
  ).length;
  const slotsUsed = attuned.length - unbindCount;
  const slotsFull = slotsUsed >= maxSlots;

  const selected = aspects.find((a) => a.path === selectedPath) || null;
  const isAttuned = selected ? attuned.includes(selected.path) : false;
  const isLocked = selected ? locked_aspects.includes(selected.path) : false;
  const isPendingUnbind = selected
    ? staged_unbind_aspects.includes(selected.path)
    : false;

  const hasAccess = (t: Tab): boolean => {
    if (read_only) return true;
    if (t === 'major') return max_majors > 0;
    if (t === 'minor') return max_minors > 0;
    if (t === 'utilities') return max_utilities > 0;
    return false;
  };

  const getPointbuyUsed = (aspect: Aspect): number => {
    const selections = pointbuy_selections[aspect.path] || [];
    let total = 0;
    for (const spellPath of selections) {
      const spell = aspect.pointbuy_spells.find((s) => s.path === spellPath);
      if (spell) total += spell.cost;
    }
    return total;
  };

  const utilitiesFull = utility_points_spent >= max_utilities;

  const allFilled =
    attuned_majors.length >= max_majors &&
    attuned_minors.length >= max_minors;
  const hasAny = attuned_majors.length > 0 || attuned_minors.length > 0;
  const hasUnbinds =
    staged_unbind_aspects.length > 0 || staged_unbind_utilities.length > 0;

  const utilityOnly = max_majors === 0 && max_minors === 0;
  const hasUnspentUtilities =
    max_utilities > 0 && utility_points_spent < max_utilities;
  const canSeal = utilityOnly
    ? utility_points_spent > 0 || hasUnbinds
    : hasAny || hasUnbinds;
  const sealReady = utilityOnly
    ? utility_points_spent >= max_utilities
    : allFilled && !hasUnspentUtilities;

  const noAct = (_action?: string, _params?: Record<string, unknown>) => {};
  const wrappedAct = read_only
    ? noAct
    : (action: string, params?: Record<string, unknown>) => {
        if (action !== 'confirm') {
          setPartialConfirmed(false);
        }
        act(action, params);
      };

  const switchTab = (t: Tab) => {
    setTab(t);
    setSelectedPath(null);
  };

  const tabAccessible = hasAccess(tab);

  const getSealLabel = (): string => {
    if (!initial_setup && hasUnbinds) {
      return sealReady
        ? 'Seal the Circuit'
        : 'Confirm Changes';
    }
    if (utilityOnly) {
      return sealReady
        ? 'Seal the Circuit'
        : `Seal (${utility_points_spent}/${max_utilities} pts)`;
    }
    return sealReady
      ? 'Seal the Circuit'
      : `Seal (${attuned_majors.length}/${max_majors} major, ${attuned_minors.length}/${max_minors} minor)`;
  };

  return (
    <Window width={860} height={580} title="Grimoire" theme="grimoire">
      <Window.Content fitted>
        <div
          style={{
            display: 'flex',
            flexDirection: 'column',
            height: '100%',
          }}
        >
          <div style={{ flex: 1, display: 'flex', minHeight: 0 }}>
            {/* Left page */}
            <div
              className="AspectPicker__page"
              style={{ width: '280px', flexShrink: 0, padding: '8px' }}
            >
              <GrimoireTabBar
                tab={tab}
                hasAccess={hasAccess}
                switchTab={switchTab}
              />

              {tab !== 'utilities' && (
                <div className="AspectPicker__slot-display">
                  {read_only
                    ? 'Arcyne Compendium'
                    : tabAccessible
                      ? `${slotsUsed} / ${maxSlots} bound`
                      : 'Browse only'}
                </div>
              )}
              {tab === 'utilities' && (
                <div className="AspectPicker__slot-display">
                  {read_only
                    ? 'Arcyne Compendium'
                    : tabAccessible
                      ? `${utility_points_spent} / ${max_utilities} pts`
                      : 'Browse only'}
                </div>
              )}

              {tab !== 'utilities' && (
                <GrimoireChapterList
                  aspects={aspects}
                  attuned={tabAccessible ? attuned : []}
                  locked={tabAccessible ? locked_aspects : []}
                  pendingUnbinds={tabAccessible ? staged_unbind_aspects : []}
                  selectedPath={selectedPath}
                  onSelect={setSelectedPath}
                />
              )}

              {tab === 'utilities' && tabAccessible && (
                <GrimoireUtilityList
                  spells={utility_spells}
                  selected={selected_utilities}
                  known={known_utilities}
                  givenUtilities={given_utilities}
                  pendingUnbinds={staged_unbind_utilities}
                  isFull={utilitiesFull}
                  pointsSpent={utility_points_spent}
                  pointsBudget={max_utilities}
                  initialSetup={initial_setup}
                  resetBudget={reset_budget}
                  allSelectedSpells={all_selected_spells}
                  act={wrappedAct}
                  readOnly={read_only}
                />
              )}
            </div>

            {/* Spine */}
            <div className="AspectPicker__spine" />

            {/* Right page */}
            <div
              className="AspectPicker__page"
              style={{
                flex: 1,
                padding: '12px 16px',
                display: 'flex',
                flexDirection: 'column',
              }}
            >
              {tab === 'utilities' ? (
                tabAccessible ? (
                  <GrimoireUtilitiesDetail
                    spells={utility_spells}
                    selected={selected_utilities}
                    known={known_utilities}
                    pendingUnbinds={staged_unbind_utilities}
                    pointsSpent={utility_points_spent}
                    pointsBudget={max_utilities}
                    initialSetup={initial_setup}
                    resetBudget={reset_budget}
                    readOnly={read_only}
                  />
                ) : (
                  <div className="AspectPicker__empty">
                    You do not have access to utility spells.
                  </div>
                )
              ) : !tabAccessible ? (
                selected ? (
                  <GrimoireAspectDetail
                    aspect={selected}
                    isAttuned={false}
                    isLocked={true}
  
                    isPendingUnbind={false}
                    slotsFull={true}
                    tab={tab}
                    userTier={user_tier}
                    initialSetup={initial_setup}
                    resetBudget={0}
                    stagedChoices={{}}
                    pointbuySelections={{}}
                    allSelectedSpells={all_selected_spells}
                    getPointbuyUsed={getPointbuyUsed}
                    act={() => {}}
                    readOnly
                    variantOverride={variant_overrides[selected.path]}
                  />
                ) : (
                  <div className="AspectPicker__empty">
                    You do not have access to {tab} aspects.
                    <br />
                    Select a discipline to browse its spells.
                  </div>
                )
              ) : selected ? (
                <GrimoireAspectDetail
                  aspect={selected}
                  isAttuned={isAttuned}
                  isLocked={isLocked}

                  isPendingUnbind={isPendingUnbind}
                  slotsFull={slotsFull}
                  tab={tab}
                  userTier={user_tier}
                  initialSetup={initial_setup}
                  resetBudget={reset_budget}
                  stagedChoices={staged_choices}
                  pointbuySelections={pointbuy_selections}
                  allSelectedSpells={all_selected_spells}
                  getPointbuyUsed={getPointbuyUsed}
                  act={wrappedAct}
                  readOnly={read_only}
                  variantOverride={variant_overrides[selected.path]}
                />
              ) : (
                <div className="AspectPicker__empty">
                  Select a discipline to read its chapter.
                </div>
              )}
            </div>
          </div>

          {/* Footer bar - hidden in read-only mode */}
          {!read_only && (
            <div
              style={{
                padding: '4px 0 0 0',
                display: 'flex',
                gap: '8px',
                alignItems: 'center',
              }}
            >
              {!initial_setup && (
                <div className="AspectPicker__reset-budget">
                  Reshaping: {reset_budget} / {reset_budget_max}
                </div>
              )}
              <div
                className={cls(
                  'AspectPicker__action-btn',
                  sealReady && 'AspectPicker__action-btn--confirm',
                  canSeal && !sealReady && 'AspectPicker__action-btn--caution',
                  !canSeal && 'AspectPicker__action-btn--disabled',
                )}
                style={{ flex: 1 }}
                onClick={
                  canSeal
                    ? () => {
                        if (!sealReady && initial_setup && !partialConfirmed) {
                          setPartialConfirmed(true);
                          return;
                        }
                        wrappedAct('confirm');
                      }
                    : undefined
                }
              >
                {!sealReady && partialConfirmed
                  ? allFilled && hasUnspentUtilities
                    ? 'Skip remaining utility spells - are you sure?'
                    : 'Do a partial binding - Rebinding requires a Grimoire!'
                  : getSealLabel()}
              </div>
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
