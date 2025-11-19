import { Box, Section, Stack } from 'tgui-core/components';

interface SessionHeaderProps {
  title: string;
  characterInfo: string;
}

export const SessionHeader = (props: SessionHeaderProps) => {
  const { title, characterInfo } = props;

  return (
    <Section>
      <Stack vertical>
        <Stack.Item>
          <Box bold fontSize="1.2em" color="good">
            {title}
          </Box>
        </Stack.Item>
        {characterInfo && (
          <Stack.Item>
            <Box color="label" fontSize="0.9em">
              {characterInfo}
            </Box>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};
