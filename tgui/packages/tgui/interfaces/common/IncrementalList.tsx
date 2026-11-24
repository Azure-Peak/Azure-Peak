import { type ReactNode, useEffect, useRef, useState } from 'react';

const CHUNK = 40;

const scrollParentOf = (element: HTMLElement) => {
  let node = element.parentElement;
  while (node) {
    const { overflowY } = getComputedStyle(node);
    if (overflowY === 'auto' || overflowY === 'scroll') {
      return node;
    }
    node = node.parentElement;
  }
  return null;
};

export const IncrementalList = (props: { children: ReactNode[] }) => {
  const { children } = props;
  const [limit, setLimit] = useState(CHUNK);
  const endRef = useRef<HTMLDivElement>(null);
  const more = limit < children.length;

  useEffect(() => {
    const end = endRef.current;
    if (!more || !end) {
      return;
    }
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting) {
          setLimit((current) => current + CHUNK);
        }
      },
      { root: scrollParentOf(end), rootMargin: '0px 0px 600px 0px' },
    );
    observer.observe(end);
    return () => observer.disconnect();
  }, [more, limit]);

  return (
    <>
      {children.slice(0, limit)}
      {more && <div ref={endRef} style={{ height: '1px' }} />}
    </>
  );
};
