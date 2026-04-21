import { useState } from 'react';
import {
  Button,
  LabeledList,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type CategoryRate = {
  category: string;
  rate: number;
};

type PollTaxRate = {
  category: string;
  label: string;
  rate: number;
};

type Data = {
  categoryRates: CategoryRate[];
  pollTaxRates: PollTaxRate[];
  pollTaxMax: number;
};

export const TaxSetter = (props: any, context: any) => {
  const { act, data } = useBackend<Data>();

  const [rates, setRates] = useState<Record<string, number>>(() => {
    if (!data.categoryRates) return {};
    return Object.fromEntries(
      data.categoryRates.map((c) => [c.category, c.rate]),
    );
  });

  const [pollRates, setPollRates] = useState<Record<string, number>>(() => {
    if (!data.pollTaxRates) return {};
    return Object.fromEntries(
      data.pollTaxRates.map((c) => [c.category, c.rate]),
    );
  });

  const updateRate = (category: string, newRate: number) => {
    setRates((prev) => ({ ...prev, [category]: newRate }));
  };

  const updatePollRate = (category: string, newRate: number) => {
    setPollRates((prev) => ({ ...prev, [category]: newRate }));
  };

  const payload = Object.entries(rates).map(([category, rate]) => ({
    category,
    rate,
  }));

  const pollPayload = Object.entries(pollRates).map(([category, rate]) => ({
    category,
    rate,
  }));

  const pollMax = data.pollTaxMax ?? 50;

  return (
    <Window width={360} height={640}>
      <Window.Content>
        <Stack vertical>
          <Stack.Item>
            <Section title="Crown Levies">
              <LabeledList>
                {data.categoryRates?.map((c) => (
                  <LabeledList.Item key={c.category} label={c.category}>
                    <NumberInput
                      step={1}
                      minValue={0}
                      maxValue={100}
                      unit="%"
                      value={rates[c.category] ?? c.rate}
                      onChange={(v: number) => updateRate(c.category, v)}
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm
              fluid
              color="transparent"
              className="input-button__submit"
              textAlign="Center"
              onClick={() => act('set_rates', { categoryRates: payload })}
            >
              MAKE IT SO
            </Button.Confirm>
          </Stack.Item>
          <Stack.Item>
            <Section title="Poll Tax (per category, daily)">
              <LabeledList>
                {data.pollTaxRates?.map((c) => (
                  <LabeledList.Item key={c.category} label={c.label}>
                    <NumberInput
                      step={1}
                      minValue={0}
                      maxValue={pollMax}
                      unit="m"
                      value={pollRates[c.category] ?? c.rate}
                      onChange={(v: number) => updatePollRate(c.category, v)}
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm
              fluid
              color="transparent"
              className="input-button__submit"
              textAlign="Center"
              onClick={() =>
                act('set_poll_rates', { pollTaxRates: pollPayload })
              }
            >
              SET POLL TAXES
            </Button.Confirm>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
