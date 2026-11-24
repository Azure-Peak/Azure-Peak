import { type ReactNode, useEffect, useState } from 'react';

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

export const useIncrementalLimit = (total: number, resetKey?: string) => {
  const [limit, setLimit] = useState(CHUNK);
  const [end, setEnd] = useState<HTMLDivElement | null>(null);
  const more = limit < total;

  useEffect(() => {
    setLimit(CHUNK);
  }, [resetKey]);

  useEffect(() => {
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
  }, [more, limit, end]);

  const sentinel = more ? <div ref={setEnd} style={{ height: '1px' }} /> : null;

  return { limit, sentinel };
};

export const IncrementalList = (props: { children: ReactNode[] }) => {
  const { children } = props;
  const { limit, sentinel } = useIncrementalLimit(children.length);

  return (
    <>
      {children.slice(0, limit)}
      {sentinel}
    </>
  );
};
