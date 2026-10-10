import { type KeyboardEvent, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { isEscape, KEY } from 'tgui-core/keys';
import { classes } from 'tgui-core/react';

// The god who watches over each stat. Colours live in ContestResponse.scss.
const GOD_BY_STAT: Record<string, string> = {
  strength: 'ravox',
  perception: 'dendor',
  intelligence: 'noc',
  willpower: 'graggar',
  constitution: 'malum',
  speed: 'matthios',
  fortune: 'xylix',
  charisma: 'baotha',
};

function godClass(stat: string) {
  const god = GOD_BY_STAT[stat.toLowerCase()];
  return god ? `ContestResponse__God--${god}` : '';
}

type Data = {
  title: string;
  challengerName: string;
  attackingStat: string;
  stats: string[];
};

export function ContestResponse() {
  const { act, data } = useBackend<Data>();
  const {
    title,
    challengerName = 'Someone',
    attackingStat = '',
    stats = [],
  } = data;

  // Index 0 is Decline, 1..n are the stats. Decline starts selected, so
  // a stray Enter opts out of the contest rather than committing a stat.
  const [selected, setSelected] = useState(0);
  const optionCount = stats.length + 1;

  function activate(index: number) {
    if (index === 0) {
      act('decline');
      return;
    }
    act('choose', { stat: stats[index - 1] });
  }

  function onKey(direction: 1 | -1) {
    setSelected((selected + direction + optionCount) % optionCount);
  }

  function keyDownHandler(event: KeyboardEvent<HTMLDivElement>) {
    switch (event.key) {
      case KEY.Space:
      case KEY.Enter:
        activate(selected);
        return;
      case KEY.Left:
      case KEY.Up:
        event.preventDefault();
        onKey(-1);
        return;
      case KEY.Tab:
      case KEY.Right:
      case KEY.Down:
        event.preventDefault();
        onKey(1);
        return;
      default:
        if (isEscape(event.key)) {
          act('decline');
        }
    }
  }

  return (
    <Window width={460} height={250} title={title}>
      <Window.Content onKeyDown={keyDownHandler}>
        <Section fill>
          <Stack fill vertical>
            <Stack.Item>
              <Box className="ContestResponse__Challenger">
                {challengerName} challenges you with their
              </Box>
              <Box className={classes(['ContestResponse__Stat', godClass(attackingStat)])}>
                {attackingStat}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                textAlign="center"
                className="ContestResponse__Decline"
                selected={selected === 0}
                onClick={() => activate(0)}
              >
                Decline
              </Button>
            </Stack.Item>
            <Stack.Item grow>
              <div className="ContestResponse__Grid">
                {stats.map((stat, index) => (
                  <Button
                    key={stat}
                    className={classes([
                      'ContestResponse__Option',
                      godClass(stat),
                    ])}
                    selected={selected === index + 1}
                    onClick={() => activate(index + 1)}
                  >
                    {stat}
                  </Button>
                ))}
              </div>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
}
