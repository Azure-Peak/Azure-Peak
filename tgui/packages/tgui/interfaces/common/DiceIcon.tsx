/**
 * SPDX-License-Identifier: MIT
 */

// Dice drawn face-on in a 100 x 100 box. The chat's roll tooltip draws from the same shapes.
export type DiceShape = {
  outline: string;
  /** The facing polygon in the middle, where there is one. */
  front?: string;
  /** Edges running from the front face out to the outline. */
  edges?: string;
  /** Drawn in place of `outline` when the outline has curves. */
  outlinePath?: string;
  /** Where the label is centred. */
  labelY: number;
};

// One size for every die, smaller for three digits so a 100 stays inside the shape.
const LABEL_SIZE = 26;
const LABEL_SIZE_LONG = 20;

/** Faces of the dice that have a shape of their own. */
export const DICE_SIDES = [4, 6, 8, 10, 12, 20, 100] as const;

const SHAPES: Record<number, DiceShape> = {
  4: {
    outline: '50,6 95,88 5,88',
    labelY: 50,
  },
  6: {
    outline: '6,6 94,6 94,94 6,94',
    outlinePath:
      'M22 6 H78 Q94 6 94 22 V78 Q94 94 78 94 H22 Q6 94 6 78 V22 Q6 6 22 6 Z',
    labelY: 50,
  },
  8: {
    outline: '50,4 91,27 91,73 50,96 9,73 9,27',
    front: '9,27 91,27 50,96',
    labelY: 50,
  },
  // Pentagonal trapezohedron: a long kite with a short straight stretch around its middle.
  10: {
    outline: '50,3 84,32 84,48 50,97 16,48 16,32',
    edges:
      'M50 3 L50 30 M16 32 L33 52 M84 32 L67 52 M50 30 L33 52 M50 30 L67 52 M33 52 L50 97 M67 52 L50 97',
    labelY: 50,
  },
  12: {
    outline:
      '50,4 77,12.8 93.8,35.8 93.8,64.2 77,87.2 50,96 23,87.2 6.2,64.2 6.2,35.8 23,12.8',
    front: '50,28 70.9,43.2 62.9,67.8 37.1,67.8 29.1,43.2',
    edges:
      'M50 28 L50 4 M70.9 43.2 L93.8 35.8 M62.9 67.8 L77 87.2 M37.1 67.8 L23 87.2 M29.1 43.2 L6.2 35.8',
    labelY: 50,
  },
  20: {
    outline: '50,4 91,27 91,73 50,96 9,73 9,27',
    front: '50,16 82,71 18,71',
    edges:
      'M50 16 L50 4 M50 16 L9 27 M50 16 L91 27 ' +
      'M18 71 L9 27 M18 71 L9 73 M18 71 L50 96 ' +
      'M82 71 L91 27 M82 71 L91 73 M82 71 L50 96',
    labelY: 50,
  },
};

/**
 * A number of faces without a die of its own takes the nearest die above it, so a d7 is a d8 and a
 * d30 a d20. A d100 is a d10.
 */
export function diceShape(sides: number): DiceShape {
  if (sides === 100) {
    return SHAPES[10];
  }
  const nearest = [4, 6, 8, 10, 12, 20].find((faces) => sides <= faces);
  return SHAPES[nearest ?? 20];
}

/** Font size for `text` on any die. */
export function diceLabelSize(text: string) {
  return text.length >= 3 ? LABEL_SIZE_LONG : LABEL_SIZE;
}

type Props = {
  sides: number;
  /** Defaults to the number of faces. */
  label?: string;
  size?: number;
};

export function DiceIcon(props: Props) {
  const { sides, label, size = 44 } = props;
  const shape = diceShape(sides);
  const text = label ?? String(sides);

  return (
    <svg
      className="DiceIcon"
      viewBox="0 0 100 100"
      width={size}
      height={size}
      aria-hidden="true"
    >
      {shape.outlinePath ? (
        <path className="DiceIcon__outline" d={shape.outlinePath} />
      ) : (
        <polygon className="DiceIcon__outline" points={shape.outline} />
      )}
      {shape.front && <polygon className="DiceIcon__edge" points={shape.front} />}
      {shape.edges && <path className="DiceIcon__edge" d={shape.edges} />}
      <text
        className="DiceIcon__label"
        x="50"
        y={shape.labelY}
        // `dominant-baseline` isn't honoured evenly, so lower by the middle of a digit instead.
        dy="0.35em"
        fontSize={diceLabelSize(text)}
      >
        {text}
      </text>
    </svg>
  );
}
