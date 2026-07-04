import { memo, useMemo, useState } from 'react';
import { Box, Section, Stack } from 'tgui-core/components';

import {
  INK_SOFT,
  inkButtonStyle,
  inkInputStyle,
  tocLinkStyle,
} from './common/parchment';

type RecipeEntry = {
  name: string;
  path: string;
  category: string;
};

type Props = {
  recipes: RecipeEntry[];
  categories: string[];
  category: string;
  selectedRecipe: string | null;
  onCategoryChange: (value: string) => void;
  onSelectRecipe: (path: string) => void;
  onBack: () => void;
};

export const RecipeBookSidebar = memo((props: Props) => {
  const {
    recipes,
    categories,
    category,
    selectedRecipe,
    onCategoryChange,
    onSelectRecipe,
    onBack,
  } = props;

  const [search, setSearch] = useState('');

  const filtered = useMemo(() => {
    const query = search.toLowerCase();
    const seen = new Set<string>();
    return recipes.filter((r) => {
      const matchCat = category === 'All' || r.category === category;
      const matchSearch = !query || (r.name && r.name.toLowerCase().includes(query));
      if (!matchCat || !matchSearch) return false;
      if (category === 'All') {
        if (seen.has(r.path)) return false;
        seen.add(r.path);
      }
      return true;
    });
  }, [recipes, search, category]);

  const hasCategories = categories.length > 1;

  return (
    <Stack fill>
      {hasCategories && (
        <Stack.Item style={{ overflow: 'auto', minWidth: '140px' }}>
          <Stack vertical fill>
            <Stack.Item grow basis={0} style={{ overflow: 'auto' }}>
              <Section fill scrollable title="Filter">
                {categories.map((cat) => {
                  const active = category === cat;
                  return (
                    <button
                      key={cat}
                      type="button"
                      className="toc-link"
                      style={tocLinkStyle(active)}
                      onClick={() => onCategoryChange(cat)}
                    >
                      {cat}
                    </button>
                  );
                })}
              </Section>
            </Stack.Item>
            <Stack.Item style={{ flexShrink: 0, marginTop: '6px', marginBottom: '6px' }}>
              <button
                type="button"
                style={{
                  ...inkButtonStyle(),
                  width: '100%',
                  textAlign: 'center',
                }}
                onClick={onBack}
              >
                &larr; Library
              </button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      )}
      <Stack.Item grow basis={0}>
        <Stack vertical fill>
          <Stack.Item grow basis={0} style={{ overflow: 'auto' }}>
            <Section fill scrollable title="Entries">
              {filtered.length === 0 ? (
                <Box textAlign="center" style={{ color: INK_SOFT }}>
                  No matching entries found.
                </Box>
              ) : (
                filtered.map((recipe) => {
                  const active = selectedRecipe === recipe.path;
                  return (
                    <button
                      key={recipe.path}
                      type="button"
                      className="toc-link"
                      style={tocLinkStyle(active)}
                      onClick={() => onSelectRecipe(recipe.path)}
                    >
                      {recipe.name}
                    </button>
                  );
                })
              )}
            </Section>
          </Stack.Item>
          <Stack.Item style={{ flexShrink: 0, marginTop: '6px', marginBottom: '6px' }}>
            <input
              type="text"
              placeholder="Search..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              style={{
                ...inkInputStyle,
                width: '100%',
                boxSizing: 'border-box',
                padding: '6px 8px',
              }}
            />
          </Stack.Item>
          {!hasCategories && (
            <Stack.Item style={{ flexShrink: 0, marginTop: '6px', marginBottom: '6px' }}>
              <button
                type="button"
                style={{
                  ...inkButtonStyle(),
                  width: '100%',
                  textAlign: 'center',
                }}
                onClick={onBack}
              >
                &larr; Back to Library
              </button>
            </Stack.Item>
          )}
        </Stack>
      </Stack.Item>
    </Stack>
  );
});
