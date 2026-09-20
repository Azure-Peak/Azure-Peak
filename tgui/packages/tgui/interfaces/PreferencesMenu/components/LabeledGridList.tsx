import type { ComponentProps, PropsWithChildren, ReactNode } from 'react';
import { Box, Divider, type LabeledList, Tooltip } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { unit } from 'tgui-core/ui';

/**
 * Pixel accurate {@link LabeledList} using css grid instead of tables
 * Works better in relative width flexboxes compared to tables
 */
export function LabeledGridList(props: PropsWithChildren) {
  const { children } = props;
  return <Box className="PreferencesMenu__LabeledGridList">{children}</Box>;
}

/**
 * @see {@link LabeledList.Divider}
 */
function LabeledGridListDivider(
  props: ComponentProps<typeof LabeledList.Divider>,
) {
  const { size } = props;
  const padding = size ? unit(Math.max(0, size - 1)) : 0;

  return (
    <Box
      className="PreferencesMenu__LabeledGridList__Divider"
      style={{ paddingBottom: padding, paddingTop: padding }}
    >
      <Divider />{' '}
    </Box>
  );
}

/**
 * @see {@link LabeledList.Item}
 */
function LabeledGridListItem(props: ComponentProps<typeof LabeledList.Item>) {
  const {
    className,
    label,
    labelColor = 'label',
    labelWrap,
    color,
    textAlign,
    buttons,
    content,
    children,
    preserveWhitespace,
    tooltip,
    tooltipPosition,
  } = props;

  let innerLabel: ReactNode;
  if (label) {
    innerLabel = label;
    if (typeof label === 'string') innerLabel += ':';
  }

  if (tooltip !== undefined) {
    innerLabel = (
      <Tooltip content={tooltip} position={tooltipPosition}>
        <Box
          as="span"
          style={{
            borderBottom: '2px dotted rgba(255, 255, 255, 0.8)',
          }}
        >
          {innerLabel}
        </Box>
      </Tooltip>
    );
  }

  const labelClass = 'PreferencesMenu__LabeledGridList__Label';

  let contentClass = 'PreferencesMenu__LabeledGridList__Content__Center';
  if (!buttons && !innerLabel) {
    contentClass = 'PreferencesMenu__LabeledGridList__Content__Full';
  } else if (!buttons) {
    contentClass = 'PreferencesMenu__LabeledGridList__Content__Right';
  } else if (!innerLabel) {
    contentClass = 'PreferencesMenu__LabeledGridList__Content__Left';
  }

  const buttonClass = 'PreferencesMenu__LabeledGridList__Buttons';

  const labelChild = innerLabel ? (
    <Box
      className={classes([
        labelClass,
        !labelWrap && 'LabeledList__label--nowrap',
        className,
      ])}
      color={labelColor}
      preserveWhitespace={preserveWhitespace}
    >
      {innerLabel}
    </Box>
  ) : null;

  return (
    <>
      {labelChild}
      <Box
        className={classes([contentClass, className])}
        color={color}
        textAlign={textAlign}
      >
        {content}
        {children}
      </Box>
      {buttons ? (
        <Box className={classes([buttonClass, className])}>{buttons}</Box>
      ) : null}
    </>
  );
}

export namespace LabeledGridList {
  /**
   * @see {@link LabeledList.Divider}
   */
  export const Divider = LabeledGridListDivider;
  /**
   * @see {@link LabeledList.Item}
   */
  export const Item = LabeledGridListItem;
}
