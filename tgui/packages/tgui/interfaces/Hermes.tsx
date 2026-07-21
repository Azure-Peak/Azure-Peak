import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  Section,
  Stack,
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
};

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
  } = data;

  const [recipient, setRecipient] = useState('');
  const [sender, setSender] = useState('');
  const [letterContent, setLetterContent] = useState('');

  const isFree = !!free_send_ready;
  const canSendLetter =
    recipient.length > 0 && (isFree || balance >= letter_cost);
  const canBuyPaper = balance >= paper_cost;
  const canBuyQuill = balance >= quill_cost;
  const canSendTube = letterContent.length > 0;

  return (
    <Window title="HERMES" width={400} height={480}>
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
                    <Stack.Item grow>
                      <Input
                        fluid
                        placeholder="From: Anonymous"
                        value={sender}
                        onChange={(value) => setSender(value)}
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
                            sender: sender || 'Anonymous',
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
                              sender: sender || 'Anonymous',
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
