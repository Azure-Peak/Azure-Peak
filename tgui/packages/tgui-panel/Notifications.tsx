/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import type { ReactNode } from 'react';
import { Flex } from 'tgui-core/components';

export function Notifications(props: React.PropsWithChildren) {
  const { children } = props;

  return <div className="Notifications">{children}</div>;
}

function NotificationsItem(
  props: React.PropsWithChildren<{ rightSlot?: ReactNode }>,
) {
  const { rightSlot, children } = props;

  return (
    <Flex align="center" className="Notification">
      <Flex.Item className="Notification__content" grow={1}>
        {children}
      </Flex.Item>
      {rightSlot && (
        <Flex.Item className="Notification__rightSlot">{rightSlot}</Flex.Item>
      )}
    </Flex>
  );
}

Notifications.Item = NotificationsItem;
