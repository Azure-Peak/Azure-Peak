import { PrefPopupGuard } from 'pm/components';
import {
  type PopupData,
  registerPopup,
  usePopupBackend,
  usePopupId,
} from 'pm/popups';
import { useState } from 'react';
import { ReactSortable } from 'react-sortablejs';
import { Button, Icon, Input, Section, Stack } from 'tgui-core/components';
import { useFuzzySearch } from 'tgui-core/fuzzysearch';

export type PopupCharacterSelectData = {
  slot: number;
  slots: Slot[];
  favorited_slots: number[];
} & PopupData;

export type Slot = {
  index: number;
  real_name: string | null; // null indicates nonexistent
  topjob: string | null; // null indicates nonexistent
  species: string | null; // null indicates nonexistent
};

const PopupCharacterSelect = () => {
  const { data } = usePopupBackend<PopupCharacterSelectData>();
  const { popup_data_ready, slots } = data;

  return (
    <PrefPopupGuard
      title="Selecting Character"
      loadingScreenText="Characters Loading..."
      width="80vw"
      height="80vh"
      dependencies={[popup_data_ready, slots]}
    >
      <PopupCharacterSelectInner />
    </PrefPopupGuard>
  );
};
// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    CharacterSelect: 'cs';
  }
}
registerPopup('CharacterSelect', 'cs', PopupCharacterSelect);

const PopupCharacterSelectInner = () => {
  const { act, data } = usePopupBackend<PopupCharacterSelectData>();
  const { favorited_slots, slots } = data;
  const [adv, setAdv] = useState(false);
  const [copying, setCopying] = useState<number | null>(null);

  const favorites: (Slot & { id: number })[] = [];
  const regular: Slot[] = [];

  // form two lists from favorited_slots and slots
  for (const slot of slots) {
    if (favorited_slots.includes(slot.index)) {
      favorites.push({ id: slot.index, ...slot });
    } else {
      regular.push(slot);
    }
  }

  // sort favorites by favorited_slot order
  favorites.sort(
    (a, b) =>
      favorited_slots.indexOf(a.index) - favorited_slots.indexOf(b.index),
  );

  const { query, setQuery, results } = useFuzzySearch({
    getSearchString: (s) => s.real_name || '',
    searchArray: regular,
  });

  return (
    <>
      {favorites.length ? (
        <Section
          title="Favorites"
          buttons={
            <Button
              icon="question"
              tooltip="Drag and drop to reorder. Advanced tasks that could harm these slots are disabled."
              tooltipPosition="bottom-end"
            />
          }
        >
          <ReactSortable
            list={favorites}
            setList={(list) => {
              // Only update on order change
              if (
                list.map((v) => v.id).join('') !==
                favorites.map((v) => v.id).join('')
              ) {
                const id_list: number[] = [];
                for (const slot of list) {
                  id_list.push(slot.index);
                }
                act('reorder_favorited_slots', { slots: id_list });
              }
            }}
          >
            {favorites.map((slot) => (
              <CharacterSlot
                key={slot.id}
                favorite
                showCopy={adv}
                slot={slot}
                copying={copying}
                setCopying={setCopying}
              />
            ))}
          </ReactSortable>
        </Section>
      ) : null}
      <Section
        title="Slots"
        buttons={
          <Stack align="center">
            <Stack.Item>
              <Input
                placeholder="Search..."
                onChange={(v) => setQuery(v)}
                value={query}
              />
            </Stack.Item>
            <Stack.Item>
              <Button.Checkbox
                checked={adv}
                selected={adv}
                tooltip="Unlock Slot Copy & Deletion"
                onClick={() => setAdv((v) => !v)}
              >
                <Icon name="unlock" mr={1} />
                <Icon name="copy" mr={1} />
                <Icon name="trash" />
              </Button.Checkbox>
            </Stack.Item>
          </Stack>
        }
      >
        <Stack fill vertical>
          {(query.length ? results : regular).map((slot) => (
            <Stack.Item key={slot.index}>
              <CharacterSlot
                slot={slot}
                showCopy={adv}
                showHarm={adv}
                copying={copying}
                setCopying={setCopying}
              />
            </Stack.Item>
          ))}
        </Stack>
      </Section>
    </>
  );
};

const CharacterSlot = (props: {
  favorite?: boolean;
  slot: Slot;
  showCopy?: boolean;
  showHarm?: boolean;
  copying: number | null;
  setCopying: React.Dispatch<React.SetStateAction<number | null>>;
}) => {
  const {
    favorite,
    slot,
    showCopy = false,
    showHarm = false,
    copying,
    setCopying,
  } = props;
  const [, setPopup] = usePopupId();
  const { act, data } = usePopupBackend<PopupCharacterSelectData>();
  const { slot: currentSlot } = data;

  return (
    <Section>
      <Stack align="center">
        <Stack.Item basis="60%">
          <Stack align="center">
            {favorite ? (
              <Stack.Item>
                <Icon name="grip-vertical" />
              </Stack.Item>
            ) : null}
            <Stack.Item bold={currentSlot === slot.index}>
              {slot.index}
            </Stack.Item>
            <Stack.Item
              basis="60%"
              bold={currentSlot === slot.index}
              fontSize={1.2}
              style={
                currentSlot === slot.index
                  ? { textDecoration: 'underline' }
                  : undefined
              }
            >
              {slot.real_name || 'No Data'}
              {slot.topjob ? ` - ${slot.topjob}` : null}
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>{slot.species || 'No Data'}</Stack.Item>
        <Stack.Item grow />
        <Stack.Item>
          <Button
            onClick={() => {
              setPopup(null);
              act('changeslot_index', { index: slot.index });
            }}
          >
            Load
          </Button>
        </Stack.Item>
        {showCopy ? (
          <Stack.Item>
            <Button
              icon={copying === slot.index ? 'copy' : 'copy-o'}
              selected={copying === slot.index}
              tooltip="Copy"
              onClick={() =>
                setCopying((x) => {
                  if (x === slot.index) {
                    return null;
                  }
                  return slot.index;
                })
              }
            />
          </Stack.Item>
        ) : null}
        {showHarm ? (
          <Stack.Item>
            <Button
              icon="paste-o"
              tooltip="Paste"
              onClick={() => {
                if (copying) {
                  act('copy_slot', {
                    from: copying,
                    to: slot.index,
                  });
                }
              }}
            />
          </Stack.Item>
        ) : null}
        <Stack.Item>
          <Button
            icon={favorite ? 'star' : 'star-o'}
            selected={favorite}
            onClick={() =>
              act(favorite ? 'unfavorite_slot' : 'favorite_slot', {
                index: slot.index,
              })
            }
          />
        </Stack.Item>
        {showHarm ? (
          <Stack.Item>
            <Button.Confirm
              icon="trash"
              confirmContent="Confirm IRREVERSIBLE deletion?"
              onClick={() => {
                act('delete_slot', { index: slot.index });
              }}
            />
          </Stack.Item>
        ) : null}
      </Stack>
    </Section>
  );
};
