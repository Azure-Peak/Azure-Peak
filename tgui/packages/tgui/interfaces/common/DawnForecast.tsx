import { FONT_BODY, INK_SOFT, SEAL_RED } from './parchment';

export type DawnForecastRow = {
  dawn_change: number;
  raided_supply: number;
  raided_demand: number;
  raided_suppliers: string[];
  raided_demanders: string[];
};

export const reachLabel = (raidedSupply = 0, raidedDemand = 0) =>
  [
    raidedSupply > 0 ? `S: ${100 - raidedSupply}%` : '',
    raidedDemand > 0 ? `D: ${100 - raidedDemand}%` : '',
  ]
    .filter(Boolean)
    .join(' ');

export const forecastVisible = (row: DawnForecastRow) =>
  !!row.dawn_change || row.raided_supply > 0 || row.raided_demand > 0;

export const DawnForecast = (props: {
  row: DawnForecastRow;
  flush?: boolean;
}) => {
  const { row, flush } = props;
  const change = row.dawn_change;
  const raided = row.raided_supply > 0 || row.raided_demand > 0;
  if (!change && !raided) {
    return null;
  }
  const hover: string[] = [];
  if (row.raided_supply > 0) {
    hover.push(
      `Supply raided in ${(row.raided_suppliers || []).join(', ')}: ${row.raided_supply}% of supply won't arrive.`,
    );
  }
  if (row.raided_demand > 0) {
    hover.push(
      `Demand raided in ${(row.raided_demanders || []).join(', ')}: ${row.raided_demand}% of a surplus can't be traded away.`,
    );
  }
  return (
    <span
      style={{
        display: 'inline-flex',
        alignItems: 'baseline',
        gap: '4px',
        marginLeft: flush ? 0 : '6px',
        fontSize: FONT_BODY,
        color: INK_SOFT,
      }}
    >
      Dawn {change > 0 ? '+' : ''}
      {change}
      {raided && (
        <span
          title={hover.join(' ')}
          style={{
            color: SEAL_RED,
            fontWeight: 'bold',
            padding: '0 4px',
            border: `1px solid ${SEAL_RED}`,
            borderRadius: '2px',
            cursor: 'help',
          }}
        >
          {reachLabel(row.raided_supply, row.raided_demand)}
        </span>
      )}
    </span>
  );
};
