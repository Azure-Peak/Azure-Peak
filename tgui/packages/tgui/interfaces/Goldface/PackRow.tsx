import {
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  SERIF,
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
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '6px',
        padding: '4px 6px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        lineHeight: 1.3,
      }}
    >
      <div
        style={{
          flex: 1,
          minWidth: 0,
          fontSize: '13px',
          fontWeight: 'bold',
          color: INK,
          overflow: 'hidden',
          textOverflow: 'ellipsis',
          whiteSpace: 'nowrap',
        }}
        title={showCategory ? `${pack.name} - ${pack.category}` : pack.name}
      >
        {pack.qty > 1 && (
          <span
            style={{
              color: INK_SOFT,
              marginRight: '4px',
              fontSize: '12px',
              fontWeight: 'bold',
            }}
          >
            x{pack.qty}
          </span>
        )}
        {starsIfIlliterate(pack.name, canRead)}
      </div>
      <div
        style={{
          fontSize: '13px',
          color: cantAfford ? INK_FAINT : INK,
          fontWeight: 'bold',
          flexShrink: 0,
          whiteSpace: 'nowrap',
        }}
        title={priceTitle}
      >
        {pack.price}
        {hasTariff && (
          <span
            style={{
              color: SEAL_AMBER,
              fontWeight: 'bold',
              fontSize: '12px',
              marginLeft: '2px',
            }}
          >
            +{pack.price_tariff}
          </span>
        )}
        <span style={{ color: INK_SOFT, fontSize: '11px', fontWeight: 'bold' }}>
          m
        </span>
      </div>
      <div style={{ flexShrink: 0 }}>
        {browseOnly ? (
          <span
            style={{
              fontStyle: 'italic',
              color: INK_FAINT,
              fontSize: '10px',
            }}
          >
            browse
          </span>
        ) : (
          <button
            type="button"
            style={{
              ...inkButtonStyle({ disabled: cantAfford }),
              padding: '1px 7px',
              fontSize: '12px',
            }}
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
