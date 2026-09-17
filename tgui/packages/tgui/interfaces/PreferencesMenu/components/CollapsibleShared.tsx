import type { ReactNode } from 'react';
import { useSharedState } from 'tgui/backend';
import { Box, Button } from 'tgui-core/components';

type Props = React.PropsWithChildren<{
  stateKey: string;
  title: ReactNode;
  transparent?: boolean;
}>;

/**
 * This is effectively a home-rolled {@link https://tgstation.github.io/tgui-core/?path=/docs/components-collapsible--docs | Collapsible}, but:
 * 1. It uses {@link useSharedState} instead of {@link React.useState} so that it stays open between component renders.
 *     - This is important for how we use it, as persistent inner tab content.
 * 2. It is much simpler.
 */
export const CollapsibleShared = (props: Props) => {
  const { stateKey, title, transparent, children } = props;
  const [open, setOpen] = useSharedState(stateKey, false);

  return (
    <Box>
      <Button
        fluid
        color={transparent ? 'transparent' : undefined}
        textColor={transparent ? 'white' : undefined}
        icon={open ? 'chevron-down' : 'chevron-right'}
        onClick={() => setOpen(!open)}
      >
        {title}
      </Button>
      {open && <Box>{children}</Box>}
    </Box>
  );
};
