import { useState } from 'react';

import { useBackend } from '../../backend';
import { groupByCategory } from './helpers';
import type { Data, RegionFlow, RegionRow } from './types';
import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
} from '../common/parchment';

export const RegionsView = (props: { data: Data }) => {
  const { region_rows, region_catalog } = props.data;

  const sorted = [...region_rows].sort((a, b) => {
    if (!!a.blockaded !== !!b.blockaded) return a.blockaded ? -1 : 1;
    const an = region_catalog[a.region_id]?.name ?? a.region_id;
    const bn = region_catalog[b.region_id]?.name ?? b.region_id;
    return an.localeCompare(bn);
  });

  return (
    <div>
      <div style={sectionHeaderStyle}>Regions</div>
      {sorted.map((r) => (
        <RegionCard key={r.region_id} region={r} data={props.data} />
      ))}
    </div>
  );
};

const RegionCard = (props: { region: RegionRow; data: Data }) => {
  const { act } = useBackend<Data>();
  const { region, data } = props;
  const meta = data.region_catalog[region.region_id];
  const regionName = meta?.name ?? region.region_id;
  const description = meta?.description;
  const [expanded, setExpanded] = useState<boolean>(!!region.blockaded);

  const producesCount = region.produces.length;
  const demandsCount = region.demands.length;

  return (
    <div
      style={{
        ...cardStyle,
        borderLeft: region.blockaded
          ? `4px solid ${SEAL_RED}`
          : `4px solid ${PARCHMENT_SHADOW}`,
      }}
    >
      <div
        onClick={() => setExpanded(!expanded)}
        style={{
          cursor: 'pointer',
          display: 'flex',
          alignItems: 'center',
          gap: '6px',
        }}
      >
        <span style={{ color: INK_FAINT, fontSize: FONT_BODY, width: '10px' }}>
          {expanded ? '▼' : '▶'}
        </span>
        <span style={{ fontWeight: 'bold', fontSize: FONT_BODY }}>
          {regionName}
        </span>
        {!!region.blockaded && (
          <span style={badgeStyle(SEAL_RED)}>BLOCKADED</span>
        )}
        <span style={{ color: INK_FAINT, fontSize: FONT_BODY, marginLeft: 'auto' }}>
          {producesCount} produces &middot; {demandsCount} demands
        </span>
      </div>
      {expanded && (
        <>
          {description && (
            <div
              style={{
                color: INK_SOFT,
                fontSize: FONT_BODY,
                margin: '6px 0 4px 16px',
              }}
            >
              {description}
            </div>
          )}
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: '1fr 1fr',
              gap: '12px',
              marginTop: '6px',
              marginLeft: '16px',
            }}
          >
            <FlowColumn
              title="Produces"
              color={SEAL_GREEN}
              flows={region.produces}
              data={data}
            />
            <FlowColumn
              title="Demands"
              color={SEAL_BLUE}
              flows={region.demands}
              data={data}
            />
          </div>
          <div
            style={{
              marginTop: '8px',
              marginLeft: '16px',
              display: 'flex',
              gap: '6px',
            }}
          >
            {producesCount > 0 && (
              <button
                type="button"
                style={inkButtonStyle({ color: SEAL_BLUE })}
                onClick={() =>
                  act('trade_region_import', { region_id: region.region_id })
                }
              >
                Import from {regionName}
              </button>
            )}
            {demandsCount > 0 && (
              <button
                type="button"
                style={inkButtonStyle({ color: SEAL_GREEN })}
                onClick={() =>
                  act('trade_region_export', { region_id: region.region_id })
                }
              >
                Export to {regionName}
              </button>
            )}
          </div>
        </>
      )}
    </div>
  );
};

const FlowColumn = (props: {
  title: string;
  color: string;
  flows: RegionFlow[];
  data: Data;
}) => {
  const { title, color, flows, data } = props;
  if (!flows.length) {
    return (
      <div>
        <div
          style={{
            color: INK_SOFT,
            fontWeight: 'bold',
            borderBottom: `1px solid ${INK_FAINT}`,
            paddingBottom: '2px',
            marginBottom: '4px',
            fontSize: FONT_BODY,
          }}
        >
          {title}
        </div>
        <div
          style={{ fontStyle: 'italic', color: INK_FAINT, fontSize: FONT_BODY }}
        >
          none
        </div>
      </div>
    );
  }

  const groups = groupByCategory(flows, data.good_catalog);

  return (
    <div>
      <div
        style={{
          color: INK_SOFT,
          fontWeight: 'bold',
          borderBottom: `1px solid ${INK_FAINT}`,
          paddingBottom: '2px',
          marginBottom: '4px',
          fontSize: FONT_BODY,
        }}
      >
        {title} &middot; {flows.length}
      </div>
      {groups.map(({ category, label, rows }) => (
        <div key={category} style={{ marginBottom: '4px' }}>
          <div
            style={{
              color: INK_FAINT,
              fontSize: FONT_BODY,
            }}
          >
            {label}
          </div>
          {rows.map((f) => (
            <div
              key={f.good_id}
              style={{
                fontSize: FONT_BODY,
                display: 'flex',
                justifyContent: 'space-between',
                padding: '1px 4px',
              }}
            >
              <span>{data.good_catalog[f.good_id]?.name ?? f.good_id}</span>
              <span>
                <span style={{ color }}>{f.total}/day</span>
                <span style={{ color: INK_FAINT }}> ({f.today})</span>
              </span>
            </div>
          ))}
        </div>
      ))}
    </div>
  );
};
