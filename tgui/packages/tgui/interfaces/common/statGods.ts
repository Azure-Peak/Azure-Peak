/**
 * SPDX-License-Identifier: MIT
 */

// The god who watches over each stat. Their colours live in ContestResponse.scss.
const GOD_BY_STAT: Record<string, string> = {
  strength: 'ravox',
  perception: 'dendor',
  intelligence: 'noc',
  willpower: 'graggar',
  constitution: 'malum',
  speed: 'matthios',
  fortune: 'xylix',
  charisma: 'baotha',
};

/** The class that colours text by the god of `stat`, or nothing for anything that is not a stat. */
export function godClass(stat: string) {
  const god = GOD_BY_STAT[stat.toLowerCase()];
  return god ? `ContestResponse__God--${god}` : '';
}
