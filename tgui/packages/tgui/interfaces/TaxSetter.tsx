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

type Data = {
  categoryRates: CategoryRate[];
};

export const TaxSetter = (props: any, context: any) => {
  const { act, data } = useBackend<Data>();

  const [rates, setRates] = useState<Record<string, number>>(() => {
    if (!data.categoryRates) return {};
    return Object.fromEntries(data.categoryRates.map((c) => [c.category, c.rate]));
  });

  const updateRate = (category: string, newRate: number) => {
    setRates((prev) => ({ ...prev, [category]: newRate }));
  };

  const payload = Object.entries(rates).map(([category, rate]) => ({
    category,
    rate,
  }));

  return (
    <Window width={320} height={360}>
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
        </Stack>
      </Window.Content>
    </Window>
  );
};
