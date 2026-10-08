/**
 * @file
 * @license MIT
 */

import { sanitizeHTML } from 'tgui/sanitize';
import { Tooltip } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

/** Mirrors DICE_MAX_COUNT and DICE_MAX_SIDES in roll_emotes.dm. */
const MAX_DICE = 20;
const MAX_SIDES = 100;
/** A roll shows one throw, a contest shows one per side. */
const MAX_THROWS = 4;
/** Dice up to this many sides are drawn with pips, anything larger is numbered. */
const MAX_PIP_SIDES = 6;
/** Dice with at least this many sides are drawn as an icosahedron, a d20 seen face-on. */
const MIN_ICOSAHEDRON_SIDES = 20;

type Outcome = 'good' | 'bad' | 'neutral';

/** The stats a throw can be made with. Each has its own colour in RollTooltip.scss. */
const STATS = new Set([
  'strength',
  'perception',
  'intelligence',
  'constitution',
  'willpower',
  'speed',
  'fortune',
  'charisma',
]);

type RollTooltipProps = {
  /** Faces thrown, dash separated, e.g. `3-5-2`. Separate throws with `|`. Every prop arrives as a string. */
  dice?: string;
  /** One label per throw, separated by `|`, in the same order as `dice`. */
  labels?: string;
  sides?: string;
  outcome?: string;
  /** One outcome per throw, separated by `|`. A throw without one takes `outcome`. */
  outcomes?: string;
  /** One stat per throw, separated by `|`. Colours that throw's dice by its stat. */
  stats?: string;
  /** One footer per throw, separated by `|`, shown under a line below its dice. */
  footers?: string;
  /** Everything else worth saying about the roll. The dice are drawn here, so don't repeat them. */
  /** Empty when there is nothing else to say, and the chat renderer drops empty props. */
  html?: string;
  children?: React.ReactNode;
} & Omit<React.ComponentProps<typeof Tooltip>, 'content' | 'children'>;

/**
 * Turns the raw string into faces we are willing to draw. Anything that isn't a whole number
 * inside 1..sides is dropped rather than drawn, and there is a hard cap on how many we draw.
 */
const parseFaces = (dice: string, sides: number): number[] =>
  dice
    .split('-')
    .map((face) => Number.parseInt(face, 10))
    .filter((face) => Number.isInteger(face) && face >= 1 && face <= sides)
    .slice(0, MAX_DICE);

type Throw = {
  label?: string;
  faces: number[];
  outcome?: Outcome;
  stat?: string;
  footer?: string;
};

/** Pairs each throw with its label. A throw with nothing valid left in it is dropped. */
const parseThrows = (
  dice: string | undefined,
  labels: string | undefined,
  outcomes: string | undefined,
  stats: string | undefined,
  footers: string | undefined,
  sides: number,
): Throw[] => {
  if (!dice) {
    return [];
  }
  const labelList = labels ? labels.split('|') : [];
  const outcomeList = outcomes ? outcomes.split('|') : [];
  const statList = stats ? stats.split('|') : [];
  const footerList = footers ? footers.split('|') : [];
  return dice
    .split('|')
    .slice(0, MAX_THROWS)
    .map((group, i) => ({
      label: labelList[i] || undefined,
      outcome: outcomeList[i] ? parseOutcome(outcomeList[i]) : undefined,
      stat: STATS.has(statList[i]) ? statList[i] : undefined,
      footer: footerList[i] || undefined,
      faces: parseFaces(group, sides),
    }))
    .filter((roll) => roll.faces.length > 0);
};

const parseSides = (sides: string | undefined): number => {
  const parsed = Number.parseInt(sides ?? '', 10);
  if (!Number.isInteger(parsed)) {
    return 6;
  }
  return Math.min(Math.max(parsed, 2), MAX_SIDES);
};

const parseOutcome = (outcome: string | undefined): Outcome =>
  outcome === 'good' || outcome === 'bad' ? outcome : 'neutral';

export const RollTooltip = (props: RollTooltipProps) => {
  const {
    dice,
    labels,
    sides,
    outcome,
    outcomes,
    stats,
    footers,
    html,
    children,
    ...rest
  } = props;

  const sideCount = parseSides(sides);
  const throws = parseThrows(dice, labels, outcomes, stats, footers, sideCount);
  const outcomeClass = parseOutcome(outcome);

  const content = (
    <div className="RollTooltip">
      <div className="RollTooltip__throws">
        {throws.map((roll, i) => (
          // The list never reorders, so the index is the identity.
          // biome-ignore lint/suspicious/noArrayIndexKey: see above
          <div key={i} className="RollTooltip__throw">
            {roll.label && (
              <div
                className="RollTooltip__label"
                // eslint-disable-next-line react/no-danger
                dangerouslySetInnerHTML={{ __html: sanitizeHTML(roll.label) }}
              />
            )}
            <div className="RollTooltip__dice">
              {roll.faces.map((face, j) => (
                <Die
                  // biome-ignore lint/suspicious/noArrayIndexKey: faces repeat
                  key={j}
                  face={face}
                  sides={sideCount}
                  outcome={roll.outcome ?? outcomeClass}
                  stat={roll.stat}
                />
              ))}
            </div>
            {roll.footer && (
              <>
                <div className="RollTooltip__separator" />
                <div
                  className="RollTooltip__footer"
                  // eslint-disable-next-line react/no-danger
                  dangerouslySetInnerHTML={{ __html: sanitizeHTML(roll.footer) }}
                />
              </>
            )}
          </div>
        ))}
      </div>
      {/* eslint-disable-next-line react/no-danger */}
      <div dangerouslySetInnerHTML={{ __html: sanitizeHTML(html ?? '') }} />
    </div>
  );

  return (
    <Tooltip content={content} {...rest}>
      {children}
    </Tooltip>
  );
};

// Pip positions on the 100x100 face, as [x, y] pairs.
const PIPS: Record<number, [number, number][]> = {
  1: [[50, 50]],
  2: [
    [26, 26],
    [74, 74],
  ],
  3: [
    [26, 26],
    [50, 50],
    [74, 74],
  ],
  4: [
    [26, 26],
    [74, 26],
    [26, 74],
    [74, 74],
  ],
  5: [
    [26, 26],
    [74, 26],
    [50, 50],
    [26, 74],
    [74, 74],
  ],
  6: [
    [26, 26],
    [74, 26],
    [26, 50],
    [74, 50],
    [26, 74],
    [74, 74],
  ],
};

// An icosahedron seen face-on: a hexagon outline with the facing triangle in the middle. Each
// triangle corner runs out to the hexagon corners nearest it, which are the edges of the faces
// around the front one.
const ICOSAHEDRON_OUTLINE = '50,4 91,27 91,73 50,96 9,73 9,27';
/** Where the front triangle's middle is - the number is centred on it, not on the hexagon. */
const ICOSAHEDRON_CENTRE_Y = 53;
const ICOSAHEDRON_FRONT = '50,16 82,71 18,71';
const ICOSAHEDRON_EDGES =
  'M50 16 L50 4 M50 16 L9 27 M50 16 L91 27 ' +
  'M18 71 L9 27 M18 71 L9 73 M18 71 L50 96 ' +
  'M82 71 L91 27 M82 71 L91 73 M82 71 L50 96';

type DieProps = {
  face: number;
  sides: number;
  outcome: Outcome;
  stat?: string;
};

const Die = (props: DieProps) => {
  const { face, sides, outcome, stat } = props;
  const icosahedron = sides >= MIN_ICOSAHEDRON_SIDES;
  const pips = sides > MAX_PIP_SIDES ? undefined : PIPS[face];

  return (
    <svg
      className={classes([
        'RollTooltip__die',
        // An stat's colour wins over the outcome's, so a failed throw is dimmed instead.
        `RollTooltip__die--${stat ?? outcome}`,
        stat && outcome === 'bad' && 'RollTooltip__die--dim',
      ])}
      viewBox="0 0 100 100"
      width={icosahedron ? '76px' : '48px'}
      height={icosahedron ? '76px' : '48px'}
    >
      <title>{face}</title>
      {icosahedron ? (
        <>
          <polygon className="die-bg" points={ICOSAHEDRON_OUTLINE} />
          <polygon className="die-front" points={ICOSAHEDRON_FRONT} />
          <path className="die-edge" d={ICOSAHEDRON_EDGES} />
        </>
      ) : (
        <rect className="die-bg" x="2" y="2" width="96" height="96" />
      )}
      {pips ? (
        pips.map(([x, y]) => (
          <circle key={`${x}-${y}`} className="die-pip" cx={x} cy={y} />
        ))
      ) : (
        <text
          className={classes([
            'die-number',
            icosahedron && 'die-number--icosahedron',
            face >= 100 && 'die-number--long',
          ])}
          x="50"
          y={icosahedron ? ICOSAHEDRON_CENTRE_Y : 50}
          // Lowered by a share of its own height rather than trusting `dominant-baseline`, which the
          // chat's font does not honour evenly. 0.35em is the middle of a digit.
          dy="0.35em"
        >
          {face}
        </text>
      )}
    </svg>
  );
};
