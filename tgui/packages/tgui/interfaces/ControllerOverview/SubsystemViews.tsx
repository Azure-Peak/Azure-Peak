import { type Dispatch, useEffect, useState } from 'react';
import { Button, Section, Stack, Table } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { SORTING_TYPES } from './contants';
import type { FilterState } from './filters';
import { SubsystemRow } from './SubsystemRow';
import type { ControllerData, SubsystemData } from './types';

type Props = {
  filterOpts: FilterState;
  setSelected: Dispatch<SubsystemData | undefined>;
};

export function SubsystemViews(props: Props) {
  const { data } = useBackend<ControllerData>();
  const { subsystems } = data;

  const { filterOpts, setSelected } = props;
  const { ascending, inactive, query, smallValues, sortType } = filterOpts;
  const { propName, inDeciseconds } = SORTING_TYPES[sortType];

  const [bars, setBars] = useState(inDeciseconds);

  const sorted = subsystems
    .filter((subsystem) => {
      // Matches search
      const nameMatchesQuery = subsystem.name
        .toLowerCase()
        .includes(query?.toLowerCase());

      // Filters out based on inactive
      if (inactive && (!!subsystem.doesnt_fire || !subsystem.can_fire)) {
        return false;
      }

      const value = subsystem[propName];

      // Filters out based on small values
      if (typeof value === 'number' && smallValues && value < 1) {
        return false;
      }

      return nameMatchesQuery;
    })
    .sort((a, b) => {
      const aValue =
        typeof a[propName] === 'number' || typeof a[propName] === 'string'
          ? a[propName]
          : '';
      const bValue =
        typeof b[propName] === 'number' || typeof b[propName] === 'string'
          ? b[propName]
          : '';
      if (ascending) {
        return aValue > bValue ? 1 : -1;
      } else {
        return bValue > aValue ? 1 : -1;
      }
    });

  // Gets our totals for bar display
  const totals: number[] = [];
  let currentMax = 0;
  if (inDeciseconds) {
    for (let i = 0; i < sorted.length; i++) {
      const value = sorted[i][propName];
      if (typeof value !== 'number') {
        continue;
      }

      totals.push(value);
    }

    currentMax = Math.max(...totals);
  }

  // Toggles default bar view for valid cases
  useEffect(() => {
    if (inDeciseconds && !bars) {
      setBars(true);
    } else if (!inDeciseconds && bars) {
      setBars(false);
    }
  }, [inDeciseconds]);

  return (
    <Section
      fill
      scrollable
      title="Subsystem Overview"
      buttons={
        <Stack align="center">
          <Stack.Item color="label">
            ({sorted.length} / {subsystems.length})
          </Stack.Item>
          <Stack.Item>
            <Button
              disabled={!inDeciseconds}
              icon="bars"
              onClick={() => setBars(!bars)}
              selected={bars}
            >
              Bars
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      <Table>
        {sorted.map((subsystem) => (
          <SubsystemRow
            key={subsystem.ref}
            max={currentMax}
            setSelected={setSelected}
            showBars={bars && inDeciseconds}
            sortType={sortType}
            subsystem={subsystem}
          />
        ))}
      </Table>
    </Section>
  );
}
