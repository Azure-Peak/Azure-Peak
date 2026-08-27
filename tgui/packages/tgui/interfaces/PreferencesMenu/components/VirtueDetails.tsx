import type { ConstantVirtue } from 'pm/constant_data';
import { Box, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

const virtueTitle = (origin: BooleanLike) => {
  return origin ? 'Origin' : 'Virtue';
};

type VirtueDetailsProps = { virtue: ConstantVirtue };

export const VirtueDetails = (props: VirtueDetailsProps) => {
  const { virtue } = props;

  return (
    <Stack vertical>
      <Stack.Item>
        <Box bold style={{ textDecoration: 'underline' }}>
          Description
        </Box>
        <Box dangerouslySetInnerHTML={{ __html: virtue.desc }} />
      </Stack.Item>
      {virtue.origin_desc ? (
        <Stack.Item>
          <Box bold style={{ textDecoration: 'underline' }}>
            Origin Description
          </Box>
          <Box dangerouslySetInnerHTML={{ __html: virtue.origin_desc }} />
        </Stack.Item>
      ) : null}
      {virtue.added_skills.length ? (
        <Stack.Item>
          <Box bold style={{ textDecoration: 'underline' }}>
            This {virtueTitle(virtue.is_origin)} adds the following skills
          </Box>
          {virtue.added_skills.map((skill) => (
            <Box key={skill.name}>
              {skill.level} levels of {skill.name}{' '}
              {skill.max_level ? `up to ${skill.max_level}` : null}
            </Box>
          ))}
        </Stack.Item>
      ) : null}
      {virtue.softcap ? (
        <Stack.Item bold>
          This {virtueTitle(virtue.is_origin)} is soft capped, and values will
          only give you 1 level above the skill cap.
        </Stack.Item>
      ) : null}
      {virtue.added_traits.length ? (
        <Stack.Item>
          <Box bold style={{ textDecoration: 'underline' }}>
            This {virtueTitle(virtue.is_origin)} grants the following traits
          </Box>
          {virtue.added_traits.map((trait) => (
            <Box key={trait.name}>
              {trait.name} -{' '}
              <Box as="span" dangerouslySetInnerHTML={{ __html: trait.desc }} />
            </Box>
          ))}
        </Stack.Item>
      ) : null}
      {virtue.added_stashed_items.length ? (
        <Stack.Item>
          <Box bold style={{ textDecoration: 'underline' }}>
            This {virtueTitle(virtue.is_origin)} adds the following items to
            your stash
          </Box>
          {virtue.added_stashed_items.map((item) => (
            <Box key={item}>- {item}</Box>
          ))}
        </Stack.Item>
      ) : null}
      {virtue.added_languages.length ? (
        <Stack.Item>
          <Box bold style={{ textDecoration: 'underline' }}>
            This {virtueTitle(virtue.is_origin)} adds the following languages
          </Box>
          {virtue.added_languages.map((item) => (
            <Box key={item}>- {item}</Box>
          ))}
        </Stack.Item>
      ) : null}
      {virtue.custom_text ? (
        <Stack.Item>
          <Box bold style={{ textDecoration: 'underline' }}>
            This {virtueTitle(virtue.is_origin)} has this special behaviour
          </Box>
          {virtue.custom_text}
        </Stack.Item>
      ) : null}
      {virtue.stackable ? (
        <Stack.Item bold>
          This {virtueTitle(virtue.is_origin)} can be picked twice using a
          virtuous statpack.
        </Stack.Item>
      ) : null}
    </Stack>
  );
};
