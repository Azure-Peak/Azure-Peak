import { Box, Section } from 'tgui-core/components';

import { useBackend } from '../backend';

type Data = {
  threat_regions: {
    region_name: string;
    danger_level: string;
    danger_color: string;
  }[];
};

export const ThreatBoard = (props) => {
  const { data } = useBackend<Data>();

  return (
    <Box>
      Test
      {data.threat_regions.map((region) => (
        <Section key={region.region_name}>
          <h3>{region.region_name}</h3>
          <p>Danger Level: {region.danger_level}</p>
        </Section>
      ))}
    </Box>
  );
};
