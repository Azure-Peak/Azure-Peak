import {
  Box,
  Button,
  Divider,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Project = {
  ref: string;
  name: string;
  description: string;
  cost: number;
  paid: number;
  remaining: number;
  progress: number;
  isLordOnly: boolean;
  accessText: string;
  canContribute: boolean;
  maxContribution: number;
  maxBloodCost: number;
  contributorsText: string;
  contributionText: string;
};

type AvailableProject = {
  type_path: string;
  name: string;
  description: string;
  cost: number;
  isLordOnly: boolean;
  accessText: string;
  accessSeal: string;
  canStart: boolean;
  lockedReason: string;
};

type CrucibleTexts = {
  number_locale: string;
  window_title: string;
  header_title: string;
  seals: {
    header: string;
  };
  sections: {
    active_projects: string;
    available_projects: string;
  };
  roles: {
    lord: string;
    vampire: string;
    mortal: string;
  };
  labels: {
    cup_blood: string;
    committed: string;
    max_deposit: string;
    required: string;
    collected: string;
    remaining: string;
    contributors: string;
    cost: string;
    vitae: string;
  };
  actions: {
    deposit_vampire: string;
    deposit_mortal: string;
    contribute_lord: string;
    contribute_vampire: string;
    cancel: string;
    start: string;
  };
  states: {
    no_active_projects: string;
    no_available_projects: string;
    nonvampire_info: string;
    vampire_nonlord_info: string;
  };
};

type CrucibleData = {
  texts: CrucibleTexts;
  bloodLevel: number;
  maxBlood: number;
  committedVitae: number;
  isLord: boolean;
  isVampire: boolean;
  canDepositBlood: boolean;
  maxCupDeposit: number;
  activeProjects: Project[];
  availableProjects: AvailableProject[];
};

const emptyTexts: CrucibleTexts = {
  number_locale: 'en-US',
  window_title: '',
  header_title: '',
  seals: {
    header: '',
  },
  sections: {
    active_projects: '',
    available_projects: '',
  },
  roles: {
    lord: '',
    vampire: '',
    mortal: '',
  },
  labels: {
    cup_blood: '',
    committed: '',
    max_deposit: '',
    required: '',
    collected: '',
    remaining: '',
    contributors: '',
    cost: '',
    vitae: '',
  },
  actions: {
    deposit_vampire: '',
    deposit_mortal: '',
    contribute_lord: '',
    contribute_vampire: '',
    cancel: '',
    start: '',
  },
  states: {
    no_active_projects: '',
    no_available_projects: '',
    nonvampire_info: '',
    vampire_nonlord_info: '',
  },
};

const formatVitae = (value: number, locale: string) =>
  Math.round(value || 0).toLocaleString(locale || 'en-US');

const formatPercent = (value: number, locale: string) =>
  `${Number(value || 0).toLocaleString(locale || 'en-US', {
    maximumFractionDigits: 1,
  })}%`;

const clampRatio = (value: number) => Math.max(0, Math.min(1, value || 0));

const frameStyle = {
  background:
    'linear-gradient(135deg, rgba(45, 5, 8, 0.95), rgba(12, 10, 10, 0.96))',
  border: '1px solid #5b1b1f',
  borderRadius: '6px',
  boxShadow: 'inset 0 0 18px rgba(0, 0, 0, 0.55)',
};

const parchmentStyle = {
  background: 'linear-gradient(180deg, #c9b98d, #a99461)',
  border: '1px solid #1f1614',
  borderRadius: '6px',
  color: '#17110f',
  boxShadow: 'inset 0 0 12px rgba(255, 246, 190, 0.22)',
};

const sealStyle = {
  width: '42px',
  height: '42px',
  borderRadius: '6px',
  border: '1px solid #572126',
  background: 'radial-gradient(circle at 50% 35%, #611820, #18090b 74%)',
  color: '#d8c7a0',
  textAlign: 'center' as const,
  lineHeight: '42px',
  fontWeight: 700,
  fontSize: '18px',
  textShadow: '0 0 8px #d82034',
};

export const CrimsonCrucible = () => {
  const { act, data } = useBackend<CrucibleData>();
  const {
    texts = emptyTexts,
    bloodLevel = 0,
    maxBlood = 20000,
    committedVitae = 0,
    isLord = false,
    isVampire = false,
    canDepositBlood = false,
    maxCupDeposit = 0,
    activeProjects = [],
    availableProjects = [],
  } = data;
  const bloodRatio = clampRatio(bloodLevel / Math.max(maxBlood, 1));
  const locale = texts.number_locale;
  const roleText = isVampire
    ? isLord
      ? texts.roles.lord
      : texts.roles.vampire
    : texts.roles.mortal;

  return (
    <Window title={texts.window_title} width={760} height={580} theme="dark">
      <Window.Content>
        <Box
          height="100%"
          p={1}
          style={{
            background:
              'linear-gradient(180deg, rgba(24, 3, 5, 0.95), rgba(8, 7, 7, 0.98))',
          }}
        >
          <Stack vertical fill>
            <Stack.Item>
              <Box p={1.2} style={frameStyle}>
                <Stack align="center">
                  <Stack.Item>
                    <Box style={sealStyle}>{texts.seals.header}</Box>
                  </Stack.Item>
                  <Stack.Item grow>
                    <Box
                      bold
                      fontSize={1.45}
                      color="#e0c090"
                      textAlign="center"
                      style={{ letterSpacing: '0' }}
                    >
                      {texts.header_title}
                    </Box>
                    <Box color="#c8878d" textAlign="center" mt={0.3}>
                      {roleText}
                    </Box>
                  </Stack.Item>
                  <Stack.Item width="230px">
                    <Box color="#e8d0a0" mb={0.4}>
                      {texts.labels.cup_blood}: {formatVitae(bloodLevel, locale)}
                      {' / '}
                      {formatVitae(maxBlood, locale)}
                    </Box>
                    <ProgressBar
                      value={bloodRatio}
                      ranges={{
                        good: [0.66, Infinity],
                        average: [0.25, 0.66],
                        bad: [-Infinity, 0.25],
                      }}
                    />
                    <Box color="#b99b7c" mt={0.4}>
                      {texts.labels.committed}: {formatVitae(committedVitae, locale)}
                      {' '}
                      {texts.labels.vitae}
                    </Box>
                    <Button
                      fluid
                      color="red"
                      mt={0.6}
                      disabled={!canDepositBlood}
                      onClick={() => act('deposit_blood')}
                    >
                      {isVampire
                        ? texts.actions.deposit_vampire
                        : texts.actions.deposit_mortal}
                    </Button>
                    <Box color="#b99b7c" mt={0.4} fontSize={0.9}>
                      {texts.labels.max_deposit}: {formatVitae(maxCupDeposit, locale)}
                      {' '}
                      {texts.labels.vitae}
                    </Box>
                  </Stack.Item>
                </Stack>
              </Box>
            </Stack.Item>
            <Stack.Item grow basis={0}>
              <Stack fill>
                <Stack.Item grow basis={0}>
                  <Section title={texts.sections.active_projects} fill scrollable>
                    {activeProjects.length ? (
                      activeProjects.map((project, index) => (
                        <ActiveProjectCard
                          key={project.ref}
                          index={index}
                          isLord={isLord}
                          locale={locale}
                          project={project}
                          texts={texts}
                          onContribute={() => act('contribute', { ref: project.ref })}
                          onCancel={() => act('cancel_project', { ref: project.ref })}
                        />
                      ))
                    ) : (
                      <EmptyState text={texts.states.no_active_projects} />
                    )}
                  </Section>
                </Stack.Item>
                <Stack.Item width="338px">
                  <Section title={texts.sections.available_projects} fill scrollable>
                    {!isVampire ? (
                      <Box color="#c7a97a" italic mb={1}>
                        {texts.states.nonvampire_info}
                      </Box>
                    ) : !isLord ? (
                      <Box color="#c7a97a" italic mb={1}>
                        {texts.states.vampire_nonlord_info}
                      </Box>
                    ) : null}
                    {isVampire && isLord && availableProjects.length ? (
                      availableProjects.map((project) => (
                        <AvailableProjectCard
                          key={project.type_path}
                          locale={locale}
                          project={project}
                          texts={texts}
                          onStart={() =>
                            act('start_project', { type_path: project.type_path })
                          }
                        />
                      ))
                    ) : isVampire && isLord ? (
                      <EmptyState text={texts.states.no_available_projects} />
                    ) : null}
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Box>
      </Window.Content>
    </Window>
  );
};

type ActiveProjectCardProps = {
  index: number;
  isLord: boolean;
  locale: string;
  project: Project;
  texts: CrucibleTexts;
  onContribute: () => void;
  onCancel: () => void;
};

const ActiveProjectCard = (props: ActiveProjectCardProps) => {
  const { index, isLord, locale, project, texts, onContribute, onCancel } =
    props;
  const ratio = clampRatio(project.paid / Math.max(project.cost, 1));

  return (
    <Box mb={1.1} p={1} style={parchmentStyle}>
      <Stack>
        <Stack.Item>
          <Box style={sealStyle}>{index + 1}</Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box bold fontSize={1.08}>
            {project.name} {project.accessText}
          </Box>
          <Box color="#3b2724" mt={0.3}>
            {project.description}
          </Box>
          <Divider />
          <Stack>
            <Stack.Item grow>
              <Box>
                {texts.labels.required}: {formatVitae(project.cost, locale)}
                {' '}
                {texts.labels.vitae}
              </Box>
              <Box>
                {texts.labels.collected}: {formatVitae(project.paid, locale)}
                {' '}
                {texts.labels.vitae}
              </Box>
              <Box>
                {texts.labels.remaining}: {formatVitae(project.remaining, locale)}
                {' '}
                {texts.labels.vitae}
              </Box>
            </Stack.Item>
            <Stack.Item width="110px">
              <Button
                fluid
                color="red"
                disabled={!project.canContribute}
                onClick={onContribute}
              >
                {isLord
                  ? texts.actions.contribute_lord
                  : texts.actions.contribute_vampire}
              </Button>
              {isLord && (
                <Button fluid color="bad" mt={0.5} onClick={onCancel}>
                  {texts.actions.cancel}
                </Button>
              )}
            </Stack.Item>
          </Stack>
          <Box mt={0.8}>
            <ProgressBar value={ratio} color="red">
              {formatPercent(project.progress, locale)}
            </ProgressBar>
          </Box>
          <Box color="#563f37" mt={0.5} fontSize={0.9}>
            {texts.labels.contributors}: {project.contributorsText}
          </Box>
          {project.canContribute && (
            <Box color="#563f37" mt={0.3} fontSize={0.9}>
              {project.contributionText}
            </Box>
          )}
        </Stack.Item>
      </Stack>
    </Box>
  );
};

type AvailableProjectCardProps = {
  locale: string;
  project: AvailableProject;
  texts: CrucibleTexts;
  onStart: () => void;
};

const AvailableProjectCard = (props: AvailableProjectCardProps) => {
  const { locale, project, texts, onStart } = props;

  return (
    <Box mb={1} p={1} style={parchmentStyle}>
      <Stack align="center">
        <Stack.Item>
          <Box style={sealStyle}>{project.accessSeal}</Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box bold>
            {project.name} {project.accessText}
          </Box>
          <Box color="#3b2724" mt={0.3}>
            {project.description}
          </Box>
          <Box color="#563f37" mt={0.5}>
            {texts.labels.cost}: {formatVitae(project.cost, locale)}
            {' '}
            {texts.labels.vitae}
          </Box>
          {!project.canStart && (
            <Box color="#6c1f25" mt={0.4} fontSize={0.9}>
              {project.lockedReason}
            </Box>
          )}
        </Stack.Item>
        <Stack.Item width="82px">
          <Button
            fluid
            color="red"
            disabled={!project.canStart}
            onClick={onStart}
          >
            {texts.actions.start}
          </Button>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const EmptyState = ({ text }: { text: string }) => (
  <Box
    italic
    textAlign="center"
    color="#b99b7c"
    p={2}
    style={{
      border: '1px dashed #5b1b1f',
      borderRadius: '6px',
      background: 'rgba(24, 6, 7, 0.45)',
    }}
  >
    {text}
  </Box>
);
