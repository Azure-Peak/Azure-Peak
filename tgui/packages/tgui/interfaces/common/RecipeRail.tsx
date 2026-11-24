import type { CSSProperties, ReactNode } from 'react';

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
  children: ReactNode;
}) => (
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
      <div style={{ flex: 1, minWidth: 0, overflowY: 'auto' }}>
        {props.children}
      </div>
    </div>
  </div>
);
