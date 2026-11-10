import type { BooleanLike } from 'tgui-core/react';

export enum SourceState {
  Idle = 0,
  Loading = 1,
  Ready = 2,
  Huge = 3,
  Gone = 4,
}

export type Category = {
  name: string;
  count: number;
  on: BooleanLike;
};

export type Source = {
  name: string;
  file: string;
  state: SourceState;
  bytes: number;
  on: BooleanLike;
  cats: Category[];
};

export type Person = {
  ckey: string;
  key: string;
  names: string[];
  jobs: string[];
};

export type Row = {
  src: string;
  i: number;
  ts: string;
  cat: string;
  msg: string;
  data: string | null;
};

export type Data = {
  days: string[];
  day: string | null;
  rounds: string[];
  round: string | null;
  live: BooleanLike;
  busy: BooleanLike;
  error: string | null;
  search: string;
  pattern: BooleanLike;
  exclude: string;
  from: string;
  till: string;
  players: string[];
  chars: BooleanLike;
  newest: BooleanLike;
  marks: string[];
  focus: string | null;
  sources: Source[];
  others?: string[];
  people: Person[];
  rows: Row[];
  total: number;
  page: number;
  pages: number;
};

export type Filters = {
  search: string;
  pattern: boolean;
  exclude: string;
  from: string;
  till: string;
};
