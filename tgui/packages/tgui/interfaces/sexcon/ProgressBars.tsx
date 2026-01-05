import { Box, Section, Stack } from 'tgui-core/components';

interface ProgressBarsProps {
  arousal: number;
}

interface CustomProgressBarProps {
  label: string;
  value: number;
  gradient: string;
}

const CustomProgressBar = (props: CustomProgressBarProps) => {
  const { label, value, gradient } = props;

  return (
    <Stack align="center">
      <Stack.Item>
        <Box bold mr={1} minWidth="70px">{label}:</Box>
      </Stack.Item>
      <Stack.Item grow>
        <Box
          style={{
            height: '25px',
            position: 'relative',
            overflow: 'hidden',
            border: '1px solid var(--color-border)',
          }}
        >
          <Box
            style={{
              background: gradient,
              height: '100%',
              width: `${Math.min(100, Math.max(0, value))}%`,
              transition: 'width 0.3s',
            }}
          />
          <Box
            style={{
              position: 'absolute',
              right: '10px',
              top: '50%',
              transform: 'translateY(-50%)',
              fontWeight: 'bold',
              textShadow: '1px 1px 2px rgba(0,0,0,0.8)',
            }}
          >
            {value.toFixed(0)}%
          </Box>
        </Box>
      </Stack.Item>
    </Stack>
  );
};

export const ProgressBars = (props: ProgressBarsProps) => {
  const { arousal } = props;

  return (
    <Section>
      <Stack vertical>
        <Stack.Item>
          <CustomProgressBar
            label="Arousal"
            value={arousal}
            gradient="linear-gradient(90deg, #ff4444, #cc0000)"
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
