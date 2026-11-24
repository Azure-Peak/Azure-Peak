import {
  type CSSProperties,
  type ReactNode,
  useEffect,
  useRef,
} from 'react';

import {
  FONT_BODY,
  INK_FAINT,
  INK_SOFT,
  PARCHMENT_SHADOW,
  pageStyle,
  SEAL_AMBER,
  SERIF,
  tocLinkStyle,
} from './parchment';

export const RAIL_PINNED = '__pinned__';
export const RAIL_ALL = '__all__';

export type RailNode = {
  key: string;
  label: string;
  count: number;
  children?: RailNode[];
};

export const SMITHING_GROUP_ORDER = [
  'Armor',
  'Weapons',
  'Tools',
  'Valuables',
  'Decoration',
  'Engineering',
];

export const groupOf = (category: string) => {
  const paren = category.indexOf(' (');
  return paren === -1 ? category : category.slice(0, paren);
};

export const subcategoryOf = (category: string) => {
  const paren = category.indexOf(' (');
  return paren === -1 ? category : category.slice(paren + 2, -1);
};

export const compareGroupedCategories = (order: string[]) => {
  const rank = (group: string) => {
    const index = order.indexOf(group);
    return index === -1 ? order.length : index;
  };
  return (a: string, b: string) =>
    rank(groupOf(a)) - rank(groupOf(b)) || a.localeCompare(b);
};

export const buildGroupedRail = (
  categories: string[],
  counts: Record<string, number>,
) => {
  const groups: string[] = [];
  const members: Record<string, string[]> = {};
  for (const category of categories) {
    const group = groupOf(category);
    if (!members[group]) {
      members[group] = [];
      groups.push(group);
    }
    members[group].push(category);
  }
  return groups.map((group): RailNode => {
    const cats = members[group];
    if (cats.length === 1) {
      return { key: cats[0], label: cats[0], count: counts[cats[0]] || 0 };
    }
    return {
      key: group,
      label: group,
      count: cats.reduce((sum, category) => sum + (counts[category] || 0), 0),
      children: cats.map((category) => ({
        key: category,
        label: subcategoryOf(category),
        count: counts[category] || 0,
      })),
    };
  });
};

export const recipeGroupHeaderStyle: CSSProperties = {
  fontFamily: SERIF,
  fontSize: FONT_BODY,
  fontWeight: 'bold',
  color: SEAL_AMBER,
  borderBottom: `1px solid ${INK_FAINT}`,
  padding: '2px 4px',
  margin: '8px 0 2px 0',
};

export const recipeEmptyStyle: CSSProperties = {
  color: INK_SOFT,
  textAlign: 'center',
  padding: '16px 0',
};

const RailRow = (props: {
  node: RailNode;
  active: boolean;
  indent?: boolean;
  onSelect: (key: string) => void;
}) => {
  const { node, active, indent, onSelect } = props;
  return (
    <button
      type="button"
      className="toc-link"
      style={{
        ...tocLinkStyle(active),
        display: 'flex',
        fontSize: FONT_BODY,
        padding: indent ? '3px 8px 3px 20px' : '4px 8px',
      }}
      onClick={() => onSelect(node.key)}
    >
      <span style={{ flex: 1 }}>{node.label}</span>
      <span style={{ color: INK_FAINT, marginLeft: '6px' }}>{node.count}</span>
    </button>
  );
};

export const RecipeRail = (props: {
  nodes: RailNode[];
  selected: string | null;
  onSelect: (key: string) => void;
}) => {
  const { nodes, selected, onSelect } = props;
  return (
    <>
      {nodes.map((node) => {
        const children = node.children || [];
        const open =
          node.key === selected ||
          children.some((child) => child.key === selected);
        return (
          <div key={node.key}>
            <RailRow
              node={node}
              active={node.key === selected}
              onSelect={onSelect}
            />
            {open &&
              children.map((child) => (
                <RailRow
                  key={child.key}
                  node={child}
                  active={child.key === selected}
                  indent
                  onSelect={onSelect}
                />
              ))}
          </div>
        );
      })}
    </>
  );
};

export const RecipeRailLayout = (props: {
  header: ReactNode;
  rail: ReactNode;
  scrollKey?: string;
  children: ReactNode;
}) => {
  const listRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (listRef.current) {
      listRef.current.scrollTop = 0;
    }
  }, [props.scrollKey]);

  return (
    <div
      style={{
        ...pageStyle,
        height: '100%',
        boxSizing: 'border-box',
        padding: '8px 12px',
        display: 'flex',
        flexDirection: 'column',
      }}
    >
      <div
        style={{
          flexShrink: 0,
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          marginBottom: '8px',
        }}
      >
        {props.header}
      </div>
      <div style={{ flex: 1, minHeight: 0, display: 'flex', gap: '10px' }}>
        <div
          style={{
            flex: '0 0 180px',
            overflowY: 'auto',
            borderRight: `1px solid ${PARCHMENT_SHADOW}`,
            paddingRight: '6px',
          }}
        >
          {props.rail}
        </div>
        <div ref={listRef} style={{ flex: 1, minWidth: 0, overflowY: 'auto' }}>
          {props.children}
        </div>
      </div>
    </div>
  );
};
