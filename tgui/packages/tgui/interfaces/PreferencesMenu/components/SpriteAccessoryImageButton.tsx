import { type PropsWithChildren, useEffect, useState } from 'react';
import { Box } from 'tgui-core/components';
import { renderer } from 'tgui-webworkers';
import { CustomImageButton } from './CustomImageButton';

type SpriteAccessoryImageProps = {
  iconRef: string;
  iconStates: string[];
  offsetX: number;
  imageSize: number;
};

const SpriteAccessoryImage = (props: SpriteAccessoryImageProps) => {
  const { iconRef, iconStates, offsetX, imageSize } = props;
  const [image, setImage] = useState<string | null>(null);

  useEffect(() => {
    const inner = async () => {
      const blob = await renderer.render(
        `${iconRef}${iconStates.join('')}`,
        iconRef,
        iconStates,
        offsetX,
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
  }, [iconRef, iconStates, offsetX, imageSize]);

  if (!iconStates.length || iconStates.every((v) => v === null)) {
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

type SpriteAccessoryImageButtonProps = PropsWithChildren<{
  iconRef: string;
  iconStates: string[];
  offsetX: number;
  imageSize: number;
  tooltip?: string;
  selected?: boolean;
  onClick: () => void;
}>;

export const SpriteAccessoryImageButton = (
  props: SpriteAccessoryImageButtonProps,
) => {
  const {
    iconRef,
    iconStates,
    offsetX,
    imageSize,
    tooltip,
    selected,
    onClick,
    children,
  } = props;

  return (
    <CustomImageButton
      image={
        <SpriteAccessoryImage
          iconRef={iconRef}
          iconStates={iconStates}
          offsetX={offsetX}
          imageSize={imageSize}
        />
      }
      imageSize={imageSize}
      onClick={onClick}
      selected={selected}
      tooltip={tooltip}
    >
      {children}
    </CustomImageButton>
  );
};
