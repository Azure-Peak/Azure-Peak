import { cls, stripHtml } from './helpers';
import { type Aspect } from './types';

export const GrimoireChoiceSection = ({
  aspect,
  stagedChoices,
  allSelectedSpells,
  act,
  readOnly = false,
}: {
  aspect: Aspect;
  stagedChoices: Record<string, string>;
  allSelectedSpells: string[];
  act: (action: string, params: Record<string, unknown>) => void;
  readOnly?: boolean;
}) => {
  const currentChoice = stagedChoices[aspect.path] || null;
  const hasChosen = currentChoice !== null;

  return (
    <div>
      <div className="AspectPicker__divider" />
      {!hasChosen && (
        <div
          className="AspectPicker__section-label"
          style={{ color: 'rgba(255,200,120,0.9)' }}
        >
          Choose One
          <span style={{ fontSize: '10px', marginLeft: '6px', opacity: 0.7 }}>
            - click to select
          </span>
        </div>
      )}
      {aspect.choice_spells.map((spell) => {
        const isSelected = currentChoice === spell.path;
        const selectedElsewhere =
          !isSelected && allSelectedSpells.includes(spell.path);
        return (
          <div
            key={spell.path}
            className={cls(
              'AspectPicker__pointbuy-entry',
              isSelected && 'AspectPicker__pointbuy-entry--selected',
              selectedElsewhere && 'AspectPicker__pointbuy-entry--disabled',
            )}
            title={spell.fluff_desc ? stripHtml(spell.fluff_desc) : undefined}
            style={{
              cursor: selectedElsewhere ? 'default' : 'pointer',
            }}
            onClick={() =>
              !selectedElsewhere &&
              act('choice_toggle', {
                aspect_path: aspect.path,
                spell_path: spell.path,
              })
            }
          >
            <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
              <span
                style={{
                  display: 'inline-block',
                  width: '12px',
                  flexShrink: 0,
                  fontSize: '12px',
                  color: isSelected
                    ? 'rgba(120,255,120,0.9)'
                    : 'rgba(150,150,150,0.3)',
                }}
              >
                {isSelected ? '\u2713' : '\u2013'}
              </span>
              <span className="AspectPicker__spell-name">{spell.name}</span>
            </div>
            {selectedElsewhere && (
              <span
                className="AspectPicker__spell-desc"
                style={{ marginLeft: '18px' }}
              >
                already inscribed
              </span>
            )}
            {spell.desc && (
              <div
                className="AspectPicker__spell-desc"
                style={{ marginLeft: '18px' }}
                dangerouslySetInnerHTML={{ __html: spell.desc }}
              />
            )}
            {readOnly && spell.fluff_desc && (
              <div
                className="AspectPicker__spell-fluff"
                style={{ marginLeft: '18px' }}
                dangerouslySetInnerHTML={{ __html: spell.fluff_desc }}
              />
            )}
          </div>
        );
      })}
    </div>
  );
};
