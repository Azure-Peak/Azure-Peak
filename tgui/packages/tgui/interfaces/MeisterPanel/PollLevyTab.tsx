import {
  cardStyle,
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  sectionHeaderStyle,
} from '../common/parchment';
import type { TabProps } from './types';

export const PollLevyTab = ({ data }: TabProps) => {
  const tax = data.poll_levy;
  const taxUser = data.poll_levy_user;

  return (
    <div style={cardStyle}>
      <div style={sectionHeaderStyle}>Poll Levy</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Class</div>
        <div style={fieldValueStyle}>
          {taxUser.category_label || 'No taxable class'}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Status</div>
        <div style={fieldValueStyle}>
          {tax.exempt ? 'Exempt by Charter' : 'Pays levies'}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Arrears</div>
        <div style={fieldValueStyle}>
          {tax.owed > 0 ? `${tax.owed}m owed` : 'None'}
        </div>
      </div>
    </div>
  );
};
