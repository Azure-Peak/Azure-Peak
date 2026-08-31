import { PrefPopupGuard } from 'pm/components';
import { type PopupData, registerPopup, usePopupBackend } from 'pm/popups';
import { Stack } from 'tgui-core/components';
/**
 * Character Selection
 */
export type PopupVerboseLogsData = {
  logs: string[];
} & PopupData;

const PopupVerboseLogs = (props) => {
  const { data } = usePopupBackend<PopupVerboseLogsData>();
  const { popup_data_ready } = data;

  return (
    <PrefPopupGuard
      title="Character Creator Logs"
      loadingScreenText="Logs Loading..."
      width="80vw"
      height="80vh"
      dependencies={[popup_data_ready]}
    >
      <PopupVerboseLogsInner />
    </PrefPopupGuard>
  );
};

// Register it
declare module 'pm/popups' {
  interface PopupRegistry {
    VerboseLogs: 'verbose_logs';
  }
}
registerPopup('VerboseLogs', 'verbose_logs', PopupVerboseLogs);

export const PopupVerboseLogsInner = (props) => {
  const { data } = usePopupBackend<PopupVerboseLogsData>();
  const { logs } = data;

  return (
    <Stack fill vertical m={2}>
      <Stack.Item fontSize={1.2}>
        This shows the last 20 changes you've made, this round only.
      </Stack.Item>
      {logs.map((log, i) => (
        <Stack.Item key={i}>{log}</Stack.Item>
      ))}
    </Stack>
  );
};
