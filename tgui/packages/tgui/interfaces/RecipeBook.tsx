import { useMemo, useState } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { RecipeBookEntry } from './RecipeBookEntry';
import { RecipeBookSidebar } from './RecipeBookSidebar';

type BookEntry = {
  wiki_name: string;
  path: string;
  section: string;
};

type RecipeEntry = {
  name: string;
  path: string;
  category: string;
};

export type RecipeBookData = {
  books: BookEntry[];
  book_recipes: Record<string, RecipeEntry[]>;
  page: 'library' | 'book';
  current_book: string | null;
  current_book_title: string;
  current_recipe: string | null;
  recipe_detail_html: string;
};

export const RecipeBook = () => {
  const { data } = useBackend<RecipeBookData>();

  return (
    <Window
      width={1150}
      height={810}
      title={
        data.page === 'book' && data.current_book_title
          ? `Encyclopedia - ${data.current_book_title}`
          : 'Encyclopedia'
      }
    >
      <Window.Content>
        {data.page === 'book' && data.current_book ? (
          <BookPage />
        ) : (
          <LibraryPage />
        )}
      </Window.Content>
    </Window>
  );
};

const LibraryPage = () => {
  const { data, act } = useBackend<RecipeBookData>();
  const { books = [] } = data;

  const guides = useMemo(
    () => books.filter((b) => b.section === 'Guides'),
    [books],
  );
  const recipes = useMemo(
    () => books.filter((b) => b.section !== 'Guides'),
    [books],
  );

  return (
    <Section fill scrollable>
      <Box
        textAlign="center"
        fontSize={2.2}
        bold
        mb={2}
        pb={1}
        style={{
          borderBottom: '2px solid var(--section-title-color)',
          color: 'var(--section-title-color)',
        }}
      >
        Encyclop&aelig;dia Azurea
      </Box>
      {guides.length > 0 && (
        <>
          <Box bold fontSize={1.2} mb={1} mt={1}>
            Guides
          </Box>
          <Box
            style={{
              display: 'grid',
              gridTemplateColumns: '1fr 1fr',
              gap: '2px',
              alignItems: 'stretch',
            }}
          >
            {guides.map((book) => (
              <Button
                key={book.path}
                fluid
                style={{ height: '100%' }}
                onClick={() => act('open_book', { path: book.path })}
              >
                {book.wiki_name}
              </Button>
            ))}
          </Box>
        </>
      )}
      {recipes.length > 0 && (
        <>
          <Box bold fontSize={1.2} mb={1} mt={2}>
            Crafting Recipes
          </Box>
          <Box
            style={{
              display: 'grid',
              gridTemplateColumns: '1fr 1fr',
              gap: '2px',
              alignItems: 'stretch',
            }}
          >
            {recipes.map((book) => (
              <Button
                key={book.path}
                fluid
                style={{ height: '100%' }}
                onClick={() => act('open_book', { path: book.path })}
              >
                {book.wiki_name}
              </Button>
            ))}
          </Box>
        </>
      )}
    </Section>
  );
};

const BookPage = () => {
  const { data, act } = useBackend<RecipeBookData>();
  const [category, setCategory] = useState('All');

  const recipes = data.current_book
    ? (data.book_recipes[data.current_book] || [])
    : [];

  const categories = useMemo(() => {
    const cats = new Set<string>();
    cats.add('All');
    for (const r of recipes) {
      if (r.category) {
        cats.add(r.category);
      }
    }
    const arr = Array.from(cats);
    arr.sort((a, b) => {
      if (a === 'All') return -1;
      if (b === 'All') return 1;
      return a.localeCompare(b);
    });
    return arr;
  }, [recipes]);

  return (
    <Stack fill>
      <Stack.Item basis="30%">
        <RecipeBookSidebar
          recipes={recipes}
          categories={categories}
          category={category}
          selectedRecipe={data.current_recipe}
          onCategoryChange={setCategory}
          onSelectRecipe={(path) => act('view_recipe', { path })}
          onBack={() => act('back_to_library')}
        />
      </Stack.Item>
      <Stack.Item grow basis={0}>
        <RecipeBookEntry html={data.recipe_detail_html} />
      </Stack.Item>
    </Stack>
  );
};
