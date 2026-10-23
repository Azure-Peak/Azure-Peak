import { useBackend } from '../../backend';
import {
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
import type { Data, PetitionOffer } from './types';

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

  const cannotAct = !petition.is_steward_role || !!petition.is_alderman_acting;

  const cannotActReason = petition.is_alderman_acting
    ? "As Alderman, you can't petition regions."
    : !petition.is_steward_role
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
            <RegionTable
              offers={petition.offers}
              regionNames={region_catalog}
              cannotAct={cannotAct}
              onPetition={(region_id) =>
                act('petition_for_order', { region_id, template: selectedId })
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

const RegionTable = (props: {
  offers: PetitionOffer[];
  regionNames: Record<string, { name: string; description: string }>;
  cannotAct: boolean;
  onPetition: (region_id: string) => void;
}) => {
  const { offers, regionNames, cannotAct, onPetition } = props;

  if (offers.length === 0) {
    return (
      <div style={{ color: INK_FAINT, fontStyle: 'italic', marginTop: '6px' }}>
        No regions configured.
      </div>
    );
  }

  const sorted = [...offers].sort(
    (a, b) => Number(a.blocker !== '') - Number(b.blocker !== ''),
  );

  return (
    <table
      style={{
        width: '100%',
        borderCollapse: 'collapse',
        fontSize: FONT_BODY,
        marginTop: '6px',
      }}
    >
      <tbody>
        {sorted.map((offer) => {
          const regionName =
            regionNames[offer.region_id]?.name ?? offer.region_id;
          const eligible = offer.blocker === '';
          const disabled = cannotAct || !eligible;
          return (
            <tr
              key={offer.region_id}
              style={{
                borderBottom: `1px dotted ${INK_FAINT}`,
                opacity: eligible ? 1 : 0.65,
              }}
            >
              <td
                style={{
                  padding: '4px 6px',
                  fontWeight: 'bold',
                  color: INK,
                  whiteSpace: 'nowrap',
                }}
              >
                {regionName}
              </td>
              <td
                style={{
                  padding: '4px 6px',
                  width: '100%',
                  color: eligible ? INK_SOFT : SEAL_RED,
                }}
              >
                {eligible ? '' : offer.blocker}
              </td>
              <td style={{ padding: '4px 6px', textAlign: 'right' }}>
                <button
                  type="button"
                  disabled={disabled}
                  title={disabled ? offer.blocker : undefined}
                  onClick={() => onPetition(offer.region_id)}
                  style={inkButtonStyle({ color: PETITION_PURPLE, disabled })}
                >
                  Petition
                </button>
              </td>
            </tr>
          );
        })}
      </tbody>
    </table>
  );
};
