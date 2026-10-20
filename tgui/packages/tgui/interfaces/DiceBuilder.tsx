import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { DiceIcon } from './common/DiceIcon';
import { godClass } from './common/statGods';

// Any other number of faces is set with the stepper.
const COMMON_SIDES = [4, 6, 8, 10, 12, 20, 100];

type StatOption = {
  name: string;
  key: string;
  code: string;
};

type Data = {
  title: string;
  allowDifficulty: boolean;
  stats: StatOption[];
  maxCount: number;
  maxSides: number;
  maxBonus: number;
};

type StepperProps = {
  value: number;
  min: number;
  max: number;
  autoFocus?: boolean;
  onChange: (value: number) => void;
};

/** A typeable number with a nudge button either side. Anything out of range is put right on blur. */
function Stepper(props: StepperProps) {
  const { value, min, max, onChange } = props;
  // Half-typed text, such as a lone minus. Null when not typing.
  const [draft, setDraft] = useState<string | null>(null);

  const clamp = (number: number) => Math.min(max, Math.max(min, number));

  function type(text: string) {
    if (!(min < 0 ? /^-?\d*$/ : /^\d*$/).test(text)) {
      return;
    }
    setDraft(text);
    const number = Number.parseInt(text, 10);
    if (Number.isInteger(number) && number >= min && number <= max) {
      onChange(number);
    }
  }

  function finish(text: string) {
    const number = Number.parseInt(text, 10);
    onChange(Number.isInteger(number) ? clamp(number) : clamp(value));
    setDraft(null);
  }

  return (
    <Box className="DiceBuilder__Stepper">
      <Button
        icon="minus"
        disabled={value <= min}
        onClick={() => {
          setDraft(null);
          onChange(clamp(value - 1));
        }}
      />
      <Input
        className="DiceBuilder__Field"
        value={draft ?? String(value)}
        autoFocus={props.autoFocus}
        autoSelect={props.autoFocus}
        onChange={type}
        onEnter={finish}
        onBlur={finish}
      />
      <Button
        icon="plus"
        disabled={value >= max}
        onClick={() => {
          setDraft(null);
          onChange(clamp(value + 1));
        }}
      />
    </Box>
  );
}

function Row(props: { label: string; children: React.ReactNode }) {
  return (
    <Box className="DiceBuilder__Row">
      <Box className="DiceBuilder__Label">{props.label}</Box>
      <Box className="DiceBuilder__Control">{props.children}</Box>
    </Box>
  );
}

/** Everything the window and the *roll shorthand do, for anyone who hovers the question mark. */
function Help() {
  return (
    <Box className="DiceBuilder__Help">
      <Box className="DiceBuilder__HelpTitle">Rolling dice</Box>
      <p>
        Pick the dice, a stat and a bonus. Everyone nearby sees the result. The
        sum reads stat, traits, bonus, then dice: <b>13 + 1 + 8 = 22</b>. CHA
        uses the higher of willpower and fortune.
      </p>
      <Box className="DiceBuilder__HelpTitle">Difficulty</Box>
      <p>
        The total must reach it to succeed. Without one the roll has no pass or
        fail.
      </p>
      <Box className="DiceBuilder__HelpTitle">Criticals</Box>
      <p>
        Every die at its highest is a CRITICAL SUCCESS, every die on 1 a
        CRITICAL FAIL. They decide a difficulty alone, and only count on rolls
        that crit at most 1 time in 20, like a d20, 2d10 or 3d6. Untick Crits
        to leave them out.
      </p>
      <Box className="DiceBuilder__HelpTitle">Typing it instead</Box>
      <p>
        After a star: <b>*d20</b>, <b>*2d6+3</b>, <b>*d20+STR</b>,{' '}
        <b>*3d6+STR+1/DC12</b>.
      </p>
      <ul>
        <li>
          <b>2d6</b>: dice and faces. The count is optional.
        </li>
        <li>
          <b>+3</b>, <b>-2</b>, or a stat: <b>+STR +PER +INT +CON +WIL +SPD
          +FOR +CHA</b>.
        </li>
        <li>
          <b>/DC15</b> sets a difficulty, <b>/NOCRIT</b> drops criticals.
        </li>
        <li>Up to 24 dice, 2 to 100 faces, bonus up to 99.</li>
      </ul>
      <Box className="DiceBuilder__HelpTitle">Contests</Box>
      <p>
        Custom Roll opens this window without a difficulty. A critical outranks
        any total, and equal totals are a draw.
      </p>
    </Box>
  );
}

export function DiceBuilder() {
  const { act, data } = useBackend<Data>();
  const { title, stats = [], maxCount, maxSides, maxBonus } = data;
  // BYOND sends TRUE as 1 and FALSE as 0, and a 0 in a condition would be drawn on the page.
  const allowDifficulty = !!data.allowDifficulty;

  const [count, setCount] = useState(1);
  const [sides, setSides] = useState(20);
  const [bonus, setBonus] = useState(0);
  const [stat, setStat] = useState('');
  const [useDifficulty, setUseDifficulty] = useState(false);
  const [difficulty, setDifficulty] = useState(20);
  const [crits, setCrits] = useState(true);

  const chosen = stats.find((option) => option.key === stat);
  const rollsAgainst = allowDifficulty && useDifficulty;

  // The roll as it will be written in chat, so the window and the *2d10+STR/DC15 shorthand agree.
  const preview =
    `${count}D${sides}` +
    (chosen ? ` + ${chosen.code}` : '') +
    (bonus ? ` ${bonus > 0 ? '+' : '-'} ${Math.abs(bonus)}` : '') +
    (rollsAgainst ? ` vs DC ${difficulty}` : '');

  function roll() {
    act('roll', {
      count,
      sides,
      bonus,
      stat,
      dc: rollsAgainst ? difficulty : '',
      crits: crits ? 1 : 0,
    });
  }

  return (
    <Window
      width={440}
      height={allowDifficulty ? 545 : 505}
      title={title}
      titleClassName="DiceBuilder__Title"
      buttons={
        <Button
          icon="question-circle"
          color="transparent"
          tooltip={<Help />}
          tooltipPosition="bottom-start"
        />
      }
    >
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <Box className="DiceBuilder__Dice">
                {COMMON_SIDES.map((faces) => (
                  <Button
                    key={faces}
                    className={classes([
                      'DiceBuilder__Die',
                      sides === faces && 'DiceBuilder__Die--selected',
                    ])}
                    selected={sides === faces}
                    tooltip={`D${faces}`}
                    onClick={() => setSides(faces)}
                  >
                    <DiceIcon sides={faces} label={String(faces)} />
                  </Button>
                ))}
              </Box>
              <Row label="Dice">
                <Stepper
                  autoFocus
                  value={count}
                  min={1}
                  max={maxCount}
                  onChange={setCount}
                />
              </Row>
              <Row label="Faces">
                <Stepper value={sides} min={2} max={maxSides} onChange={setSides} />
              </Row>
              <Row label="Bonus">
                <Stepper
                  value={bonus}
                  min={-maxBonus}
                  max={maxBonus}
                  onChange={setBonus}
                />
              </Row>
              <Row label="Criticals">
                <Button.Checkbox
                  checked={crits}
                  onClick={() => setCrits(!crits)}
                >
                  Crits
                </Button.Checkbox>
              </Row>
              {allowDifficulty && (
                <Row label="Against">
                  <Button.Checkbox
                    checked={useDifficulty}
                    onClick={() => setUseDifficulty(!useDifficulty)}
                  >
                    Difficulty
                  </Button.Checkbox>
                  {useDifficulty && (
                    <Stepper
                      value={difficulty}
                      min={1}
                      max={999}
                      onChange={setDifficulty}
                    />
                  )}
                </Row>
              )}
              <Box className="DiceBuilder__Heading">Add a stat</Box>
              <Box className="DiceBuilder__Stats">
                <Button
                  className="DiceBuilder__Stat"
                  selected={stat === ''}
                  onClick={() => setStat('')}
                >
                  None
                </Button>
                {stats.map((option) => (
                  <Button
                    key={option.key}
                    className={classes(['DiceBuilder__Stat', godClass(option.key)])}
                    selected={stat === option.key}
                    tooltip={option.name}
                    onClick={() => setStat(option.key)}
                  >
                    {option.code}
                  </Button>
                ))}
              </Box>
            </Section>
          </Stack.Item>
          {/* Takes the space left over and centres the roll in it, between the stats and the buttons. */}
          <Stack.Item grow className="DiceBuilder__PreviewSlot">
            <Box className="DiceBuilder__Preview">
              <DiceIcon sides={sides} label={String(sides)} size={40} />
              <span>{preview}</span>
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item grow>
                <Button
                  fluid
                  textAlign="center"
                  className="DiceBuilder__Roll"
                  onClick={roll}
                >
                  Roll
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  textAlign="center"
                  className="DiceBuilder__Cancel"
                  onClick={() => act('cancel')}
                >
                  Cancel
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
}
