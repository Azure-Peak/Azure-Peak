import { LoadingScreen } from 'interfaces/common/LoadingScreen';
import { SaveUndo } from 'pm/components';
import {
  DepartmentEnum,
  getClassDepartment,
  getClassDisplayOrder,
  getClassDisplayTitle,
  useConstantPrefs,
} from 'pm/constant_data';
import { MAX_CLASS_TUTORIAL_LENGTH } from 'pm/constants';
import { useBackendStrict } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import {
  CLASSAVAIL_COLOR,
  CLASSAVAIL_NAME,
  type Class,
  ClassAvailability,
  type ClassData,
  ClassPreference,
  type IdentityData,
} from '../data';

const PRIORITY_BUTTON_SIZE = 18;

// INSTRUCTIONS FOR DOWNSTREAM: you may need to manage this list yourself
const COLS = [
  [DepartmentEnum.NOBLEMEN, DepartmentEnum.COURTIERS],
  [DepartmentEnum.RETINUE, DepartmentEnum.GARRISON, DepartmentEnum.BURGHERS],
  [
    DepartmentEnum.CHURCHMEN,
    DepartmentEnum.INQUISITION,
    DepartmentEnum.SIDEFOLK,
    DepartmentEnum.WANDERERS,
  ],
  [DepartmentEnum.PEASANTS, DepartmentEnum.ANTAGONIST, DepartmentEnum.NONE],
];

export const SubtabClass = (props) => {
  const [constantData] = useConstantPrefs();

  if (!constantData) {
    return (
      <Section fill scrollable>
        <LoadingScreen />
      </Section>
    );
  }

  return (
    <Section
      fill
      scrollable
      className="PreferencesMenu__Section__NoChildPadding"
    >
      <Stack align="space-between" justify="space-around">
        {COLS.map((col, i) => (
          // Math just calculates correct % of space based on how many columns we have with a 3px gap
          <Stack.Item key={i} basis={`${100 * (1 / COLS.length) - 3}%`}>
            <Stack vertical>
              {col.map((dept, i) => (
                <Stack.Item key={dept} mt={i > 0 ? 2 : 0}>
                  <Department dept={dept} />
                </Stack.Item>
              ))}
              {i === 0 ? (
                <>
                  <ExplainerKey />
                  <Controls />
                </>
              ) : null}
            </Stack>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const Controls = (props) => {
  const { act, data } = useBackendStrict<ClassData>();
  const { joblessrole } = data;

  return (
    <Stack.Item>
      <Section title="Controls">
        <Stack vertical>
          <Stack.Item bold>If Role Unavailable?</Stack.Item>
          <Stack.Item ml={2}>
            <Button fluid onClick={() => act('select_joblessrole')}>
              {joblessrole}
            </Button>
          </Stack.Item>
          <SaveUndo />
        </Stack>
      </Section>
    </Stack.Item>
  );
};

const ExplainerKey = (props) => {
  return (
    <Stack.Item>
      <Section
        title="Key"
        buttons={
          <Button
            color="transparent"
            icon="circle-question-o"
            tooltipPosition="right"
            tooltip={
              <Stack vertical>
                <Stack.Item>
                  This menu selects priority for random role assignment at the
                  start of a new round.
                </Stack.Item>
                <Stack.Item>
                  Select 1 highest priority class, and any number of medium and
                  low priority classes.
                </Stack.Item>
                <Stack.Item>
                  Upon the lobby timer ending, everyone who is marked ready will
                  be spawned in, in order of priority.
                </Stack.Item>
                <Stack.Item>
                  First, high priorities are spawned in, and conflicts (multiple
                  people going for the same role over the amount of slots
                  available) are resolved via weighted random chance depending
                  on role.
                </Stack.Item>
                <Stack.Item>
                  Then medium priorities undergo the same, then low priority.
                </Stack.Item>
                <Stack.Item>
                  If after this you still have not been assigned a class, the
                  fallback option you pick under &quot;If Role
                  Unavailable?&quot; will be done.
                </Stack.Item>
              </Stack>
            }
          />
        }
      >
        <Stack vertical>
          <Stack.Item>
            <Stack>
              <PriorityButton
                enabled
                color="light-grey"
                modifier="off"
                name="Off"
              />
              <Stack.Item>- Off</Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item>
            <Stack>
              <PriorityButton enabled color="red" name="Low" />
              <Stack.Item>- Low</Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item>
            <Stack>
              <PriorityButton enabled color="yellow" name="Medium" />
              <Stack.Item>- Medium</Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item>
            <Stack>
              <PriorityButton enabled color="green" name="High" />
              <Stack.Item>- High</Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};

const DEPARTMENT_ENUM_TO_NAME = {
  [DepartmentEnum.NOBLEMEN]: (
    <Box inline textColor="#af3eb9">
      Nobles
    </Box>
  ),
  [DepartmentEnum.COURTIERS]: (
    <Box inline textColor="#7c0072">
      Courtiers
    </Box>
  ),
  [DepartmentEnum.RETINUE]: (
    <Box inline textColor="#0cb3e6">
      Retinue
    </Box>
  ),
  [DepartmentEnum.GARRISON]: (
    <Box inline textColor="#123fd3">
      Garrison
    </Box>
  ),
  [DepartmentEnum.CHURCHMEN]: (
    <Box inline textColor="#d1ce00">
      Church
    </Box>
  ),
  [DepartmentEnum.BURGHERS]: (
    <Box inline textColor="#c88544">
      Burghers
    </Box>
  ),
  [DepartmentEnum.INQUISITION]: (
    <Box inline textColor="#cecece">
      Inquisition
    </Box>
  ),
  [DepartmentEnum.PEASANTS]: (
    <Box inline textColor="#5e4017">
      Peasants
    </Box>
  ),
  [DepartmentEnum.SIDEFOLK]: (
    <Box inline textColor="#525252">
      Sidefolk
    </Box>
  ),
  [DepartmentEnum.WANDERERS]: (
    <Box inline textColor="rgb(0, 119, 0)">
      Wanderers
    </Box>
  ),
  [DepartmentEnum.ANTAGONIST]: (
    <Box inline textColor="rgb(207, 6, 6)">
      Antags
    </Box>
  ),
  [DepartmentEnum.NONE]: <Box inline>Other</Box>,
};

export const Department = (props: { dept: DepartmentEnum }) => {
  const { dept } = props;
  const [constantData] = useConstantPrefs();
  const { data } = useBackendStrict<ClassData>();
  const { classes } = data;

  if (!constantData) {
    return (
      <Section title={DEPARTMENT_ENUM_TO_NAME[dept]}>
        <LoadingScreen />
      </Section>
    );
  }

  const classes_to_show = classes.filter(
    (cls) => getClassDepartment(constantData, cls.title) === dept,
  );
  classes_to_show.sort(
    (a, b) =>
      getClassDisplayOrder(constantData, a.title) -
      getClassDisplayOrder(constantData, b.title),
  );

  if (!classes_to_show.length) {
    return null;
  }

  return (
    <Section title={DEPARTMENT_ENUM_TO_NAME[dept]}>
      <Stack vertical>
        {classes_to_show.map((cls) => (
          <ClassEntry key={cls.title} cls={cls} />
        ))}
      </Stack>
    </Section>
  );
};

export const ClassEntry = (props: { cls: Class }) => {
  const { cls } = props;

  const createSetPriority = createCreateSetPriorityFromName(cls.title);

  return (
    <Stack.Item style={{ minHeight: PRIORITY_BUTTON_SIZE + 4 }}>
      <Stack align="center">
        <Stack.Item>
          <ClassTitle cls={cls} />
        </Stack.Item>
        <Stack.Item grow textAlign="right">
          {cls.unavailable ? (
            <UnavailableExplanation cls={cls} />
          ) : (
            <PriorityButtons
              createSetPriority={createSetPriority}
              priority={cls.pref}
            />
          )}
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};

export const UnavailableExplanation = (props: { cls: Class }) => {
  const { cls } = props;
  const { act } = useBackendStrict();
  const { unavailable, unavailable_details } = cls;

  return (
    <Tooltip content={unavailable_details}>
      <Box
        inline
        textColor={CLASSAVAIL_COLOR[unavailable]}
        style={
          unavailable_details
            ? { borderBottom: `1px solid ${CLASSAVAIL_COLOR[unavailable]}` }
            : undefined
        }
      >
        {CLASSAVAIL_NAME[unavailable]}
        {unavailable === ClassAvailability.UNAVAILABLE_BANNED ? (
          <Button
            color="bad"
            ml={1}
            onClick={() => act('bancheck', { bancheck: cls.title })}
          >
            Why?
          </Button>
        ) : null}
      </Box>
    </Tooltip>
  );
};

/// This is a little helper that will shorten text to limit, but not cut off words
const smartCut = (text: string, limit: number) => {
  if (!limit || text.length <= limit) {
    return text;
  }

  let i = limit;
  let searcher: string = text.charAt(i);
  while (searcher !== '' && searcher !== ' ') {
    i += 1;
    searcher = text.charAt(i);
  }

  return text.substring(0, i);
};

export const ClassTitle = (props: { cls: Class }) => {
  const { cls } = props;
  const [constantData] = useConstantPrefs();
  const { act, data } = useBackendStrict<ClassData & IdentityData>();
  const { titles_pref } = data;

  if (!constantData) {
    return (
      <Box inline>
        <Icon color="blue" name="toolbox" spin />
      </Box>
    );
  }

  const { classes } = constantData;
  const constClass = classes[cls.title];

  return (
    <Tooltip
      content={
        <Stack vertical>
          <Stack.Item italic fontSize={0.9}>
            Left-click to see subclass details!
          </Stack.Item>
          {constClass.has_subprefs ? (
            <Stack.Item italic fontSize={0.9}>
              Right-click to see class-specific preferences!
            </Stack.Item>
          ) : null}
          <Stack.Item>
            <Stack align="">
              <Stack.Item>Slots: {cls.spawn_positions}</Stack.Item>
              <Stack.Divider />
              <Stack.Item>
                RCP: {constClass.round_contrib_points || 0}
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            {constClass.tutorial.length > MAX_CLASS_TUTORIAL_LENGTH ? (
              <Box>
                {smartCut(constClass.tutorial, MAX_CLASS_TUTORIAL_LENGTH)}
                <Box inline fontSize={0.9}>
                  ...
                </Box>
                <Box italic fontSize={0.9}>
                  [Read the full tutorial in the subclass menu.]
                </Box>
              </Box>
            ) : (
              constClass.tutorial
            )}
          </Stack.Item>
        </Stack>
      }
    >
      <Box
        inline
        className={
          // Review if this is obvious enough or if it should always be underlined
          constClass.class_setup_examine
            ? 'PreferencesMenu__Class__Name'
            : undefined
        }
        onClick={() => act('explainjob', { job: cls.title })}
        onContextMenu={() => act('subprefs', { job: cls.title })}
      >
        {getClassDisplayTitle(constantData, cls.title, titles_pref)}
      </Box>
    </Tooltip>
  );
};

type PriorityButtonProps = {
  name: string;
  color: string;
  modifier?: string;
  enabled: boolean;
  onClick?: () => void;
};

const PriorityButton = (props: PriorityButtonProps) => {
  const { color, enabled, modifier, name, onClick } = props;
  const className = `PreferencesMenu__Class__PriorityButton`;

  return (
    <Stack.Item>
      <Button
        circular
        color={enabled ? color : 'white'}
        onClick={onClick}
        tooltip={name}
        tooltipPosition="bottom"
        className={classes([
          className,
          modifier && `${className}--${modifier}`,
        ])}
        style={{
          height: PRIORITY_BUTTON_SIZE,
          minHeight: PRIORITY_BUTTON_SIZE,
          padding: '0',
          width: PRIORITY_BUTTON_SIZE,
        }}
      />
    </Stack.Item>
  );
};

// Cursed nonsense to cache the onClick handlers for every priority button
type CreateSetPriority = (priority: ClassPreference | null) => () => void;
const createSetPriorityCache: Record<string, CreateSetPriority> = {};
function createCreateSetPriorityFromName(jobName: string): CreateSetPriority {
  if (createSetPriorityCache[jobName] !== undefined) {
    return createSetPriorityCache[jobName];
  }

  const perPriorityCache: Map<ClassPreference | null, () => void> = new Map();

  function createSetPriority(priority: ClassPreference | null) {
    const existingCallback = perPriorityCache.get(priority);
    if (existingCallback !== undefined) {
      return existingCallback;
    }

    function setPriority() {
      const { act } = useBackendStrict();

      act('set_job_preference', {
        job: jobName,
        level: priority,
      });
    }

    perPriorityCache.set(priority, setPriority);
    return setPriority;
  }

  createSetPriorityCache[jobName] = createSetPriority;

  return createSetPriority;
}

type PriorityButtonsProps = {
  createSetPriority: CreateSetPriority;
  priority: ClassPreference | null;
};

const PriorityButtons = (props: PriorityButtonsProps) => {
  const { createSetPriority, priority } = props;

  return (
    <Stack
      style={{
        alignItems: 'center',
        justifyContent: 'flex-end',
        paddingLeft: '0.3em',
      }}
    >
      <PriorityButton
        color="light-grey"
        modifier="off"
        name="Off"
        enabled={!priority}
        onClick={createSetPriority(null)}
      />

      <PriorityButton
        color="red"
        name="Low"
        enabled={priority === ClassPreference.JP_LOW}
        onClick={createSetPriority(ClassPreference.JP_LOW)}
      />

      <PriorityButton
        color="yellow"
        name="Medium"
        enabled={priority === ClassPreference.JP_MEDIUM}
        onClick={createSetPriority(ClassPreference.JP_MEDIUM)}
      />

      <PriorityButton
        color="green"
        name="High"
        enabled={priority === ClassPreference.JP_HIGH}
        onClick={createSetPriority(ClassPreference.JP_HIGH)}
      />
    </Stack>
  );
};
