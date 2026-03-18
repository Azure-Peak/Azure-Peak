import { memo } from 'react';
import { Box, Section } from 'tgui-core/components';

type Props = {
  html: string;
};

export const RecipeBookEntry = memo((props: Props) => {
  const { html } = props;

  if (!html) {
    return (
      <Section fill scrollable>
        <Box color="label" textAlign="center" mt={4}>
          Select an entry from the list to view details.
        </Box>
      </Section>
    );
  }

  return (
    <Section fill scrollable>
      <style>
        {`
          .recipe-detail .icon { margin-right: 8px; vertical-align: middle; }
          .recipe-detail h2 {
            border-bottom: 1px solid currentColor;
            padding-bottom: 4px;
            margin-bottom: 8px;
          }
          .recipe-detail h3 {
            border-bottom: 1px solid currentColor;
            padding-bottom: 4px;
            margin-top: 16px;
            margin-bottom: 8px;
          }
          .recipe-detail .recipe-desc {
            border-bottom: 1px solid rgba(255, 255, 255, 0.15);
            padding-bottom: 8px;
            margin-bottom: 12px;
          }
          .recipe-detail hr {
            border: none;
            border-top: 1px solid rgba(255, 255, 255, 0.15);
            margin: 12px 0;
          }
        `}
      </style>
      <Box
        className="recipe-detail"
        dangerouslySetInnerHTML={{ __html: html }}
        style={{
          textAlign: 'left',
        }}
      />
    </Section>
  );
});
