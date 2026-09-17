import { usePopupId } from 'pm/popups';
import type { ComponentProps, PropsWithChildren, ReactNode } from 'react';
import { LoadingScreen } from 'tgui/interfaces/common/LoadingScreen';
import { Box, Button, Modal, Section } from 'tgui-core/components';

export type PopupProps = {
  title: ReactNode;
  disableScroll?: boolean;
} & Pick<ComponentProps<typeof Modal>, 'width' | 'height'>;

export const PrefPopup = (props: PropsWithChildren<PopupProps>) => {
  const [, setPopup] = usePopupId();
  const { title, disableScroll, width, height, children } = props;

  return (
    <Modal onEscape={() => setPopup(null)}>
      <Section
        fill
        scrollable={!disableScroll}
        title={title}
        width={width}
        height={height}
        className="PreferencesMenu__Popup"
        buttons={
          <Button
            fluid
            icon="times"
            className="PreferencesMenu__Popup__Close"
            onClick={() => setPopup(null)}
          />
        }
      >
        {children}
      </Section>
    </Modal>
  );
};

export const PopupRouteError = (props: { e: Error }) => {
  const { e } = props;

  const stack = window.__augmentStack__(e.stack || '[popups.ts]', e);

  return (
    <PrefPopup title="Popup Routing Error" width="80vh" height="80vh">
      <Box fontSize={1.2}>
        The Preferences Menu ran into a severe error rendering this popup!
      </Box>
      <Box mt={1} mb={1}>
        Please report this error to your local coder.
      </Box>
      {e.message}
      <Box mt={1}>{stack}</Box>
    </PrefPopup>
  );
};

type PrefPopupGuardProps = React.PropsWithChildren<{
  dependencies: any[];
  loadingScreenText: string;
}> &
  PopupProps;

export const PrefPopupGuard = (props: PrefPopupGuardProps) => {
  const { dependencies, loadingScreenText, children, ...rest } = props;
  if (dependencies.some((v) => !v)) {
    return (
      <PrefPopup {...rest}>
        <LoadingScreen label={loadingScreenText} />
      </PrefPopup>
    );
  }

  return <PrefPopup {...rest}>{children}</PrefPopup>;
};
