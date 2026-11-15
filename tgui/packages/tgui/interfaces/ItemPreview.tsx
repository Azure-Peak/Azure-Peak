import { useBackend } from '../backend';
import { Window } from '../layouts';
import { ItemStatCard, type ItemStatCardData } from './common/ItemStatCard';
import {
  cardStyle,
  INK_SOFT,
  pageStyle,
  subTabBarStyle,
  subTabStyle,
} from './common/parchment';

type Choice = {
  path: string;
  name: string;
};

type ItemPreviewData = {
  card: ItemStatCardData | null;
  current: string | null;
  choices: Choice[];
};

export const ItemPreview = () => {
  const { data, act } = useBackend<ItemPreviewData>();
  const choices = data.choices || [];
  return (
    <Window width={460} height={680} theme="parchment" title="Item Properties">
      <Window.Content scrollable>
        <div style={pageStyle}>
          {choices.length > 1 && (
            <div style={subTabBarStyle}>
              {choices.map((choice) => (
                <button
                  type="button"
                  key={choice.path}
                  style={subTabStyle(choice.path === data.current)}
                  onClick={() => act('pick', { path: choice.path })}
                >
                  {choice.name}
                </button>
              ))}
            </div>
          )}
          {data.card ? (
            <ItemStatCard card={data.card} />
          ) : (
            <div style={{ ...cardStyle, textAlign: 'center', color: INK_SOFT }}>
              Nothing to show.
            </div>
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
