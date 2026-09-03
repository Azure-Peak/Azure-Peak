import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

/**
 * Save/Undo button stack used across the character creator.
 */
export const SaveUndo = (props) => {
  const { act } = useBackendStrict();

  return (
    <>
      <Stack.Item>
        <Button fluid icon="floppy-disk" onClick={() => act('save')}>
          Save
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button.Confirm
          fluid
          confirmIcon="exclamation-triangle"
          confirmContent="Reset all changes?"
          icon="rotate-left"
          onClick={() => act('load')}
        >
          Undo (Reload Slot)
        </Button.Confirm>
      </Stack.Item>
    </>
  );
};
