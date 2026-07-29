import { Box, Collapsible, Section } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Region = {
  name: string;
  subtitle: string | null;
  description: string;
};

type Data = {
  primer_html: string;
  regions: Region[];
};

export function LorePrimer(props) {
  const { data } = useBackend<Data>();
  return (
    <Window width={650} height={780} title="Lore Primer">
      <Window.Content scrollable>
        <Section>
          {/* Server-authored lore text (strings/rt/rp_prompt.txt), rendered as-is to keep its legacy formatting */}
          <div dangerouslySetInnerHTML={{ __html: data.primer_html }} />
        </Section>
        <Section title="Regions of Valmoria">
          {data.regions.map((region) => (
            <Collapsible key={region.name} title={region.name}>
              {region.subtitle && (
                <Box italic mb={1}>
                  {region.subtitle}
                </Box>
              )}
              <div dangerouslySetInnerHTML={{ __html: region.description }} />
            </Collapsible>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
}
