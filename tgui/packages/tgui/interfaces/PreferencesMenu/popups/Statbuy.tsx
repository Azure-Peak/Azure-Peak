import { PrefPopupGuard } from 'pm/components';
import { type ConstantData, useConstantPrefs } from 'pm/constant_data';
import { type PopupData, registerPopup, usePopupBackend } from 'pm/popups';
import { Box, Button, Section, Stack } from 'tgui-core/components';
/**
 * Statbuy
 */
export type StatbuyData = {
  statbuy: Record<string, number>;
  statbuy_points_remaining: number;
} & PopupData;

const PopupStatbuy = () => {
  const [constantData] = useConstantPrefs();
  const { data } = usePopupBackend<StatbuyData>();
  const { popup_data_ready } = data;

  return (
    <PrefPopupGuard
      title="Assigning Stats"
      loadingScreenText="Statbuy Loading..."
      width="40vw"
      height="60vh"
      dependencies={[constantData, popup_data_ready]}
    >
      <PopupStatbuyInner constantData={constantData!} />
    </PrefPopupGuard>
  );
};

// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    Statbuy: 'statbuy';
  }
}
registerPopup('Statbuy', 'statbuy', PopupStatbuy);

const formatModifier = (value: number) => (value > 0 ? `+${value}` : value);

export const PopupStatbuyInner = (props: { constantData: ConstantData }) => {
  const { constantData } = props;
  const { act, data } = usePopupBackend<StatbuyData>();
  const { STATBUY_POINTS, STATBUY_STAT_MAX, STATBUY_STAT_MIN, statbuy_stats } =
    constantData;
  const { statbuy, statbuy_points_remaining } = data;

  return (
    <Stack fill vertical p={2}>
      <Stack.Item>
        <Section>
          <Stack align="center">
            <Stack.Item grow>
              <Box bold fontSize={1.2}>
                Points remaining: {statbuy_points_remaining}
              </Box>
              <Box color="label">
                You have {STATBUY_POINTS} points to spend. Raising a stat costs
                a point, lowering a stat gives one back. Each stat can be
                changed by {STATBUY_STAT_MIN} to +{STATBUY_STAT_MAX}.
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button icon="rotate-left" onClick={() => act('statbuy_reset')}>
                Reset
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack vertical zebra>
            {statbuy_stats.map((stat) => {
              const value = statbuy[stat.key] || 0;
              return (
                <Stack.Item key={stat.key}>
                  <Stack align="center" p={1}>
                    <Stack.Item grow fontSize={1.2}>
                      {stat.name}
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        disabled={value <= STATBUY_STAT_MIN}
                        icon="minus"
                        onClick={() =>
                          act('statbuy_adjust', { stat: stat.key, amount: -1 })
                        }
                      />
                    </Stack.Item>
                    <Stack.Item
                      bold
                      color={value > 0 ? 'good' : value < 0 ? 'bad' : undefined}
                      fontSize={1.2}
                      textAlign="center"
                      width={3}
                    >
                      {formatModifier(value)}
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        disabled={
                          value >= STATBUY_STAT_MAX ||
                          statbuy_points_remaining <= 0
                        }
                        icon="plus"
                        onClick={() =>
                          act('statbuy_adjust', { stat: stat.key, amount: 1 })
                        }
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              );
            })}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
