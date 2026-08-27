import { PrefPopupGuard } from 'pm/components';
import { type ConstantData, useConstantPrefs } from 'pm/constant_data';
import { registerPopup } from 'pm/popups';
import { Box } from 'tgui-core/components';

const PopupLorePrimer = (props) => {
  const [constantData] = useConstantPrefs();

  return (
    <PrefPopupGuard
      title="Lore Primer"
      loadingScreenText="LORE Loading..."
      width="80vw"
      height="90vh"
      dependencies={[constantData]}
    >
      <PopupLorePrimerInner constantData={constantData!} />
    </PrefPopupGuard>
  );
};
// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    LorePrimer: 'lore_primer';
  }
}
registerPopup('LorePrimer', 'lore_primer', PopupLorePrimer);

const PopupLorePrimerInner = (props: { constantData: ConstantData }) => {
  const { constantData } = props;
  const { lore_primer } = constantData;

  return <Box m={2} dangerouslySetInnerHTML={{ __html: lore_primer }} />;
};
