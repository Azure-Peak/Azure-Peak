import type { CSSProperties } from 'react';
import { ImageButton } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { pageStyle } from './common/parchment';

type Data = {
  recipe: string;
  current_steps: number[];
  history: number[];
  answer: number[];
};

const STEP_ICON: string = 'icons/roguetown/misc/alchemy.dmi';
const STEP_NAMES: string[] = [
  'Harmonize',
  'Sanguinate',
  'Raefy',
  'Platonize',
  'Distill',
];
const STEP_DESCS: string[] = [
  "Adjust the item's essence. Pull it apart at the asymptote of existence.",
  'Imbue the object with (im)mortal quintessence. Add to its composition.',
  'Make it less. Consign components to nothing, remove, resculpt.',
  'Make it more. Pluck meaning from nothing. Add, enhance.',
  'Remove the excess. Bring out inner beauty. Focus only on what matters.',
];
const STEP_ICONSTATES: string[] = [
  'harmonize',
  'sanguinate',
  'raefy',
  'platonize',
  'distill',
];

const MAIN_STEPBOX_STYLE: CSSProperties = {
  width: '74px',
  height: '74px',
  margin: 4,
  borderStyle: 'solid',
  borderWidth: '2px',
  borderRadius: '1px',
};

const HISTORY_STEPBOX_STYLE: CSSProperties = {
  width: '38px',
  height: '38px',
  margin: 2,
};

const check_answer = (data: Data, idx: number, val: number) => {
  if (data.answer[idx] === val) return 1;
  if (!data.answer.find((_) => _ === val)) return -1;
  return 0;
};

const answer_check_str = (val: number) => {
  switch (val) {
    case 1:
      return 'correct';
    case -1:
      return 'invalid step';
    case 0:
      return 'valid step, wrong position';
  }
};

const answer_check_color = (val: number) => {
  switch (val) {
    case 1:
      return '#558b65';
    case -1:
      return '#7a2020';
    case 0:
      return '#a08050';
  }
};

export const Catalyzation = () => {
  const { act, data } = useBackend<Data>();

  if (!data.answer || !data.current_steps || !data.history || !data.recipe)
    // we're still initializing so chill out
    return (
      <Window width={760} height={780} theme="parchment" title="Catalyzation" />
    );

  return (
    <Window width={760} height={780} theme="parchment" title="Catalyzation">
      <Window.Content scrollable>
        <div style={pageStyle}>
          <div // main content
            style={{
              display: 'flex',
            }}
          >
            <div
              style={{
                width: '20%',
              }}
            >
              {STEP_NAMES.map((name, idx) => (
                <ImageButton
                  key={`input_${name}`}
                  tooltip={name}
                  style={MAIN_STEPBOX_STYLE}
                  onClick={() => act('add_step', { id: idx + 1 })}
                  dmIcon={STEP_ICON}
                  dmIconState={STEP_ICONSTATES[idx]}
                />
              ))}
            </div>
            <div
              style={{
                // puzzle section
                width: '80%',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'center',
                alignContent: 'center',
              }}
            >
              <div
                style={{
                  display: 'flex',
                  justifyContent: 'center',
                  alignContent: 'center',
                }}
              >
                <h1>Experiment: create a {data.recipe}.</h1>
              </div>
              <div
                style={{
                  // input boxes
                  display: 'flex',
                  flexDirection: 'row',
                  justifyContent: 'center',
                  alignContent: 'center',
                }}
              >
                {data.current_steps.map((val, idx) => {
                  if (val === 0) return <div style={MAIN_STEPBOX_STYLE} />;
                  else
                    return (
                      <ImageButton
                        key={`inslot_${idx}`}
                        dmIcon={STEP_ICON}
                        dmIconState={STEP_ICONSTATES[val - 1]}
                        imageSize={64}
                        assetSize={32}
                        style={MAIN_STEPBOX_STYLE}
                        onClick={() => act('del_step', { id: idx + 1 })}
                      />
                    );
                })}
              </div>
              <div
                style={{
                  // history section
                  display: 'flex',
                  flexDirection: 'row',
                  justifyContent: 'center',
                  alignContent: 'center',
                }}
              >
                {data.history.map((val, idx) => {
                  if (val === 0) return <div style={HISTORY_STEPBOX_STYLE} />;
                  else
                    return (
                      <ImageButton
                        key={`inslot_${idx}`}
                        dmIcon={STEP_ICON}
                        dmIconState={STEP_ICONSTATES[val - 1]}
                        assetSize={32}
                        // width="32px"
                        // height="32px"
                        imageSize={32}
                        style={{
                          margin: 2,
                          backgroundColor: answer_check_color(
                            check_answer(data, idx, val),
                          ),
                        }}
                        tooltip={`${STEP_NAMES[val - 1]} (${answer_check_str(check_answer(data, idx, val))})`} // colorblind friendly wheeeeeeee
                      />
                    );
                })}
              </div>
            </div>
          </div>
          <div
            style={{
              // tutorial text
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
              flexDirection: 'column',
            }}
          >
            <div>
              The creation of catalysts is a multi-step process, but the
              specific steps for any given catalyst are unknown. Click the icons
              on the left to input a series of guesses (click the icons in the
              center to clear a step), then click the table with a handful of
              catalyzing reagent (which you can make with normal crafting, in
              the alchemy section, or more efficiently with an albedo catalyst)
              to see if you were right. If you were, you'll get your catalyst;
              otherwise, a section beneath the input slots will show you your
              last guess and how correct you were. Green-tinted icons are fully
              correct; yellow-tinted icons are in the wrong spot, but that step
              is in the recipe; red-tinted icons are a step that isn't in the
              recipe at all. This information is also displayed as text when
              history icons are hovered. Use that information to narrow down the
              steps and complete the recipe.
              <br />
              <br />
              The processes used in catalyzation are as follows:
              <br />
              <ul>
                <li>
                  {STEP_NAMES.map((name, idx) => (
                    <li key={`stepdesc_${name}`}>
                      {name}: {STEP_DESCS[idx]}
                    </li>
                  ))}
                </li>
              </ul>
            </div>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
