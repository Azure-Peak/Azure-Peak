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
  mechanics: string;
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
  mechanics: string;
  cost: number;
  isLordOnly: boolean;
  accessText: string;
  accessSeal: string;
  canStart: boolean;
  lockedReason: string;
};

type CrucibleData = {
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

const formatVitae = (value: number) =>
  Math.round(value || 0).toLocaleString('en-US');

const formatPercent = (value: number) =>
  `${Number(value || 0).toLocaleString('en-US', {
    maximumFractionDigits: 1,
  })}%`;

const clampRatio = (value: number) => Math.max(0, Math.min(1, value || 0));

const shellStyle = {
  background:
    'linear-gradient(180deg, rgba(24, 3, 5, 0.95), rgba(8, 7, 7, 0.98))',
  display: 'grid',
  gap: '8px',
  gridTemplateRows: '136px minmax(0, 1fr)',
  height: '100%',
  minHeight: 0,
};

const frameStyle = {
  background:
    'linear-gradient(135deg, rgba(45, 5, 8, 0.95), rgba(12, 10, 10, 0.96))',
  border: '1px solid #5b1b1f',
  borderRadius: '6px',
  boxShadow: 'inset 0 0 18px rgba(0, 0, 0, 0.55)',
};

const headerGridStyle = {
  ...frameStyle,
  alignItems: 'center',
  display: 'grid',
  gap: '16px',
  gridTemplateColumns: '64px minmax(320px, 1fr) minmax(280px, 340px)',
  padding: '14px',
};

const contentGridStyle = {
  display: 'grid',
  gap: '8px',
  gridTemplateColumns: 'minmax(660px, 2.25fr) minmax(460px, 1fr)',
  height: '100%',
  minHeight: 0,
};

const parchmentStyle = {
  background: 'linear-gradient(180deg, #c9b98d, #a99461)',
  border: '1px solid #1f1614',
  borderRadius: '6px',
  color: '#17110f',
  boxShadow: 'inset 0 0 12px rgba(255, 246, 190, 0.22)',
};

const activeCardStyle = {
  ...parchmentStyle,
  minWidth: 0,
  padding: '10px',
};

const availableCardStyle = {
  ...parchmentStyle,
  display: 'grid',
  gap: '8px',
  minWidth: 0,
  padding: '10px',
};

const sealStyle = {
  width: '52px',
  height: '52px',
  borderRadius: '6px',
  border: '1px solid #572126',
  background: 'radial-gradient(circle at 50% 35%, #611820, #18090b 74%)',
  color: '#d8c7a0',
  textAlign: 'center' as const,
  lineHeight: '52px',
  fontWeight: 700,
  fontSize: '21px',
  textShadow: '0 0 8px #d82034',
};

const labelStyle = {
  color: '#4b332c',
  fontSize: '12px',
  fontWeight: 700,
  textTransform: 'uppercase' as const,
};

const copyStyle = {
  color: '#2f211e',
  lineHeight: 1.35,
  overflowWrap: 'break-word' as const,
};

const mechanicsStyle = {
  color: '#7040b8',
  fontStyle: 'normal',
  fontWeight: 400,
  lineHeight: 1.35,
  overflowWrap: 'break-word' as const,
  whiteSpace: 'pre-line' as const,
};

export const CrimsonCrucible = () => {
  const { act, data } = useBackend<CrucibleData>();
  const {
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
  const roleText = isVampire
    ? isLord
      ? 'Right of Dominion'
      : 'Right of Sacrifice'
    : 'Living sacrifice';

  return (
    <Window title="Crimson Crucible" width={1680} height={920} theme="dark">
      <Window.Content fitted>
        <Box p={1} style={shellStyle}>
          <Box style={headerGridStyle}>
            <Box style={sealStyle}>V</Box>
            <Box>
              <Box
                bold
                fontSize={1.65}
                color="#e0c090"
                textAlign="center"
                style={{ letterSpacing: '0' }}
              >
                CRIMSON CRUCIBLE
              </Box>
              <Box color="#c8878d" textAlign="center" mt={0.3}>
                {roleText}
              </Box>
            </Box>
            <Box>
              <Box color="#e8d0a0" mb={0.4}>
                Blood in cup: {formatVitae(bloodLevel)} / {formatVitae(maxBlood)}
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
                Committed: {formatVitae(committedVitae)} vitae
              </Box>
              <Button
                fluid
                color="red"
                mt={0.6}
                disabled={!canDepositBlood}
                onClick={() => act('deposit_blood')}
              >
                {isVampire ? 'Pour blood' : 'Give blood'}
              </Button>
              <Box color="#b99b7c" mt={0.4} fontSize={0.9}>
                Available to pour: {formatVitae(maxCupDeposit)} vitae
              </Box>
            </Box>
          </Box>
          <Box style={contentGridStyle}>
            <Section title="Active Rituals" fill scrollable>
              {activeProjects.length ? (
                activeProjects.map((project, index) => (
                  <ActiveProjectCard
                    key={project.ref}
                    index={index}
                    isLord={isLord}
                    project={project}
                    onContribute={() => act('contribute', { ref: project.ref })}
                    onCancel={() => act('cancel_project', { ref: project.ref })}
                  />
                ))
              ) : (
                <EmptyState text="The crucible is silent. No ritual has begun." />
              )}
            </Section>
            <Section title="New Rituals" fill scrollable>
              {!isVampire ? (
                <Box color="#c7a97a" italic mb={1}>
                  The crucible accepts blood into the cup or into rituals already
                  begun. New rites remain the clan&apos;s will.
                </Box>
              ) : !isLord ? (
                <Box color="#c7a97a" italic mb={1}>
                  Only the Methuselah can begin new rituals. Others may fill the
                  cup and aid rituals already in motion.
                </Box>
              ) : null}
              {isVampire && isLord && availableProjects.length ? (
                availableProjects.map((project) => (
                  <AvailableProjectCard
                    key={project.type_path}
                    project={project}
                    onStart={() =>
                      act('start_project', { type_path: project.type_path })
                    }
                  />
                ))
              ) : isVampire && isLord ? (
                <EmptyState text="No rituals are available." />
              ) : null}
            </Section>
          </Box>
        </Box>
      </Window.Content>
    </Window>
  );
};

type ProjectCopyProps = {
  description: string;
  mechanics?: string;
};

const ProjectCopy = (props: ProjectCopyProps) => {
  const { description, mechanics } = props;

  return (
    <Box mt={0.7}>
      <Box style={labelStyle}>Description</Box>
      <Box mt={0.2} style={copyStyle}>
        {description}
      </Box>
      {!!mechanics && (
        <Box mt={0.9}>
          <Box style={labelStyle}>Mechanics</Box>
          <Box mt={0.2} style={mechanicsStyle}>
            {mechanics}
          </Box>
        </Box>
      )}
    </Box>
  );
};

type ActiveProjectCardProps = {
  index: number;
  isLord: boolean;
  project: Project;
  onContribute: () => void;
  onCancel: () => void;
};

const ActiveProjectCard = (props: ActiveProjectCardProps) => {
  const { index, isLord, project, onContribute, onCancel } = props;
  const ratio = clampRatio(project.paid / Math.max(project.cost, 1));

  return (
    <Box mb={1} style={activeCardStyle}>
      <Stack align="start">
        <Stack.Item>
          <Box style={sealStyle}>{index + 1}</Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box bold fontSize={1.08}>
            {project.name} {project.accessText}
          </Box>
          <ProjectCopy
            description={project.description}
            mechanics={project.mechanics}
          />
        </Stack.Item>
        <Stack.Item width="128px">
          <Button
            fluid
            color="red"
            disabled={!project.canContribute}
            onClick={onContribute}
          >
            {isLord ? 'Direct' : 'Contribute'}
          </Button>
          {isLord && (
            <Button fluid color="bad" mt={0.5} onClick={onCancel}>
              Cancel
            </Button>
          )}
        </Stack.Item>
      </Stack>
      <Divider />
      <Stack>
        <Stack.Item grow>
          <Box>Required: {formatVitae(project.cost)} vitae</Box>
          <Box>Collected: {formatVitae(project.paid)} vitae</Box>
          <Box>Remaining: {formatVitae(project.remaining)} vitae</Box>
        </Stack.Item>
      </Stack>
      <Box mt={0.8}>
        <ProgressBar value={ratio} color="red">
          {formatPercent(project.progress)}
        </ProgressBar>
      </Box>
      <Box color="#563f37" mt={0.5} fontSize={0.9}>
        Contributors: {project.contributorsText}
      </Box>
      {project.canContribute && (
        <Box color="#563f37" mt={0.3} fontSize={0.9}>
          {project.contributionText}
        </Box>
      )}
    </Box>
  );
};

type AvailableProjectCardProps = {
  project: AvailableProject;
  onStart: () => void;
};

const AvailableProjectCard = (props: AvailableProjectCardProps) => {
  const { project, onStart } = props;

  return (
    <Box mb={1} style={availableCardStyle}>
      <Stack align="center">
        <Stack.Item>
          <Box style={sealStyle}>{project.accessSeal}</Box>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box bold fontSize={1.08}>
            {project.name} {project.accessText}
          </Box>
        </Stack.Item>
      </Stack>
      <ProjectCopy description={project.description} mechanics={project.mechanics} />
      <Stack align="center" mt={0.3}>
        <Stack.Item grow>
          <Box color="#563f37">Cost: {formatVitae(project.cost)} vitae</Box>
          {!project.canStart && (
            <Box color="#6c1f25" mt={0.4} fontSize={0.9}>
              {project.lockedReason}
            </Box>
          )}
        </Stack.Item>
        <Stack.Item width="112px">
          <Button
            fluid
            color="red"
            disabled={!project.canStart}
            onClick={onStart}
          >
            Start
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
