import { formatMammon } from '../common/format';
import { FONT_SMALL, SEAL_AMBER, SEAL_RED } from '../common/parchment';
import type { AccountRow } from './types';

export const StatusTags = (props: { row: AccountRow }) => {
  const { row } = props;
  const tags: { label: string; color: string }[] = [];
  if (row.debtor) {
    tags.push({ label: 'Debtor', color: SEAL_RED });
  }
  if (row.poll_owed > 0) {
    tags.push({
      label: `Arrears ${formatMammon(row.poll_owed)}m`,
      color: SEAL_AMBER,
    });
  } else if (row.arrears && !row.debtor) {
    tags.push({ label: 'Arrears', color: SEAL_AMBER });
  }
  if (!tags.length) {
    return null;
  }
  return (
    <span style={{ fontSize: FONT_SMALL }}>
      {tags.map((t, i) => (
        <span key={i} style={{ color: t.color, marginRight: '8px' }}>
          {t.label}
        </span>
      ))}
    </span>
  );
};
