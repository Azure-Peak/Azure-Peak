import {
  Box,
  Button,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

export type DebugCounts = {
  derived_price_count: number;
  categorized_count: number;
  uncategorized_item_count: number;
  total_item_count: number;
};

type Props = {
  debug: DebugCounts;
  act: (action: string, payload?: Record<string, unknown>) => void;
};

export const DebugView = (props: Props) => {
  const { debug, act } = props;
  return (
    <>
      <Section title="Pricing Engine Counts">
        <LabeledList>
          <LabeledList.Item label="Derived Prices">
            {debug.derived_price_count}
          </LabeledList.Item>
          <LabeledList.Item label="Categorized Subtypes">
            {debug.categorized_count}
          </LabeledList.Item>
          <LabeledList.Item label="Uncategorized /obj/item">
            {debug.uncategorized_item_count >= 0 ? (
              <>
                {debug.uncategorized_item_count} / {debug.total_item_count} (
                {debug.total_item_count > 0
                  ? Math.round(
                      (debug.uncategorized_item_count /
                        debug.total_item_count) *
                        100,
                    )
                  : 0}
                %)
              </>
            ) : (
              <i>not scanned yet - press Refresh</i>
            )}
          </LabeledList.Item>
        </LabeledList>
        <Box mt={1}>
          <Button icon="sync" onClick={() => act('refresh_debug_counts')}>
            Refresh Counts
          </Button>
        </Box>
      </Section>

      <Section title="Audit Dumps">
        <Box mb={1}>
          <i>
            CSVs land at the project root. Full pricing engine re-run takes a
            few hundred ms; the uncategorized-only dump is cheaper.
          </i>
        </Box>
        <Stack>
          <Stack.Item>
            <Button.Confirm
              icon="file-csv"
              onClick={() => act('dump_pricing_audits')}
            >
              Dump All Pricing Audits (re-run engine)
            </Button.Confirm>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="file-csv"
              onClick={() => act('dump_uncategorized_items')}
            >
              Dump Uncategorized Items Only
            </Button>
          </Stack.Item>
        </Stack>
      </Section>
    </>
  );
};
