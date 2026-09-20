import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

type HeadshotButtonProps = {
  action: string;
  link: string | null;
  subtitle: string;
} & Pick<React.ComponentProps<typeof Button>, 'tooltip' | 'tooltipPosition'>;

/**
 * This is effectively a home-rolled {@link https://tgstation.github.io/tgui-core/?path=/docs/components-imagebutton--docs | ImageButton}, but:
 * 1. It is hardcoded to be 100px x 100px
 * 2. It is made to fit a little better in our margins
 * 3. ImageButton cannot disable pixelated rendering, but we actually want anti-aliasing
 */
export const HeadshotButton = (props: HeadshotButtonProps) => {
  const { action, link, subtitle, tooltip, tooltipPosition } = props;
  const { act } = useBackendStrict();

  return (
    <Button
      color="transparent"
      tooltip={tooltip}
      tooltipPosition={tooltipPosition}
      onClick={() => act(action)}
    >
      <Stack align="center" vertical>
        {link ? (
          <Stack.Item width="100px" height="100px">
            <img src={link} width="100%" height="100%" />
          </Stack.Item>
        ) : (
          <Stack.Item
            width="100px"
            height="100px"
            backgroundColor="black"
            fontSize={3}
          >
            <Stack fill align="center" justify="center">
              <Stack.Item>?</Stack.Item>
            </Stack>
          </Stack.Item>
        )}
        <Stack.Item fontSize={0.9}>{subtitle}</Stack.Item>
      </Stack>
    </Button>
  );
};
