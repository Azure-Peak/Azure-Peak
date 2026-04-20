import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  Divider,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';

type Theme = {
  key: string;
  name: string;
};

type ThemePickerData = {
  themes: Theme[];
  current: string;
};

export const ThemePicker = () => {
  const { act, data } = useBackend<ThemePickerData>();
  const { themes = [], current } = data;

  return (
    <Window title="TGUI Theme" width={580} height={520} theme={current}>
      <Window.Content>
        <Stack fill>
          <Stack.Item basis="45%">
            <Section fill scrollable title="Themes">
              <Stack vertical>
                {themes.map((theme) => (
                  <Stack.Item key={theme.key}>
                    <Button
                      fluid
                      selected={theme.key === current}
                      onClick={() => act('preview', { theme: theme.key })}
                    >
                      {theme.name}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <Stack vertical fill>
              <Stack.Item grow>
                <Section fill title="Preview">
                  <LabeledList>
                    <LabeledList.Item label="Text">
                      This is how body text appears.
                    </LabeledList.Item>
                    <LabeledList.Item label="Label">
                      Labels and secondary text.
                    </LabeledList.Item>
                    <LabeledList.Item label="Emphasis">
                      <em>Emphasized text stands out.</em>
                    </LabeledList.Item>
                    <LabeledList.Item label="Link">
                      <a href="#">Hyperlink example</a>
                    </LabeledList.Item>
                  </LabeledList>
                  <Divider />
                  <Stack>
                    <Stack.Item>
                      <Button>Default</Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button selected>Schlechted</Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button disabled>Disabled</Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button color="transparent">Transparent</Button>
                    </Stack.Item>
                  </Stack>
                  <Divider />
                  <ProgressBar value={0.65}>Momentum: 65%</ProgressBar>
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section>
                  <em>
                    &quot;True is my strike and sharp is my edge.&quot;
                  </em>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
