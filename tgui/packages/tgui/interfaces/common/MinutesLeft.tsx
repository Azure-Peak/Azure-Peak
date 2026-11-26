import { minutesLeft, useCountdown } from './useCountdown';

export const MinutesLeft = (props: { seconds: number }) => {
  const left = minutesLeft(useCountdown(props.seconds));
  return (
    <>
      {left} {left === 1 ? 'minute' : 'minutes'}
    </>
  );
};
