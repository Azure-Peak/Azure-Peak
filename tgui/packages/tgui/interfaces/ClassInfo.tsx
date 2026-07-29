import { Box, Collapsible, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type StatEntry = {
  name: string;
  value: number;
  roman: string;
};

type TraitEntry = {
  name: string;
  desc: string | null;
};

type SkillEntry = {
  name: string;
  level: string;
};

type MageAspects = {
  mastery: BooleanLike;
  major: number;
  minor: number;
  utilities: number;
  innate: string[];
  traditions: string[];
};

type Subclass = {
  name: string;
  tutorial: string | null;
  stats: StatEntry[];
  ceilings: StatEntry[];
  traits: TraitEntry[];
  traits_are_class: BooleanLike;
  languages: string[];
  stashed_items: string[];
  virtues: string[];
  mage_aspects: MageAspects | null;
  skills: SkillEntry[];
  extra_context: string | null;
  age_preview: string | null;
};

type Data = {
  title: string;
  jester: BooleanLike;
  class_stats: StatEntry[];
  class_ceilings: StatEntry[];
  class_traits: TraitEntry[];
  subclasses: Subclass[];
};

const StatBlock = (props: { title: string; stats: StatEntry[] }) => (
  <Box>
    <Box color="#7a4d0a" bold>
      {props.title}
    </Box>
    {props.stats.map((stat) => (
      <Box key={stat.name}>
        {stat.name}:{' '}
        <Box inline bold color={stat.value < 0 ? 'bad' : 'good'}>
          {stat.roman}
        </Box>
      </Box>
    ))}
  </Box>
);

const CeilingBlock = (props: { stats: StatEntry[] }) => (
  <Box color="bad" mt={1}>
    <Box bold>Stat limits:</Box>
    {props.stats.map((stat) => (
      <Box inline key={stat.name} mr={1}>
        {stat.name}: <b>{stat.roman}</b>
      </Box>
    ))}
    <Box italic>
      Regardless of your statpacks or race choice, you will not be able to
      exceed these stats on spawn.
    </Box>
  </Box>
);

const TraitList = (props: { label: string; traits: TraitEntry[] }) => (
  <Box>
    <Box color="#7a4d0a" bold>
      {props.label}
    </Box>
    {props.traits.map((trait) => (
      <Collapsible key={trait.name} title={trait.name} color="transparent">
        <Box italic color="#a3ffe0">
          {/* Server-authored trait description; may contain markup */}
          <div dangerouslySetInnerHTML={{ __html: trait.desc || '' }} />
        </Box>
      </Collapsible>
    ))}
  </Box>
);

const SubclassEntry = (props: { subclass: Subclass }) => {
  const sc = props.subclass;
  return (
    <Collapsible title={sc.name}>
      <Stack>
        <Stack.Item grow basis={0}>
          {sc.tutorial && (
            <Box italic mb={1}>
              {/* Server-authored tutorial text; may contain markup */}
              <div dangerouslySetInnerHTML={{ __html: sc.tutorial }} />
            </Box>
          )}
          {sc.traits.length > 0 && (
            <TraitList
              label={sc.traits_are_class ? 'Class Traits:' : 'Subclass Traits:'}
              traits={sc.traits}
            />
          )}
          {sc.stashed_items.length > 0 && (
            <Box mt={1}>
              <Box color="#7a4d0a" bold>
                Stashed Items:
              </Box>
              {sc.stashed_items.map((item) => (
                <Box key={item} italic>
                  - {item}
                </Box>
              ))}
            </Box>
          )}
          {sc.virtues.length > 0 && (
            <Box mt={1}>
              <Box color="#7a4d0a" bold>
                Subclass Virtues:
              </Box>
              {sc.virtues.map((virtue) => (
                <Box key={virtue} italic>
                  - {virtue}
                </Box>
              ))}
            </Box>
          )}
          {sc.languages.length > 0 && (
            <Collapsible title="Known Languages" color="transparent">
              <Box italic>{sc.languages.join(', ')}</Box>
            </Collapsible>
          )}
        </Stack.Item>
        <Stack.Item grow basis={0} textAlign="right">
          {sc.stats.length > 0 && (
            <StatBlock title="Stat Bonuses:" stats={sc.stats} />
          )}
          {sc.skills.length > 0 && (
            <Box mt={1}>
              <Box color="#7a4d0a" bold>
                Notable Skills:
              </Box>
              {sc.skills.map((skill) => (
                <Box key={skill.name} color="#d4b164">
                  {skill.name} —{' '}
                  {/* Skill level names are server-authored HTML spans */}
                  <span dangerouslySetInnerHTML={{ __html: skill.level }} />
                </Box>
              ))}
            </Box>
          )}
          {sc.skills.length === 0 && sc.stats.length === 0 && (
            <Box italic>This subclass has no notable skills.</Box>
          )}
        </Stack.Item>
      </Stack>
      {sc.ceilings.length > 0 && <CeilingBlock stats={sc.ceilings} />}
      {sc.mage_aspects && (
        <Box color="#a3a7e0" mt={1}>
          <Box bold>Mage Aspects:</Box>
          {!!sc.mage_aspects.mastery && (
            <Box>
              Mastery: <b>Unlocked</b>
            </Box>
          )}
          {sc.mage_aspects.major > 0 && (
            <Box>
              Major Aspects: <b>{sc.mage_aspects.major}</b>
            </Box>
          )}
          {sc.mage_aspects.minor > 0 && (
            <Box>
              Minor Aspects: <b>{sc.mage_aspects.minor}</b>
            </Box>
          )}
          {sc.mage_aspects.utilities > 0 && (
            <Box>
              Utility Slots: <b>{sc.mage_aspects.utilities}</b>
            </Box>
          )}
          {sc.mage_aspects.innate.length > 0 && (
            <Box>
              Innate: <b>{sc.mage_aspects.innate.join(' ')}</b>
            </Box>
          )}
          {sc.mage_aspects.traditions.map((tradition) => (
            <Box key={tradition}>
              Tradition: <b>{tradition}</b>
            </Box>
          ))}
        </Box>
      )}
      {sc.extra_context && (
        <Box color="#a06c1e" mt={1}>
          {/* Server-authored extra context; may contain markup */}
          <div dangerouslySetInnerHTML={{ __html: sc.extra_context }} />
        </Box>
      )}
      {sc.age_preview && (
        // Server-authored age-bonus preview HTML, rendered as-is.
        <Box mt={1}>
          <div dangerouslySetInnerHTML={{ __html: sc.age_preview }} />
        </Box>
      )}
    </Collapsible>
  );
};

export function ClassInfo(props) {
  const { data } = useBackend<Data>();
  if (data.jester) {
    return (
      <Window width={475} height={420} title={data.title}>
        <Window.Content>
          <Box textAlign="center" color="#d151ab" mt={2}>
            <Box>
              Come one, come all, where Psydon Lies!
              <br />
              Let Xylix roll the dice,
              <br />
              unto our untimely demise!
              <br />
              Ahahaha!
            </Box>
            <Box bold fontSize={1.5} mt={2}>
              STR: ???
              <br />
              WIL: ???
              <br />
              CON: ???
              <br />
              PER: ???
              <br />
              INT: ???
              <br />
              FOR: ???
            </Box>
          </Box>
        </Window.Content>
      </Window>
    );
  }
  return (
    <Window width={520} height={650} title={data.title}>
      <Window.Content scrollable>
        {data.subclasses.length > 0 && (
          <Section title="Subclasses">
            {data.subclasses.map((sc) => (
              <SubclassEntry key={sc.name} subclass={sc} />
            ))}
          </Section>
        )}
        {(data.class_stats.length > 0 || data.class_traits.length > 0) && (
          <Section title="Class">
            {data.class_stats.length > 0 && (
              <StatBlock title="Starting Stats:" stats={data.class_stats} />
            )}
            {data.class_ceilings.length > 0 && (
              <CeilingBlock stats={data.class_ceilings} />
            )}
            {data.class_traits.length > 0 && (
              <TraitList label="Class Traits:" traits={data.class_traits} />
            )}
          </Section>
        )}
        <Box italic mt={1}>
          This information is not all-encompassing. Many classes have other
          quirks and skills that define them.
        </Box>
      </Window.Content>
    </Window>
  );
}
