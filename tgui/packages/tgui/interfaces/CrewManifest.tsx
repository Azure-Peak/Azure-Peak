import { LabeledList, NoticeBox, Section } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type CrewEntry = {
  name: string;
  rank: string;
};

type Department = {
  name: string;
  crew: CrewEntry[];
};

type Data = {
  manifest: Department[];
};

export function CrewManifest(props) {
  const { data } = useBackend<Data>();
  return (
    <Window width={400} height={550} title="Crew Manifest">
      <Window.Content scrollable>
        {data.manifest.length === 0 && (
          <NoticeBox>Nobody has arrived yet.</NoticeBox>
        )}
        {data.manifest.map((department) => (
          <Section key={department.name} title={department.name}>
            <LabeledList>
              {department.crew.map((entry, i) => (
                <LabeledList.Item key={`${entry.name}-${i}`} label={entry.name}>
                  {entry.rank}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
}
