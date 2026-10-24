import { useState } from 'react';
import {
  Box,
  Button,
  Floating,
  Input,
  Section,
  Stack,
  Table,
  TextArea,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  balance: number;
  paper_cost: number;
  quill_cost: number;
  letter_cost: number;
  free_send_ready: 0 | 1;
  free_send_remaining_ds: number;
  has_tube?: boolean;
  ghost_mode?: boolean;
  delay_min?: number;
  delay_max?: number;
  letter_count?: number;
};

const FORMATTING_HELP: [string, string][] = [
  ['# text', 'Defines a header.'],
  ['|text|', 'Centers the text.'],
  ['**text**', 'Makes the text bold.'],
  ['*text*', 'Makes the text italic.'],
  ['^text^', 'Increases the size of the text.'],
  ['((text))', 'Decreases the size of the text.'],
  ['%s', 'Inserts a signature of your name in a foolproof way.'],
  [
    '%f',
    'Inserts an invisible field which lets you start typing from there. Useful for forms.',
  ],
  ['* item', 'An unordered list item.'],
  ['  * item', 'An unordered list child item.'],
  ['---', 'Adds a horizontal rule.'],
  ['-=FFFFFFtext=-', 'Adds a specific colour to text.'],
];

const FormattingHelp = () => (
  <Box>
    <Table>
      {FORMATTING_HELP.map(([syntax, description], index) => {
        const divider =
          index < FORMATTING_HELP.length - 1
            ? '1px solid rgba(255, 255, 255, 0.1)'
            : undefined;
        return (
          <Table.Row key={syntax}>
            <Table.Cell
              collapsing
              pr={1}
              style={{
                fontFamily: 'monospace',
                whiteSpace: 'pre',
                borderBottom: divider,
              }}
            >
              {syntax}
            </Table.Cell>
            <Table.Cell style={{ borderBottom: divider }}>
              {description}
            </Table.Cell>
          </Table.Row>
        );
      })}
    </Table>
  </Box>
);

const HERMES_TITLE = `${'\u00A0'.repeat(6)}HERMES`;

const dsToMinutes = (ds: number) => Math.round(ds / 600);

const dsToClock = (ds: number) => {
  if (ds <= 0) return '0s';
  const totalSeconds = Math.ceil(ds / 10);
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  if (minutes <= 0) return `${seconds}s`;
  return `${minutes}m ${seconds}s`;
};

export const Hermes = (props: any, context: any) => {
  const { act, data } = useBackend<Data>();
  const {
    balance,
    paper_cost,
    quill_cost,
    letter_cost,
    free_send_ready,
    free_send_remaining_ds,
    has_tube,
    ghost_mode,
    delay_min,
    delay_max,
    letter_count,
  } = data;

  const [recipient, setRecipient] = useState('');
  const [letterContent, setLetterContent] = useState('');

  const helpButton = (
    <Box
      style={{
        position: 'fixed',
        top: '2px',
        left: '8px',
        height: '32px',
        display: 'flex',
        alignItems: 'center',
      }}
    >
      <Floating
        hoverOpen
        placement="bottom-start"
        content={<FormattingHelp />}
        contentStyles={{
          width: '340px',
          padding: '6px 8px',
          textAlign: 'left',
          background: 'rgba(15, 15, 15, 0.97)',
          border: '1px solid rgba(255, 255, 255, 0.15)',
          borderRadius: '4px',
        }}
      >
        <Button compact icon="question-circle" color="transparent" />
      </Floating>
    </Box>
  );

  const isFree = !!free_send_ready;
  const canSendLetter =
    recipient.length > 0 && (isFree || balance >= letter_cost);
  const canBuyPaper = balance >= paper_cost;
  const canBuyQuill = balance >= quill_cost;
  const canSendTube = letterContent.length > 0;

  if (ghost_mode) {
    const canPost = recipient.length > 0 && letterContent.length > 0;
    const delayLabel =
      delay_min && delay_max
        ? `${dsToMinutes(delay_min)}-${dsToMinutes(delay_max)} minutes`
        : 'some time';

    return (
      <Window title={HERMES_TITLE} width={400} height={440} buttons={helpButton}>
        <Window.Content>
          <Stack vertical fill>
            <Stack.Item>
              <Box italic color="label">
                A letter posted from beyond takes {delayLabel} to arrive.
              </Box>
            </Stack.Item>
            {!!letter_count && (
              <Stack.Item>
                <Button
                  fluid
                  icon="envelope-open-text"
                  onClick={() => act('read_letters')}
                >
                  Read My Letters ({letter_count})
                </Button>
              </Stack.Item>
            )}
            <Stack.Item grow>
              <Section title="Post a Letter" fill>
                <Stack vertical fill>
                  <Stack.Item>
                    <Stack>
                      <Stack.Item grow>
                        <Input
                          fluid
                          placeholder="To: Name or #number"
                          value={recipient}
                          onChange={(value) => setRecipient(value)}
                        />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                  <Stack.Item grow>
                    <TextArea
                      fluid
                      height="100%"
                      placeholder="Write your letter here..."
                      value={letterContent}
                      maxLength={2000}
                      onChange={(value) => setLetterContent(value)}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      fluid
                      icon="paper-plane"
                      color="good"
                      disabled={!canPost}
                      onClick={() =>
                        act('send_letter', {
                          recipient: recipient,
                          content: letterContent,
                        })
                      }
                    >
                      Post Letter
                    </Button>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window title={HERMES_TITLE} width={400} height={480} buttons={helpButton}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Stack align="center">
              <Stack.Item>
                <Box bold inline mr={1} color={balance <= 0 ? 'bad' : 'good'}>
                  {balance} Mammon
                </Box>
              </Stack.Item>
              <Stack.Item grow>
                <Stack>
                  <Stack.Item>
                    <Button
                      compact
                      icon="scroll"
                      disabled={!canBuyPaper}
                      onClick={() => act('buy_paper')}
                    >
                      Paper ({paper_cost})
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      compact
                      icon="feather"
                      disabled={!canBuyQuill}
                      onClick={() => act('buy_quill')}
                    >
                      Quill ({quill_cost})
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <Button
                  compact
                  icon="coins"
                  color="caution"
                  disabled={balance <= 0}
                  onClick={() => act('refund')}
                >
                  Refund
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item grow>
            <Section
              title={
                isFree
                  ? 'Write Letter (free letter ready)'
                  : `Write Letter (${letter_cost} mammon, next free in ${dsToClock(free_send_remaining_ds)})`
              }
              fill
            >
              <Stack vertical fill>
                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <Input
                        fluid
                        placeholder="To: Name or #number"
                        value={recipient}
                        onChange={(value) => setRecipient(value)}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item grow>
                  <TextArea
                    fluid
                    height="100%"
                    placeholder="Write your letter here..."
                    value={letterContent}
                    maxLength={2000}
                    onChange={(value) => setLetterContent(value)}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item grow>
                      <Button
                        fluid
                        icon="paper-plane"
                        color={isFree ? 'good' : undefined}
                        disabled={!canSendLetter}
                        onClick={() =>
                          act('send_letter', {
                            recipient: recipient,
                            content: letterContent,
                          })
                        }
                      >
                        {isFree ? 'Send Letter (Free)' : 'Send Letter'}
                      </Button>
                    </Stack.Item>
                    {has_tube && (
                      <Stack.Item grow>
                        <Button
                          fluid
                          icon="paper-plane"
                          color="teal"
                          disabled={!canSendTube}
                          onClick={() =>
                            act('send_tube', {
                              content: letterContent,
                            })
                          }
                        >
                          Send Through Tube (Free)
                        </Button>
                      </Stack.Item>
                    )}
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
