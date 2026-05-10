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
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'flex-start',
        gap: '8px',
        padding: '6px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
      }}
    >
      <div style={{ flex: 1, minWidth: 0 }}>
        <div
          style={{
            fontSize: '13px',
            color: INK,
            overflow: 'hidden',
            textOverflow: 'ellipsis',
          }}
        >
          {starsIfIlliterate(pack.name, canRead)}
          {pack.qty > 1 && (
            <span
              style={{
                color: INK_SOFT,
                marginLeft: '4px',
                fontSize: '11px',
              }}
            >
              x{pack.qty}
            </span>
          )}
        </div>
        {showCategory && (
          <div
            style={{
              fontSize: '10px',
              fontStyle: 'italic',
              color: INK_SOFT,
            }}
          >
            {pack.category}
          </div>
        )}
      </div>
      <div style={{ textAlign: 'right', flexShrink: 0 }}>
        <div
          style={{
            fontSize: '13px',
            color: cantAfford ? INK_FAINT : INK,
            fontWeight: 'bold',
          }}
        >
          {pack.price}m
        </div>
        {pack.price_tariff > 0 && (
          <div
            style={{
              fontSize: '10px',
              fontStyle: 'italic',
              color: SEAL_AMBER,
              whiteSpace: 'nowrap',
            }}
          >
            +{pack.price_tariff}m tariff
          </div>
        )}
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
            style={inkButtonStyle({ disabled: cantAfford })}
            disabled={cantAfford}
            onClick={() => act('buy', { ref: pack.ref })}
          >
            Buy
          </button>
        )}
      </div>
    </div>
  );
};
