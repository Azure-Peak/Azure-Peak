import { useBackend } from '../../backend';
import {
  badgeStyle,
  cardStyle,
  FONT_BODY,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
  subTabBarStyle,
  subTabStyle,
} from '../common/parchment';
import type { Data, PetitionTarget } from './types';

const PETITION_PURPLE = '#a872c4';

export const PetitionView = (props: { data: Data }) => {
  const { act } = useBackend<Data>();
  const {
    petition_categories,
    petition_tax_pct,
    petitions_per_day,
    petition,
    region_catalog,
  } = props.data;

  const selectedId = petition.selected_template;
  const selectedCat = petition_categories.find((c) =>
    c.templates.some((t) => t.id === selectedId),
  );

  const cannotAct = !props.data.is_steward_role;

  const cannotActReason = cannotAct
    ? "Only Crown officials can petition regions."
    : '';

  const select = (template: string) => act('petition_select', { template });

  return (
    <div>
      <div style={sectionHeaderStyle}>Petition a Region</div>

      <div
        style={{
          color: INK_SOFT,
          fontSize: FONT_BODY,
          marginBottom: '10px',
          lineHeight: '1.5em',
        }}
      >
        Petition a region for a Standing Order of your choice. Costs Burgher
        Pledge. The order pays {petition_tax_pct}% less to cover the cost of
        searching for such demands. The exact item mix is still set by
        the region.
      </div>

      <PetitionStatusStrip data={props.data} />

      {cannotAct && (
        <div
          style={{
            ...cardStyle,
            borderLeft: `4px solid ${SEAL_RED}`,
            color: SEAL_RED,
          }}
        >
          {cannotActReason}
        </div>
      )}

      <div style={subTabBarStyle}>
        {petition_categories.map((c) => (
          <button
            type="button"
            key={c.id}
            title={c.description}
            style={subTabStyle(c.id === selectedCat?.id)}
            onClick={() => c.templates[0] && select(c.templates[0].id)}
          >
            {c.label} <span style={{ color: SEAL_AMBER }}>{c.cost}p</span>
          </button>
        ))}
      </div>

      <div style={{ height: '380px', overflowY: 'auto' }}>
        {selectedCat ? (
          <>
            <div style={{ ...subTabBarStyle, marginTop: 0 }}>
              {selectedCat.templates.map((t) => {
                const active = t.id === selectedId;
                return (
                  <button
                    type="button"
                    key={t.id}
                    style={{
                      ...subTabStyle(active),
                      borderColor: active ? PETITION_PURPLE : INK_FAINT,
                      color: t.region_ids.length ? INK : INK_FAINT,
                    }}
                    onClick={() => select(t.id)}
                  >
                    {t.label}
                  </button>
                );
              })}
            </div>
            <TargetTable
              targets={petition.targets}
              blocker={cannotAct ? cannotActReason : petition.blocker}
              cost={selectedCat.cost}
              regionNames={region_catalog}
              onPetition={() =>
                act('petition_for_order', { template: selectedId })
              }
            />
          </>
        ) : (
          <div
            style={{ color: INK_FAINT, fontStyle: 'italic', marginTop: '6px' }}
          >
            Select a category above.
          </div>
        )}
      </div>

      <div
        style={{
          marginTop: '14px',
          color: INK_SOFT,
          fontSize: FONT_BODY,
          lineHeight: '1.5em',
        }}
      >
        Limit: {petitions_per_day} petition{petitions_per_day === 1 ? '' : 's'}{' '}
        per day.
      </div>
    </div>
  );
};

const PetitionStatusStrip = (props: { data: Data }) => {
  const { petition, petitions_per_day } = props.data;
  const remaining = petition.petitions_remaining;
  const remainingColor = remaining > 0 ? SEAL_GREEN : SEAL_RED;
  return (
    <div
      style={{
        display: 'flex',
        gap: '14px',
        padding: '6px 10px',
        marginBottom: '10px',
        background: 'rgba(120,90,40,0.08)',
        border: `1px solid ${INK_FAINT}`,
        fontSize: FONT_BODY,
        color: INK,
      }}
    >
      <div>
        Pledge balance:{' '}
        <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
          {petition.pledge_balance}p
        </span>
      </div>
      <div>
        Petitions today:{' '}
        <span style={{ color: remainingColor, fontWeight: 'bold' }}>
          {remaining}
        </span>{' '}
        / {petitions_per_day}
      </div>
    </div>
  );
};

const TARGET_HELP =
  "The petition will come from one of the regions below, including raided ones. It will replace that region's current request, unless that request was petitioned or has already been partly delivered. In that case, it will come from another region. If there are no eligible regions, it will fail.";

const TargetTable = (props: {
  targets: PetitionTarget[];
  blocker: string;
  cost: number;
  regionNames: Record<string, { name: string }>;
  onPetition: () => void;
}) => {
  const { targets, blocker, cost, regionNames, onPetition } = props;
  const disabled = !!blocker;
  const sorted = [...targets].sort((a, b) =>
    (regionNames[a.region_id]?.name ?? a.region_id).localeCompare(
      regionNames[b.region_id]?.name ?? b.region_id,
    ),
  );

  return (
    <div style={{ marginTop: '6px' }}>
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          marginBottom: '8px',
        }}
      >
        <button
          type="button"
          disabled={disabled}
          title={blocker || undefined}
          onClick={onPetition}
          style={inkButtonStyle({ color: PETITION_PURPLE, disabled })}
        >
          Petition <span style={{ color: SEAL_AMBER }}>{cost}p</span>
        </button>
        <span
          title={TARGET_HELP}
          style={{ color: INK_SOFT, cursor: 'help', fontWeight: 'bold' }}
        >
          (?)
        </span>
        {disabled && (
          <span style={{ color: SEAL_RED, fontSize: FONT_BODY }}>
            {blocker}
          </span>
        )}
      </div>
      {sorted.length === 0 ? (
        <div style={{ color: INK_FAINT, fontStyle: 'italic' }}>
          No region can take this petition right now.
        </div>
      ) : (
        <>
          <div style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
            May come from:
          </div>
          <table
            style={{
              width: '100%',
              borderCollapse: 'collapse',
              fontSize: FONT_BODY,
              marginTop: '4px',
            }}
          >
            <tbody>
              {sorted.map((target) => (
                <tr
                  key={target.region_id}
                  style={{ borderBottom: `1px dotted ${INK_FAINT}` }}
                >
                  <td
                    style={{
                      padding: '4px 6px',
                      fontWeight: 'bold',
                      color: INK,
                      whiteSpace: 'nowrap',
                    }}
                  >
                    {regionNames[target.region_id]?.name ?? target.region_id}
                    {!!target.raided && (
                      <span style={badgeStyle(SEAL_RED)}>RAIDED</span>
                    )}
                  </td>
                  <td
                    style={{ padding: '4px 6px', width: '100%', color: INK_SOFT }}
                  >
                    {target.replaces ? `Replaces ${target.replaces}` : ''}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}
    </div>
  );
};
