import { memo, useEffect, useMemo, useState } from 'react';
import {
  Box,
  Button,
  DmIcon,
  Dropdown,
  Input,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { IncrementalList } from './common/IncrementalList';
import {
  buildGroupedRail,
  compareGroupedCategories,
  groupOf,
  type RailNode,
  SMITHING_GROUP_ORDER,
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
  name: string;
  category: string;
  icon: string;
  created_num: number;
  active: boolean;
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
};

const STATUS_COLORS = {
  off: '#d14b43',
  on: '#58b76a',
  working: '#a46bff',
  waiting: '#d98b2b',
};

const STATUS_LABELS = {
  off: 'DEAD',
  on: 'ALIVE',
  working: 'WORKING',
  waiting: 'FEED ME',
};

const MACHINE_ACTIVITY_LABELS = {
  active: STATUS_LABELS.on,
  inactive: STATUS_LABELS.off,
};

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

const QUOTE_LINES_PER_RAIL = 2;

const ALL_CATEGORIES = '__all__';

const compareCategories = compareGroupedCategories(SMITHING_GROUP_ORDER);

const shuffleLines = (lines: string[]) => {
  const shuffled = [...lines];

  for (let index = shuffled.length - 1; index > 0; index--) {
    const swapIndex = Math.floor(Math.random() * (index + 1));
    const nextValue = shuffled[index];
    shuffled[index] = shuffled[swapIndex];
    shuffled[swapIndex] = nextValue;
  }

  return shuffled;
};

const getQuoteColumns = (lines: string[], linesPerRail: number) => {
  const shuffled = shuffleLines(lines);
  const visibleCount = Math.min(shuffled.length, linesPerRail * 2);
  const visibleLines = shuffled.slice(0, visibleCount);
  const midpoint = Math.ceil(visibleLines.length / 2);
  return [visibleLines.slice(0, midpoint), visibleLines.slice(midpoint)];
};

const getCategoryIconState = (category: string | null | undefined) => {
  const lowerCategory = (category || '').toLowerCase();
  if (lowerCategory.includes('weapon')) {
    return 'weapon';
  }
  if (lowerCategory.includes('armor')) {
    return 'armor';
  }
  return 'rework';
};

export const Autosmither = () => {
  const { data } = useBackend<Data>();

  return (
    <Window width={1100} height={620} title="Auto Anvil">
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
  const { recipes = [], current_recipes = [], machine_on } = data;
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

  const selectedRecipe = useMemo(
    () => recipes.find((recipe) => recipe.ref === selectedRef) || null,
    [recipes, selectedRef],
  );

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

  const quoteColumns = useMemo(
    () => getQuoteColumns(QUOTE_LINES, QUOTE_LINES_PER_RAIL),
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
          left: '29%',
          top: '2.5%',
          opacity: 0.22,
        }}
      />
      <CovenantSigil
        style={{
          right: '2%',
          bottom: '6%',
          opacity: 0.18,
        }}
      />
      <Stack fill>
        <Stack.Item basis="30%" mr={1}>
          <CurrentQueueSection machineOn={machine_on} queue={current_recipes} />
        </Stack.Item>
        <Stack.Item basis="5%" mr={1}>
          <QuoteRail lines={quoteColumns[0]} />
        </Stack.Item>
        <Stack.Item grow basis={0} mr={1}>
          {machine_on ? (
            <ActiveCenterPanel
              controlsLocked={data.controls_locked}
              hopperCounts={data.hopper_counts}
              statusState={data.status_state}
              selectedRecipe={selectedRecipe}
              amount={amount}
              setAmount={setAmount}
              progress={data.progress}
              neededProgress={data.needed_progress}
            />
          ) : (
            <OffCenterPanel
              controlsLocked={data.controls_locked}
              machinePowered={data.machine_powered}
            />
          )}
        </Stack.Item>
        <Stack.Item basis="5%" mr={1}>
          <QuoteRail lines={quoteColumns[1]} />
        </Stack.Item>
        <Stack.Item basis="30%">
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
        width={48}
        height={48}
      />
    </Box>
  );
};

type QuoteRailProps = {
  lines: string[];
};

const QuoteRail = ({ lines }: QuoteRailProps) => {
  return (
    <Section fill>
      <Stack vertical fill align="center" justify="space-around">
        {lines.map((line) => (
          <Stack.Item key={line} grow>
            <Box
              bold
              textAlign="center"
              style={{
                writingMode: 'vertical-rl',
                textOrientation: 'mixed',
                color: '#c9c1ab',
                minHeight: '100%',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              {line}
            </Box>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

type CurrentQueueSectionProps = {
  machineOn: boolean;
  queue: QueueEntry[];
};

const CurrentQueueSection = ({
  machineOn,
  queue,
}: CurrentQueueSectionProps) => {
  const { act } = useBackend<Data>();

  return (
    <Section
      title="What Churns Inside"
      fill
      scrollable
      buttons={
        <Box bold color={machineOn ? STATUS_COLORS.on : STATUS_COLORS.off}>
          {machineOn
            ? MACHINE_ACTIVITY_LABELS.active
            : MACHINE_ACTIVITY_LABELS.inactive}
        </Box>
      }
    >
      {!queue.length && (
        <Box
          px={2}
          py={3}
          textAlign="center"
          style={{
            background: '#2c2f33',
            border: '1px solid rgba(255, 255, 255, 0.08)',
            color: '#d8d3c2',
          }}
        >
          Malum holds you in His cradle. Do not kick Him in the guts.
        </Box>
      )}
      {queue.map((entry) => (
        <Button
          key={entry.id}
          fluid
          mb={1}
          color={entry.active ? 'purple' : undefined}
          onClick={() => act('remove_recipe', { id: entry.id })}
        >
          <Stack align="center">
            <Stack.Item>
              <Box className={entry.icon} mr={1} inline />
            </Stack.Item>
            <Stack.Item grow>
              <Box bold>
                {entry.index}. {entry.name}
              </Box>
              <Box color="label">
                {entry.category}
                {entry.created_num > 1 ? ` x${entry.created_num}` : ''}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Box color={entry.active ? STATUS_COLORS.working : 'label'}>
                {entry.active ? 'ACTIVE' : 'REMOVE'}
              </Box>
            </Stack.Item>
          </Stack>
        </Button>
      ))}
    </Section>
  );
};

type ActiveCenterPanelProps = {
  controlsLocked: boolean;
  hopperCounts: Record<string, number>;
  statusState: Data['status_state'];
  selectedRecipe: Recipe | null;
  amount: number;
  setAmount: (amount: number) => void;
  progress: number;
  neededProgress: number;
};

const ActiveCenterPanel = ({
  controlsLocked,
  hopperCounts,
  statusState,
  selectedRecipe,
  amount,
  setAmount,
  progress,
  neededProgress,
}: ActiveCenterPanelProps) => {
  const { act } = useBackend<Data>();
  const progressPercent =
    neededProgress > 0
      ? Math.min(100, Math.round((progress / neededProgress) * 100))
      : 0;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="MY MOOD">
          <Box
            textAlign="center"
            bold
            fontSize={2}
            style={{
              color: STATUS_COLORS[statusState],
            }}
          >
            {STATUS_LABELS[statusState]}
          </Box>
          <Box
            mt={1}
            px={1.5}
            py={1}
            style={{
              background: '#1f2328',
              border: '1px solid rgba(255, 255, 255, 0.08)',
            }}
          >
            <Box bold mb={0.5}>
              Progress
            </Box>
            <Box color="label">
              {progressPercent}% complete ({Math.round(progress)}/
              {neededProgress || 0})
            </Box>
          </Box>
          <Box mt={1}>
            <ControlRack controlsLocked={controlsLocked} />
          </Box>
        </Section>
      </Stack.Item>
      <Stack.Item grow basis={0}>
        {selectedRecipe ? (
          <Section title={selectedRecipe.name} fill scrollable>
            <Stack vertical fill>
              <Stack.Item>
                <Stack align="center">
                  <Stack.Item>
                    <DmIcon
                      icon={selectedRecipe.icon_file}
                      icon_state={selectedRecipe.icon_state}
                      width={16}
                      height={16}
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item mt={1}>
                <Box bold mb={1}>
                  Required Materials
                </Box>
                {selectedRecipe.requirements.map((requirement) => {
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
                      <Stack.Item>
                        {hasEnough ? (
                          <Box
                            inline
                            mr={1}
                            style={{
                              color: '#58b76a',
                            }}
                          >
                            ✓
                          </Box>
                        ) : null}
                      </Stack.Item>
                      <Stack.Item>
                        {requirement.amount}x {requirement.name}
                      </Stack.Item>
                    </Stack>
                  );
                })}
              </Stack.Item>
              <Stack.Item mt={2}>
                <Box bold mb={1}>
                  Queue Amount
                </Box>
                <Stack align="center" justify="space-between">
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
                  <Stack.Item grow>
                    <Box textAlign="center" bold fontSize={1.5}>
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
                </Stack>
              </Stack.Item>
              <Stack.Item mt={2}>
                <Button.Confirm
                  fluid
                  color="good"
                  onClick={() =>
                    act('add_recipe', { ref: selectedRecipe.ref, amount })
                  }
                >
                  Add {amount} To Queue
                </Button.Confirm>
              </Stack.Item>
            </Stack>
          </Section>
        ) : (
          <Section title="No Recipe Selected" fill>
            <NoticeBox>
              Select a recipe from the right to preview its inputs.
            </NoticeBox>
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};

type OffCenterPanelProps = {
  controlsLocked: boolean;
  machinePowered: boolean;
};

const OffCenterPanel = ({
  controlsLocked,
  machinePowered,
}: OffCenterPanelProps) => {
  return (
    <Section fill>
      <Stack fill align="center" justify="center">
        <Stack.Item>
          <Box
            textAlign="center"
            px={4}
            py={6}
            style={{
              background: '#2c2f33',
              border: '1px solid rgba(255, 255, 255, 0.08)',
            }}
          >
            <Box
              bold
              fontSize={1.8}
              style={{
                color: '#d8d3c2',
              }}
            >
              {machinePowered
                ? 'MALUM AWAITS YOUR BLOOD, SWEAT AND DEVOTION'
                : "MALUM'S FORCE OF LYFE DOES NOT FLOW"}
            </Box>
            <Box
              mt={2}
              bold
              fontSize={2.2}
              style={{
                color: STATUS_COLORS.off,
              }}
            >
              {MACHINE_ACTIVITY_LABELS.inactive}
            </Box>
            <Box mt={3}>
              <ControlRack controlsLocked={controlsLocked} />
            </Box>
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

type ControlRackProps = {
  controlsLocked: boolean;
};

const ControlRack = ({ controlsLocked }: ControlRackProps) => {
  const { act } = useBackend<Data>();
  const isLocked = Boolean(controlsLocked);

  return (
    <Stack vertical>
      <Stack.Item>
        <Box bold textAlign="center" mb={1}>
          Control Rack
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item grow>
            <Button fluid disabled={isLocked} onClick={() => act('lever')}>
              Pull Lever
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button fluid disabled={isLocked} onClick={() => act('button')}>
              Push Buttons
            </Button>
          </Stack.Item>
          <Stack.Item grow>
            <Button fluid disabled={isLocked} onClick={() => act('dial')}>
              Fiddle Dials
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      {isLocked && (
        <Stack.Item>
          <Box color="label" textAlign="center" mt={1}>
            Stand next to the auto anvil to use its controls.
          </Box>
        </Stack.Item>
      )}
    </Stack>
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
      <Stack.Item mt={1}>
        <Input
          fluid
          placeholder="Search recipes..."
          value={searchText}
          onChange={onSearch}
        />
      </Stack.Item>
      <Stack.Item grow basis={0} mt={1}>
        <Section key={category} title="What I Can Provide" fill scrollable>
          {!recipes.length && <NoticeBox>No matching recipes.</NoticeBox>}
          <IncrementalList>
            {recipes.map((recipe) => (
              <RecipePickerRow
                key={recipe.ref}
                recipe={recipe}
                selected={recipe.ref === selectedRef}
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
  onSelect: (ref: string) => void;
};

const RecipePickerRow = memo(
  ({ recipe, selected, onSelect }: RecipePickerRowProps) => (
    <Button
      fluid
      mb={1}
      selected={selected}
      onClick={() => onSelect(recipe.ref)}
    >
      <Stack align="center">
        <Stack.Item>
          <Box className={recipe.icon} mr={1} inline />
        </Stack.Item>
        <Stack.Item grow>
          <Box bold>{recipe.name}</Box>
          <Box color="label">
            {recipe.category}
            {recipe.created_num > 1 ? ` x${recipe.created_num}` : ''}
          </Box>
        </Stack.Item>
      </Stack>
    </Button>
  ),
);
