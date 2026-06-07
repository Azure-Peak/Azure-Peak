import { type Spell } from './types';

export const GrimoireUtilitiesDetail = ({
  spells,
  selected,
  known,
  pendingUnbinds,
  pointsSpent,
  pointsBudget,
  initialSetup,
  resetBudget,
  readOnly = false,
}: {
  spells: Spell[];
  selected: string[];
  known: string[];
  pendingUnbinds: string[];
  pointsSpent: number;
  pointsBudget: number;
  initialSetup: boolean;
  resetBudget: number;
  readOnly?: boolean;
}) => (
  <div style={{ flex: 1, overflowY: 'auto' }}>
    <div className="AspectPicker__heading">Cantrips &amp; Utilities</div>
    <div className="AspectPicker__fluff">
      The lesser workings of the arcyne arts - simple enchantments, practical
      cantrips, and scholarly conveniences that require no particular attunement.
    </div>
    <div className="AspectPicker__divider" />
    <div className="AspectPicker__section-label">
      {pointsSpent} / {pointsBudget} pts spent
      {!readOnly && !initialSetup && (
        <span style={{ marginLeft: '12px', fontStyle: 'italic' }}>
          (reshaping: {resetBudget} / 2)
        </span>
      )}
    </div>
    {spells.map((spell) => {
      const isSelected = selected.includes(spell.path);
      const isKnown = known.includes(spell.path);
      const isPendingUnbind = pendingUnbinds.includes(spell.path);
      return (
        <div key={spell.path} className="AspectPicker__spell-entry">
          <span
            className="AspectPicker__spell-name"
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
            {spell.cost > 0 ? `(${spell.cost} pts)` : '(free)'}
          </span>
          {isSelected && (
            <span
              className="AspectPicker__spell-desc"
              style={{ marginLeft: '6px' }}
            >
              inscribed
            </span>
          )}
          {isKnown && !isPendingUnbind && !isSelected && (
            <span
              className="AspectPicker__spell-desc"
              style={{ marginLeft: '6px' }}
            >
              learned
            </span>
          )}
          {isPendingUnbind && (
            <span
              className="AspectPicker__spell-desc"
              style={{ marginLeft: '6px', color: 'rgba(200,100,100,0.8)' }}
            >
              unbinding
            </span>
          )}
          {spell.desc && (
            <div
              className="AspectPicker__spell-desc"
              dangerouslySetInnerHTML={{ __html: spell.desc }}
            />
          )}
        </div>
      );
    })}
  </div>
);
