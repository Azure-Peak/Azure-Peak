import { useState } from 'react';
import { NumberInput } from 'tgui-core/components';

import {
  fieldRowStyle,
  FONT_BODY,
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
          color: SEAL_AMBER,
        }}
      >
        {label}
      </div>
      <div style={{ flex: 1, color: INK, fontSize: FONT_BODY }}>
        <span style={{ fontWeight: 'bold' }}>Current: {current}</span>
        <span
          style={{
            color: INK_FAINT,
            fontSize: FONT_BODY,
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
  const enabled = !!material.enabled;
  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '6px',
        padding: '3px 6px',
        borderBottom: `1px dashed ${PARCHMENT_SHADOW}`,
        fontFamily: SERIF,
        opacity: enabled ? 1 : 0.5,
      }}
    >
      <input
        type="checkbox"
        checked={enabled}
        title={enabled ? 'Disable this material' : 'Enable this material'}
        onChange={() => act('toggle_material', { path: material.path })}
        style={{ cursor: 'pointer' }}
      />
      <div
        style={{
          flex: 1,
          color: INK,
          fontSize: FONT_BODY,
          textTransform: 'capitalize',
        }}
      >
        {material.name}
      </div>
      <div
        style={{
          flex: '0 0 auto',
          color: INK_SOFT,
          fontSize: FONT_BODY,
        }}
      >
        {material.price}m
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
  return (
    <>
      <div style={sectionHeaderStyle}>Commission Limits</div>
      <MarginRow
        label="Items per Order"
        hint="max items in a single commission (1 active order per person)"
        current={data.item_cap_per_order}
        minValue={1}
        maxValue={10}
        step={1}
        onSet={(v) => act('set_item_cap', { value: v })}
      />

      <div style={{ ...sectionHeaderStyle, marginTop: '16px' }}>
        Pricing Margins
      </div>
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
        Material Prices & Acceptance
      </div>
      <div
        style={{
          marginTop: '4px',
          fontSize: FONT_BODY,
          color: INK_SOFT,
          marginBottom: '6px',
        }}
      >
        Per unit. Recipe price = (material cost) × (1 + percent margin / 100) +
        flat margin. Disabling a material drops every recipe that uses it from
        the catalog - whether it is a primary or secondary ingredient.
      </div>
      <MaterialColumns materials={data.materials} act={act} />
    </>
  );
};

const MaterialColumns = (props: {
  materials: MaterialEntry[];
  act: ActFn;
}) => {
  const { materials, act } = props;
  const priority = materials.filter((m) => !!m.priority);
  const other = materials.filter((m) => !m.priority);
  return (
    <>
      {priority.length > 0 && (
        <>
          <div
            style={{
              fontFamily: SERIF,
              color: SEAL_AMBER,
              fontSize: FONT_BODY,
              marginTop: '6px',
              marginBottom: '2px',
            }}
          >
            Priority Materials
          </div>
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(2, minmax(0, 1fr))',
              columnGap: '12px',
            }}
          >
            {priority.map((m) => (
              <MaterialRow key={m.path} material={m} act={act} />
            ))}
          </div>
        </>
      )}
      {other.length > 0 && (
        <>
          <div
            style={{
              fontFamily: SERIF,
              color: INK_SOFT,
              fontSize: FONT_BODY,
              marginTop: '10px',
              marginBottom: '2px',
            }}
          >
            Other Materials
          </div>
          <div
            style={{
              display: 'grid',
              gridTemplateColumns: 'repeat(2, minmax(0, 1fr))',
              columnGap: '12px',
            }}
          >
            {other.map((m) => (
              <MaterialRow key={m.path} material={m} act={act} />
            ))}
          </div>
        </>
      )}
    </>
  );
};
