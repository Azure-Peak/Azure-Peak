import { type CSSProperties, useEffect, useMemo, useState } from 'react';
import { Box, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  INK,
  INK_FAINT,
  INK_SOFT,
  rulerStyle,
  SERIF,
  titleStyle,
} from './common/parchment';
import { RecipeBookEntry } from './RecipeBookEntry';
import { RecipeBookSidebar } from './RecipeBookSidebar';

const ROMAN = [
  '',
  'I',
  'II',
  'III',
  'IV',
  'V',
  'VI',
  'VII',
  'VIII',
  'IX',
  'X',
  'XI',
  'XII',
  'XIII',
  'XIV',
  'XV',
  'XVI',
  'XVII',
  'XVIII',
  'XIX',
  'XX',
];

const chapterRowStyle: CSSProperties = {
  display: 'flex',
  alignItems: 'baseline',
  gap: '14px',
  width: '100%',
  textAlign: 'left',
  background: 'transparent',
  border: 'none',
  borderBottom: `1px dashed ${INK_FAINT}`,
  padding: '10px 12px',
  fontFamily: SERIF,
  fontSize: '17px',
  color: INK,
  cursor: 'pointer',
  whiteSpace: 'normal',
  lineHeight: 1.35,
};

const chapterNumeralStyle: CSSProperties = {
  color: INK_SOFT,
  minWidth: '48px',
  textAlign: 'right',
  flexShrink: 0,
};

const libraryHeadingStyle: CSSProperties = {
  fontFamily: SERIF,
  fontSize: '20px',
  fontWeight: 'bold',
  color: INK,
  textAlign: 'center',
  letterSpacing: '2px',
  marginTop: '20px',
  marginBottom: '8px',
};

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
  initial_category?: string;
};

export const RecipeBook = () => {
  const { data } = useBackend<RecipeBookData>();

  return (
    <Window
      width={1150}
      height={810}
      theme="parchment"
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
      <Box style={{ padding: '20px 36px 28px 36px' }}>
        <Box style={titleStyle}>Encyclop&aelig;dia Azurea</Box>
        <hr style={rulerStyle} />
        {guides.length > 0 && (
          <>
            <Box style={libraryHeadingStyle}>Guides</Box>
            <Box
              style={{
                display: 'grid',
                gridTemplateColumns: '1fr 1fr',
                columnGap: '36px',
              }}
            >
              {guides.map((book, idx) => (
                <button
                  key={book.path}
                  type="button"
                  className="toc-link"
                  style={chapterRowStyle}
                  onClick={() => act('open_book', { path: book.path })}
                >
                  <span style={chapterNumeralStyle}>{ROMAN[idx + 1]}.</span>
                  <span>{book.wiki_name}</span>
                </button>
              ))}
            </Box>
          </>
        )}
        {recipes.length > 0 && (
          <>
            <Box style={{ ...libraryHeadingStyle, marginTop: '32px' }}>
              Crafting Recipes
            </Box>
            <Box
              style={{
                display: 'grid',
                gridTemplateColumns: '1fr 1fr',
                columnGap: '36px',
              }}
            >
              {recipes.map((book, idx) => (
                <button
                  key={book.path}
                  type="button"
                  className="toc-link"
                  style={chapterRowStyle}
                  onClick={() => act('open_book', { path: book.path })}
                >
                  <span style={chapterNumeralStyle}>{ROMAN[idx + 1]}.</span>
                  <span>{book.wiki_name}</span>
                </button>
              ))}
            </Box>
          </>
        )}
      </Box>
    </Section>
  );
};

const BookPage = () => {
  const { data, act } = useBackend<RecipeBookData>();
  const [category, setCategory] = useState(data.initial_category || 'All');

  useEffect(() => {
    setCategory(data.initial_category || 'All');
  }, [data.current_book, data.initial_category]);

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
