import { useBackend } from '../backend';
import { Window } from '../layouts';
import { pageStyle } from './common/parchment';

type Data = {
  name: string;
  // you know what, fuck this, i'm not doing this right now. one tgui nightmare was enough for one day
};

export const Catalyzation = () => {
  const { act, data } = useBackend<Data>();

  return (
    <Window width={760} height={560} theme="parchment" title="Catalyzation">
      <Window.Content scrollable>
        <div style={pageStyle} />
      </Window.Content>
    </Window>
  );
};
