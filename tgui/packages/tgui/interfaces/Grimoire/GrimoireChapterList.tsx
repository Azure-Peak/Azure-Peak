import { cls } from './helpers';
import { type Aspect } from './types';

export const GrimoireChapterList = ({
  aspects,
  attuned,
  locked,
  pendingUnbinds,
  selectedPath,
  onSelect,
}: {
  aspects: Aspect[];
  attuned: string[];
  locked: string[];
  pendingUnbinds: string[];
  selectedPath: string | null;
  onSelect: (path: string) => void;
}) => (
  <>
    {aspects.map((aspect) => {
      const active = attuned.includes(aspect.path);
      const isLocked = locked.includes(aspect.path);
      const isPendingUnbind = pendingUnbinds.includes(aspect.path);
      const viewing = selectedPath === aspect.path;
      return (
        <div
          key={aspect.path}
          className={cls(
            'AspectPicker__chapter-entry',
            viewing && 'AspectPicker__chapter-entry--active',
            active && !isPendingUnbind && 'AspectPicker__chapter-entry--attuned',
            isLocked && 'AspectPicker__chapter-entry--locked',
            isPendingUnbind && 'AspectPicker__chapter-entry--unbinding',
          )}
          onClick={() => onSelect(aspect.path)}
        >
          <span
            style={{
              ...(aspect.school_color
                ? { color: aspect.school_color }
                : {}),
              ...(isPendingUnbind
                ? { textDecoration: 'line-through', opacity: 0.6 }
                : {}),
            }}
          >
            {aspect.name}
          </span>
          {isLocked && (
            <span
              className="AspectPicker__spell-desc"
              style={{ marginLeft: '6px' }}
            >
              bound
            </span>
          )}
          {active && !isLocked && !isPendingUnbind && (
            <span
              className="AspectPicker__spell-desc"
              style={{ marginLeft: '6px', opacity: 0.6 }}
            >
              attuned
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
        </div>
      );
    })}
  </>
);
