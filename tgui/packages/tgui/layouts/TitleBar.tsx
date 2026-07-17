import { useSetAtom } from 'jotai';
import type { PropsWithChildren } from 'react';
import { Button, Icon } from 'tgui-core/components';
import { type BooleanLike, classes } from 'tgui-core/react';
import { toTitleCase } from 'tgui-core/string';
import { kitchenSinkAtom } from '../events/store';

type TitleBarProps = Partial<{
  className: string;
  title: string;
  status: number;
  canClose: BooleanLike;
  onClose: (e) => void;
  onDragStart: (e) => void;
}> &
  PropsWithChildren;

export function TitleBar(props: TitleBarProps) {
  const { className, title, canClose, onDragStart, onClose, children } = props;

  const setKitchenSink = useSetAtom(kitchenSinkAtom);

  const finalTitle =
    (typeof title === 'string' &&
      title === title.toLowerCase() &&
      toTitleCase(title)) ||
    title;

  return (
    <div className={classes(['TitleBar', className])}>
      <div
        className="TitleBar__dragZone"
        onMouseDown={(e) => onDragStart?.(e)}
      />
      <div className="TitleBar__title">{finalTitle}</div>
      {!!children && <div className="TitleBar__buttons">{children}</div>}
      {process.env.NODE_ENV !== 'production' && (
        <Button
          className="TitleBar__buttons TitleBar__KitchenSink"
          icon="bug"
          onClick={() => setKitchenSink((prev) => !prev)}
        />
      )}
      {!!canClose && (
        <div className="TitleBar__close" onClick={onClose}>
          <Icon className="TitleBar__close--icon" name="times" />
        </div>
      )}
    </div>
  );
}
