import { type PropsWithChildren, useEffect, useState } from 'react';
import { Box } from 'tgui-core/components';
import { renderer } from 'tgui-webworkers';
import { CustomImageButton } from './CustomImageButton';

const MarkingImage = (props: {
  iconRef: string;
  iconState: string;
  imageSize: number;
}) => {
  const { iconRef, iconState, imageSize } = props;
  const [image, setImage] = useState<string | null>(null);

  useEffect(() => {
    const inner = async () => {
      const blob = await renderer.render(
        `${iconRef}${iconState}`,
        iconRef,
        [iconState],
        0,
        imageSize,
      );
      setImage(URL.createObjectURL(blob));
    };
    inner();

    return () => {
      if (image) {
        URL.revokeObjectURL(image);
      }
      setImage(null);
    };
  }, [iconRef, iconState, imageSize]);

  if (!iconState) {
    return (
      <Box
        style={{
          width: `${imageSize}px`,
          height: `${imageSize}px`,
        }}
      />
    );
  }

  return image ? (
    <img
      src={image}
      width={imageSize}
      height={imageSize}
      draggable={false}
      style={{ imageRendering: 'pixelated' }}
    />
  ) : null;
};

export const MarkingImageButton = (
  props: PropsWithChildren<{
    iconRef: string;
    iconState: string;
    imageSize: number;
    tooltip?: string;
    disabled?: boolean;
    selected?: boolean;
    onClick: () => void;
  }>,
) => {
  const {
    iconRef,
    iconState,
    imageSize,
    tooltip,
    disabled,
    selected,
    onClick,
    children,
  } = props;

  return (
    <CustomImageButton
      image={
        <MarkingImage
          iconRef={iconRef}
          iconState={iconState}
          imageSize={imageSize}
        />
      }
      imageSize={imageSize}
      onClick={onClick}
      disabled={disabled}
      selected={selected}
      tooltip={tooltip}
    >
      {children}
    </CustomImageButton>
  );
};
