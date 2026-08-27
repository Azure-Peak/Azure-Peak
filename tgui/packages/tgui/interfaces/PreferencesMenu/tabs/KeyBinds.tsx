import { LoadingScreen } from 'interfaces/common/LoadingScreen';
import { LabeledGridList } from 'pm/components';
import { type ConstantData, useConstantPrefs } from 'pm/constant_data';
import type { KeyBind, KeybindsPageData } from 'pm/data';
import { useBackendStrict } from 'tgui/backend';
import { Box, Button, Section } from 'tgui-core/components';

export const KeyBinds = (props) => {
  const [constantData] = useConstantPrefs();
  const { act, data } = useBackendStrict<KeybindsPageData>();
  const { keybindings } = data;

  if (!constantData) {
    return (
      <Section fill scrollable>
        <LoadingScreen />
      </Section>
    );
  }

  return (
    <Section fill scrollable title="Keybinds (Auto-Saves on Change)">
      <LabeledGridList>
        {keybindings.map((kb) => (
          <Keybind key={kb.name} constantData={constantData} kb={kb} />
        ))}
      </LabeledGridList>
      <Button color="bad" onClick={() => act('keybindings_reset')}>
        [Reset to default]
      </Button>
    </Section>
  );
};

const Keybind = (props: { kb: KeyBind; constantData: ConstantData }) => {
  const { kb, constantData } = props;
  const { act } = useBackendStrict();
  const { MAX_KEYS_PER_KEYBIND } = constantData;

  return (
    <LabeledGridList.Item label={kb.full_name}>
      {kb.user_binds?.length ? (
        kb.user_binds.map((binding, idx) => (
          <Button
            key={idx}
            inline
            onClick={() =>
              act('keybindings_capture', {
                keybinding: kb.name,
                old_key: binding,
              })
            }
          >
            {binding}
          </Button>
        ))
      ) : (
        <Button
          inline
          onClick={() =>
            act('keybindings_capture', {
              keybinding: kb.name,
              old_key: 'Unbound',
            })
          }
        >
          Unbound
        </Button>
      )}
      {/* only show if it's not unbound */}
      {(kb.user_binds?.length || MAX_KEYS_PER_KEYBIND) <
      MAX_KEYS_PER_KEYBIND ? (
        <Button
          inline
          onClick={() => act('keybindings_capture', { keybinding: kb.name })}
        >
          Add Secondary
        </Button>
      ) : null}
      {kb.default_keys?.length ? (
        <Box inline>
          Default:&nbsp;
          {kb.default_keys.join(',')}
        </Box>
      ) : null}
    </LabeledGridList.Item>
  );
};
