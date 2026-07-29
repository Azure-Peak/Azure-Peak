import { Box, Button, NoticeBox, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type SubclassSlot = {
  name: string;
  occupied: number;
  max: number;
};

type Incompatibility = {
  subclass: string;
  reasons: string[];
};

type JobEntry = {
  title: string;
  name: string;
  current: number;
  total: number;
  command: BooleanLike;
  prioritized: BooleanLike;
  subclass_slots: SubclassSlot[];
  incompatibilities: Incompatibility[];
};

type Category = {
  name: string;
  color: string;
  jobs: JobEntry[];
};

type Siege = {
  title: string;
  label: string;
};

type Data = {
  round_duration: string;
  sieges: Siege[];
  categories: Category[];
};

const JobRow = (props: { job: JobEntry }) => {
  const { act } = useBackend<Data>();
  const { job } = props;
  return (
    <Box>
      {job.incompatibilities.length > 0 && (
        <Button
          color="transparent"
          textColor="bad"
          bold
          tooltip={
            <Box>
              Incompatible with your character:
              {job.incompatibilities.map((inc) => (
                <Box key={inc.subclass}>
                  <b>{inc.subclass}</b>: {inc.reasons.join(', ')}
                </Box>
              ))}
            </Box>
          }
        >
          (!!)
        </Button>
      )}
      {job.subclass_slots.length > 0 && (
        <Button
          color="transparent"
          textColor="#6b6743"
          bold
          tooltip={
            <Box>
              Subclass slots:
              {job.subclass_slots.map((slot) => (
                <Box key={slot.name}>
                  {slot.name} —{' '}
                  <b>
                    {slot.occupied >= slot.max
                      ? 'FULL!'
                      : `${slot.occupied} / ${slot.max}`}
                  </b>
                </Box>
              ))}
            </Box>
          }
        >
          (!)
        </Button>
      )}
      <Button
        color="transparent"
        bold={!!job.command}
        textColor={job.prioritized ? 'good' : undefined}
        onClick={() => act('join', { title: job.title })}
      >
        {job.name} ({job.current}/{job.total})
      </Button>
    </Box>
  );
};

export function LateJoin(props) {
  const { act, data } = useBackend<Data>();
  return (
    <Window width={720} height={620} title="Choose Class">
      <Window.Content scrollable>
        <NoticeBox info>Round Duration: {data.round_duration}</NoticeBox>
        {data.sieges.map((siege) => (
          <Section key={siege.title}>
            <Button
              fluid
              color="bad"
              bold
              textAlign="center"
              onClick={() => act('join', { title: siege.title })}
            >
              {siege.label}
            </Button>
          </Section>
        ))}
        <Stack wrap>
          {data.categories.map((category) => (
            <Stack.Item key={category.name} width="230px" mb={1}>
              <Section
                title={
                  <Box inline bold color={category.color}>
                    {category.name}
                  </Box>
                }
              >
                {category.jobs.map((job) => (
                  <JobRow key={job.title} job={job} />
                ))}
              </Section>
            </Stack.Item>
          ))}
        </Stack>
      </Window.Content>
    </Window>
  );
}
