import { useState } from 'react';
import { NumberInput } from 'tgui-core/components';

import { useBackend } from '../../backend';
import {
  cardStyle,
  FONT_BODY,
  INK,
  INK_SOFT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SERIF,
} from '../common/parchment';
import type { Data } from './types';

export const RoyalCustomPanel = () => {
  const { act, data } = useBackend<Data>();
  const [marginDraft, setMarginDraft] = useState(data.royal_custom_margin);
  const unlocked = !!data.royal_custom_unlocked;
  return (
    <div
      style={{
        ...cardStyle,
        marginBottom: '10px',
        fontFamily: SERIF,
        fontSize: FONT_BODY,
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          flexWrap: 'wrap',
        }}
      >
        <span
          style={{
            color: SEAL_AMBER,
            fontWeight: 'bold',
          }}
        >
          Royal Custom Charter
        </span>
        {!unlocked ? (
          <span style={{ color: INK_SOFT }}>
            Locked - volume{' '}
            <b style={{ color: INK }}>{data.royal_custom_volume}m</b> of{' '}
            <b style={{ color: INK }}>{data.royal_custom_threshold}m</b>
          </span>
        ) : (
          <>
            <span style={{ color: SEAL_GREEN, fontWeight: 'bold' }}>
              INVOKED
            </span>
            <span style={{ color: INK_SOFT }}>
              Import margin{' '}
              <b style={{ color: INK }}>{data.royal_custom_margin}%</b>
            </span>
            <div
              style={{
                marginLeft: 'auto',
                display: 'flex',
                gap: '6px',
                alignItems: 'center',
              }}
            >
              <span style={{ color: INK_SOFT, fontSize: FONT_BODY }}>
                Margin %
              </span>
              <NumberInput
                value={marginDraft}
                minValue={0}
                maxValue={500}
                step={5}
                stepPixelSize={4}
                width="60px"
                onChange={(v: number) => setMarginDraft(v)}
              />
              <button
                type="button"
                style={inkButtonStyle({
                  disabled: marginDraft === data.royal_custom_margin,
                })}
                disabled={marginDraft === data.royal_custom_margin}
                onClick={() =>
                  act('set_royal_custom_margin', { value: marginDraft })
                }
              >
                Set
              </button>
            </div>
          </>
        )}
      </div>
      <div
        style={{
          color: INK_SOFT,
          fontSize: FONT_BODY,
          marginTop: '4px',
        }}
      >
        Invoked once the volume threshold is reached; Import surcharges flow
        into the Crown&apos;s purse thereafter.
      </div>
    </div>
  );
};
