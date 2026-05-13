import { useState } from 'react';
import { NumberInput } from 'tgui-core/components';

import {
  cardStyle,
  fieldRowStyle,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT_SHADOW,
  SEAL_AMBER,
  sectionHeaderStyle,
  SERIF,
} from '../common/parchment';
import type { ActFn, CommissionerData, MaterialEntry } from './types';

const MarginRow = (props: {
  label: string;
  hint: string;
  current: number;
  minValue: number;
  maxValue: number;
  step: number;
  onSet: (value: number) => void;
}) => {
  const { label, hint, current, minValue, maxValue, step, onSet } = props;
  const [draft, setDraft] = useState(current);
  return (
    <div style={fieldRowStyle}>
      <div
        style={{
          flex: '0 0 160px',
          fontFamily: SERIF,
          fontVariant: 'small-caps',
          letterSpacing: '2px',
          color: SEAL_AMBER,
          fontStyle: 'italic',
        }}
      >
        {label}
      </div>
      <div style={{ flex: 1, color: INK, fontSize: '13px' }}>
        <span style={{ fontWeight: 'bold' }}>Current: {current}</span>
        <span
          style={{
            color: INK_FAINT,
            fontStyle: 'italic',
            fontSize: '11px',
            marginLeft: '8px',
          }}
        >
          {hint}
        </span>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
        <NumberInput
          value={draft}
          minValue={minValue}
          maxValue={maxValue}
          step={step}
          stepPixelSize={4}
          width="70px"
          onChange={(v: number) => setDraft(v)}
        />
        <button
          type="button"
          style={inkButtonStyle({ disabled: draft === current })}
          disabled={draft === current}
          onClick={() => onSet(draft)}
        >
          Set
        </button>
      </div>
    </div>
  );
};

const MaterialRow = (props: {
  material: MaterialEntry;
  act: ActFn;
}) => {
  const { material, act } = props;
  const [draft, setDraft] = useState(material.price);
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        padding: '4px 8px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
      }}
    >
      <div style={{ flex: 1, color: INK, fontSize: '13px' }}>
        {material.name}
      </div>
      <div
        style={{
          flex: '0 0 auto',
          color: INK_SOFT,
          fontSize: '11px',
          fontStyle: 'italic',
        }}
      >
        Current: {material.price}m
      </div>
      <NumberInput
        value={draft}
        minValue={0}
        maxValue={500}
        step={1}
        stepPixelSize={4}
        width="60px"
        onChange={(v: number) => setDraft(v)}
      />
      <button
        type="button"
        style={inkButtonStyle({ disabled: draft === material.price })}
        disabled={draft === material.price}
        onClick={() =>
          act('set_material_price', {
            path: material.path,
            value: draft,
          })
        }
      >
        Set
      </button>
    </div>
  );
};

export const ConfigPanel = (props: {
  data: CommissionerData;
  act: ActFn;
}) => {
  const { data, act } = props;
  const locked = !!data.locked;
  return (
    <>
      <div
        style={{
          ...cardStyle,
          marginBottom: '12px',
          display: 'flex',
          alignItems: 'center',
          gap: '12px',
        }}
      >
        <div style={{ flex: 1 }}>
          <div
            style={{
              fontFamily: SERIF,
              fontVariant: 'small-caps',
              letterSpacing: '2px',
              color: SEAL_AMBER,
              fontStyle: 'italic',
              fontSize: '12px',
            }}
          >
            Machine State
          </div>
          <div
            style={{
              fontFamily: SERIF,
              color: locked ? INK : INK_FAINT,
              fontWeight: 'bold',
              fontSize: '13px',
            }}
          >
            {locked ? 'Open for business' : 'Closed (no commissions accepted)'}
          </div>
        </div>
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() => act('toggle_lock')}
        >
          {locked ? 'Close Machine' : 'Open Machine'}
        </button>
      </div>

      <div style={sectionHeaderStyle}>Pricing Margins</div>
      <MarginRow
        label="Percent Margin"
        hint="% added to material cost"
        current={data.percent_margin}
        minValue={0}
        maxValue={500}
        step={5}
        onSet={(v) => act('set_percent_margin', { value: v })}
      />
      <MarginRow
        label="Flat Margin"
        hint="m added to each piece"
        current={data.flat_margin}
        minValue={0}
        maxValue={500}
        step={1}
        onSet={(v) => act('set_flat_margin', { value: v })}
      />

      <div style={{ ...sectionHeaderStyle, marginTop: '16px' }}>
        Material Prices
      </div>
      <div
        style={{
          marginTop: '4px',
          fontStyle: 'italic',
          fontSize: '11px',
          color: INK_FAINT,
          marginBottom: '6px',
        }}
      >
        Per unit. Recipe price = (material cost) × (1 + percent margin / 100) +
        flat margin.
      </div>
      {data.materials.map((m) => (
        <MaterialRow key={m.path} material={m} act={act} />
      ))}
    </>
  );
};
