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
  "Estates will only apply if your character is a noble. Your estate determines which region of Azuria your character's estate is located in, and determines what kind of tributes in kind you will receive every day, the gifts you will receive every third dae, and what blockades will affect your income. If you're a noble of foreign origin, you can flavor it as where your foreign tributes or income arrive.";

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
      <Stack.Item grow basis={0}>
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

const EstateSection = (props: { constantData: ConstantData }) => {
  const { act, data } = useBackendStrict<PoliticsData>();
  const routes = props.constantData.estate_routes;
  const [viewing, setViewing] = useState(data.estate_region);

  const entries = routes.flatMap((route) =>
    route.subroutes.flatMap((sub) =>
      sub.regions.map((region) => ({
        region,
        subroute: sub.name,
        route: route.name,
      })),
    ),
  );
  const found = entries.find((e) => e.region.id === viewing) ?? entries[0];
  const selected = found?.region.id === data.estate_region;

  return (
    <Section
      fill
      title="Estate"
      buttons={
        <>
          <HelpButton text={ESTATE_HELP} />
          {found ? (
            <Button
              disabled={selected}
              color="justNotTransparent"
              onClick={() =>
                act('set_estate_region', { region_id: found.region.id })
              }
            >
              {selected ? 'Already Selected' : 'Select This Estate'}
            </Button>
          ) : null}
        </>
      }
    >
      <Stack vertical fill>
        <Stack.Item grow basis={0}>
          <Stack fill>
            <Stack.Item width="16em" style={{ overflowY: 'auto' }}>
              {routes.map((route) => (
                <Box key={route.name} mb={1}>
                  <Box bold>{route.name}</Box>
                  {route.subroutes.map((sub) => (
                    <Box key={sub.name} ml={1} mt={0.5}>
                      <Box color="label">{sub.name}</Box>
                      <Tabs vertical mt={0}>
                        {sub.regions.map((region) => (
                          <Tabs.Tab
                            key={region.id}
                            selected={viewing === region.id}
                            onClick={() => setViewing(region.id)}
                            leftSlot={region.name}
                            rightSlot={
                              region.id === data.estate_region ? (
                                <Icon name="check" />
                              ) : (
                                <Icon name="" />
                              )
                            }
                          />
                        ))}
                      </Tabs>
                    </Box>
                  ))}
                </Box>
              ))}
            </Stack.Item>
            <Stack.Divider />
            <Stack.Item grow basis={0} style={{ overflowY: 'auto' }}>
              {found ? (
                <>
                  <Box bold fontSize={1.1}>
                    {found.region.name}
                  </Box>
                  {found.region.subtitle ? (
                    <Box italic color="label">
                      {found.region.subtitle}
                    </Box>
                  ) : null}
                  <Box color="label">
                    {found.subroute}, {found.route}
                  </Box>
                  {found.region.tribute.length ? (
                    <Box mt={1}>
                      <b>Parcels:</b> {found.region.tribute.join(', ')}
                    </Box>
                  ) : null}
                  {found.region.gifts.length ? (
                    <Box mt={0.5}>
                      <b>Gifts, every third dae:</b>{' '}
                      {found.region.gifts.join(', ')}
                    </Box>
                  ) : null}
                  <Box mt={0.5} color="average">
                    A raid on {found.subroute} holds back estate income until
                    it is cleared.
                  </Box>
                  {found.region.description ? (
                    <Box mt={1}>{found.region.description}</Box>
                  ) : null}
                </>
              ) : null}
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
