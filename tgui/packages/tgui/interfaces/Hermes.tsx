import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  LabeledList,
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
            <Section title="Balance">
              <Box fontSize="1.2em" textAlign="center" bold>
                {balance} Mammon
              </Box>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Supplies">
              <Stack>
                <Stack.Item grow>
                  <Button
                    fluid
                    icon="scroll"
                    disabled={!canBuyPaper}
                    onClick={() => act('buy_paper')}
                  >
                    Paper ({paper_cost} mammon)
                  </Button>
                </Stack.Item>
                <Stack.Item grow>
                  <Button
                    fluid
                    icon="feather"
                    disabled={!canBuyQuill}
                    onClick={() => act('buy_quill')}
                  >
                    Quill ({quill_cost} mammon)
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section title={`Write Letter (${letter_cost} mammon)`} fill>
              <Stack vertical fill>
                <Stack.Item>
                  <LabeledList>
                    <LabeledList.Item label="To">
                      <Input
                        fluid
                        placeholder="Name or #number"
                        value={recipient}
                        onChange={(value) => setRecipient(value)}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="From">
                      <Input
                        fluid
                        placeholder="Anonymous"
                        value={sender}
                        onChange={(value) => setSender(value)}
                      />
                    </LabeledList.Item>
                  </LabeledList>
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

          <Stack.Item>
            <Button
              fluid
              icon="coins"
              color="caution"
              disabled={balance <= 0}
              onClick={() => act('refund')}
            >
              Return Coins
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
