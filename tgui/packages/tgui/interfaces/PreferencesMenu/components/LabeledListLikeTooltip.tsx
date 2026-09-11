import type { ComponentProps } from 'react';
import { Box, LabeledList, Tooltip } from 'tgui-core/components';

type LabeledListLikeTooltipProps = {
  tooltip: ComponentProps<typeof Tooltip>['content'];
  tooltipPosition?: ComponentProps<typeof Tooltip>['position'];
} & ComponentProps<typeof Box>;

/**
 * {@link LabeledList} underlines labels with a tooltip using a dotted border,
 * this allows us to replicate that on other elements for the sake of consistency
 */
export const LabeledListLikeTooltip = (props: LabeledListLikeTooltipProps) => {
  const { tooltip, tooltipPosition, children, ...boxProps } = props;

  return (
    <Tooltip content={tooltip} position={tooltipPosition}>
      <Box
        {...boxProps}
        as="span"
        style={{
          borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',
        }}
      >
        {children}
      </Box>
    </Tooltip>
  );
};
