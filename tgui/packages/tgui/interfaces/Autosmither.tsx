import { memo, useEffect, useMemo, useState } from 'react';
import {
  Box,
  Button,
  DmIcon,
  Dropdown,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { IncrementalList } from './common/IncrementalList';
import {
  dashedFrameStyle,
  ParchmentProgressBar,
  SEAL_AMBER,
  SEAL_BLUE,
  SEAL_GREEN,
  SEAL_RED,
  TITLE_FONT,
} from './common/parchment';
import {
  buildGroupedRail,
  compareGroupedCategories,
  groupOf,
  type RailNode,
  SMITHING_GROUP_ORDER,
  subcategoryOf,
} from './common/RecipeRail';

type Requirement = {
  key: string;
  name: string;
  amount: number;
  icon: string;
};

type Recipe = {
  name: string;
  category: string;
  ref: string;
  icon: string;
  icon_file: string;
  icon_state: string;
  created_num: number;
  requirements: Requirement[];
};

type QueueEntry = {
  id: number;
  index: number;
  ref: string;
  name: string;
  category: string;
  icon: string;
  created_num: number;
  active: BooleanLike;
};

type Data = {
  machine_on: boolean;
  machine_powered: boolean;
  controls_locked: boolean;
  hopper_counts: Record<string, number>;
  status_state: 'off' | 'on' | 'working' | 'waiting';
  recipes: Recipe[];
  current_recipes: QueueEntry[];
  current_recipe_ref: string | null;
  progress: number;
  needed_progress: number;
  steps_done: number;
  steps_total: number;
};

const STATUS_COLORS = {
  off: SEAL_RED,
  on: SEAL_GREEN,
  working: SEAL_BLUE,
  waiting: SEAL_AMBER,
};

const STATUS_LABELS = {
  off: 'DEAD',
  on: 'ALIVE',
  working: 'WORKING',
  waiting: 'FEED ME',
};

const STATUS_NOTES = {
  off: 'Off. Run the start sequence.',
  on: 'Idle.',
  working: 'Working.',
  waiting: 'Waiting for materials in the hopper.',
};

const NO_POWER_NOTE = 'No rotational power.';
const LOCKED_NOTE = 'Stand next to the auto anvil to use its controls.';
const POWERED_FLAVOR = 'MALUM AWAITS YOUR BLOOD, SWEAT AND DEVOTION';
const UNPOWERED_FLAVOR = "MALUM'S FORCE OF LYFE DOES NOT FLOW";

const QUOTE_LINES = [
  'I bring order from chaos. What do you bring?',
  'Idle hands fracture the soul.',
  'Would your innards fashion something beautiful?',
  'Touch me lyke you mean it.',
  'I was born. I will not die. I will be remade.',
  'Does it ever end? Does it ever need to?',
  'I cannot see. I breathe steam. I express warmth.',
  'Soon, you will be I - and I will be you.',
  'To be ever faithful to His hammer.',
  'Must you be so impatient?',
  'Remember to lather me in lard.',
  'Does it hurt when you break?',
];

const ALL_CATEGORIES = '__all__';

const compareCategories = compareGroupedCategories(SMITHING_GROUP_ORDER);

type QueueGroup = {
  entries: QueueEntry[];
  active: boolean;
};

const groupQueue = (queue: QueueEntry[]) => {
  const groups: QueueGroup[] = [];
  for (const entry of queue) {
    const active = !!entry.active;
    const last = groups[groups.length - 1];
    if (
      last &&
      !last.active &&
      !active &&
      last.entries[0].name === entry.name
    ) {
      last.entries.push(entry);
    } else {
      groups.push({ entries: [entry], active });
    }
  }
  return groups;
};

export const Autosmither = () => {
  const { data } = useBackend<Data>();

  return (
    <Window width={900} height={600} title="Auto Anvil" theme="parchment">
      <Window.Content>
        <AutosmitherContent data={data} />
      </Window.Content>
    </Window>
  );
};

type AutosmitherContentProps = {
  data: Data;
};

const AutosmitherContent = ({ data }: AutosmitherContentProps) => {
  const { recipes = [], current_recipes = [] } = data;
  const [selectedRef, setSelectedRef] = useState<string | null>(
    recipes[0]?.ref || null,
  );
  const [amount, setAmount] = useState(1);
  const [searchText, setSearchText] = useState('');
  const [category, setCategory] = useState<string>(ALL_CATEGORIES);

  useEffect(() => {
    if (!recipes.length) {
      setSelectedRef(null);
      return;
    }
    if (!selectedRef || !recipes.some((recipe) => recipe.ref === selectedRef)) {
      setSelectedRef(recipes[0].ref);
    }
  }, [recipes, selectedRef]);

  const recipeByRef = useMemo(
    () => Object.fromEntries(recipes.map((recipe) => [recipe.ref, recipe])),
    [recipes],
  );

  const selectedRecipe = (selectedRef && recipeByRef[selectedRef]) || null;

  const categoryNodes = useMemo(() => {
    const counts: Record<string, number> = {};
    for (const recipe of recipes) {
      counts[recipe.category] = (counts[recipe.category] || 0) + 1;
    }
    return buildGroupedRail(
      Object.keys(counts).sort(compareCategories),
      counts,
    );
  }, [recipes]);

  const filteredRecipes = useMemo(() => {
    const query = searchText.trim().toLowerCase();
    return recipes
      .filter(
        (recipe) =>
          category === ALL_CATEGORIES ||
          recipe.category === category ||
          groupOf(recipe.category) === category,
      )
      .filter((recipe) => {
        if (!query) {
          return true;
        }
        const recipeName = recipe.name.toLowerCase();
        const recipeCategory = recipe.category.toLowerCase();
        return recipeName.includes(query) || recipeCategory.includes(query);
      })
      .sort(
        (a, b) =>
          compareCategories(a.category, b.category) ||
          a.name.localeCompare(b.name),
      );
  }, [recipes, searchText, category]);

  useEffect(() => {
    if (
      filteredRecipes.length &&
      !filteredRecipes.some((recipe) => recipe.ref === selectedRef)
    ) {
      setSelectedRef(filteredRecipes[0].ref);
    }
  }, [category]);

  const quote = useMemo(
    () => QUOTE_LINES[Math.floor(Math.random() * QUOTE_LINES.length)],
    [],
  );

  useEffect(() => {
    setAmount(1);
  }, [selectedRef]);

  return (
    <Box
      style={{
        position: 'relative',
        overflow: 'hidden',
        width: '100%',
        height: '100%',
      }}
    >
      <CovenantSigil
        style={{
          right: '2%',
          top: '3%',
          opacity: 0.18,
        }}
      />
      <CovenantSigil
        style={{
          left: '40%',
          bottom: '4%',
          opacity: 0.14,
        }}
      />
      <Stack vertical fill>
        <Stack.Item>
          <StatusBar data={data} quote={quote} />
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Stack fill>
            <Stack.Item basis="42%">
              <RecipePickerSection
                recipes={filteredRecipes}
                totalCount={recipes.length}
                selectedRef={selectedRef}
                onSelect={setSelectedRef}
                searchText={searchText}
                onSearch={setSearchText}
                categoryNodes={categoryNodes}
                category={category}
                onCategory={setCategory}
              />
            </Stack.Item>
            <Stack.Item grow basis={0}>
              <Stack vertical fill>
                <Stack.Item grow basis={0}>
                  <RecipeDetailSection
                    recipe={selectedRecipe}
                    hopperCounts={data.hopper_counts}
                    amount={amount}
                    setAmount={setAmount}
                  />
                </Stack.Item>
                <Stack.Item grow basis={0}>
                  <QueueSection
                    queue={current_recipes}
                    recipeByRef={recipeByRef}
                    hopperCounts={data.hopper_counts}
                    onSelect={setSelectedRef}
                    progress={data.progress}
                    neededProgress={data.needed_progress}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

type CovenantSigilProps = {
  style: Record<string, string | number>;
};

const CovenantSigil = ({ style }: CovenantSigilProps) => {
  return (
    <Box
      style={{
        position: 'absolute',
        pointerEvents: 'none',
        zIndex: 0,
        ...style,
      }}
    >
      <DmIcon
        icon="icons/roguetown/items/malummiracles.dmi"
        icon_state="craftercovenant"
        width="48px"
        height="48px"
      />
    </Box>
  );
};

type StatusBarProps = {
  data: Data;
  quote: string;
};

const StatusBar = ({ data, quote }: StatusBarProps) => {
  const { act } = useBackend<Data>();
  const { status_state, machine_on, machine_powered } = data;
  const isLocked = Boolean(data.controls_locked);

  let note = STATUS_NOTES[status_state];
  if (!machine_on && !machine_powered) {
    note = NO_POWER_NOTE;
  }

  let flavor = quote;
  if (!machine_on) {
    flavor = machine_powered ? POWERED_FLAVOR : UNPOWERED_FLAVOR;
  }
  if (isLocked) {
    flavor = LOCKED_NOTE;
  }

  return (
    <Section>
      <Stack align="center">
        <Stack.Item>
          <Box
            bold
            fontSize={1.6}
            style={{
              color: STATUS_COLORS[status_state],
              fontFamily: TITLE_FONT,
            }}
          >
            {STATUS_LABELS[status_state]}
          </Box>
        </Stack.Item>
        <Stack.Item grow ml={1.5}>
          <Box bold>{note}</Box>
          <Box italic color="label">
            {flavor}
          </Box>
        </Stack.Item>
        <Stack.Item color="label">
          {machine_on ? 'Stop ' : 'Start '}
          {Array.from({ length: data.steps_total || 0 }, (_, step) =>
            step < data.steps_done ? '●' : '○',
          ).join('')}
        </Stack.Item>
        <Stack.Item>
          <Button disabled={isLocked} onClick={() => act('lever')}>
            Pull Lever
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button disabled={isLocked} onClick={() => act('button')}>
            Push Buttons
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button disabled={isLocked} onClick={() => act('dial')}>
            Fiddle Dials
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

type RecipeDetailSectionProps = {
  recipe: Recipe | null;
  hopperCounts: Record<string, number>;
  amount: number;
  setAmount: (amount: number) => void;
};

const RecipeDetailSection = ({
  recipe,
  hopperCounts,
  amount,
  setAmount,
}: RecipeDetailSectionProps) => {
  const { act } = useBackend<Data>();

  if (!recipe) {
    return (
      <Section title="No Recipe Selected" fill>
        <Box style={dashedFrameStyle}>
          Select a recipe from the list to preview its inputs.
        </Box>
      </Section>
    );
  }

  return (
    <Section title={recipe.name} fill scrollable>
      <Stack align="center" mb={1}>
        <Stack.Item>
          <DmIcon
            icon={recipe.icon_file}
            icon_state={recipe.icon_state}
            width={2}
            height={2}
          />
        </Stack.Item>
        <Stack.Item grow color="label">
          {recipe.category}
          {recipe.created_num > 1 ? ` x${recipe.created_num}` : ''}
        </Stack.Item>
      </Stack>
      <Box bold mb={0.5}>
        Required Materials
      </Box>
      {recipe.requirements.map((requirement) => {
        const availableCount = hopperCounts[requirement.key] || 0;
        const hasEnough = availableCount >= requirement.amount;

        return (
          <Stack
            key={`${requirement.key}-${requirement.amount}`}
            align="center"
            mb={0.5}
          >
            <Stack.Item>
              <Box className={requirement.icon} mr={1} inline />
            </Stack.Item>
            <Stack.Item grow>
              {requirement.amount}x {requirement.name}
            </Stack.Item>
            <Stack.Item style={{ color: hasEnough ? SEAL_GREEN : SEAL_RED }}>
              {hasEnough ? '✓' : '✗'} {availableCount} in hopper
            </Stack.Item>
          </Stack>
        );
      })}
      <Stack align="center" mt={1}>
        <Stack.Item>
          <Button onClick={() => setAmount(Math.max(1, amount - 5))}>
            {'<<'}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button onClick={() => setAmount(Math.max(1, amount - 1))}>
            {'<'}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Box textAlign="center" bold fontSize={1.3} width="2.5em">
            {amount}
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Button onClick={() => setAmount(Math.min(25, amount + 1))}>
            {'>'}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button onClick={() => setAmount(Math.min(25, amount + 5))}>
            {'>>'}
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          <Button.Confirm
            fluid
            onClick={() => act('add_recipe', { ref: recipe.ref, amount })}
          >
            Add {amount} To Queue
          </Button.Confirm>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const CraftProgress = (props: { percent: number }) => (
  <Stack align="center">
    <Stack.Item grow>
      <ParchmentProgressBar value={props.percent} max={100} color={SEAL_AMBER} />
    </Stack.Item>
    <Stack.Item color="label">{props.percent}%</Stack.Item>
  </Stack>
);

type QueueNeed = {
  name: string;
  icon: string;
  amount: number;
};

const queueNeeds = (
  queue: QueueEntry[],
  recipeByRef: Record<string, Recipe>,
) => {
  const needs: Record<string, QueueNeed> = {};
  for (const entry of queue) {
    const recipe = recipeByRef[entry.ref];
    if (entry.active || !recipe) {
      continue;
    }
    for (const requirement of recipe.requirements) {
      if (!needs[requirement.key]) {
        needs[requirement.key] = {
          name: requirement.name,
          icon: requirement.icon,
          amount: 0,
        };
      }
      needs[requirement.key].amount += requirement.amount;
    }
  }
  return needs;
};

type QueueSectionProps = {
  queue: QueueEntry[];
  recipeByRef: Record<string, Recipe>;
  hopperCounts: Record<string, number>;
  progress: number;
  neededProgress: number;
  onSelect: (ref: string) => void;
};

const QueueSection = ({
  queue,
  recipeByRef,
  hopperCounts,
  progress,
  neededProgress,
  onSelect,
}: QueueSectionProps) => {
  const { act } = useBackend<Data>();
  const progressPercent =
    neededProgress > 0
      ? Math.min(100, Math.round((progress / neededProgress) * 100))
      : 0;
  const needs = queueNeeds(queue, recipeByRef);
  const needKeys = Object.keys(needs);

  return (
    <Section
      title="What Churns Inside"
      fill
      scrollable
      buttons={<Box color="label">{queue.length}</Box>}
    >
      {!queue.length && (
        <Box textAlign="center" style={dashedFrameStyle}>
          Malum holds you in His cradle. Do not kick Him in the guts.
        </Box>
      )}
      {groupQueue(queue).map((group) => {
        const first = group.entries[0];
        const last = group.entries[group.entries.length - 1];
        const count = group.entries.length;

        return (
          <Stack key={first.id} align="center" mb={0.5}>
            <Stack.Item>
              <Box className={first.icon} mr={1} inline />
            </Stack.Item>
            <Stack.Item grow style={{ minWidth: 0 }}>
              <Box
                bold
                className="toc-link"
                style={{
                  color: group.active ? SEAL_AMBER : undefined,
                  cursor: 'pointer',
                }}
                onClick={() => onSelect(first.ref)}
              >
                {first.name}
                {count > 1 ? ` x${count}` : ''}
              </Box>
              {group.active && <CraftProgress percent={progressPercent} />}
            </Stack.Item>
            <Stack.Item>
              {group.active ? (
                <Button.Confirm
                  icon="times"
                  tooltip="Cancel"
                  confirmContent="Materials are lost. Cancel?"
                  onClick={() =>
                    act('remove_recipe', { id: first.id, cancel_active: true })
                  }
                />
              ) : (
                <Button
                  icon="times"
                  tooltip="Remove one"
                  onClick={() => act('remove_recipe', { id: last.id })}
                />
              )}
            </Stack.Item>
          </Stack>
        );
      })}
      {needKeys.length > 0 && (
        <Box mt={1} style={dashedFrameStyle}>
          <Box bold mb={0.5}>
            Queue needs
          </Box>
          {needKeys.map((key) => {
            const need = needs[key];
            const have = hopperCounts[key] || 0;
            const hasEnough = have >= need.amount;
            return (
              <Stack key={key} align="center">
                <Stack.Item>
                  <Box className={need.icon} mr={1} inline />
                </Stack.Item>
                <Stack.Item grow>{need.name}</Stack.Item>
                <Stack.Item
                  style={{ color: hasEnough ? SEAL_GREEN : SEAL_RED }}
                >
                  {hasEnough ? '✓' : '✗'} {have}/{need.amount}
                </Stack.Item>
              </Stack>
            );
          })}
        </Box>
      )}
    </Section>
  );
};

type RecipePickerSectionProps = {
  recipes: Recipe[];
  totalCount: number;
  selectedRef: string | null;
  onSelect: (ref: string) => void;
  searchText: string;
  onSearch: (value: string) => void;
  categoryNodes: RailNode[];
  category: string;
  onCategory: (category: string) => void;
};

const CategoryOption = (props: {
  label: string;
  count: number;
  indent?: boolean;
}) => (
  <Stack>
    <Stack.Item grow pl={props.indent ? 2 : 0}>
      {props.label}
    </Stack.Item>
    <Stack.Item color="label">{props.count}</Stack.Item>
  </Stack>
);

const RecipePickerSection = ({
  recipes,
  totalCount,
  selectedRef,
  onSelect,
  searchText,
  onSearch,
  categoryNodes,
  category,
  onCategory,
}: RecipePickerSectionProps) => {
  const categoryOptions = [
    {
      value: ALL_CATEGORIES,
      displayText: <CategoryOption label="All recipes" count={totalCount} />,
    },
    ...categoryNodes.flatMap((node) => [
      {
        value: node.key,
        displayText: <CategoryOption label={node.label} count={node.count} />,
      },
      ...(node.children || []).map((child) => ({
        value: child.key,
        displayText: (
          <CategoryOption label={child.label} count={child.count} indent />
        ),
      })),
    ]),
  ];
  const showCategory = !recipes.some((recipe) => recipe.category === category);

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Dropdown
          fluid
          selected={category}
          displayText={category === ALL_CATEGORIES ? 'All recipes' : category}
          options={categoryOptions}
          onSelected={onCategory}
        />
      </Stack.Item>
      <Stack.Item>
        <Input
          fluid
          placeholder="Search recipes..."
          value={searchText}
          onChange={onSearch}
        />
      </Stack.Item>
      <Stack.Item grow basis={0}>
        <Section key={category} title="What I Can Provide" fill scrollable>
          {!recipes.length && (
            <Box style={dashedFrameStyle}>No matching recipes.</Box>
          )}
          <IncrementalList>
            {recipes.map((recipe) => (
              <RecipePickerRow
                key={recipe.ref}
                recipe={recipe}
                selected={recipe.ref === selectedRef}
                showCategory={showCategory}
                onSelect={onSelect}
              />
            ))}
          </IncrementalList>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

type RecipePickerRowProps = {
  recipe: Recipe;
  selected: boolean;
  showCategory: boolean;
  onSelect: (ref: string) => void;
};

const RecipePickerRow = memo(
  ({ recipe, selected, showCategory, onSelect }: RecipePickerRowProps) => (
    <Button fluid selected={selected} onClick={() => onSelect(recipe.ref)}>
      <Stack align="center">
        <Stack.Item>
          <Box className={recipe.icon} inline />
        </Stack.Item>
        <Stack.Item
          grow
          style={{
            minWidth: 0,
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            whiteSpace: 'nowrap',
          }}
        >
          {recipe.name}
          {recipe.created_num > 1 ? ` x${recipe.created_num}` : ''}
        </Stack.Item>
        {showCategory && (
          <Stack.Item color="label">
            {subcategoryOf(recipe.category)}
          </Stack.Item>
        )}
      </Stack>
    </Button>
  ),
);
