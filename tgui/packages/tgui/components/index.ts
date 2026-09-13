/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */
import type React from 'react';
import type { Tooltip } from 'tgui-core/components';

/**
 * Re-exports props from tgui-core so we can freely use them in our wrappers.
 */
export type TooltipProps = React.ComponentProps<typeof Tooltip>;
