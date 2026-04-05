import { cls, stripHtml } from './helpers';
import { type Aspect } from './types';

export const GrimoirePointBuySection = ({
  aspect,
  pointbuySelections,
  allSelectedSpells,
  getPointbuyUsed,
  act,
  readOnly = false,
}: {
  aspect: Aspect;
  pointbuySelections: Record<string, string[]>;
  allSelectedSpells: string[];
  getPointbuyUsed: (a: Aspect) => number;
  act: (action: string, params: Record<string, unknown>) => void;
  readOnly?: boolean;
}) => {
  const selections = pointbuySelections[aspect.path] || [];
  const used = getPointbuyUsed(aspect);

  return (
    <div>
      <div className="AspectPicker__divider" />
      <div className="AspectPicker__section-label">
        Point-Buy ({used}/{aspect.pointbuy_budget})
      </div>
      {aspect.pointbuy_spells.map((spell) => {
        const isSelected = selections.includes(spell.path);
        const selectedElsewhere =
          !isSelected && allSelectedSpells.includes(spell.path);
        const wouldExceed =
          !isSelected && used + spell.cost > aspect.pointbuy_budget;
        const isDisabled = !isSelected && (wouldExceed || selectedElsewhere);
        return (
          <div
            key={spell.path}
            className={cls(
              'AspectPicker__pointbuy-entry',
              isSelected && 'AspectPicker__pointbuy-entry--selected',
              isDisabled && 'AspectPicker__pointbuy-entry--disabled',
            )}
            title={spell.desc ? stripHtml(spell.desc) : undefined}
            onClick={() =>
              !isDisabled &&
              act('pointbuy_toggle', {
                aspect_path: aspect.path,
                spell_path: spell.path,
              })
            }
          >
            {spell.name} ({spell.cost}pts)
            {selectedElsewhere && (
              <span
                className="AspectPicker__spell-desc"
                style={{ marginLeft: '6px' }}
              >
                already inscribed
              </span>
            )}
            {readOnly && spell.desc && (
              <div
                className="AspectPicker__spell-desc"
                dangerouslySetInnerHTML={{ __html: spell.desc }}
              />
            )}
            {readOnly && spell.fluff_desc && (
              <div
                className="AspectPicker__spell-fluff"
                dangerouslySetInnerHTML={{ __html: spell.fluff_desc }}
              />
            )}
          </div>
        );
      })}
    </div>
  );
};
