import { cls } from './helpers';
import { type Spell, type Variant } from './types';

export const GrimoireVariantSection = ({
  variants,
  fixedSpells,
  userTier,
  variantOverride,
}: {
  variants: Variant[];
  fixedSpells: Spell[];
  userTier: number;
  variantOverride?: string;
}) => (
  <div>
    <div className="AspectPicker__divider" />
    <div className="AspectPicker__section-label">Variants</div>
    {variants.map((variant) => (
      <div key={variant.name} className="AspectPicker__variant-block">
        <div
          className={cls(
            'AspectPicker__variant-name',
            ((variant.name === 'mastery' && userTier >= 4) ||
              variant.name === variantOverride) &&
              'AspectPicker__variant-name--active',
          )}
        >
          {variant.name.charAt(0).toUpperCase() + variant.name.slice(1)}
          {variant.name === 'mastery' &&
            userTier >= 4 &&
            ' \u2014 granted by your tier'}
          {variant.name === variantOverride &&
            ' \u2014 granted by your tradition'}
        </div>
        {variant.swaps.map((swap) => {
          const isAdditive = !swap.from;
          const fromSpell = isAdditive
            ? null
            : fixedSpells.find((s) => s.path === swap.from);
          return (
            <div
              key={swap.from || swap.to.name}
              className="AspectPicker__spell-entry"
            >
              {isAdditive ? (
                <span className="AspectPicker__spell-desc">
                  {'Additional: '}
                </span>
              ) : (
                <>
                  <span className="AspectPicker__spell-desc">
                    {fromSpell?.name || '?'}
                  </span>
                  {' \u2192 '}
                </>
              )}
              <span className="AspectPicker__spell-name">{swap.to.name}</span>
              {swap.to.desc && (
                <div
                  className="AspectPicker__spell-desc"
                  dangerouslySetInnerHTML={{ __html: swap.to.desc }}
                />
              )}
            </div>
          );
        })}
      </div>
    ))}
  </div>
);
