import { useState } from 'react';

import {
  INK,
  INK_SOFT,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SEAL_GREEN,
  SERIF,
} from '../../common/parchment';
import type { HarborRealm } from '../types';
import { CategoryPill, ConditionPill, RealmCard } from './RealmCard';

export const REALM_GRID_COLUMNS = '14px 150px minmax(0, 1fr)';

export const RealmRow = (props: { realm: HarborRealm }) => {
  const { realm } = props;
  const [expanded, setExpanded] = useState(false);
  const conditions = realm.market_conditions ?? [];

  return (
    <div
      style={{
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
      }}
    >
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: REALM_GRID_COLUMNS,
          alignItems: 'start',
          columnGap: '8px',
          padding: '6px',
          cursor: 'pointer',
          fontSize: '11px',
        }}
        onClick={() => setExpanded((e) => !e)}
      >
        <div
          style={{
            color: INK_SOFT,
            fontSize: '11px',
            paddingTop: '2px',
          }}
        >
          {expanded ? '▾' : '▸'}
        </div>

        <div style={{ minWidth: 0 }}>
          <div
            style={{
              color: SEAL_AMBER,
              fontVariant: 'small-caps',
              fontSize: '13px',
              fontWeight: 'bold',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap',
              marginBottom: '3px',
            }}
          >
            {realm.name}
            {!!realm.is_kin && (
              <span
                title="Kinship Bonus active"
                style={{
                  marginLeft: '6px',
                  padding: '0 6px',
                  border: `1px solid ${SEAL_GREEN}`,
                  borderRadius: '8px',
                  color: SEAL_GREEN,
                  fontSize: '10px',
                  fontWeight: 'bold',
                  letterSpacing: '0.5px',
                }}
              >
                KIN
              </span>
            )}
          </div>
          <div style={{ lineHeight: '1.5' }}>
            {conditions.length === 0 ? (
              <span
                style={{
                  color: INK_SOFT,
                  fontStyle: 'italic',
                  fontSize: '10px',
                }}
              >
                no conditions
              </span>
            ) : (
              conditions.map((c) => (
                <ConditionPill key={c.name} condition={c} />
              ))
            )}
          </div>
        </div>

        <RealmCard realm={realm} />
      </div>
      {expanded && (
        <div
          style={{
            padding: '6px 8px 10px 36px',
            fontSize: '12px',
            color: INK,
            background: 'var(--p-card-bg)',
          }}
        >
          {realm.cultural_pack_names.length > 0 && (
            <div style={{ marginBottom: '8px' }}>
              <div
                style={{
                  color: SEAL_AMBER,
                  fontStyle: 'italic',
                  fontWeight: 'bold',
                  marginBottom: '4px',
                }}
              >
                Cultural Stock:
              </div>
              <div style={{ lineHeight: '1.6' }}>
                {realm.cultural_pack_names.map((p) => (
                  <CategoryPill key={p} name={p} />
                ))}
              </div>
            </div>
          )}
          {conditions.length > 0 && (
            <div style={{ marginBottom: '8px' }}>
              <div
                style={{
                  color: SEAL_AMBER,
                  fontStyle: 'italic',
                  fontWeight: 'bold',
                  marginBottom: '4px',
                }}
              >
                Market Conditions:
              </div>
              {conditions.map((c) => (
                <div key={c.name} style={{ marginBottom: '6px' }}>
                  <ConditionPill condition={c} />
                  <div
                    style={{
                      marginTop: '2px',
                      color: INK_SOFT,
                      fontSize: '11px',
                      lineHeight: '1.4',
                    }}
                  >
                    {c.description}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
};
