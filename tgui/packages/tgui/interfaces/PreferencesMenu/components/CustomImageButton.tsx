import type { PropsWithChildren, ReactNode } from 'react';
import { ImageButton } from 'tgui-core/components';

export const CustomImageButton = (
  props: PropsWithChildren<{
    fluid?: boolean;
    image: ReactNode;
    imageSize: number;
    tooltip?: string;
    disabled?: boolean;
    selected?: boolean;
    onClick: () => void;
    buttons?: ReactNode;
  }>,
) => {
  const {
    image,
    fluid,
    imageSize,
    onClick,
    tooltip,
    disabled,
    selected,
    buttons,
    children,
  } = props;

  return (
    <ImageButton
      dmIcon="not_a_real_icon.dmi"
      dmIconState="equally_fake_icon_state"
      dmFallback={image}
      fluid={fluid}
      imageSize={imageSize}
      onClick={onClick}
      tooltip={tooltip}
      disabled={disabled}
      selected={selected}
      buttons={buttons}
      verticalAlign="top"
    >
      {children}
    </ImageButton>
  );
};
