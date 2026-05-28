import { sectionHeaderStyle } from '../../common/parchment';
import { PaginatedLog } from '../PaginatedLog';
import { type FundEntry, type TabProps } from '../types';

export const FundActivity = ({
  fund,
  data,
}: {
  fund: FundEntry;
  data: TabProps['data'];
}) => {
  const log = data.institutional_logs[fund.id] ?? [];
  return (
    <>
      <div style={sectionHeaderStyle}>Tally</div>
      <PaginatedLog entries={log} />
    </>
  );
};
