import { memo, useMemo, useState } from 'react';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';

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
        <Stack.Item style={{ overflow: 'auto', minWidth: '130px' }}>
          <Stack vertical fill>
            <Stack.Item grow basis={0} style={{ overflow: 'auto' }}>
              <Section fill scrollable title="Filter">
                <Stack vertical>
                  {categories.map((cat) => (
                    <Stack.Item key={cat}>
                      <Button
                        fluid
                        compact
                        selected={category === cat}
                        onClick={() => onCategoryChange(cat)}
                      >
                        {cat}
                      </Button>
                    </Stack.Item>
                  ))}
                </Stack>
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="arrow-left"
                onClick={onBack}
              >
                Library
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      )}
      <Stack.Item grow basis={0}>
        <Stack vertical fill>
          <Stack.Item grow basis={0} style={{ overflow: 'auto' }}>
            <Section fill scrollable title="Entries">
              {filtered.length === 0 ? (
                <Box italic color="label" textAlign="center">
                  No matching entries found.
                </Box>
              ) : (
                filtered.map((recipe) => (
                  <Button
                    key={recipe.path}
                    fluid
                    selected={selectedRecipe === recipe.path}
                    onClick={() => onSelectRecipe(recipe.path)}
                    style={{ whiteSpace: 'normal' }}
                  >
                    {recipe.name}
                  </Button>
                ))
              )}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Input
              fluid
              placeholder="Search..."
              value={search}
              onChange={(value) => setSearch(value)}
            />
          </Stack.Item>
          {!hasCategories && (
            <Stack.Item>
              <Button
                fluid
                icon="arrow-left"
                onClick={onBack}
              >
                Back to Library
              </Button>
            </Stack.Item>
          )}
        </Stack>
      </Stack.Item>
    </Stack>
  );
});
