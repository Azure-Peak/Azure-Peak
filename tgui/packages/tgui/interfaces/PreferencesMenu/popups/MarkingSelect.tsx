import { MarkingImageButton, PrefPopupGuard } from 'pm/components';
import { type ConstantData, useConstantPrefs } from 'pm/constant_data';
import type { Path } from 'pm/data';
import {
  type PopupData,
  registerPopup,
  usePopupBackend,
  usePopupContext,
} from 'pm/popups';
import type { MarkingsData } from 'pm/tabs/CharacterCreator/data';
import { Box } from 'tgui-core/components';

type PopupMarkingData = {
  // List of all markings valid for our current species
  markings_species: Path[];
} & MarkingsData &
  PopupData;

export type PopupMarkingContext = {
  zone: string;
};

const PopupMarkingSelect = (props) => {
  const [constantData] = useConstantPrefs();
  const [context] = usePopupContext<PopupMarkingContext>();
  const { data } = usePopupBackend<PopupMarkingData>();
  const { popup_data_ready } = data;

  return (
    <PrefPopupGuard
      title={`Selecting Markings for "${context?.zone}"`}
      loadingScreenText="Markings Loading..."
      width="80vw"
      height="80vh"
      dependencies={[constantData, context, popup_data_ready]}
    >
      <PopupMarkingSelectInner
        constantData={constantData!}
        context={context!}
      />
    </PrefPopupGuard>
  );
};
// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    MarkingSelect: 'marking_select';
  }
  interface PopupContextRegistry {
    MarkingSelect: PopupMarkingContext;
  }
}
registerPopup('MarkingSelect', 'marking_select', PopupMarkingSelect);

const PopupMarkingSelectInner = (props: {
  constantData: ConstantData;
  context: PopupMarkingContext;
}) => {
  const { constantData, context } = props;
  const { act, data } = usePopupBackend<PopupMarkingData>();
  const { markings_by_zone } = constantData;
  const { marking_zones, markings_species } = data;

  const activeMarkingZone = marking_zones.find((m) => m.zone === context.zone);
  const markingsForZone = markings_by_zone[context.zone];

  if (!activeMarkingZone || !markingsForZone?.length) {
    return <Box>Error: Cannot find markings for zone `{context.zone}`</Box>;
  }

  const validMarkings = markingsForZone.filter((m) =>
    markings_species.includes(m.type),
  );

  return (
    <Box
      m={2}
      className="PreferencesMenu__Grid PreferencesMenu__FiveColumn__ImageButton"
    >
      {validMarkings.map((marking) => {
        const selected = !!activeMarkingZone.markings?.find(
          (m) => m.key === marking.name,
        );
        // allow clicking selected to remove even when full
        const disabled = !activeMarkingZone.may_add && !selected;
        return (
          <MarkingImageButton
            key={marking.type}
            iconRef={marking.icon}
            // we gotta recreate this on the fly
            iconState={`${marking.icon_state}_${context.zone}_m`}
            imageSize={128}
            disabled={disabled}
            selected={selected}
            tooltip={`${marking.name} ${selected ? ' (Already Taken)' : ''} ${disabled ? ' (Marking Zone Full)' : ''}`}
            onClick={() => {
              act('toggle_marking', {
                zone: context.zone,
                type: marking.type,
              });
            }}
          >
            {marking.name}
          </MarkingImageButton>
        );
      })}
    </Box>
  );
};
