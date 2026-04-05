import { cls, stripHtml } from './helpers';
import { type Spell } from './types';

export const GrimoireUtilityList = ({
  spells,
  selected,
  known,
  givenUtilities = [],
  pendingUnbinds,
  isFull,
  pointsSpent,
  pointsBudget,
  initialSetup,
  resetBudget,
  allSelectedSpells,
  act,
  readOnly = false,
}: {
  spells: Spell[];
  selected: string[];
  known: string[];
  givenUtilities?: string[];
  pendingUnbinds: string[];
  isFull: boolean;
  pointsSpent: number;
  pointsBudget: number;
  initialSetup: boolean;
  resetBudget: number;
  allSelectedSpells: string[];
  act: (action: string, params: Record<string, unknown>) => void;
  readOnly?: boolean;
}) => (
  <>
    {spells.map((spell) => {
      const isSelected = selected.includes(spell.path);
      const isKnown = known.includes(spell.path);
      const isGiven = givenUtilities.includes(spell.path);
      const isPendingUnbind = pendingUnbinds.includes(spell.path);
      const selectedElsewhere =
        !isSelected && !isKnown && allSelectedSpells.includes(spell.path);
      const tooExpensive =
        !isSelected && !isKnown && pointsSpent + spell.cost > pointsBudget;
      const isDisabled =
        readOnly ||
        (!isSelected &&
          !isKnown &&
          (tooExpensive || selectedElsewhere));

      const handleClick = readOnly
        ? undefined
        : () => {
            if (isPendingUnbind) {
              act('undo_unbind_utility', { spell_path: spell.path });
            } else if (isKnown && !initialSetup) {
              if (resetBudget >= 1) {
                act('unbind_utility', { spell_path: spell.path });
              }
            } else if (!isDisabled) {
              act('utility_toggle', { spell_path: spell.path });
            }
          };

      return (
        <div
          key={spell.path}
          className={cls(
            'AspectPicker__chapter-entry',
            (isSelected || (isKnown && !isPendingUnbind)) &&
              'AspectPicker__chapter-entry--attuned',
            isPendingUnbind && 'AspectPicker__chapter-entry--unbinding',
            isDisabled && 'AspectPicker__chapter-entry--blocked',
          )}
          title={spell.desc ? stripHtml(spell.desc) : undefined}
          onClick={handleClick}
        >
          <span
            style={
              isPendingUnbind
                ? { textDecoration: 'line-through', opacity: 0.6 }
                : undefined
            }
          >
            {spell.name}
          </span>
          <span
            className="AspectPicker__spell-desc"
            style={{ marginLeft: '6px' }}
          >
            {isGiven ? '(Given)' : spell.cost > 0 ? `(${spell.cost})` : '(free)'}
          </span>
          {isKnown && !isPendingUnbind && !isSelected && (
            <span
              className="AspectPicker__spell-desc"
              style={{ marginLeft: '4px' }}
            >
              learned
            </span>
          )}
          {isPendingUnbind && (
            <span
              className="AspectPicker__spell-desc"
              style={{ marginLeft: '4px', color: 'rgba(200,100,100,0.8)' }}
            >
              unbinding
            </span>
          )}
          {selectedElsewhere && (
            <span
              className="AspectPicker__spell-desc"
              style={{ marginLeft: '4px', opacity: 0.6 }}
            >
              chosen in aspect
            </span>
          )}
        </div>
      );
    })}
  </>
);
