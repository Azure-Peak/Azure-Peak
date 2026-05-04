import { WaxSeal, type WaxSealColor } from '../common/WaxSeal';
import { sealLine } from './shared';

type SealBanner = { mark: string; label: string; color: WaxSealColor };

export const COMMISSION_SEAL: SealBanner = {
  mark: 'C',
  label: 'Commissioned',
  color: 'amber',
};

export const EXEMPT_SEAL: SealBanner = {
  mark: 'E',
  label: 'Levy Exempt',
  color: 'green',
};

const sealBannerStyle: React.CSSProperties = {
  display: 'inline-flex',
  flexDirection: 'column',
  alignItems: 'center',
  gap: '2px',
  margin: '0 8px',
};

const sealCaptionStyle: React.CSSProperties = {
  fontVariant: 'small-caps',
  letterSpacing: '2px',
  fontSize: '0.72em',
  color: 'hsl(28, 50%, 25%)',
  fontWeight: 'bold',
};

export const SealBannerView = (props: { seal: SealBanner }) => {
  const { seal } = props;
  return (
    <div style={sealBannerStyle}>
      <WaxSeal mark={seal.mark} label={seal.label} color={seal.color} size={48} />
      <div style={sealCaptionStyle}>{seal.label}</div>
    </div>
  );
};

export const SealLine = (props: {
  rulerTitle: string;
  issuedBy?: string;
  issuedOn?: string | null;
  bearer?: string;
}) => {
  const { rulerTitle, issuedBy, issuedOn, bearer } = props;
  const issuer = issuedBy || `the ${rulerTitle}`;
  const dateText = issuedOn ? `Sealed this ${issuedOn}, ` : '';
  const bearerClause = bearer
    ? `given unto ${bearer} for execution.`
    : `given unto whoever shall take up this writ for execution.`;
  return (
    <p style={sealLine}>
      {dateText}by writ of {issuer}, {bearerClause}
    </p>
  );
};
