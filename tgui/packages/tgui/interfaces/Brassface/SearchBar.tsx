import { useEffect, useState } from 'react';
import { Input } from 'tgui-core/components';

import { INK_SOFT, inkButtonStyle, SERIF } from '../common/parchment';
import type { ActFn } from './types';

type Props = {
  serverSearch: string;
  act: ActFn;
};

export const SearchBar = (props: Props) => {
  const { serverSearch, act } = props;
  const [draft, setDraft] = useState(serverSearch);

  useEffect(() => {
    if (draft === serverSearch) return;
    const id = setTimeout(() => {
      act('set_search', { search: draft });
    }, 250);
    return () => clearTimeout(id);
  }, [draft, serverSearch, act]);

  useEffect(() => {
    setDraft(serverSearch);
  }, [serverSearch]);

  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        margin: '8px 0',
      }}
    >
      <span
        style={{
          fontFamily: SERIF,
          fontSize: '12px',
          fontStyle: 'italic',
          color: INK_SOFT,
        }}
      >
        Search goods:
      </span>
      <Input
        value={draft}
        onChange={setDraft}
        placeholder="Type to search across categories..."
        width="260px"
      />
      {!!draft && (
        <button
          type="button"
          style={inkButtonStyle()}
          onClick={() => {
            setDraft('');
            act('clear_search');
          }}
        >
          Clear
        </button>
      )}
    </div>
  );
};
