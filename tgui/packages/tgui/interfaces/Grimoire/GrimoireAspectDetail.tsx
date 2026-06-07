import { GrimoireChoiceSection } from './GrimoireChoiceSection';
import { GrimoirePointBuySection } from './GrimoirePointBuySection';
import { GrimoireSpellEntry } from './GrimoireSpellEntry';
import { GrimoireVariantSection } from './GrimoireVariantSection';
import { stripHtml } from './helpers';
import { type Aspect, type Tab } from './types';

export const GrimoireAspectDetail = ({
  aspect,
  isAttuned,
  isLocked,
  isPendingUnbind,
  slotsFull,
  tab,
  userTier,
  initialSetup,
  resetBudget,
  stagedChoices,
  pointbuySelections,
  allSelectedSpells,
  getPointbuyUsed,
  act,
  readOnly = false,
  variantOverride,
}: {
  aspect: Aspect;
  isAttuned: boolean;
  isLocked: boolean;
  isPendingUnbind: boolean;
  slotsFull: boolean;
  tab: Tab;
  userTier: number;
  initialSetup: boolean;
  resetBudget: number;
  stagedChoices: Record<string, string>;
  pointbuySelections: Record<string, string[]>;
  allSelectedSpells: string[];
  getPointbuyUsed: (a: Aspect) => number;
  act: (action: string, params: Record<string, unknown>) => void;
  readOnly?: boolean;
  variantOverride?: string;
}) => {
  const isMajor = aspect.aspect_type === 'major';
  const unbindCost = isMajor ? 2 : 1;
  const canUnbind = !isLocked && resetBudget >= unbindCost;

  return (
    <>
      <div style={{ flex: 1, overflowY: 'auto' }}>
        <div className="AspectPicker__heading">
          <span
            style={aspect.school_color ? { color: aspect.school_color } : undefined}
          >
            {aspect.name}
          </span>
          {isPendingUnbind && (
            <span
              style={{
                fontSize: '11px',
                fontStyle: 'italic',
                marginLeft: '10px',
                color: 'rgba(200,100,100,0.8)',
              }}
            >
              - will be unbound
            </span>
          )}
        </div>

        {aspect.latin_name && (
          <div
            style={{
              fontStyle: 'italic',
              fontSize: '11px',
              opacity: 0.5,
              marginTop: '-2px',
              marginBottom: '4px',
            }}
          >
            {aspect.latin_name}
          </div>
        )}

        {aspect.desc && aspect.desc !== 'TODO' && (
          <div
            className="AspectPicker__desc"
            dangerouslySetInnerHTML={{ __html: aspect.desc }}
          />
        )}

        {aspect.attuned_name && (
          <div className="AspectPicker__attunement">
            Implement attunement: &ldquo;{aspect.attuned_name}&rdquo;
          </div>
        )}

        <div className="AspectPicker__divider" />

        {aspect.choice_spells && aspect.choice_spells.length > 0 && (
          <GrimoireChoiceSection
            aspect={aspect}
            stagedChoices={stagedChoices}
            allSelectedSpells={allSelectedSpells}
            act={act}
            readOnly={readOnly}
          />
        )}

        {aspect.fixed_spells.length > 0 && (
          <div>
            <div className="AspectPicker__section-label">Spells</div>
            {aspect.fixed_spells.map((spell) => (
              <GrimoireSpellEntry key={spell.path} spell={spell} />
            ))}
          </div>
        )}

        {aspect.variants && aspect.variants.length > 0 && (
          <GrimoireVariantSection
            variants={aspect.variants}
            fixedSpells={aspect.fixed_spells}
            userTier={userTier}
            variantOverride={variantOverride}
          />
        )}

        {aspect.pointbuy_spells.length > 0 && (
          <GrimoirePointBuySection
            aspect={aspect}
            pointbuySelections={pointbuySelections}
            allSelectedSpells={allSelectedSpells}
            getPointbuyUsed={getPointbuyUsed}
            act={act}
            readOnly={readOnly}
          />
        )}
      </div>

      {!readOnly && <div style={{ marginTop: '8px', flexShrink: 0 }}>
        {isPendingUnbind ? (
          <div
            className="AspectPicker__action-btn AspectPicker__action-btn--caution"
            onClick={() => act('undo_unbind', { path: aspect.path })}
          >
            Cancel Unbind
          </div>
        ) : isAttuned ? (
          isLocked ? (
            <div
              className="AspectPicker__attunement"
              style={{ textAlign: 'center', padding: '8px' }}
            >
              Innately bound.
            </div>
          ) : initialSetup ? (
            <div
              className="AspectPicker__action-btn AspectPicker__action-btn--remove"
              onClick={() => act('remove', { path: aspect.path })}
            >
              Unbind {aspect.name}
            </div>
          ) : canUnbind ? (
            <div
              className="AspectPicker__action-btn AspectPicker__action-btn--remove"
              onClick={() => act('remove', { path: aspect.path })}
            >
              Unbind {aspect.name} (cost: {unbindCost})
            </div>
          ) : (
            <div
              className="AspectPicker__attunement"
              style={{ textAlign: 'center', padding: '8px' }}
            >
              {resetBudget < unbindCost
                ? 'Not enough reshaping budget.'
                : 'Currently attuned.'}
            </div>
          )
        ) : slotsFull ? (
          <div
            className="AspectPicker__attunement"
            style={{ textAlign: 'center', padding: '8px' }}
          >
            No {tab} aspect slots remaining.
          </div>
        ) : (
          <div
            className="AspectPicker__action-btn AspectPicker__action-btn--confirm"
            onClick={() => act('attune', { path: aspect.path })}
          >
            Bind {aspect.name}
          </div>
        )}
      </div>}
    </>
  );
};
