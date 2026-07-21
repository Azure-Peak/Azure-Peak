import { memo } from 'react';
import { Box, DmIcon, Section } from 'tgui-core/components';

import { useBackend } from '../backend';

// ---- Shared icon shape ----

type RecipeIcon = {
  icon: string;
  icon_state: string;
  name: string;
};

// ---- Step shapes ----

type StepSharp = { kind: 'sharp' };
type StepReagent = { kind: 'reagent'; label: string };
type StepText = { kind: 'text'; label: string };
type StepCook = { kind: 'cook'; label: string };
type StepAnyof = { kind: 'anyof'; options: RecipeIcon[] };
type StepItem = {
  kind: 'item' | 'tool';
  icon: string;
  icon_state: string;
  name: string;
};

type RecipeStep =
  | StepSharp
  | StepReagent
  | StepText
  | StepCook
  | StepAnyof
  | StepItem;

// ---- Entry data shapes ----

type FoodEntryData = {
  type: 'food';
  name: string;
  time_per_step: number;
  bases: (RecipeIcon & { link: string | null })[];
  steps: RecipeStep[];
  result: RecipeIcon | null;
  result_amount: number;
  nutrition_html: string;
  follow_ups: { name: string; path: string }[];
};

type StewEntryData = {
  type: 'stew';
  name: string;
  output_name: string;
  output_desc: string;
  inputs: RecipeIcon[];
  cooktime: number;
};

export type RecipeEntryData = FoodEntryData | StewEntryData;

// ---- Inline icon helper ----

const InlineIcon = ({
  icon,
  icon_state,
}: {
  icon: string;
  icon_state: string;
}) => (
  <span
    style={{
      display: 'inline-block',
      width: '32px',
      height: '32px',
      verticalAlign: 'middle',
      marginRight: '6px',
      flexShrink: 0,
    }}
  >
    <DmIcon icon={icon} icon_state={icon_state} width={2} height={2} />
  </span>
);

// ---- Step row ----

const StepRow = ({ step }: { step: RecipeStep }) => {
  if (step.kind === 'sharp') {
    return (
      <>
        Score it with <b>any sharp tool</b>
      </>
    );
  }
  if (step.kind === 'reagent' || step.kind === 'text' || step.kind === 'cook') {
    return step.kind === 'cook' ? <b>{step.label}</b> : step.label;
  }
  if (step.kind === 'anyof') {
    return (
      <>
        Add one of:{' '}
        {step.options.map((opt, i) => (
          <span key={i}>
            <InlineIcon icon={opt.icon} icon_state={opt.icon_state} />
            {opt.name}
            {i < step.options.length - 1 ? ', ' : ''}
          </span>
        ))}
      </>
    );
  }
  return (
    <>
      {step.kind === 'tool' ? 'Apply ' : 'Add '}
      <InlineIcon icon={step.icon} icon_state={step.icon_state} />
      {step.name}
    </>
  );
};

// ---- Food entry renderer ----

const COOK_STYLES = `
  .recipe-detail h2 { border-bottom: 1px solid currentColor; padding-bottom: 4px; margin-bottom: 8px; }
  .recipe-detail h3 { border-bottom: 1px solid currentColor; padding-bottom: 4px; margin-top: 16px; margin-bottom: 8px; }
  .recipe-detail .recipe-desc { border-bottom: 1px solid rgba(255,255,255,0.15); padding-bottom: 8px; margin-bottom: 12px; }
  .recipe-detail ul { padding-left: 20px; }
  .recipe-detail li { margin: 4px 0; }
  .recipe-detail .toc-link { background: none; border: none; padding: 0; cursor: pointer; text-decoration: underline; color: inherit; font: inherit; }
`;

const FoodEntry = ({ data }: { data: FoodEntryData }) => {
  const { act } = useBackend();
  const {
    name,
    time_per_step,
    bases,
    steps,
    result,
    result_amount,
    nutrition_html,
    follow_ups,
  } = data;

  return (
    <div className="recipe-detail">
      <style>{COOK_STYLES}</style>
      <h2>{name}</h2>

      {bases.length > 1 ? (
        <p>
          <b>Start with any of:</b>{' '}
          {bases.map((b, i) => (
            <span key={i}>
              <InlineIcon icon={b.icon} icon_state={b.icon_state} />
              {b.link ? (
                <button
                  className="toc-link"
                  onClick={() => act('view_recipe', { path: b.link })}
                >
                  {b.name}
                </button>
              ) : (
                b.name
              )}
              {i < bases.length - 1 ? ', ' : ''}
            </span>
          ))}
        </p>
      ) : bases.length === 1 ? (
        <p>
          <b>Start with:</b>{' '}
          <InlineIcon icon={bases[0].icon} icon_state={bases[0].icon_state} />
          {bases[0].link ? (
            <button
              className="toc-link"
              onClick={() => act('view_recipe', { path: bases[0].link })}
            >
              {bases[0].name}
            </button>
          ) : (
            bases[0].name
          )}
        </p>
      ) : null}

      {steps.length > 0 && (
        <>
          <h3>Then, in order:</h3>
          <ul>
            {steps.map((step, i) => (
              <li key={i}>
                <StepRow step={step} />
              </li>
            ))}
          </ul>
        </>
      )}

      {result && (
        <p>
          <b>Produces:</b>{' '}
          <span
            style={{
              display: 'inline-block',
              width: '32px',
              height: '32px',
              verticalAlign: 'middle',
              marginRight: '6px',
              flexShrink: 0,
            }}
          >
            <DmIcon
              icon={result.icon}
              icon_state={result.icon_state}
              width={2}
              height={2}
            />
          </span>
          {result_amount > 1 ? `${result_amount}x ` : ''}
          {result.name}
        </p>
      )}

      {!!nutrition_html && (
        <div dangerouslySetInnerHTML={{ __html: nutrition_html }} />
      )}

      <p>
        Each step takes about {time_per_step} seconds before cooking skill
        modifiers.
      </p>

      {follow_ups.length > 0 && (
        <>
          <h3>Can be further prepared into:</h3>
          <ul>
            {follow_ups.map((f, i) => (
              <li key={i}>
                <button
                  className="toc-link"
                  onClick={() => act('view_recipe', { path: f.path })}
                >
                  {f.name}
                </button>
              </li>
            ))}
          </ul>
        </>
      )}
    </div>
  );
};

// ---- Stew entry renderer ----

const StewEntry = ({ data }: { data: StewEntryData }) => {
  const { name, output_name, output_desc, inputs, cooktime } = data;
  return (
    <div className="recipe-detail">
      <style>{COOK_STYLES}</style>
      <h2>{name}</h2>
      <p>
        Boil a hot pot of water, then add any of the following ingredients. Each
        yields <b>{output_name}</b>:
      </p>
      {!!output_desc && <p className="recipe-desc">{output_desc}</p>}
      {inputs.length > 0 && (
        <ul>
          {inputs.map((inp, i) => (
            <li key={i}>
              <InlineIcon icon={inp.icon} icon_state={inp.icon_state} />
              {inp.name}
            </li>
          ))}
        </ul>
      )}
      <p>
        Stews simmer for about {cooktime} seconds per ingredient. A pot consumes
        30dr of water per ingredient converted.
      </p>
    </div>
  );
};

// ---- Public component ----

type Props = {
  html: string;
  entryData?: RecipeEntryData | null;
};

export const RecipeBookEntry = memo((props: Props) => {
  const { html, entryData } = props;

  if (entryData) {
    return (
      <Section fill scrollable>
        <Box style={{ textAlign: 'left', padding: '4px 8px 24px 8px' }}>
          {entryData.type === 'food' ? (
            <FoodEntry data={entryData} />
          ) : (
            <StewEntry data={entryData} />
          )}
        </Box>
      </Section>
    );
  }

  if (!html) {
    return (
      <Section fill scrollable>
        <Box color="label" textAlign="center" mt={4}>
          Select an entry from the list to view details.
        </Box>
      </Section>
    );
  }

  return (
    <Section fill scrollable>
      <style>
        {`
          .recipe-detail .icon { margin-right: 8px; vertical-align: middle; }
          ${COOK_STYLES}
        `}
      </style>
      <Box
        className="recipe-detail"
        dangerouslySetInnerHTML={{ __html: html }}
        style={{ textAlign: 'left', padding: '4px 8px 24px 8px' }}
      />
    </Section>
  );
});
