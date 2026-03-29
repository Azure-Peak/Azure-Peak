import { stripHtml } from './helpers';
import { type Spell } from './types';

export const GrimoireSpellEntry = ({ spell }: { spell: Spell }) => (
  <div className="AspectPicker__spell-entry">
    <span
      className="AspectPicker__spell-name"
      title={spell.fluff_desc ? stripHtml(spell.fluff_desc) : undefined}
    >
      {spell.name}
    </span>
    {spell.desc && (
      <div
        className="AspectPicker__spell-desc"
        dangerouslySetInnerHTML={{ __html: spell.desc }}
      />
    )}
    {spell.fluff_desc && (
      <div
        className="AspectPicker__spell-fluff"
        dangerouslySetInnerHTML={{ __html: spell.fluff_desc }}
      />
    )}
  </div>
);
