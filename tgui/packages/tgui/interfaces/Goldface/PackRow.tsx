import {
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  PriceTag,
} from '../common/parchment';
import type { ActFn, VendingPack } from './types';
import { starsIfIlliterate } from './util';

type Props = {
  pack: VendingPack;
  budget: number;
  canRead: boolean;
  showCategory: boolean;
  browseOnly: boolean;
  act: ActFn;
};

export const PackRow = (props: Props) => {
  const { pack, budget, canRead, showCategory, browseOnly, act } = props;
  const cantAfford = budget < pack.price;
  const hasTariff = pack.price_tariff > 0;
  const priceTitle = hasTariff
    ? `${pack.price_base}m + ${pack.price_tariff}m tariff = ${pack.price}m`
    : `${pack.price}m`;
  return (
    <div style={denseRowStyle}>
      <div
        style={{
          ...ellipsisCellStyle,
          fontSize: FONT_TITLE,
          color: INK,
        }}
        title={showCategory ? `${pack.name} - ${pack.category}` : pack.name}
      >
        {pack.qty > 1 && (
          <span
            style={{
              color: INK_SOFT,
              marginRight: '4px',
              fontSize: FONT_LEAD,
            }}
          >
            x{pack.qty}
          </span>
        )}
        {starsIfIlliterate(pack.name, canRead)}
      </div>
      <PriceTag
        price={pack.price}
        tariff={pack.price_tariff}
        cantAfford={cantAfford}
        title={priceTitle}
      />
      <div style={{ flexShrink: 0 }}>
        {browseOnly ? (
          <span
            style={{
              color: INK_FAINT,
              fontSize: FONT_SMALL,
            }}
          >
            browse
          </span>
        ) : (
          <button
            type="button"
            style={compactButtonStyle({ disabled: cantAfford })}
            disabled={cantAfford}
            onClick={() => act('buy', { ref: pack.ref })}
            title={`Buy ${pack.name} for ${pack.price}m`}
          >
            Buy
          </button>
        )}
      </div>
    </div>
  );
};
