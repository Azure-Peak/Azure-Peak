import {
  compactButtonStyle,
  denseRowStyle,
  ellipsisCellStyle,
  FONT_LEAD,
  FONT_SMALL,
  FONT_TINY,
  FONT_TITLE,
  INK,
  INK_SOFT,
  PriceTag,
  SEAL_RED,
} from '../common/parchment';
import type { ActFn, VendingPack } from './types';
import { starsIfIlliterate } from './util';

type Props = {
  pack: VendingPack;
  budget: number;
  canRead: boolean;
  showCategory: boolean;
  act: ActFn;
};

export const PackRow = (props: Props) => {
  const { pack, budget, canRead, showCategory, act } = props;
  const cantAfford = budget < pack.price;
  const hasTariff = pack.price_tariff > 0;
  const priceTitle = hasTariff
    ? `${pack.price_base}m + ${pack.price_tariff}m duty = ${pack.price}m`
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
        {!!pack.contraband && (
          <span
            style={{
              marginLeft: '6px',
              fontSize: FONT_TINY,
              fontWeight: 'bold',
              color: SEAL_RED,
              border: `1px solid ${SEAL_RED}`,
              padding: '0 4px',
              borderRadius: '2px',
              verticalAlign: 'middle',
            }}
          >
            contraband
          </span>
        )}
        {showCategory && (
          <span
            style={{
              fontSize: FONT_SMALL,
              color: INK_SOFT,
              fontWeight: 'normal',
              marginLeft: '6px',
            }}
          >
            {pack.category}
          </span>
        )}
      </div>
      <PriceTag
        price={pack.price}
        tariff={pack.price_tariff}
        cantAfford={cantAfford}
        title={priceTitle}
      />
      <div style={{ flexShrink: 0 }}>
        <button
          type="button"
          style={compactButtonStyle({ disabled: cantAfford })}
          disabled={cantAfford}
          onClick={() => act('buy', { ref: pack.ref })}
          title={`Buy ${pack.name} for ${pack.price}m`}
        >
          Buy
        </button>
      </div>
    </div>
  );
};
