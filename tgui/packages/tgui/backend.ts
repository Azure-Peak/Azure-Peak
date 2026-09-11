//! WARNING: This file is not the same as /tg/'s! Be careful when updating!
import { sendAct } from './events/act';
import { backendStateAtom, sharedAtom, store } from './events/store';
import type { BackendState, BackendStateStrict } from './events/types';

/**
 * Reactive backend state hook. Please use a type to define what the data is
 * intended to be, e.g.:
 *
 * ```ts
 * type Data = {
 *  username: string;
 * };
 *
 * const { data } = useBackend<Data>();
 *
 * console.log(data.username); // You'll get type safety here
 * ```
 */
export function useBackend<
  TData extends Record<string, any>,
>(): BackendState<TData> {
  const state = store.get(backendStateAtom);

  return {
    act: sendAct,
    ...state,
    data: state.data as TData,
  };
}

/**
 * @see {@link useBackend}
 *
 * This is useBackend, but with stricter typing on the return type's data.
 */
export function useBackendStrict<TData>(): BackendStateStrict<TData> {
  const state = store.get(backendStateAtom);

  return {
    act: sendAct,
    ...state,
    data: state.data as any as TData,
  };
}

/**
 * A tuple that contains the state and a setter function for it.
 */
type StateWithSetter<T> = [T, (nextState: T) => void];

/**
 * Allocates state in the Jotai store without sharing it with other clients.
 *
 * Use it when you want to have a stateful variable in your component
 * that persists between renders, but will be forgotten after you close
 * the UI.
 *
 * It is a lot more performant than `setSharedState`.
 *
 * @param key Key which uniquely identifies this state in Zustand store.
 * @param initialState Initializes your global variable with this value.
 * @deprecated Use useState and useEffect when you can. Pass the state as a prop.
 */
export const useLocalState = <TState>(
  key: string,
  initialState: TState,
): StateWithSetter<TState> => {
  const sharedStates = store.get(sharedAtom);
  const sharedState = key in sharedStates ? sharedStates[key] : initialState;

  return [
    sharedState,
    (nextState) => {
      store.set(sharedAtom, (prev) => ({
        ...prev,
        [key]: nextState,
      }));
    },
  ];
};

/**
 * Allocates state on Jotai store, and **shares** it with other clients
 * in the game.
 *
 * Use it when you want to have a stateful variable in your component
 * that persists not only between renders, but also gets pushed to other
 * clients that observe this UI.
 *
 * This makes creation of observable UIs easier.
 *
 * @param key Key which uniquely identifies this state in Jotai store.
 * @param initialState Initializes your global variable with this value.
 */
export const useSharedState = <TState>(
  key: string,
  initialState: TState,
): StateWithSetter<TState> => {
  const sharedStates = store.get(sharedAtom);
  const sharedState = key in sharedStates ? sharedStates[key] : initialState;

  return [
    sharedState,
    (nextState) => {
      Byond.sendMessage({
        type: 'setSharedState',
        key,
        value:
          JSON.stringify(
            typeof nextState === 'function'
              ? nextState(sharedState)
              : nextState,
          ) || '',
      });
    },
  ];
};
