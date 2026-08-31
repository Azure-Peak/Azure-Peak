import { PrefPopupGuard } from 'pm/components';
import {
  type ConstantCharflaw,
  type ConstantData,
  useConstantPrefs,
} from 'pm/constant_data';
import type { Path } from 'pm/data';
import { type PopupData, registerPopup, usePopupBackend } from 'pm/popups';
import { ImageButton, Input, Section, Stack } from 'tgui-core/components';
import { useFuzzySearch } from 'tgui-core/fuzzysearch';
import { classes } from 'tgui-core/react';

enum Approval {
  Good = 0,
  Hide = 1,
  AlreadyTaken = 2,
  Restricted = 3,
  Full = 4,
}

type CharflawPopupData = {
  availability: Record<Path, Approval>;
  charflaws: Path[];
} & PopupData;

const PopupCharflawSelector = (props) => {
  const [constantData] = useConstantPrefs();
  const { data } = usePopupBackend<CharflawPopupData>();
  const { charflaws, popup_data_ready } = data;

  return (
    <PrefPopupGuard
      title="Selecting Character Vices"
      disableScroll
      loadingScreenText="Vices Loading..."
      width="80vw"
      height="80vh"
      dependencies={[constantData, charflaws, popup_data_ready]}
    >
      <PopupCharflawSelectorInner constantData={constantData!} />
    </PrefPopupGuard>
  );
};

// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    CharFlaw: 'charflaw';
  }
}
registerPopup('CharFlaw', 'charflaw', PopupCharflawSelector);

// Rest of the UI
const getTriCost = (name: string) => {
  const paren = name.indexOf('(');
  const TRI = name.indexOf('TRI');
  if (paren !== -1 && TRI !== -1 && TRI > paren) {
    return name.substring(paren, TRI);
  }
  return null;
};

const approvalToReason = (approval: Approval) => {
  switch (approval) {
    case Approval.Good:
      return '';
    case Approval.Hide:
      return 'Hidden (report this)';
    case Approval.Restricted:
      return 'Species Restricted';
    case Approval.Full:
      return 'Max Flaws Reached';
  }
};

const PopupCharflawSelectorInner = (props: { constantData: ConstantData }) => {
  const { constantData } = props;
  const { data } = usePopupBackend<CharflawPopupData>();
  const { availability, charflaws: charflawData } = data;
  const { charflaws: constantCharflaws } = constantData;

  const equipped_keys = charflawData;
  const triflaw_keys = Object.entries(constantCharflaws)
    .filter(([, cf]) => cf.name.includes('TRI'))
    .map(([path]) => path);
  const charflaw_keys = Object.keys(constantCharflaws).filter(
    (path) => !triflaw_keys.includes(path),
  );

  const triflaws = triflaw_keys.map((path) => ({
    path,
    cf: constantCharflaws[path],
    cf_avail: availability[path],
  }));
  triflaws.sort((a, b) => {
    const tri1 = getTriCost(a.cf.name) || '+0';
    const tri2 = getTriCost(b.cf.name) || '+0';
    return tri1.localeCompare(tri2) || a.cf.name.localeCompare(b.cf.name);
  });

  const charflaws = charflaw_keys.map((path) => ({
    path,
    cf: constantCharflaws[path],
    cf_avail: availability[path],
  }));
  charflaws.sort((a, b) => a.cf.name.localeCompare(b.cf.name));

  const combinedList = [...charflaws, ...triflaws];
  const { query, setQuery, results } = useFuzzySearch({
    getSearchString: (s) => s.cf.name || '',
    searchArray: combinedList,
  });

  return (
    <Stack fill vertical p={2}>
      <Stack.Item>
        <Input
          fluid
          placeholder="Search..."
          onChange={(v) => setQuery(v)}
          value={query}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack vertical>
            {(query.length ? results : combinedList).map((args) => (
              <CharflawButton
                key={args.path}
                taken={equipped_keys.indexOf(args.path) + 1 || undefined}
                {...args}
              />
            ))}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

type CharflawButtonProps = {
  path: string;
  cf: ConstantCharflaw;
  cf_avail: Approval;
  taken?: number;
};

const CharflawButton = (props: CharflawButtonProps) => {
  const { path, cf, cf_avail, taken } = props;
  const { act } = usePopupBackend();

  if (cf_avail === Approval.Hide) {
    return null;
  }

  const color = taken ? 'good' : cf_avail !== Approval.Good ? 'bad' : undefined;

  const reason = approvalToReason(cf_avail);

  return (
    <Stack.Item>
      <ImageButton
        fluid
        color={color}
        disabled={
          !taken &&
          cf_avail !== Approval.Good &&
          cf_avail !== Approval.AlreadyTaken
        }
        imageSize={48}
        className={classes([
          'PreferencesMenu__Charflaw',
          cf.icon?.includes('-flip')
            ? 'PreferencesMenu__Charflaw__Flipped'
            : null,
        ])}
        fallbackIcon={cf.icon?.replace('-flip', '') || undefined}
        onClick={() => act('toggle_charflaw', { flaw: path })}
      >
        <Stack fill align="center">
          <Stack.Item basis="20%" fontSize={1.1}>
            <Stack vertical>
              <Stack.Item>{cf.name}</Stack.Item>
              {taken ? (
                <Stack.Item fontSize={0.9}>
                  Already Selected: #{taken}
                </Stack.Item>
              ) : null}
              {reason ? <Stack.Item color={color}>{reason}</Stack.Item> : null}
              {cf.needs_extra_vice ? (
                <Stack.Item fontSize={0.9} color="yellow">
                  Needs extra vice.
                </Stack.Item>
              ) : null}
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <div dangerouslySetInnerHTML={{ __html: cf.desc }} />
          </Stack.Item>
        </Stack>
      </ImageButton>
    </Stack.Item>
  );
};
