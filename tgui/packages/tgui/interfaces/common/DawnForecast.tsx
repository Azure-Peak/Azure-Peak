import { FONT_BODY, INK_SOFT, SEAL_RED } from './parchment';

export const DawnForecast = (props: {
  change: number;
  supplyPct: number;
  raidedBy: string[];
}) => {
  const { change, supplyPct, raidedBy } = props;
  const raided = raidedBy.length > 0;
  if (!change && !raided) {
    return null;
  }
  const arrives =
    supplyPct > 0
      ? `${supplyPct}% of supply arrives.`
      : 'No supply will arrive.';
  return (
    <span
      style={{
        display: 'inline-flex',
        alignItems: 'baseline',
        gap: '4px',
        marginLeft: '6px',
        fontSize: FONT_BODY,
        color: INK_SOFT,
      }}
    >
      Dawn {change > 0 ? '+' : ''}
      {change}
      {raided && (
        <span
          title={`Raided: ${raidedBy.join(', ')}. ${arrives}`}
          style={{
            color: SEAL_RED,
            fontWeight: 'bold',
            padding: '0 4px',
            border: `1px solid ${SEAL_RED}`,
            borderRadius: '2px',
            cursor: 'help',
          }}
        >
          RAIDED {100 - supplyPct}%
        </span>
      )}
    </span>
  );
};
