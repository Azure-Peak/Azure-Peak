import { type ComponentProps, useEffect, useState } from 'react';
import { Tabs } from 'tgui-core/components';

type TabCollapsibleProps = {
  title: string;
  startOpen?: boolean;
  forceOpen?: boolean;
} & ComponentProps<typeof Tabs.Tab>;

export const TabCollapsible = (props: TabCollapsibleProps) => {
  const { children, title, startOpen, forceOpen, ...rest } = props;
  const [shown, setShown] = useState(!!startOpen);

  useEffect(() => {
    if (typeof forceOpen === 'boolean') {
      setShown(forceOpen);
    }
  }, [forceOpen]);

  return (
    <>
      <Tabs.Tab
        icon={shown ? 'chevron-down' : 'chevron-right'}
        style={
          shown
            ? { borderBottom: '2px solid var(--tab-background-selected)' }
            : undefined
        }
        onClick={() => setShown((v) => !v)}
        {...rest}
      >
        {title}
      </Tabs.Tab>
      {shown ? children : null}
    </>
  );
};
