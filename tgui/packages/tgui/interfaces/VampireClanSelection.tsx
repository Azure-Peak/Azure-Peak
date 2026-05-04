import { useState } from 'react';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type PowerData = {
  name: string;
  level: number;
  desc: string;
};

type CovenData = {
  name: string;
  desc: string;
  icon?: string;
  powers: PowerData[];
};

type ClanData = {
  id: string;
  name: string;
  desc: string;
  curse: string;
  downside: string;
  bloodPreference: string;
  covens: CovenData[];
  icon?: string;
  tagline?: string;
  isCustom?: boolean;
};

type VampireClanSelectionData = {
  clans: ClanData[];
  selectedClanId: string;
  pendingCustomName: string;
  defaultClanName: string;
  warning: string;
};

export const VampireClanSelection = () => {
  const { act, data } = useBackend<VampireClanSelectionData>();
  const [expandedCovens, setExpandedCovens] = useState<Set<string>>(new Set());
  const [customName, setCustomName] = useState(data.pendingCustomName || '');

  const selectedClan =
    data.clans.find((clan) => clan.id === data.selectedClanId) || data.clans[0];

  const toggleCoven = (covenName: string) => {
    setExpandedCovens((prev) => {
      const next = new Set(prev);
      if (next.has(covenName)) {
        next.delete(covenName);
      } else {
        next.add(covenName);
      }
      return next;
    });
  };

  const onCustomNameChange = (value: string) => {
    setCustomName(value);
    act('set_custom_name', { name: value });
  };

  return (
    <Window width={960} height={680} theme="generic">
      <Window.Content className="VampireClanSelection">
        <Box className="VampireClanSelection__header">
          <Box className="VampireClanSelection__crest">✦</Box>
          <Box className="VampireClanSelection__titleBlock">
            <Box className="VampireClanSelection__title">Clan Selection</Box>
            <Box className="VampireClanSelection__subtitle">
              Choose your vampire clan
            </Box>
          </Box>
          <Box className="VampireClanSelection__flavor">
            The Blood remembers.
            <br />
            Choose your lineage.
          </Box>
        </Box>

        <Stack fill>
          <Stack.Item width="36%">
            <Section title="Available Clans" fill scrollable>
              <Stack vertical>
                {data.clans.map((clan, index) => (
                  <Stack.Item key={clan.id}>
                    <Button
                      fluid
                      className={
                        clan.id === selectedClan?.id
                          ? 'VampireClanSelection__clanCard VampireClanSelection__clanCard--selected'
                          : 'VampireClanSelection__clanCard'
                      }
                      onClick={() =>
                        act('select_clan', { clan_id: clan.id })
                      }
                    >
                      <Stack align="center">
                        <Stack.Item>
                          <Box className="VampireClanSelection__number">
                            {index + 1}
                          </Box>
                        </Stack.Item>
                        <Stack.Item>
                          <Box className="VampireClanSelection__icon">
                            {clan.isCustom ? '?' : '◆'}
                          </Box>
                        </Stack.Item>
                        <Stack.Item grow>
                          <Box className="VampireClanSelection__clanName">
                            {clan.name}
                          </Box>
                          <Box className="VampireClanSelection__tagline">
                            {clan.tagline}
                          </Box>
                        </Stack.Item>
                      </Stack>
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Section fill scrollable>
              {selectedClan && (
                <Box className="VampireClanSelection__details">
                  <Box className="VampireClanSelection__selectedName">
                    {selectedClan.name}
                  </Box>
                  <Box className="VampireClanSelection__divider" />

                  {selectedClan.isCustom && (
                    <Box className="VampireClanSelection__infoBlock">
                      <Box className="VampireClanSelection__infoTitle">
                        ✎ Clan Name
                      </Box>
                      <Input
                        fluid
                        className="VampireClanSelection__customNameInput"
                        placeholder="Name your Caitiff bloodline..."
                        value={customName}
                        onChange={onCustomNameChange}
                        maxLength={42}
                      />
                      <Box
                        className="VampireClanSelection__infoText"
                        mt={0.5}
                      >
                        Leave blank to be known simply as the &quot;Custom
                        Clan&quot;.
                      </Box>
                    </Box>
                  )}

                  <InfoBlock
                    title="Description"
                    icon="☉"
                    text={selectedClan.desc}
                  />
                  <InfoBlock
                    title="Curse / Downside"
                    icon="☠"
                    text={selectedClan.downside || selectedClan.curse}
                  />
                  <InfoBlock
                    title="Blood Preference"
                    icon="♦"
                    text={selectedClan.bloodPreference}
                  />

                  <Box className="VampireClanSelection__infoBlock">
                    <Box className="VampireClanSelection__infoTitle">
                      ◉ Disciplines & Powers
                    </Box>
                    {selectedClan.covens?.length ? (
                      <Stack vertical>
                        {selectedClan.covens.map((coven) => (
                          <Stack.Item key={coven.name}>
                            <CovenCard
                              coven={coven}
                              expanded={expandedCovens.has(coven.name)}
                              onToggle={() => toggleCoven(coven.name)}
                            />
                          </Stack.Item>
                        ))}
                      </Stack>
                    ) : (
                      <Box className="VampireClanSelection__infoText">
                        {selectedClan.isCustom
                          ? 'A Caitiff chooses their own disciplines later.'
                          : 'None.'}
                      </Box>
                    )}
                  </Box>
                </Box>
              )}
            </Section>
          </Stack.Item>
        </Stack>

        <Box className="VampireClanSelection__footer">
          <Box className="VampireClanSelection__warning">{data.warning}</Box>
          <Stack>
            <Stack.Item grow />
            <Stack.Item>
              <Button
                color="red"
                icon="check"
                onClick={() => act('accept_clan')}
              >
                Accept Clan
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                color="transparent"
                icon="times"
                onClick={() => act('close')}
              >
                Close
              </Button>
            </Stack.Item>
          </Stack>
        </Box>
      </Window.Content>
    </Window>
  );
};

const InfoBlock = (props: { title: string; icon: string; text?: string }) => (
  <Box className="VampireClanSelection__infoBlock">
    <Box className="VampireClanSelection__infoTitle">
      {props.icon} {props.title}
    </Box>
    <Box className="VampireClanSelection__infoText">
      {props.text || 'Unknown'}
    </Box>
  </Box>
);

const CovenCard = (props: {
  coven: CovenData;
  expanded: boolean;
  onToggle: () => void;
}) => {
  const { coven, expanded, onToggle } = props;
  return (
    <Box className="VampireClanSelection__covenCard">
      <Button
        fluid
        className="VampireClanSelection__covenHeader"
        onClick={onToggle}
      >
        <Stack align="center">
          <Stack.Item>
            <Box className="VampireClanSelection__covenChevron">
              {expanded ? '▾' : '▸'}
            </Box>
          </Stack.Item>
          <Stack.Item grow>
            <Box className="VampireClanSelection__covenName">{coven.name}</Box>
            <Box className="VampireClanSelection__covenDesc">{coven.desc}</Box>
          </Stack.Item>
        </Stack>
      </Button>
      {expanded && (
        <Box className="VampireClanSelection__powerList">
          {coven.powers?.length ? (
            coven.powers.map((power) => (
              <Box
                key={`${coven.name}-${power.level}-${power.name}`}
                className="VampireClanSelection__powerItem"
              >
                <Box className="VampireClanSelection__powerHeader">
                  <Box className="VampireClanSelection__powerLevel">
                    lvl {power.level}
                  </Box>
                  <Box className="VampireClanSelection__powerName">
                    {power.name}
                  </Box>
                </Box>
                <Box className="VampireClanSelection__powerDesc">
                  {power.desc}
                </Box>
              </Box>
            ))
          ) : (
            <Box className="VampireClanSelection__infoText">
              No powers documented.
            </Box>
          )}
        </Box>
      )}
    </Box>
  );
};
