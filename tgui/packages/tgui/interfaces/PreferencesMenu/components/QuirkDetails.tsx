import type { ConstantQuirk } from 'pm/constant_data';
import { Box, Stack } from 'tgui-core/components';

type QuirkDetailsProps = { quirk: ConstantQuirk };

export const QuirkDetails = (props: QuirkDetailsProps) => {
  const { quirk } = props;

  return (
    <Stack vertical>
      <Stack.Item>
        <Box bold style={{ textDecoration: 'underline' }}>
          Description
        </Box>
        <Box dangerouslySetInnerHTML={{ __html: quirk.desc }} />
      </Stack.Item>
      {quirk.mechdesc ? (
        <Stack.Item>
          <Box bold style={{ textDecoration: 'underline' }}>
            Mechanical Description
          </Box>
          <Box dangerouslySetInnerHTML={{ __html: quirk.mechdesc }} />
        </Stack.Item>
      ) : null}
      {quirk.added_traits.length ? (
        <Stack.Item>
          <Box bold style={{ textDecoration: 'underline' }}>
            This quirk grants the following traits
          </Box>
          {quirk.added_traits.map((trait) => (
            <Box key={trait.name}>
              {trait.name} -{' '}
              <Box as="span" dangerouslySetInnerHTML={{ __html: trait.desc }} />
            </Box>
          ))}
        </Stack.Item>
      ) : null}
      {quirk.greater ? (
        <Stack.Item bold>
          This quirk can only be picked using a greater quirk slot.
        </Stack.Item>
      ) : null}
    </Stack>
  );
};
