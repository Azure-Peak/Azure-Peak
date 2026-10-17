/**
 * @file
 * @license MIT
 */

import { sanitizeHTML } from 'tgui/sanitize';
import { Tooltip } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { diceLabelSize, diceShape } from 'tgui/interfaces/common/DiceIcon';

/** Mirrors DICE_MAX_COUNT and DICE_MAX_SIDES in roll_emotes.dm. */
const MAX_DICE = 24;
const MAX_SIDES = 100;
/** A roll shows one throw, a contest shows one per side. */
const MAX_THROWS = 4;
/** Dice with at least this many sides are drawn larger. */
const MIN_LARGE_SIDES = 13;

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
  /** Everything else worth saying about the roll, which the chat renderer drops when empty. */
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
  sides: number;
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
  sides: number[],
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
      sides: sides[i] ?? sides[0],
      faces: parseFaces(group, sides[i] ?? sides[0]),
    }))
    .filter((roll) => roll.faces.length > 0);
};

/** One value applies to every throw, `|`-separated values give each throw its own die. */
const parseSides = (sides: string | undefined): number[] => {
  const parsed = (sides ?? '').split('|').slice(0, MAX_THROWS).map((side) => {
    const value = Number.parseInt(side, 10);
    if (!Number.isInteger(value)) {
      return 6;
    }
    return Math.min(Math.max(value, 2), MAX_SIDES);
  });
  return parsed.length ? parsed : [6];
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

  const throws = parseThrows(dice, labels, outcomes, stats, footers, parseSides(sides));
  const outcomeClass = parseOutcome(outcome);
  // One size for every die: the smallest any throw needs.
  const size = Math.min(
    ...throws.map((roll) => dieSize(roll.faces.length, roll.sides)),
  );

  const content = (
    <div className="RollTooltip">
      <div className="RollTooltip__throws">
        {throws.map((roll, i) => (
          // The list never reorders, so the index is the identity.
          // biome-ignore lint/suspicious/noArrayIndexKey: see above
          <div key={i} className="RollTooltip__throw">
            {/* Every throw fills all four grid rows, so a missing label or footer is an empty cell. */}
            <div
              className="RollTooltip__label"
              // eslint-disable-next-line react/no-danger
              dangerouslySetInnerHTML={{ __html: sanitizeHTML(roll.label ?? '') }}
            />
            <div
              className="RollTooltip__dice"
              style={
                roll.faces.length > FULL_SIZE_DICE
                  ? { maxWidth: DICE_PER_ROW * (size + DICE_GAP) }
                  : undefined
              }
            >
              {roll.faces.map((face, j) => (
                <Die
                  size={size}
                  // biome-ignore lint/suspicious/noArrayIndexKey: faces repeat
                  key={j}
                  face={face}
                  sides={roll.sides}
                  outcome={roll.outcome ?? outcomeClass}
                  stat={roll.stat}
                />
              ))}
            </div>
            <div className={roll.footer ? 'RollTooltip__separator' : undefined} />
            <div
              className="RollTooltip__footer"
              // eslint-disable-next-line react/no-danger
              dangerouslySetInnerHTML={{ __html: sanitizeHTML(roll.footer ?? '') }}
            />
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

/** A throw of this many dice or fewer is drawn at full size, past SMALL_SIZE_DICE at the smallest. */
const FULL_SIZE_DICE = 6;
const SMALL_SIZE_DICE = 12;
/** Dice per row once a throw is too big for full size. */
const DICE_PER_ROW = 6;
/** Mirrors the gap in RollTooltip.scss. */
const DICE_GAP = 4;

/** How wide a die is drawn, shrinking as a throw has more of them. */
const dieSize = (count: number, sides: number): number => {
  if (count > SMALL_SIZE_DICE) {
    return 34;
  }
  if (count > FULL_SIZE_DICE) {
    return 44;
  }
  return sides >= MIN_LARGE_SIDES ? 76 : 56;
};

type DieProps = {
  size: number;
  face: number;
  sides: number;
  outcome: Outcome;
  stat?: string;
};

const Die = (props: DieProps) => {
  const { size, face, sides, outcome, stat } = props;
  const shape = diceShape(sides);
  // Only a d5 and a d6 get pips.
  const pips = sides === 5 || sides === 6 ? PIPS[face] : undefined;
  const label = String(face);

  return (
    <svg
      className={classes([
        'RollTooltip__die',
        // An stat's colour wins over the outcome's, so a failed throw is dimmed instead.
        `RollTooltip__die--${stat ?? outcome}`,
        stat && outcome === 'bad' && 'RollTooltip__die--dim',
      ])}
      viewBox="0 0 100 100"
      width={size}
      height={size}
    >
      <title>{face}</title>
      {shape.outlinePath ? (
        <path className="die-bg" d={shape.outlinePath} />
      ) : (
        <polygon className="die-bg" points={shape.outline} />
      )}
      {!pips && shape.front && (
        <polygon className="die-front" points={shape.front} />
      )}
      {!pips && shape.edges && <path className="die-edge" d={shape.edges} />}
      {pips ? (
        pips.map(([x, y]) => (
          <circle key={`${x}-${y}`} className="die-pip" cx={x} cy={y} />
        ))
      ) : (
        <text
          className="die-number"
          x="50"
          y={shape.labelY}
          style={{ fontSize: diceLabelSize(label) }}
          // `dominant-baseline` isn't honoured evenly, so lower by the middle of a digit instead.
          dy="0.35em"
        >
          {label}
        </text>
      )}
    </svg>
  );
};
