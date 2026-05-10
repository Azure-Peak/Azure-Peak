import { useBackend } from '../backend';
import { Window } from '../layouts';
import type { VendingData } from './Goldface/types';
import { VendingPanel } from './Goldface/VendingPanel';

export const Goldface = () => {
  const { act, data } = useBackend<VendingData>();
  return (
    <Window width={720} height={800} theme="parchment">
      <Window.Content scrollable>
        <VendingPanel data={data} act={act} />
      </Window.Content>
    </Window>
  );
};
