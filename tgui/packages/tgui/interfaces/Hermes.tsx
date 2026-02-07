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
};

export const Hermes = (props: any, context: any) => {
  const { act, data } = useBackend<Data>();
  const { balance, paper_cost, quill_cost, letter_cost } = data;

  const [recipient, setRecipient] = useState('');
  const [sender, setSender] = useState('');
  const [letterContent, setLetterContent] = useState('');

  const canSendLetter = balance >= letter_cost && recipient.length > 0;
  const canBuyPaper = balance >= paper_cost;
  const canBuyQuill = balance >= quill_cost;

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
              title={`Write Letter (${letter_cost} mammon)`}
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
                  <Button
                    fluid
                    icon="paper-plane"
                    disabled={!canSendLetter}
                    onClick={() =>
                      act('send_letter', {
                        recipient: recipient,
                        sender: sender || 'Anonymous',
                        content: letterContent,
                      })
                    }
                  >
                    Send Letter
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
