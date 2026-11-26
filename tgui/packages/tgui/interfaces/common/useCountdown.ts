import { useEffect, useState } from 'react';

export const useCountdown = (seconds: number, tickMs = 5000) => {
  const [start, setStart] = useState(() => Date.now());
  const [now, setNow] = useState(start);

  useEffect(() => {
    const t = Date.now();
    setStart(t);
    setNow(t);
  }, [seconds]);

  useEffect(() => {
    const id = setInterval(() => setNow(Date.now()), tickMs);
    return () => clearInterval(id);
  }, [tickMs]);

  return Math.max(0, seconds - (now - start) / 1000);
};

export const minutesLeft = (seconds: number) =>
  Math.max(1, Math.ceil(seconds / 60));
