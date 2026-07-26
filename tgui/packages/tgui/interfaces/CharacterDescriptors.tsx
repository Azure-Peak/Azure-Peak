import { Button, LabeledList, NoticeBox, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Choice = {
  name: string;
  type: string;
  current: string;
};

type Custom = {
  index: number;
  name: string;
  content: string;
  has_prefix: BooleanLike;
  prefix: string | null;
};

type Data = {
  choices: Choice[];
  customs: Custom[];
};

export function CharacterDescriptors(props) {
  const { act, data } = useBackend<Data>();
  return (
    <Window width={400} height={560} theme="parchment" title="Describe Myself">
      <Window.Content scrollable>
        <Section
          title="Descriptors"
          buttons={
            <Button
              icon="print"
              tooltip="Print descriptor setup to chat"
              onClick={() => act('print')}
            >
              Print
            </Button>
          }
        >
          <LabeledList>
            {data.choices.map((choice) => (
              <LabeledList.Item key={choice.type} label={choice.name}>
                <Button onClick={() => act('choose', { type: choice.type })}>
                  {choice.current}
                </Button>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
        {data.customs.length > 0 && (
          <Section title="Custom Descriptors">
            <LabeledList>
              {data.customs.map((custom) => (
                <LabeledList.Item key={custom.index} label={custom.name}>
                  {!!custom.has_prefix && (
                    <Button
                      onClick={() => act('prefix', { index: custom.index })}
                    >
                      {custom.prefix}
                    </Button>
                  )}
                  <Button
                    onClick={() => act('content', { index: custom.index })}
                  >
                    {custom.content || 'Set...'}
                  </Button>
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        )}
        <NoticeBox info>
          Custom descriptor rules: no proper nouns, no immersion-breaking words,
          no overtly sexual descriptors. Look at the pre-written descriptors for
          examples of what is acceptable. Capitalization is handled
          automatically.
        </NoticeBox>
      </Window.Content>
    </Window>
  );
}
