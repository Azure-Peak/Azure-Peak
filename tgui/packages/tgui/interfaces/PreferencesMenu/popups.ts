/// <reference types="@rspack/core" />
import { useAtom, useSetAtom } from 'jotai';
import { atomWithStorage } from 'jotai/utils';
import { useCallback, useEffect } from 'react';
import { useBackendStrict, useSharedState } from 'tgui/backend';
import type { BackendStateStrict } from 'tgui/events/types';
import { globalEvents, type KeyEvent } from 'tgui-core/events';
import { KEY } from 'tgui-core/keys';
import type { BooleanLike } from 'tgui-core/react';

// Popup Data
// Data used inside the popup, & this with your own data type
export type PopupData = {
  popup_data_ready: BooleanLike;
};
export type PopupContext = unknown;

// The DM code sends us { regularPageData, popup: { popup_data_ready, other... }}
// So this lets you declare what your data is without having to manually specify
// weird typescript stuff
export type PopupDataWrapper<T extends PopupData> = {
  popup: T;
};

// Helper for useBackendStrict
type PopupBackendState<T extends PopupData> = Pick<
  BackendStateStrict<PopupDataWrapper<T>>,
  'act'
> & {
  data: T;
};
export function usePopupBackend<T extends PopupData>(): PopupBackendState<T> {
  const { act, data } = useBackendStrict<PopupDataWrapper<PopupData>>();
  const { popup } = data;
  return {
    act,
    data: popup as T,
  };
}

// General Helpers for things popups usually do
// Implements all the logic for scrolling through a list using keyboard input
function arrowKeySwitchHandler<T>(
  event: KeyEvent,
  list: T[],
  currentIndex: number,
  setter: (value: T) => void,
) {
  const key = event.event.key;
  if (key === KEY.Tab || key === KEY.Up || key === KEY.Down) {
    event.event.preventDefault();
    let nextIndex: number;
    if (currentIndex === -1) {
      if (key === KEY.Tab) {
        nextIndex = event.event.shiftKey ? list.length - 1 : 0;
      } else if (key === KEY.Down) {
        nextIndex = 0;
      } else {
        nextIndex = list.length - 1;
      }
    } else {
      if (key === KEY.Tab) {
        nextIndex = event.event.shiftKey ? currentIndex - 1 : currentIndex + 1;
      } else if (key === KEY.Up) {
        nextIndex = currentIndex - 1;
      } else {
        nextIndex = currentIndex + 1;
      }

      if (nextIndex < 0) {
        nextIndex = list.length - 1;
      } else if (nextIndex >= list.length) {
        nextIndex = 0;
      }
    }

    const nextValue = list.at(nextIndex);
    if (nextValue) {
      setter(nextValue);
    }
  }
}

/**
 * Custom React Hook that handles binding Tab/Shift+Tab/Up Arrow/Down Arrow to
 * scrolling through a list with wraparound behavior.
 * All you need to pass is the list, the current index, and a setter callback.
 */
export function useKeyscrollEffect<T>({
  list,
  currentIndex,
  setter,
}: {
  list: T[];
  currentIndex: number;
  setter: (value: T) => void;
}) {
  const keydownHandler = useCallback(
    (e: KeyEvent) => {
      arrowKeySwitchHandler(e, list, currentIndex, setter);
    },
    [list, currentIndex, setter],
  );

  return useEffect(() => {
    globalEvents.on('keydown', keydownHandler);
    return () => {
      globalEvents.off('keydown', keydownHandler);
    };
  }, [keydownHandler]);
}

/***********************************/
/* Backend stuff below here!       */
/***********************************/

// Beyond this point lies pure TypeScript madness
// Through a lot of type manipulation and declaration merging and absolutely BS,
// these provide compile time guarantees for registerPopup arguments
// and enable autocompletion.

// All you need to know as someone who wants to make a new popup, is to look at
// the documentation for `registerPopup`, follow the example,
// and it'll automagically work and TypeScript will tell you if you made any typos.

// Automatically import (this means execute!) all files in popup directory
// (so that downstream doesn't have to touch this file)
const popups = import.meta.glob('./popups/*.{tsx,jsx,ts,js}');
for (const popup of Object.values(popups)) {
  popup();
}

/**
 * This is the magic: PopupRegistry is an empty interface that every popup extends
 * via {@link https://www.typescriptlang.org/docs/handbook/declaration-merging.html#module-augmentation | Module Augmentation}
 *
 * This ends up producing a type that would look something like
 * ```ts
 * type PopupRegistry { PopupKey1: dm_key1, PopupKey2: dm_key2 }
 * ```
 * All in the type system. Biome doesn't even like this thing...
 */
// biome-ignore lint/suspicious/noEmptyInterface: intentionally empty to be extended
export interface PopupRegistry {}

/**
 * This is the primary type of React Components we accept as popups.
 * Currently, we accept any valid component with no props, class and function alike.
 */
type PopupComponent = React.ComponentType;

/**
 * Here begins the madness.
 * This type is a union of all {@link PopupRegistry} property keys as strings.
 *
 * This ends up producing a type that would look something like
 * ```tsx
 * type PopupStateKey = "PopupKey1" | "PopupKey2";
 * ```
 */
type PopupStateKey = keyof PopupRegistry;
/**
 * This type is the inverse, the union of all {@link PopupRegistry} propery values.
 *
 * The type would look something like
 * ```tsx
 * type PopupStateValue = "dm_key1" | "dm_key2";
 * ```
 * These are indirectly forced to be strings by {@link PopupMapEntry.state_key}
 * through our other relationships.
 */
type PopupStateValue = PopupRegistry[PopupStateKey];

// HERE LIES CONTEXT HANDLING

/**
 * Same pattern as {@link PopupRegistry} but for context
 */
// biome-ignore lint/suspicious/noEmptyInterface: intentionally empty to be extended
export interface PopupContextRegistry {}

/**
 * This truly cursed nonsense is type system level branching to accomplish this
 * relationship:
 * PopupContextRegistry[keyof PopupRegistry] = T extends PopupContext | never;
 * See internal comments for a more detailed explanation of how it works.
 */
type PopupContextForKey = {
  // First: Iterate over every K in PopupStateKey
  // For each K, is it also a key of PopupContextRegistry?
  [K in PopupStateKey]: K extends keyof PopupContextRegistry
    ? // Yes: K is a key shared between PopupStateKey and PopupContextRegistry
      // New question: Does the value at PopupContextRegistry[K] extend PopupContext?
      PopupContextRegistry[K] extends PopupContext
      ? // Yes: The value at PopupContextRegistry[K] extends PopupContext,
        // Therefore, we have establish that PopupContextForKey[K] -> PopupContextRegistry[K]
        PopupContextRegistry[K]
      : // No: The value at PopupContextRegistry[K] does not extends PopupContext
        // This is an invalid context type,
        // Therefore, we use `never` to indicate that `usePopupId` should not accept
        // a context for this K.
        never
    : // No: K is not a key in PopupContextRegistry.
      // Therefore, the popup does not accept any context.
      // Therefore, we use `never` to indicate that `usePopupId` should not accept
      // a context for this K.
      never;
};

// HERE ENDS CONTEXT HANDLING

/**
 * This is the actual object that ends up stored inside {@link popupMap} to
 * establish relationships between
 * {@link PopupStateKey} ->
 * {@link PopupStateValue} & {@link PopupComponent}
 */
export type PopupMapEntry = {
  state_key: string;
  component: PopupComponent;
};

/**
 * This is the type for {@link popupMap}, which establishes a relationship
 * between every union member of {@link PopupStateKey} and their according
 * {@link PopupMapEntry}.
 *
 * This is used to make sure that {@link registerPopup} is correct at
 * compile time!
 */
type PopupMapType = { [K in PopupStateKey]: PopupMapEntry };
/**
 * Primary map that stores the relationship between {@link PopupStateKey} and {@link PopupMapEntry}.
 *
 * This is {@link Partial} because we can't compute it at compile time, we rely on {@link registerPopup}.
 */
const popupMap: Partial<PopupMapType> = {};

/**
 * Inverted map linking each {@link PopupStateValue} to their {@link PopupComponent}.
 * This is used by {@link getActivePopup} to figure out what popup to display based
 * on the DM shared state.
 */
type PopupByStateValueMapType = { [V in PopupStateValue]: PopupComponent };
/**
 * @see {@link PopupByStateValueMapType}
 */
const popupByStateValueMap: Partial<PopupByStateValueMapType> = {};

/**
 * Register a popup component under a typed registry key.
 *
 * This works via TypeScript module augmentation:
 * You add keys to {@link PopupRegistry} in the popup modules under `popups/`,
 * and then register components against those keys.
 *
 * @example
 * // popups/MyPopup.tsx
 *
 * const MyComponent = (props) => {};
 *
 * // 1) Augment the registry's key set and associated state_key type
 * declare module "pm/popups" {
 *   interface PopupRegistry {
 *     MyPopup: "dm_side_key"
 *   }
 * }
 *
 * // 2) Register the component (this has type enforcement on all parameters!)
 * registerPopup("MyPopup", "dm_side_key", MyComponent);
 *
 * @desc
 * Technical details: This is generic over {@link PopupStateKey} to enforce
 * that {@link state_key} is the exact value of {@link key} given inside
 * {@link PopupRegistry}, thereby providing autocompletion and preventing you at
 * the typesystem level from mismatching them, such as
 * `registerPopup("Popup1", "dm_key_2")`.
 */
export const registerPopup = <K extends PopupStateKey>(
  key: K,
  state_key: PopupRegistry[K],
  component: React.ComponentType<any>,
) => {
  popupMap[key] = {
    state_key,
    component,
  };
  popupByStateValueMap[state_key] = component;
};

/**
 * This function just returns the {@link PopupMapEntry} for a given
 * {@link PopupStateKey} with extra error handling.
 */
const getPopup = <K extends PopupStateKey>(
  key: K | null,
): PopupMapEntry | null => {
  if (!key) return null;

  const entry = popupMap[key];
  if (!entry) throw new Error(`Popup "${key}" is not registered!`);

  return entry;
};

/**
 * Extra context, used for stuff like "which virtue are you setting?"
 * This uses atomWithStorage because we want to persist stuff for exactly the
 * duration of this play session in case they close the window and reopen it.
 *
 * Be careful with this, as it's an `any` type and types are only checked via
 * {@link usePopupContext}'s generic. There's nothing preventing you from feeding
 * your popup the wrong type of data.
 */
export const popupContextAtom = atomWithStorage<any | null>(
  'pm-popup-context',
  null,
);
/**
 * @see {@link popupContextAtom}
 */
export const usePopupContext = <T>() => useAtom<T | null>(popupContextAtom);

// A whole bunch of nonsense to enforce our requirements
type PopupKeysWithCtx = {
  [K in PopupStateKey]: PopupContextForKey[K] extends never ? never : K;
}[PopupStateKey];

type PopupKeysWithoutCtx = {
  [K in PopupStateKey]: PopupContextForKey[K] extends never ? K : never;
}[PopupStateKey];

/**
 * Returned from {@link usePopupId},
 * this setter function enforces that you pass the correct {@link PopupContext}
 * for the given key of {@link PopupStateKey}.
 */
type PopupSetter = {
  // When nextState is a specific popup key w/ context, context MUST BE the matching Ctx
  <K extends PopupKeysWithCtx>(
    nextState: K,
    context: PopupContextForKey[K],
  ): void;

  // When nextState is a specific popup key wo/ context, context is not allowed
  <K extends PopupKeysWithoutCtx>(nextState: K, context?: never): void;

  // When nextState is null, no context
  (nextState: null): void;
};

/**
 * This is a {@link https://react.dev/learn/reusing-logic-with-custom-hooks | React Hook}
 * that allows you to get and set the current global popup for the UI.
 *
 * This enforces that your call to setPopupId uses a key registered by {@link registerPopup}.
 *
 * @example
 * const Component = (props) => {
 *   const [popupId, setPopupId] = usePopupId();
 *   return (
 *     <Button onClick={() => setPopupId("CharFlaw")}>
 *   )
 * }
 */
export const usePopupId = (): [string | null, PopupSetter] => {
  const setPopupContext = useSetAtom(popupContextAtom);
  const [state, setState] = useSharedState<string | null>('popup', null);

  const setter: PopupSetter = (
    nextKey: PopupStateKey | null,
    context?: PopupContext,
  ) => {
    if (nextKey === null) {
      setState(null);
    } else {
      const entry = getPopup(nextKey);
      // entry cannot be null because we guaranteed that nextKey is a PopupStateKey
      // and it is an invariant that anything that defines a new PopupStateKey
      // must call registerPopup. If that invariant is broken, let us crash!
      setState(entry!.state_key);
    }

    if (context) setPopupContext(context);
  };

  return [state, setter];
};

/**
 * This just gets the {@link PopupComponent} for whatever {@link PopupStateKey}
 * is currently active. Mostly used by pm/index.tsx.
 */
export const getActivePopup = (): PopupComponent | null => {
  const [popupId] = usePopupId();
  if (!popupId) return null;
  return popupByStateValueMap[popupId];
};
