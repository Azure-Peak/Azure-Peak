import { useEffect, useState } from 'react';

import { inkInputStyle } from './parchment';

export const CommitNumberInput = (props: {
  value: number;
  min?: number;
  max?: number;
  width?: number;
  onCommit: (value: number) => void;
}) => {
  const { value, min, max, width = 56, onCommit } = props;
  const [text, setText] = useState(String(value));

  useEffect(() => setText(String(value)), [value]);

  const commit = () => {
    const amount = Number(text);
    if (text !== '' && Number.isFinite(amount) && amount !== value) {
      onCommit(amount);
    }
    setText(String(value));
  };

  return (
    <input
      type="number"
      min={min}
      max={max}
      step={1}
      value={text}
      onChange={(e) => setText(e.target.value)}
      onBlur={commit}
      onKeyDown={(e) => {
        if (e.key === 'Enter') {
          e.currentTarget.blur();
        } else if (e.key === 'Escape') {
          setText(String(value));
        }
      }}
      style={{ ...inkInputStyle, width, textAlign: 'right' }}
    />
  );
};
