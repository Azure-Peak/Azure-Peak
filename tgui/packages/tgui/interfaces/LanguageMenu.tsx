import { Button, Section, Stack, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Language = {
  name: string;
  desc: string;
  key: string;
};

type KnownLanguage = Language & {
  is_default: BooleanLike;
  shadow: BooleanLike;
  can_speak: BooleanLike;
};

type Data = {
  is_living: BooleanLike;
  languages: KnownLanguage[];
  admin_mode: BooleanLike;
  omnitongue: BooleanLike;
  unknown_languages: Language[];
};

export const LanguageMenu = (props) => {
  const { data } = useBackend<Data>();
  const { admin_mode } = data;

  return (
    <Window width={600}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <KnownLanguages />
          </Stack.Item>
          {admin_mode ? (
            <Stack.Item grow>
              <AdminMenu />
            </Stack.Item>
          ) : null}
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const KnownLanguages = (props) => {
  const { data } = useBackend<Data>();

  const { languages, admin_mode } = data;

  return (
    <Section title="Known Languages" fill scrollable>
      <Table>
        <Table.Row header>
          <Table.Cell header>Name</Table.Cell>
          <Table.Cell header collapsing textAlign="right">
            Key
          </Table.Cell>
          <Table.Cell header collapsing textAlign="center">
            Default?
          </Table.Cell>
          {admin_mode ? (
            <Table.Cell header collapsing textAlign="center">
              Del
            </Table.Cell>
          ) : null}
        </Table.Row>
        {languages.map((lang) => (
          <KnownLanguageRow key={lang.name} lang={lang} />
        ))}
      </Table>
    </Section>
  );
};

export const KnownLanguageRow = (props: { lang: KnownLanguage }) => {
  const { act, data } = useBackend<Data>();
  const { admin_mode } = data;
  const { lang } = props;

  return (
    <Table.Row>
      <Table.Cell>{lang.name}</Table.Cell>
      <Table.Cell textAlign="right">{lang.key}</Table.Cell>
      <Table.Cell textAlign="center">
        <Button.Checkbox
          checked={lang.is_default}
          selected={lang.is_default}
          onClick={() => act('select_default', { language_name: lang.name })}
        />
      </Table.Cell>
      {admin_mode ? (
        <Table.Cell textAlign="Right">
          <Button
            onClick={() => act('remove_language', { language_name: lang.name })}
          >
            Del
          </Button>
        </Table.Cell>
      ) : null}
    </Table.Row>
  );
};

export const AdminMenu = (props) => {
  const { act, data } = useBackend<Data>();

  const { unknown_languages, omnitongue } = data;

  return (
    <Section
      title="Unknown Languages"
      buttons={
        <Button selected={omnitongue} onClick={() => act('toggle_omnitongue')}>
          Omnitongue: {omnitongue ? 'On' : 'Off'}
        </Button>
      }
      fill
      scrollable
    >
      <Table>
        <Table.Row header>
          <Table.Cell header>Name</Table.Cell>
          <Table.Cell header collapsing>
            Key
          </Table.Cell>
          <Table.Cell header collapsing textAlign="center">
            Add
          </Table.Cell>
        </Table.Row>
        {unknown_languages.map((lang) => (
          <Table.Row key={lang.name}>
            <Table.Cell>{lang.name}</Table.Cell>
            <Table.Cell collapsing>{lang.key}</Table.Cell>
            <Table.Cell collapsing>
              <Button
                onClick={() =>
                  act('grant_language', { language_name: lang.name })
                }
              >
                Add
              </Button>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
