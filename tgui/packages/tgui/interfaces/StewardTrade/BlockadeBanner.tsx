import { bannerStyle, SEAL_RED } from '../common/parchment';

export const BlockadeBanner = (props: { regions: string[] }) => {
  if (!props.regions || props.regions.length === 0) {
    return null;
  }
  return (
    <div style={bannerStyle(SEAL_RED)}>
      Blockaded Regions: {props.regions.join(', ')}
    </div>
  );
};
