import {
  type ConstantData,
  type ConstantPoliticalFaction,
  useConstantPrefs,
} from 'pm/constant_data';
import { useState } from 'react';
import { useBackendStrict } from 'tgui/backend';
import { LoadingScreen } from 'tgui/interfaces/common/LoadingScreen';
import {
  Box,
  Button,
  Icon,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import type { PoliticsData } from '../data';

const factionLabel = (faction: ConstantPoliticalFaction) =>
  faction.color_name ? `${faction.name} (${faction.color_name})` : faction.name;

const englishList = (items: string[]) =>
  items.length > 1
    ? `${items.slice(0, -1).join(', ')} and ${items[items.length - 1]}`
    : (items[0] ?? '');

const FACTION_HELP =
  "Your faction will always apply to your character. It is always visible to other nobles if you're a noble, but otherwise only to people of the same faction.";

const ESTATE_HELP =
  "Estates will only apply if your character is a noble. Your estate determines which region your character's estate is located in, and determines what kind of tributes in kind you will receive every day / every two day, the gifts you will receive every third dae, and what blockades will affect your income. Foreign estates arrive every other dae and are immune to blockades.";

const LANDLESS = 'landless';

const HelpButton = (props: { text: string }) => (
  <Button
    color="transparent"
    icon="circle-question-o"
    tooltipPosition="bottom-end"
    tooltip={props.text}
  />
);

export const SubtabPolitics = () => {
  const [constantData] = useConstantPrefs();
  if (!constantData) {
    return <LoadingScreen label="Loading Politics..." />;
  }
  return (
    <Stack vertical fill>
      <Stack.Item>
        <FactionSection constantData={constantData} />
      </Stack.Item>
      <Stack.Item grow basis={0} style={{ minHeight: 0 }}>
        <EstateSection constantData={constantData} />
      </Stack.Item>
    </Stack>
  );
};

const FactionSection = (props: { constantData: ConstantData }) => {
  const { act, data } = useBackendStrict<PoliticsData>();
  const factions = props.constantData.political_factions;
  const [viewing, setViewing] = useState(data.political_faction);
  const faction = factions.find((f) => f.id === viewing) ?? factions[0];
  const held = factions.find((f) => f.id === data.political_faction);
  const selected = faction.id === data.political_faction;
  const barred = !!faction.psydonite_only && !data.psydonite;
  const heldBarred = !!held?.psydonite_only && !data.psydonite;

  return (
    <Section
      title="Political Faction"
      buttons={
        <>
          <HelpButton text={FACTION_HELP} />
          <Button
            disabled={selected || barred}
            color="justNotTransparent"
            tooltip={barred ? 'Only Psydonites can join.' : undefined}
            onClick={() =>
              act('set_political_faction', { faction_id: faction.id })
            }
          >
            {selected ? 'Already Selected' : 'Select This Faction'}
          </Button>
        </>
      }
    >
      {heldBarred ? (
        <NoticeBox danger>
          {held?.name} only takes Psydonites. You will be Neutral.
        </NoticeBox>
      ) : null}
      <Stack>
        {factions.map((f) => (
          <Stack.Item grow basis={0} key={f.id}>
            <Button
              fluid
              textAlign="center"
              selected={f.id === viewing}
              onClick={() => setViewing(f.id)}
            >
              <Box
                inline
                mr={1}
                style={{
                  width: '0.7em',
                  height: '0.7em',
                  backgroundColor: f.color,
                  border: '1px solid rgba(0, 0, 0, 0.6)',
                }}
              />
              {f.name}
              {f.id === data.political_faction ? (
                <Icon name="check" ml={1} />
              ) : null}
            </Button>
          </Stack.Item>
        ))}
      </Stack>
      <Box mt={1}>
        <Stack align="center">
          <Stack.Item grow bold fontSize={1.1}>
            {factionLabel(faction)}
          </Stack.Item>
          {faction.has_wiki ? (
            <Stack.Item>
              <Button
                icon="book"
                onClick={() =>
                  act('open_faction_wiki', { faction_id: faction.id })
                }
              >
                Wiki
              </Button>
            </Stack.Item>
          ) : null}
        </Stack>
        {faction.motto ? (
          <Box italic mt={0.5}>
            &quot;{faction.motto}&quot;
          </Box>
        ) : null}
        {faction.description ? (
          <Box mt={0.5}>{faction.description}</Box>
        ) : null}
        {faction.members ? (
          <Box mt={0.5}>
            <b>Members:</b> {faction.members}
          </Box>
        ) : null}
        {faction.goals ? (
          <Box mt={0.5}>
            <b>Goals:</b> {faction.goals}
          </Box>
        ) : null}
        {faction.forced_by.length ? (
          <Box mt={0.5} color="label">
            Always held by the {englishList(faction.forced_by)}.
          </Box>
        ) : null}
      </Box>
    </Section>
  );
};

const EstateTab = (props: {
  id: string;
  name: string;
  viewing: string;
  held: string;
  onView: (id: string) => void;
}) => (
  <Tabs.Tab
    selected={props.viewing === props.id}
    onClick={() => props.onView(props.id)}
    leftSlot={props.name}
    rightSlot={<Icon name={props.held === props.id ? 'check' : ''} />}
  />
);

const EstateSection = (props: { constantData: ConstantData }) => {
  const { act, data } = useBackendStrict<PoliticsData>();
  const routes = props.constantData.estate_routes;
  const realms = props.constantData.estate_realms;
  const [viewing, setViewing] = useState(data.estate_region);

  const entries = [
    ...routes.flatMap((route) =>
      route.subroutes.flatMap((sub) =>
        sub.regions.map((region) => ({
          region,
          label: `${sub.name}, ${route.name}`,
          raid: sub.name,
        })),
      ),
    ),
    ...realms.map((region) => ({
      region,
      label: 'Foreign',
      raid: null as string | null,
    })),
  ];
  const landless = viewing === LANDLESS;
  const found = landless
    ? undefined
    : (entries.find((e) => e.region.id === viewing) ?? entries[0]);
  const viewingId = landless ? LANDLESS : found?.region.id;
  const selected = viewingId === data.estate_region;

  return (
    <Stack fill>
      <Stack.Item width="16em">
        <Section
          fill
          scrollable
          title="Estate"
          buttons={<HelpButton text={ESTATE_HELP} />}
        >
          <Tabs vertical mt={0} mb={1}>
            <EstateTab
              id={LANDLESS}
              name="Landless"
              viewing={viewing}
              held={data.estate_region}
              onView={setViewing}
            />
          </Tabs>
          {routes.map((route) => (
            <Box key={route.name} mb={1}>
              <Box bold>{route.name}</Box>
              {route.subroutes.map((sub) => (
                <Box key={sub.name} ml={1} mt={0.5}>
                  <Box color="label">{sub.name}</Box>
                  <Tabs vertical mt={0}>
                    {sub.regions.map((region) => (
                      <EstateTab
                        key={region.id}
                        id={region.id}
                        name={region.name}
                        viewing={viewing}
                        held={data.estate_region}
                        onView={setViewing}
                      />
                    ))}
                  </Tabs>
                </Box>
              ))}
            </Box>
          ))}
          {realms.length ? (
            <Box mb={1}>
              <Box bold>Foreign</Box>
              <Tabs vertical mt={0.5} ml={1}>
                {realms.map((region) => (
                  <EstateTab
                    key={region.id}
                    id={region.id}
                    name={region.name}
                    viewing={viewing}
                    held={data.estate_region}
                    onView={setViewing}
                  />
                ))}
              </Tabs>
            </Box>
          ) : null}
        </Section>
      </Stack.Item>
      <Stack.Item grow basis={0}>
        <Section
          fill
          scrollable
          title={landless ? 'Landless' : found?.region.name}
          buttons={
            viewingId ? (
              <Button
                disabled={selected}
                color="justNotTransparent"
                onClick={() =>
                  act('set_estate_region', { region_id: viewingId })
                }
              >
                {selected ? 'Already Selected' : 'Select This Estate'}
              </Button>
            ) : null
          }
        >
          {landless ? (
            <Box>
              Landless nobles only receive noble income and gain noble
              privilege, but will not be affected by blockades.
            </Box>
          ) : found ? (
            <>
              <Box color="label">{found.label}</Box>
              {found.region.parcels.length ? (
                <>
                  <Box mt={1}>
                    <b>Parcels:</b> {found.region.parcels.join(', ')}
                  </Box>
                  {found.region.occasional.length ? (
                    <Box mt={0.5}>
                      <b>Occasionally:</b>{' '}
                      {found.region.occasional.join(', ')}
                    </Box>
                  ) : null}
                  <Box mt={0.5} color="label">
                    {found.raid
                      ? 'You get a random selection of goods mailed to you every dae through the HERMES from your estate.'
                      : 'You get a random selection of goods mailed to you through the HERMES from your estate.'}
                  </Box>
                </>
              ) : null}
              {found.region.gifts.length ? (
                <Box mt={0.5}>
                  <b>Gifts, every third dae:</b>{' '}
                  {found.region.gifts.join(', ')}
                </Box>
              ) : null}
              <Box mt={0.5} color="average">
                {found.raid
                  ? `A raid on ${found.raid} will hold back estate income, and you will lose the parcel every dae it is not cleared.`
                  : `Rent from foreign estates are handled by ${found.region.carrier} who remit it every other dae. Foreign Estates are immune to blockade, but the ATC will collect a third of the rent due to you as their fee for paying you by proxy. Each delivery carries the income, goods and gifts owed since the last.`}
              </Box>
              {found.region.description ? (
                <Box mt={1}>{found.region.description}</Box>
              ) : null}
            </>
          ) : null}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
