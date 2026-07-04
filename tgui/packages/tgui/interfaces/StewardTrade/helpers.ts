// Display order and human labels for the TRADE_CATEGORY_* strings emitted by DM.

export const CATEGORY_ORDER: string[] = [
  'grain',
  'vegetable',
  'fruit',
  'animal',
  'seafood',
  'cloth',
  'artisan',
  'basic_mineral',
  'rare_metal',
  'precious_metal',
  'intermediary',
  'gem_common',
  'gem_rare',
  'gem_legendary',
  'Equipment',
  'misc',
];

export const CATEGORY_LABEL: Record<string, string> = {
  grain: 'Grains',
  vegetable: 'Vegetables',
  fruit: 'Fruits',
  animal: 'Animal Products',
  seafood: 'Seafood',
  cloth: 'Textiles',
  artisan: 'Artisan Raws',
  basic_mineral: 'Basic Minerals',
  rare_metal: 'Rare Metals',
  precious_metal: 'Precious Metals',
  intermediary: 'Intermediaries',
  gem_common: 'Common Gems',
  gem_rare: 'Rare Gems',
  gem_legendary: 'Legendary Gems',
  Equipment: 'Equipment',
  misc: 'Misc',
};

/// Group an array of rows by their category (looked up via good_catalog).
/// Returns an ordered list of { category, label, rows } preserving CATEGORY_ORDER.
export function groupByCategory<T extends { good_id: string }>(
  rows: T[],
  good_catalog: Record<string, { category: string }>,
): { category: string; label: string; rows: T[] }[] {
  const byCat: Record<string, T[]> = {};
  for (const row of rows) {
    const cat = good_catalog[row.good_id]?.category ?? 'misc';
    if (!byCat[cat]) byCat[cat] = [];
    byCat[cat].push(row);
  }
  const ordered = [
    ...CATEGORY_ORDER.filter((c) => byCat[c]?.length),
    ...Object.keys(byCat).filter((c) => !CATEGORY_ORDER.includes(c)),
  ];
  return ordered.map((category) => ({
    category,
    label: CATEGORY_LABEL[category] ?? category,
    rows: byCat[category],
  }));
}
