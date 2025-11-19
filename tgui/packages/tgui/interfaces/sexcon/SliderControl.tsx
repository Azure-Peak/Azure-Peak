import { Box, Button, Stack } from 'tgui-core/components';

interface SliderControlProps {
  label: string;
  value: number; // 1-4
  options: string[]; // Array of 4 option names
  onChange: (value: number) => void;
}

export const SliderControl = (props: SliderControlProps) => {
  const { label, value, options, onChange } = props;

  return (
    <Box mb={2}>
      <Box bold mb={1}>
        {label}:
      </Box>
      <Stack>
        {options.map((option, index) => {
          const optionValue = index + 1;
          const isSelected = value === optionValue;

          return (
            <Stack.Item key={index} grow>
              <Button
                fluid
                color={isSelected ? 'good' : 'default'}
                selected={isSelected}
                onClick={() => onChange(optionValue)}
              >
                {option}
              </Button>
            </Stack.Item>
          );
        })}
      </Stack>
      <Box textAlign="center" mt={1} color="label" fontSize="0.9em" italic>
        Current: {options[value - 1] || 'Unknown'}
      </Box>
    </Box>
  );
};