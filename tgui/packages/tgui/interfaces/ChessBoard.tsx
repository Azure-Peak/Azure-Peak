import {
  type CSSProperties,
  type ReactNode,
  useEffect,
  useMemo,
  useState,
} from 'react';

import { Button, Section } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type ChessSquare = {
  index: number;
  file: number;
  rank: number;
  piece: string | null;
  light: boolean;
  selected: boolean;
  lastmove: boolean;
  target: boolean;
  pose?: string | null;
  offset_x?: number;
  offset_y?: number;
  angle?: number;
};

type ChessHistoryRow = {
  turn: number;
  white: string | null;
  black: string | null;
};

type ModeOption = {
  key: 'chess' | 'checkers' | 'nards';
  label: string;
};

type ModePickerStep = 'root' | 'checkers_rules' | 'nards_rules';

type NardsPointData = {
  point: number;
  color: 'w' | 'b' | null;
  count: number;
};

type NardsScatterPiece = {
  color: 'w' | 'b';
  pose?: string | null;
  left: number;
  top: number;
  angle?: number;
  z?: number;
};

type NardsScatterDie = {
  face: number;
  left: number;
  top: number;
  angle?: number;
  z?: number;
};

type NardsData = {
  points: NardsPointData[];
  bar_white: number;
  bar_black: number;
  off_white: number;
  off_black: number;
  die_one: number;
  die_two: number;
  roll_nonce: number;
  can_roll: boolean;
  selected_point: number;
  selected_bar: boolean;
  legal_targets: number[];
  can_select_bar: boolean;
  available_rolls: number[];
  is_long_rules?: boolean;
  overturned?: boolean;
  scatter?: NardsScatterPiece[];
  scatter_dice?: NardsScatterDie[];
};

type ChessBoardData = {
  board_title: string;
  white_player_name: string;
  black_player_name: string;
  my_side: string;
  my_side_key: string | null;
  turn: string;
  turn_key: string;
  paused: boolean;
  result_text: string | null;
  selected_square: number;
  status_text: string;
  last_message: string | null;
  can_resume: boolean;
  can_pack: boolean;
  board: ChessSquare[];
  history: ChessHistoryRow[];
  promotion_choices: string[];
  game_mode: 'none' | 'chess' | 'checkers' | 'nards';
  game_mode_label: string;
  current_rules_text: string | null;
  checkers_flying_kings: boolean;
  nards_long_rules: boolean;
  switch_mode_target_key: 'chess' | 'checkers' | 'nards';
  switch_mode_target_label: string;
  mode_switch_pending: boolean;
  mode_switch_pending_text: string | null;
  can_confirm_mode_switch: boolean;
  can_cancel_mode_switch: boolean;
  reset_pending_text: string | null;
  can_confirm_reset_request: boolean;
  can_cancel_reset_request: boolean;
  can_flip_board: boolean;
  can_resign: boolean;
  mode_options: ModeOption[];
  nards: NardsData | null;
};

const CHESS_IMAGES: Record<string, string> = {
  bk: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAaCAYAAAC+aNwHAAAAAXNSR0IArs4c6QAAAMFJREFUOI3tkzEOwyAMRX/jTtyOiDFSe4AeJwdILhBu1b0dukV0cgTGUJiy9EssYD9sfxmoyBAFQxRqMZda8mgtAGDzHp99V2OHGr1Ff0DBhdgBVsmJIU6Svs/rgnldAACjtWpM0oL89XG7Z9XJmKYZcBU/ZYjC5NxR5uTcceK3bkhzcgyRgFKyOgPNrq5lkr+xhc2AHp0PyAYT99qyD+e3kAC4fFk66/l+ZXZetcDN+wTCy6RtpwpgSMtd1QVN0oUv+YRmDtjjVIsAAAAASUVORK5CYII=',
  bq: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAaCAYAAAC+aNwHAAAAAXNSR0IArs4c6QAAAN9JREFUOI3NVLsRgzAMfcSpKKBnK3OUuYMBGIcBYAG8VWqSg3QcqZQDWVZMqrwOyXrS0wdAQWrMlhqzaW/U4GmZt2mZVZKLRlJk+fms+2zfvk+VHPIfJPCSeUZJUsIDAOC1rklqzFZaCwAYnfvYyC8S7IkomEAk/K03hVCT7s+H6FPHSOiGHm3diL4ogrZu0A19HAHpHJ072IssF3sQBI3wVlW/r3IM/pSAay6tDe7Hn0o4A28x9lpjDipYAQ8O4UDA/wF8naWLvHLG0TkvOx2SdJEeAYRD0uxqEyXwJr4BCQR6HSM589sAAAAASUVORK5CYII=',
  br: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAALdJREFUOI2lUjkOgzAQXOxUFNDzKyPKSPAAnsMD4APhV9QBkXTIqWwt69lQMJJl+Zixd3aIbiLTDnJrPV9/j0O9C8nPpvHvzx6HFAx4IHLtHA3TSH3bxf1lW6kqSi9/YhAZoW87WrY1Kc1wsiQN03iakYiRJP5iIPNSJBIPkMg/JD94zfMliSM6Kj2QZgYfqqIk0nKRW+v5QFmQDyUqWmACLnOgEWvnYA5gF7T6UVeggNYJtH/bgx97JWirP5ZlNQAAAABJRU5ErkJggg==',
  bb: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAVCAYAAABPPm7SAAAAAXNSR0IArs4c6QAAAOZJREFUOI2NVDEOwjAMvBKmDrDzK0cZK8EDeA4PgA80v+pMK+hWhYVUqeM4PSlSZcX2nc8poKA1JrTGBO1OoyVbIgBA7z3mZRHvisE0OaJUJAvw5N57ACgyOJYk1KhHHGrUazjsuLNpwF3JCkTNAGCJ1qSYGGO7GVgiDNMIS4Rd8mK3zrnw/n7W0zkXOucyCaKN8XuYRtyvt4087kpm47wsDe+i7YI6g7R7CcUC6cC04RXfghSXJKirLL2JKoN0YTiqLvB/AC80TCMup3NIizS8gNT98XoCf1c4C3EGJb1SXN1ECXwGPz4khROyCGpGAAAAAElFTkSuQmCC',
  bn: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAARCAYAAADUryzEAAAAAXNSR0IArs4c6QAAAL1JREFUOI2tU8ENgzAMNKQvtqPKE6kdoOMwACwQb8UbEPSH0pej1MlZqtSTIgXnOF/MQaTQORd1zTprNeHe91UiOms18VckAelgITCTdtFqAhEVJNnXGsAriIj18pfA+7qa3MU4T7TsW1q5S+FCB4GZXo9nes73Go0uWJZ1d4jOuTh4H9fziOt5xMH7iAJ2s4Qs64L/BUmArKKIF/+CkANz+qSCZd8KkeoMJLKCcZ6IwEzgEHV3VIM5QNA5+ACcy2I3yHjNqgAAAABJRU5ErkJggg==',
  bp: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAINJREFUOI1jYBgFjLgkuJiZ/yPzv/39i1UtVkEuZub/QYGBKGLr1q/HaggTIZthICgwEKschgHINhIDcBpArCF4DaDYBSQbAAsk9BiAAWwBiRItyJLYDJmycAGDFB8/SnSyEOPMKQsXMDAwMDDkxCdgyOE0AFsMYBPDSFm4EhIMoKdGADBjKGH4tZZaAAAAAElFTkSuQmCC',
  wk: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAaCAYAAAC+aNwHAAAAAXNSR0IArs4c6QAAANNJREFUOI3lkjEOgzAMRZ2GKQPZuRSiYmqR4AAcpwdoh/ZozICgG0qnRMG1QwuoS/+EsP3zEz+AgJSURklpQj3B4XYcTDsOQZPDKvc/MKAejXtIwTU1fTdrTGLtvp/T5OaEP4yH9OkM3eP+dmoSa2cS+YW6rAAA4HK7kia2zsqSV+S5g8ik6Qyoj8jEJks0siabUV68889AavqOBYlNcMyy9Qm+0WYDgX8oKY2N7xMJCOHdEuxrYOPj6FbUOskEdVmxJlgRV/AxtmYU2uQWQifiLbwApGV48x1Y0i0AAAAASUVORK5CYII=',
  wq: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAaCAYAAAC+aNwHAAAAAXNSR0IArs4c6QAAAPNJREFUOI29k70OgjAQx09Plg6y+0wkDcYJNPoAPo4PoAM8GjMQcCPnYDDlerSA0UsY6LW/+98XgMMUIilEct1xPiatibR2QtYuyCkI5kc1o/n+Z0ke8w9S4JJ5RG9K5gOFSGXbUNk2gzOubjUGKupqcLbbhvDsOuu+1QWFSPs4tqBtFIFUG2cbewuTFKo8E32TAFWeQZikU66+TSHS8XD4FNEs5CLI4lEGALieL06/F3B73L8D+EwE8Fko6kqcgd8p+CvAWg4zf94BaaFGFfjaJyro19gcnikqBgC+A/zj7dxIID6+vQpprMUijqQLAGDJfwH2wpwfXybqGgAAAABJRU5ErkJggg==',
  wr: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAMlJREFUOI2lUjsSgjAUXI1poPBiaUIJw+gBPA4HgEJLaXImepjBjsEqTt4HZcZtQkJ232bfA/7EYetHZsya7l/Lot5VDzNj1tk5cpaHoIqcfpHHxx0AMJcV8hBWLnLk5GEaBTl+z86Jpx1TcuE9cXMuK7ICECLEgVY5JWtQBTT7uwVulyshRvKWE9VBKsJRW0v2pCU8yKZrSfXaWjz7nsyDGAytGxGcLJ7Ae5yi6VoM0yjuiEksvP9Y3wMhACXEKKiFq2bwrSLP4A1VM1o5Oc2Y1QAAAABJRU5ErkJggg==',
  wb: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAVCAYAAABPPm7SAAAAAXNSR0IArs4c6QAAAOpJREFUOI2NVDsOgzAMfTRlYYCdMyGxMPWj9gA9Tg/QDu1YbsUMCNiidMERJI7hTZHl5/jZLwEEJEqZRCkj5YjkdhxMOw5ikShEbvpuFcvTDJPWXr4XcMl5mgEASwaAoyQjdOsSB+727HSWOOECAEQytxWvwDWO7bnpO0siIsUoJzgD6mQsCnTfz05Bc5uXqrIeMGVpz5wnPAmEx+3uxbiteAUmraNfXXvFdhuJZGAeGDbMFJSwdKNr6yWCW+BmsBvuJrZe5CZZKhK5ZNJLEp7v14ogPjDp9lAX7BDdAVIX3GDZD4Vtb4bb/h/fAMEBoGQ9WAAAAABJRU5ErkJggg==',
  wn: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAARCAYAAADUryzEAAAAAXNSR0IArs4c6QAAANxJREFUOI2tUjEOgzAMNA0TQ9n7JqQoKFOLBA/gOTwAhnYsv2KGClhQ5A6VURRMYOhJkSL7fMnZBnAQCYFu7ExuJfTTiBxxL3fxKp7AKhAJgd1n8JLLvIDuM/BWIiEw0xr7adx81ZfbtUAvRUJgqhRUTc3yQrrMxgTvtkUAgKqpIb4/YEqSX3JZgMzdrjHMxgSHPxheT/Z+CNevfQ73wBbppxFRSkQpvcUBF+RG6non/G+R7NdTpTbE3QVyi6mBmdZsM12RkBMq82J3cVywAiRCIDE7Rth09cinO4kv5pOkv2PICzcAAAAASUVORK5CYII=',
  wp: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAHtJREFUOI1jYBgFjLgkuJiZ/yPzv/39i1UtVkEuZub/zz59RBGT4uPHaggTNs1BgYEYhj779BHDVVgNgIGc+ARcUsQZQKwheA2g2AUkGwALwCkLF2BVjC0gWbApzIlPwGkIXheQA7C6gAEtBmCuwRYrGCkLW2JBBuipEQCXqSYmibUbxQAAAABJRU5ErkJggg==',
};

const CHECKERS_IMAGES: Record<string, string> = {
  bk: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAO9JREFUOI3FkyEOwjAUhr8SDgFBLEGQYDgAyQSb4AS7wywGFAoFBssdOAECECQcYGbJxJKKZbtFUd26rkswhN81ff/X/722AodWy0DlRenaQspUmOuhbQSI4g2vx90J4IkyQcI0m8YqSwAYzRb4QQjQgr6fN6RMhQDwvLnaHU5Osyk/CDuQgV64ImuQ1vVy7tTUCaaTcetE22wnqrKEvCibIUbxhuvlXBfZ8fvArVvQA3NFNWtMSA0wZ/Dt6UAzRD8IqbKk//5/2oKUqTjut2q5Wn/dQl6UzUPS8ry5AphOxr0J9B/pPGUXyCX7M/1fH4y5eAAZ+aW4AAAAAElFTkSuQmCC',
  bm: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAANVJREFUOI1jYBjygBGboLy85n9cGh4+vI6ihwWZ42jl9J+BgYEhNKOQ4fC+vdhN2M/wH9kgRmTNyBpf3LrEwMDAwCChpsdg6+TMwMDAgGLosf07GR4+vM7ICHNyeXMXVs3IwNbJGcMQJhgHm5NhBsHA6hn9GGrgLlCSlkSxEV0zuote3LrEcO/pc0QghmYUMqye0Q9XhO58XAajxAIswLA5FVkNsiEsDNAo6awt+2/l6E607feePkfEAgzAEpCStCROF9x7+pyBAVs6wGYQNoCeEgceAABj7mGQJr3UowAAAABJRU5ErkJggg==',
  wk: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAQhJREFUOI3Fk6FuAkEQhr+lfQBM9QYSBKoKQ1IBFXUkTTA4ZB2nqCIhqQLVOh6CpEndCThBcqYKdYI016UPslVLZ7m9UkHSP1kx2Z1v/5nMKAIaDCObJnHoCmMyJWMvGAwjC/Dy/MDybRcEzCZjD6RkskzcrFcA3HRv6fcaAB50NhljTKYUgNZN+759DSZL9XuNAqTigpBlB3IaRYvCmwuAavVqaqmga3UAdK3OPs8B2Of54UhHm/WKr88PvBJG0aJg+zdXaRJzKS9dw0JW5RsJOQBkD8pcHPfEA5z6uQxynhKMyVTr+t4+Ps3/XEKaxD+D5KR10wK0O3elDtyOFEY5BArpeJn+X99Ty3/UCob+KgAAAABJRU5ErkJggg==',
  wm: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAO5JREFUOI3VkiELwkAcxX+bfgCLeSgYTCaLYFCDbSBYbEabS5oGgkmTtn0IQbAZnEGwmEwGkTn9ILN4486dYhMfXPjfvffu3f3/8PcwdJuWVYzeCcLwpGiUotN1IoD5rMdiddYaTNyBYmTIYlm48zcAVOsN2nYBQDGduAPC8GQYIvLhuNSKZbTtQsLEFIUusjAS6DtegpMCyGSyowgTK5cHwMrluQUBALcgiJecaOdvuF8vKE/oO14i9qdU++2atHwoPkwXVebIJmmeLSmXWtFwPI1J39wed0FADFCl1nybYL9dg24OdEY6vE7i7/EARwBtEydM/q4AAAAASUVORK5CYII=',
};

const CHESS_LABELS: Record<string, string> = {
  bk: 'K',
  bq: 'Q',
  br: 'R',
  bb: 'B',
  bn: 'N',
  bp: 'P',
  wk: 'K',
  wq: 'Q',
  wr: 'R',
  wb: 'B',
  wn: 'N',
  wp: 'P',
};

const CHECKERS_LABELS: Record<string, string> = {
  bk: 'D',
  bm: 'M',
  wk: 'D',
  wm: 'M',
};

const NARDS_CHECKERS_IMAGES: Record<'w' | 'b', string> = {
  w: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAL1JREFUOI1jYKAQMOKSkJfX/I/Mf/jwOla1GIIwjeXNXSjinbVlWA1iRNeMrhEZHN63l+HY/p0ohrDg0nx4314429bJGYVm2M/wH2YIEy6bYBpgmkL8VFENQfYCsu3ImtFBiJ8qw5pNt+Fh8vDhdUasLiAF0NcAmPMxDHj48Dojut+RYwGdD/M/A3I0wgAstA/v24s1KtEB3IDlCyYwMjAw/Ec2BBtAtp0BW1KOTCj4f2z/TvKSMjIgNjNRDAB8iF6KIITsnAAAAABJRU5ErkJggg==',
  b: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAMVJREFUOI29k7EKwyAQhn9LHqJbtkKXPkDAQR36zBkah4APkCWQIeAQkrewS00v5qQtgf6Lyvl/53EncFAiFyjLa6Bn73v2bpEzVuq+DVgEDiRS885ItAwdxmneQIqceRm6dX++3DYrgBAhp1ymaIgmqU0KeZdAs1NzKqkN2uYBAHC2hve9YF/wi/4LiM/fAbzvRVo77UJ6jvWDGySpDdqXgWtlqhVgXSMUEFoC4USzg/sLqtJhnObdKDtbA59Gmerbz3RYT03UYPxBM4coAAAAAElFTkSuQmCC',
};

const NARDS_DICE_FLAT: Record<number, string> = {
  1: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAKFJREFUSIntllEKwyAQBcfSG6z3P8R6LfcM9kuwqRasawglA4EgyRvURwz8O6HeiAhA2eUxMwAezeAuWT9bREq9VLWsoqqlzRwKPWQ9afW0e1gAcs6uaxljBMDMAoc9PIVb6M5z9oVagspsyaZmeJSNxtyEHtzCN3oFmS3NdEtXP33XXtJb+JMwpeQW/jXrrF+MjxN/F70TP4wfX2Zn9sV4AYZEDmdLoXcfAAAAAElFTkSuQmCC',
  2: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAALJJREFUSIndllEKxCAMBceyN4j3P4Rey5zB/RJka2vFuEgfCG1tM5oXYuHtcuVCRADyKo6qAnBUD1fB2rFFJJcRQsizCiHkOuYl0ALWghZO7WEGSCmZ5tJ7D4CqOoDP0w+sFnPcTdaw1r05cIX2Av56ZuFht2isq3avlL4C2PXwiUaaw/QOR5vD+z2cBo42B5OiGWkOpx3GGC3W0I/1r1+M04m/SuXEr1Pqrl+f1srYm+kLs6AaL4V765sAAAAASUVORK5CYII=',
  3: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAL5JREFUSIndllsKxCAMRa9DdxD3v4i4LbMG50sIUx9jEweZC4VSNEfNAQv8e0J9ISIAKLs4IgIAeKmPu2Dt2kRU6sPMxRpmLrpmF+gBa0ErR/ewAEDO2fUsY4wAABEJ+Ohhd0Kd5JEhUIO8oNMdemcI1P306u01G+At0aMjtYi0DLSKdJY0rVhFmkozg67G7Ui/FckFuCLS+dK0siLSI2lm0FFuO0wpea1hXOtXvxi3G39XWjd+6A83Z2ftw/IGDIEeWdI+4TIAAAAASUVORK5CYII=',
  4: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAKhJREFUSIntlmEKwyAMhT/HbpDe/xDxWuYM7pcgm9qM6ihdHxSkvLyvJEWFqyuUhYgA5FUcMwPgUb1cBWtni0guj6rmo1LVXGd2gTNgLWjh1DPMACmlqb3ctg0AMwu8zbBbUIpm+IbAOmAU5vXtAldoCKznOZqt1wfw3Psi70/k9Z2rpTfwGsB7p/lWf7jTxBhdhR4Ns351xfg48VepdeKHvv2wVmafTC/S3yeTztuWAQAAAABJRU5ErkJggg==',
  5: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAALpJREFUSIntlm0KAyEMRJ+lN4j3P4ReS89gfwnS9SNWLaXtwMKyJPPEDLrw7TL5RUQA0ilOjBGAW/HxFKzuLSIpP865tCrnXCo9m8AdsBo0c8oZJoAQwta9tNYCEGM0PM2w2ZCbdtR1gaVBz0xbNwSeUBdYzrM3W20dwH20Im2ItHUvbak2IFuAMwHZAlzVNHAmIDUNQzOCzup/0mzXD5403ntVo0Zdr3f9Ylxu/FOq3fimXb6sk94fpgeufDDRJ8+jrQAAAABJRU5ErkJggg==',
  6: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAKdJREFUSIntllEKwyAQRJ+lN1jvf4j1Wu4Z7JcgrZot0VLaPAiEMDsTsgMGfp1Qb0QEoOzKMTMAbs3DXWF9bxEp9VLVchZVLa3nMHBFWC+05rQ7LAA556XfMsYIgJkFnnY4HKhDK3TTwNZgZubVHQbuYBrY7nO2W68O4H70Rt4SeXVXaZZzleYqzdv8YWlSSq5BD1OvT/1ivJz4u+id+GEsP81O7y/jAX+BOg15M04HAAAAAElFTkSuQmCC',
};

const NARDS_DICE_ROLL: Record<number, string> = {
  1: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAVFJREFUSImtluGtwyAMhJ2qGySDkEEyIzvAIGQQmCHvlyMwnDHVO6lqaY77DLESNlrUvu9PPS6lbCvzzWYJkrKCPxZQDfPeU86Zcs7kvYe+ZXEAf0IID1II4ZF+lNttgzTnnJcKPY6jGcutfgdWUIyxGV/XtQTeJExbkYTNoBJcStmapvHew1AUrMFijE1jERF9kfEXgJw/UgM8z5OIiFJKU7AFxHkQ+CvYAoLAlNI7AYGRNBCraRoO5u86SAsbXZcZQ6A2gVdeB6NCUOEdEK1CC5gVqgJr6Axu0ShjuKXSaGkG6UVzOiBawSzIWqCpS3msBVm3GjaNhGuBK00Fm0YLnv1nBjrnXujKPWONvJzZAOu3snOuM2lwdE3mNC/gWvLNf993B9GaSBYrjxjdw5sNDOaAEXgFBIGrYCuINT2XllI2eY9Hv6UPaemYTv9w1P8Dl1YD4n1DRQsAAAAASUVORK5CYII=',
  2: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAUBJREFUSInNlv/JxDAIhm25DVrIToUO0cm6QwLdKdDM0Psrh1o1psf3cS8cJFbzqP1xDtCpaZouvC+lDD3xXc4c9gTqcuSgfd8BAGDbtsdgE4Z/McarKsZ48et/AuLqAYst4AHnebqSnOeZ7KUWE8NTEFZKyby3n4UXllIi+3VdRT+t2oHDrKo4rAXl4FLKMOKLT1rYEj+TALUKvhE/c5QcelqntVM752Vl1gPgsZoIMIQAAAA5ZxLogUigeh4WaWnOGXLON0fPvfXAQGsphraq9YKqSIWSs1WtBqudknSrsJWhBQLUEU2316IV4E1QsxPgsiwiFAdra2zD9npmlfrxPo5DzBAnxB8sC1Q/3iM3SAHWQyDZNRh4/oDr/FIVQiAV4bUFMoEcKoFxAq2qXEAvuHdy+/cx8TcHYQvaO/y+AS3hCu60Of85AAAAAElFTkSuQmCC',
  3: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAMVJREFUSInF1sEZwyAIBlCSFXQth3Ayh3AtnaE9tR9ajfxIUk5RiO8SCUQPx4G+4Jx78XWtFToDKu4xDSou5FhKiYiIYowwKiriWCmlyXnvIXRZcIVp0MukBEPRaQLBEHS4qcGk6M/GDiZBm4UFtkK/D1Is59ysQwgQeuxgGvTkyU8HsYz+zHNaeVM0IO+NVtGf+Z+PBkUlsbwWlqj44lugcGvbQdXNW4Nu/54Q1OwHLEHNR4wRevsQNUJ53DImzlB0EH483kUApB75Q6XNAAAAAElFTkSuQmCC',
  4: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAAVNJREFUSIm1lsGVhSAMRZ//2AEWgoVQhJVRhIVgIVDDn1U4EBMkzkxWGkMueQRkgdGcc9/2vZSyWMabgjnsDXQqkINijACA4zjM4McADUZmhaofOSjnXJ/P8wQAhBCqb9u2KfBnBhZjrBDN2glJOcjWUVDO+REkQalaytdWWyscSQgm3yxYyr1yxxuQtKa8k51z31LK0knKJaQEbcL2uyZ36885dw310QIl32g9JSUk33rzTMi47zsAIKXUTYbGjcZ3FYYQqmxaNQTjz3hQgGxB0zSjbcCTc2urhXIolFIWceNbYVKMNvF1FDQDkuKpWgmqVmiFzY69dal1rbR4qZPBK7TCNN8oZwf03g8HvzGes57i/PC+rktMMCspB9Efo/tJzkKfTIPdgL8Fj0Bk4rbggd77YXOklKZgeHuJalv+zy5RT1D81zVxBLaAXgElqPWq/wMhytzVv4m90AAAAABJRU5ErkJggg==',
  5: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAATlJREFUSImt1tGNgzAMBmCDbgOQ2AkpQzAZQyCxE1Iyw91TKufHDr/p+aWlcvJhJ4UMEoxpmn71dSlliIynkxHCYOHHJIRyznIch4iIpJRknucQ/BOBrKi/V7iO8+AbyEJv4VFDGss5N1htIwPrcTjviFXhAI2xqAc3FUqgfZHAOUcrCStJKTWfTHjduIFe+95gFmpW6E3wbY4JYvuYDYM5vSUwK4y0zwtvDncNcWDvJiKbqgG/2TBsV9xnqRV4I7hmTAyingL1TYATsDvQg+vztZQy3MAetCyLOeF1XV34EWQhFtZgs4ZvIcyvsLUU5qbpQViFlYuwjqalIiLnedIYc4Prun6+f9YQ0R7MVIiQqDf/7dzBwl54UA33hIXwvu/dv8W2bV3oEWTgCESDHozxbwfhJzh61P8Dcl7vRphHGXsAAAAASUVORK5CYII=',
  6: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABwAAAAcCAYAAAByDd+UAAAAAXNSR0IArs4c6QAAASRJREFUSInNlu0NhCAMhothA1yLIZiMHWCtdgbvF6by2XJecm9iovLCU7BIDSjlnLv4MxEZTX+RuYaMJIEPDTNIjBEAAEIIariVQhDxvs85N+/O8xwGzOF2BuIDriSBE5E5aliMERBRBevBEfFeeg4+apj3fhtUy3vfQG/gCla+27fQY+quYBroyNsAc84P887MZgEePeNIku+7GmO5pAWyk0y9Pl1gbdTAVgHanvlbzcYRZembWmbpT4Ez0FtBvLbxpQEts1QykOZPpMrSXrt2qV/d+KJt5Zy7ypVSuiRKKT28s34ppYszHjMMIWxl42hmOeem7rFEZPipzw27p35dYhQRkbHAipy63OAdV/ARBHpFVK9hBi8nuBTC9T+FsBSuLfU/bYEIIPW9qCkAAAAASUVORK5CYII=',
};

const NARDS_MODE_FALLBACK: ModeOption[] = [
  { key: 'chess', label: 'Chess' },
  { key: 'checkers', label: 'Checkers' },
  { key: 'nards', label: 'Backgammon' },
];

const PROMOTION_LABELS: Record<string, string> = {
  queen: 'Queen',
  rook: 'Rook',
  bishop: 'Bishop',
  knight: 'Knight',
};

const boardWrapStyle: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: 'repeat(8, 48px)',
  gridTemplateRows: 'repeat(8, 48px)',
  gap: '0',
  border: '2px solid rgba(255, 255, 255, 0.12)',
  width: '384px',
};

const panelStyle: CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '412px minmax(300px, 1fr)',
  gap: '12px',
  alignItems: 'start',
};

const buttonGroupStyle: CSSProperties = {
  display: 'flex',
  flexWrap: 'wrap',
  gap: '6px',
};

const pieceImageBaseStyle: CSSProperties = {
  imageRendering: 'pixelated',
  pointerEvents: 'none',
  userSelect: 'none',
  backgroundRepeat: 'no-repeat',
  backgroundPosition: 'center bottom',
  backgroundSize: 'contain',
};

const appendTransform = (
  baseTransform: string | undefined,
  extraTransform: string,
) => {
  if (!baseTransform) {
    return extraTransform;
  }
  return `${baseTransform} ${extraTransform}`;
};

const getPieceImageStyle = (
  piece: string | null,
  mode: 'chess' | 'checkers',
  pose?: string | null,
  offsetX = 0,
  offsetY = 0,
  angle = 0,
): CSSProperties => {
  let style: CSSProperties;

  if (!piece) {
    style = {
      ...pieceImageBaseStyle,
      width: '32px',
      height: '32px',
    };
  } else if (mode === 'checkers') {
    if (piece.endsWith('k')) {
      style = {
        ...pieceImageBaseStyle,
        width: '34px',
        height: '34px',
        transform: 'translate(-1px, 3px)',
      };
    } else {
      style = {
        ...pieceImageBaseStyle,
        width: '32px',
        height: '32px',
        transform: 'translate(-1px, 3px)',
      };
    }
  } else if (piece.endsWith('p')) {
    style = {
      ...pieceImageBaseStyle,
      width: '29px',
      height: '29px',
    };
  } else if (piece.endsWith('r')) {
    style = {
      ...pieceImageBaseStyle,
      width: '35px',
      height: '35px',
    };
  } else if (piece.endsWith('n')) {
    style = {
      ...pieceImageBaseStyle,
      width: '39px',
      height: '39px',
      transform: 'translateY(-3px)',
    };
  } else if (piece.endsWith('b')) {
    style = {
      ...pieceImageBaseStyle,
      width: '41px',
      height: '43px',
      transform: 'translateY(-7px)',
    };
  } else if (piece.endsWith('q')) {
    style = {
      ...pieceImageBaseStyle,
      width: '44px',
      height: '46px',
      transform: 'translateY(-8px)',
    };
  } else if (piece.endsWith('k')) {
    style = {
      ...pieceImageBaseStyle,
      width: '44px',
      height: '46px',
      transform: 'translateY(-10px)',
    };
  } else {
    style = {
      ...pieceImageBaseStyle,
      width: '35px',
      height: '35px',
    };
  }

  if (pose === 'fallen_left') {
    style = {
      ...style,
      transform: appendTransform(
        style.transform as string | undefined,
        'rotate(-90deg)',
      ),
      transformOrigin: 'center center',
    };
  } else if (pose === 'fallen_right') {
    style = {
      ...style,
      transform: appendTransform(
        style.transform as string | undefined,
        'rotate(90deg)',
      ),
      transformOrigin: 'center center',
    };
  }

  if (offsetX || offsetY) {
    style = {
      ...style,
      transform: appendTransform(
        style.transform as string | undefined,
        `translate(${offsetX}px, ${offsetY}px)`,
      ),
    };
  }

  if (angle) {
    style = {
      ...style,
      transform: appendTransform(
        style.transform as string | undefined,
        `rotate(${angle}deg)`,
      ),
      transformOrigin: 'center center',
    };
  }

  return style;
};

export const ChessBoard = () => {
  const { act, data } = useBackend<ChessBoardData>();
  const [pendingPromotion, setPendingPromotion] = useState<{
    from: number;
    to: number;
  } | null>(null);
  const [confirmReset, setConfirmReset] = useState(false);
  const [confirmResign, setConfirmResign] = useState(false);
  const [showModePicker, setShowModePicker] = useState(false);
  const [modePickerStep, setModePickerStep] = useState<ModePickerStep>('root');
  const [rollingDiceFaces, setRollingDiceFaces] = useState<
    [number, number] | null
  >(null);
  const [modePickerCheckersFlyingKings, setModePickerCheckersFlyingKings] =
    useState(!!data.checkers_flying_kings);
  const [modePickerNardsLongRules, setModePickerNardsLongRules] = useState(
    !!data.nards_long_rules,
  );

  const board = data.board || [];
  const history = data.history || [];
  const promotionChoices = data.promotion_choices || [];
  const modeOptions = data.mode_options?.length
    ? data.mode_options
    : NARDS_MODE_FALLBACK;
  const nards = data.nards;
  const hasMode = data.game_mode !== 'none';

  const boardByIndex = useMemo(() => {
    const lookup = new Map<number, ChessSquare>();
    for (const square of board) {
      lookup.set(square.index, square);
    }
    return lookup;
  }, [board]);

  const interactive =
    !!data.my_side_key &&
    !data.paused &&
    !data.result_text &&
    data.turn_key === data.my_side_key;

  const nardsInteractive = interactive && data.game_mode === 'nards';

  const imageMap =
    data.game_mode === 'checkers' ? CHECKERS_IMAGES : CHESS_IMAGES;
  const labelMap =
    data.game_mode === 'checkers' ? CHECKERS_LABELS : CHESS_LABELS;

  const isBlackPerspective = data.my_side_key === 'b';
  const displayedBoard = isBlackPerspective ? [...board].reverse() : board;
  const fileLabels = isBlackPerspective
    ? ['h', 'g', 'f', 'e', 'd', 'c', 'b', 'a']
    : ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  const rankLabels = isBlackPerspective
    ? ['1', '2', '3', '4', '5', '6', '7', '8']
    : ['8', '7', '6', '5', '4', '3', '2', '1'];

  const whiteSeatButtonLabel =
    data.white_player_name === 'Available'
      ? 'Join as White'
      : 'Leave White seat';
  const blackSeatButtonLabel =
    data.black_player_name === 'Available'
      ? 'Join as Black'
      : 'Leave Black seat';

  const handleWhiteSeatButton = () => {
    if (data.white_player_name === 'Available') {
      act('claim_side', { color: 'w' });
      return;
    }
    act('release_side', { color: 'w' });
  };

  const handleBlackSeatButton = () => {
    if (data.black_player_name === 'Available') {
      act('claim_side', { color: 'b' });
      return;
    }
    act('release_side', { color: 'b' });
  };

  const pauseResumeLabel = data.paused ? 'Resume' : 'Pause';
  const pauseResumeDisabled =
    !hasMode || (data.paused ? !data.can_resume : false);

  const handlePauseResume = () => {
    if (data.paused) {
      act('resume_game');
      return;
    }
    act('pause_game');
  };

  useEffect(() => {
    if (!data.selected_square) {
      setPendingPromotion(null);
    }
  }, [data.selected_square]);

  useEffect(() => {
    setConfirmReset(false);
  }, [
    data.game_mode,
    data.result_text,
    data.last_message,
    data.reset_pending_text,
  ]);

  useEffect(() => {
    setConfirmResign(false);
  }, [data.can_resign, data.game_mode, data.result_text]);

  useEffect(() => {
    setShowModePicker(false);
    setModePickerStep('root');
  }, [data.game_mode]);

  useEffect(() => {
    setModePickerCheckersFlyingKings(!!data.checkers_flying_kings);
    setModePickerNardsLongRules(!!data.nards_long_rules);
  }, [data.checkers_flying_kings, data.nards_long_rules]);

  useEffect(() => {
    if (!nards?.roll_nonce) {
      return;
    }

    setRollingDiceFaces([
      1 + Math.floor(Math.random() * 6),
      1 + Math.floor(Math.random() * 6),
    ]);

    let ticks = 0;
    const handle = window.setInterval(() => {
      ticks += 1;
      setRollingDiceFaces([
        1 + Math.floor(Math.random() * 6),
        1 + Math.floor(Math.random() * 6),
      ]);
      if (ticks >= 8) {
        window.clearInterval(handle);
        setRollingDiceFaces(null);
      }
    }, 90);

    return () => window.clearInterval(handle);
  }, [nards?.roll_nonce]);

  const requiresPromotion = (fromIndex: number, toIndex: number) => {
    if (data.game_mode !== 'chess') {
      return false;
    }

    const fromSquare = boardByIndex.get(fromIndex);
    const toSquare = boardByIndex.get(toIndex);
    if (!fromSquare || !toSquare || !fromSquare.piece) {
      return false;
    }
    if (!fromSquare.piece.endsWith('p')) {
      return false;
    }
    return (
      (fromSquare.piece.startsWith('w') && toSquare.rank === 8) ||
      (fromSquare.piece.startsWith('b') && toSquare.rank === 1)
    );
  };

  const handleSquareClick = (square: ChessSquare) => {
    if (pendingPromotion || data.game_mode === 'nards') {
      return;
    }

    const selected = data.selected_square;
    const piece = square.piece;
    const ownPiece =
      !!piece && !!data.my_side_key && piece.startsWith(data.my_side_key);

    if (!selected || ownPiece || square.index === selected || !interactive) {
      act('select_square', { square: square.index });
      return;
    }

    if (square.target) {
      if (requiresPromotion(selected, square.index)) {
        setPendingPromotion({ from: selected, to: square.index });
        return;
      }
      act('move_piece', { from: selected, to: square.index });
      return;
    }

    act('select_square', { square: square.index });
  };

  const submitPromotion = (promotion: string) => {
    if (!pendingPromotion) {
      return;
    }
    act('move_piece', {
      from: pendingPromotion.from,
      to: pendingPromotion.to,
      promotion,
    });
    setPendingPromotion(null);
  };

  const resetBoard = () => {
    if (!confirmReset) {
      setConfirmReset(true);
      return;
    }
    act('reset_board');
    setConfirmReset(false);
  };

  const resignGame = () => {
    if (!confirmResign) {
      setConfirmResign(true);
      return;
    }
    act('resign_game');
    setConfirmResign(false);
  };

  const handleNardsPointClick = (point: number) => {
    if (!nardsInteractive || !nards) {
      return;
    }

    if (nards.legal_targets?.includes(point)) {
      act('move_nards_checker', { to_point: point, to_off: 0 });
      return;
    }

    act('select_nards_point', { point });
  };

  const handleNardsBarClick = () => {
    if (!nardsInteractive || !nards?.can_select_bar) {
      return;
    }
    act('select_nards_bar');
  };

  const handleNardsBearOffClick = () => {
    if (!nardsInteractive || !nards?.legal_targets?.includes(0)) {
      return;
    }
    act('move_nards_checker', { to_point: 0, to_off: 1 });
  };

  const requestModeSwitch = (
    mode: 'chess' | 'checkers' | 'nards',
    overrides?: {
      checkersFlyingKings?: boolean;
      nardsLongRules?: boolean;
    },
  ) => {
    const checkersFlyingKings =
      overrides?.checkersFlyingKings ?? modePickerCheckersFlyingKings;
    const nardsLongRules =
      overrides?.nardsLongRules ?? modePickerNardsLongRules;

    act('request_mode_switch', {
      mode,
      checkers_flying_kings: checkersFlyingKings ? 1 : 0,
      nards_long_rules: nardsLongRules ? 1 : 0,
    });
    setShowModePicker(false);
    setModePickerStep('root');
  };

  const openModePicker = () => {
    setModePickerCheckersFlyingKings(!!data.checkers_flying_kings);
    setModePickerNardsLongRules(!!data.nards_long_rules);
    setModePickerStep('root');
    setShowModePicker(true);
  };

  const closeModePicker = () => {
    setShowModePicker(false);
    setModePickerStep('root');
  };

  const isSameModeSelection = (mode: 'chess' | 'checkers' | 'nards') => {
    if (mode !== data.game_mode) {
      return false;
    }
    if (mode === 'checkers') {
      return !!data.checkers_flying_kings === modePickerCheckersFlyingKings;
    }
    if (mode === 'nards') {
      return !!data.nards_long_rules === modePickerNardsLongRules;
    }
    return true;
  };

  const renderModePicker = () => {
    if (!showModePicker) {
      return null;
    }

    const chessLabel =
      modeOptions.find((option) => option.key === 'chess')?.label || 'Chess';
    const checkersLabel =
      modeOptions.find((option) => option.key === 'checkers')?.label ||
      'Checkers';
    const nardsLabel =
      modeOptions.find((option) => option.key === 'nards')?.label ||
      'Backgammon';

    let title = 'Choose a mode';
    let description = 'Select a game mode for this board.';

    if (modePickerStep === 'checkers_rules') {
      title = 'Checkers rules';
      description = 'Choose how kings can move.';
    } else if (modePickerStep === 'nards_rules') {
      title = 'Backgammon rules';
      description = 'Choose long or short backgammon.';
    }

    return (
      <div
        style={{
          position: 'fixed',
          inset: 0,
          backgroundColor: 'rgba(0, 0, 0, 0.45)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          zIndex: 50,
        }}
      >
        <div
          style={{
            minWidth: '340px',
            maxWidth: '420px',
            border: '1px solid rgba(255, 255, 255, 0.16)',
            backgroundColor: '#200607',
            boxShadow: '0 8px 24px rgba(0, 0, 0, 0.5)',
            padding: '14px',
            display: 'grid',
            gap: '10px',
          }}
        >
          <div style={{ fontSize: '18px' }}>{title}</div>
          <div style={{ opacity: 0.85 }}>{description}</div>

          {modePickerStep === 'root' && (
            <>
              <Button
                disabled={isSameModeSelection('chess')}
                onClick={() => requestModeSwitch('chess')}
              >
                {chessLabel}
              </Button>
              <Button onClick={() => setModePickerStep('checkers_rules')}>
                {checkersLabel}
              </Button>
              <Button onClick={() => setModePickerStep('nards_rules')}>
                {nardsLabel}
              </Button>
              <Button onClick={closeModePicker}>Close</Button>
            </>
          )}

          {modePickerStep === 'checkers_rules' && (
            <>
              <Button
                disabled={
                  data.game_mode === 'checkers' && !data.checkers_flying_kings
                }
                onClick={() => {
                  setModePickerCheckersFlyingKings(false);
                  requestModeSwitch('checkers', { checkersFlyingKings: false });
                }}
              >
                Short-range kings
              </Button>
              <Button
                disabled={
                  data.game_mode === 'checkers' && !!data.checkers_flying_kings
                }
                onClick={() => {
                  setModePickerCheckersFlyingKings(true);
                  requestModeSwitch('checkers', { checkersFlyingKings: true });
                }}
              >
                Flying kings
              </Button>
              <Button onClick={() => setModePickerStep('root')}>Back</Button>
            </>
          )}

          {modePickerStep === 'nards_rules' && (
            <>
              <Button
                disabled={data.game_mode === 'nards' && !data.nards_long_rules}
                onClick={() => {
                  setModePickerNardsLongRules(false);
                  requestModeSwitch('nards', { nardsLongRules: false });
                }}
              >
                Short backgammon
              </Button>
              <Button
                disabled={data.game_mode === 'nards' && !!data.nards_long_rules}
                onClick={() => {
                  setModePickerNardsLongRules(true);
                  requestModeSwitch('nards', { nardsLongRules: true });
                }}
              >
                Long backgammon
              </Button>
              <Button onClick={() => setModePickerStep('root')}>Back</Button>
            </>
          )}
        </div>
      </div>
    );
  };

  const renderClassicBoard = () => (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: '16px 384px',
        gap: '4px',
        alignItems: 'start',
      }}
    >
      <div
        style={{
          display: 'grid',
          gridTemplateRows: 'repeat(8, 48px)',
          fontSize: '11px',
          opacity: 0.7,
          marginTop: '2px',
        }}
      >
        {rankLabels.map((rank) => (
          <div
            key={rank}
            style={{
              height: '48px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
            }}
          >
            {rank}
          </div>
        ))}
      </div>

      <div>
        <div style={boardWrapStyle}>
          {displayedBoard.map((square) => {
            const piece = square.piece;
            const pieceImage = piece ? imageMap[piece] : null;
            const pieceLabel = piece ? labelMap[piece] || '' : '';
            const pieceRenderStyle = getPieceImageStyle(
              piece,
              data.game_mode as 'chess' | 'checkers',
              square.pose,
              square.offset_x || 0,
              square.offset_y || 0,
              square.angle || 0,
            );

            let border = '1px solid rgba(0, 0, 0, 0.3)';
            if (square.lastmove) {
              border = '2px solid rgba(105, 180, 255, 0.85)';
            }
            if (square.target) {
              border = '2px solid rgba(90, 210, 120, 0.95)';
            }
            if (square.selected) {
              border = '2px solid rgba(255, 220, 90, 1)';
            }

            return (
              <Button
                key={square.index}
                onClick={() => handleSquareClick(square)}
                style={{
                  width: '48px',
                  minWidth: '48px',
                  height: '48px',
                  margin: 0,
                  padding: 0,
                  borderRadius: 0,
                  border,
                  backgroundColor: square.light ? '#f0d9b5' : '#b58863',
                  color: '#111111',
                  display: 'flex',
                  alignItems: 'flex-end',
                  justifyContent: 'center',
                  paddingBottom: '1px',
                  boxShadow: 'none',
                  overflow: 'visible',
                  position: 'relative',
                }}
              >
                {pieceImage ? (
                  <div
                    style={{
                      ...pieceRenderStyle,
                      backgroundImage: `url(${pieceImage})`,
                      zIndex: 2,
                    }}
                  />
                ) : (
                  pieceLabel || ' '
                )}
              </Button>
            );
          })}
        </div>

        <div
          style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(8, 48px)',
            marginTop: '4px',
            fontSize: '11px',
            opacity: 0.7,
          }}
        >
          {fileLabels.map((file) => (
            <div key={file} style={{ textAlign: 'center' }}>
              {file}
            </div>
          ))}
        </div>
      </div>
    </div>
  );

  const renderNardsBoard = () => {
    const points = nards?.points || [];
    const pointMap = new Map<number, NardsPointData>();
    for (const point of points) {
      pointMap.set(point.point, point);
    }

    const legalTargets = nards?.legal_targets || [];
    const selectedPoint = nards?.selected_point || 0;
    const selectedBar = !!nards?.selected_bar;
    const nardsOverturned =
      !!nards?.overturned ||
      (data.game_mode === 'nards' &&
        !!data.result_text &&
        data.result_text.includes('The board has been flipped'));
    const scatterPieces = nards?.scatter || [];
    const scatterDice = nards?.scatter_dice || [];

    const topPoints = isBlackPerspective
      ? [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
      : [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24];
    const bottomPoints = isBlackPerspective
      ? [24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13]
      : [12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1];

    const getPointX = (idx: number) => {
      if (idx < 6) {
        return 8 + idx * 28;
      }
      return 8 + 6 * 28 + 20 + (idx - 6) * 28;
    };

    const renderPointHotspot = (
      pointNumber: number,
      idx: number,
      isTop: boolean,
    ) => {
      const selected = selectedPoint === pointNumber;
      const target = legalTargets.includes(pointNumber);
      const left = getPointX(idx);
      const top = isTop ? 8 : 240;

      return (
        <div
          key={`hot-${pointNumber}`}
          onClick={() => handleNardsPointClick(pointNumber)}
          style={{
            position: 'absolute',
            left: `${left}px`,
            top: `${top + 4}px`,
            width: '28px',
            height: '144px',
            cursor: nardsInteractive ? 'pointer' : 'default',
            backgroundColor: selected
              ? 'rgba(255, 220, 90, 0.18)'
              : target
                ? 'rgba(90, 210, 120, 0.14)'
                : 'transparent',
            outline: selected
              ? '2px solid rgba(255, 220, 90, 0.95)'
              : target
                ? '2px solid rgba(90, 210, 120, 0.85)'
                : 'none',
            zIndex: 40,
          }}
        />
      );
    };

    const renderPointStack = (
      pointNumber: number,
      idx: number,
      isTop: boolean,
    ) => {
      const point = pointMap.get(pointNumber);
      if (!point?.color || !point?.count) {
        return null;
      }

      const nodes: ReactNode[] = [];
      const visibleCount = Math.min(point.count, 15);
      const checkerSize =
        visibleCount >= 13 ? 24 : visibleCount >= 10 ? 26 : 32;
      const stackSpan = 144 - checkerSize;
      const naturalStep = Math.max(8, checkerSize - 10);
      const naturalHeight =
        checkerSize + naturalStep * Math.max(0, visibleCount - 1);
      const stackStep =
        visibleCount <= 1
          ? 22
          : naturalHeight <= 144
            ? naturalStep
            : Math.max(6, Math.floor(stackSpan / (visibleCount - 1)));
      const pieceLeft = getPointX(idx) + Math.floor((28 - checkerSize) / 2);

      for (let i = 0; i < visibleCount; i++) {
        const top = isTop
          ? 8 + i * stackStep
          : 392 - 8 - checkerSize - i * stackStep;
        nodes.push(
          <div
            key={`${pointNumber}-${i}`}
            style={{
              position: 'absolute',
              left: `${pieceLeft}px`,
              top: `${top}px`,
              width: `${checkerSize}px`,
              height: `${checkerSize}px`,
              backgroundImage: `url(${NARDS_CHECKERS_IMAGES[point.color]})`,
              backgroundSize: 'contain',
              backgroundRepeat: 'no-repeat',
              imageRendering: 'pixelated',
              zIndex: 10 + i,
              pointerEvents: 'none',
            }}
          />,
        );
      }

      if (point.count > 5) {
        const badgeTop = isTop
          ? Math.min(
              8 +
                (visibleCount - 1) * stackStep +
                Math.max(12, checkerSize - 8),
              152,
            )
          : Math.max(
              392 - 8 - checkerSize - (visibleCount - 1) * stackStep - 6,
              226,
            );

        nodes.push(
          <div
            key={`${pointNumber}-count`}
            style={{
              position: 'absolute',
              left: `${getPointX(idx) + 10}px`,
              top: `${badgeTop}px`,
              minWidth: '18px',
              height: '14px',
              padding: '0 4px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '10px',
              fontWeight: 700,
              backgroundColor: 'rgba(0, 0, 0, 0.72)',
              color: '#fff',
              borderRadius: '7px',
              border: '1px solid rgba(255, 255, 255, 0.18)',
              zIndex: 40,
              pointerEvents: 'none',
            }}
          >
            {point.count}
          </div>,
        );
      }

      return nodes;
    };

    const diceFaces = rollingDiceFaces || [
      nards?.die_one || 0,
      nards?.die_two || 0,
    ];
    const diceImageMap = rollingDiceFaces ? NARDS_DICE_ROLL : NARDS_DICE_FLAT;
    const availableRollsText = nards?.available_rolls?.length
      ? nards.available_rolls.join(', ')
      : '—';

    return (
      <div>
        <div
          style={{
            width: '372px',
            height: '392px',
            position: 'relative',
            border: '2px solid rgba(255, 255, 255, 0.12)',
            background: '#d9bf96',
            overflow: 'hidden',
          }}
        >
          <svg
            width="372"
            height="392"
            style={{ position: 'absolute', inset: 0 }}
          >
            <rect x="0" y="0" width="372" height="392" fill="#caa173" />
            <rect
              x="6"
              y="6"
              width="360"
              height="380"
              fill="#ead8bd"
              stroke="#6b4a2d"
              strokeWidth="2"
            />
            <rect x="176" y="6" width="20" height="380" fill="#9f6f43" />
            <rect x="6" y="194" width="360" height="4" fill="#8f6239" />
            {Array.from({ length: 12 }).map((_, idx) => {
              const x = getPointX(idx);
              const color = idx % 2 === 0 ? '#b58863' : '#f0d9b5';
              return (
                <g key={`tri-${idx}`}>
                  <polygon
                    points={`${x},8 ${x + 28},8 ${x + 14},152`}
                    fill={color}
                  />
                  <polygon
                    points={`${x},384 ${x + 28},384 ${x + 14},240`}
                    fill={color}
                  />
                </g>
              );
            })}
          </svg>

          {!nardsOverturned &&
            topPoints.map((pointNumber, idx) =>
              renderPointHotspot(pointNumber, idx, true),
            )}
          {!nardsOverturned &&
            bottomPoints.map((pointNumber, idx) =>
              renderPointHotspot(pointNumber, idx, false),
            )}

          {!nardsOverturned && (
            <div
              onClick={handleNardsBarClick}
              style={{
                position: 'absolute',
                left: '170px',
                top: '8px',
                width: '32px',
                height: '376px',
                cursor:
                  nardsInteractive && nards?.can_select_bar
                    ? 'pointer'
                    : 'default',
                backgroundColor: selectedBar
                  ? 'rgba(255, 220, 90, 0.18)'
                  : 'transparent',
                outline: selectedBar
                  ? '2px solid rgba(255, 220, 90, 0.95)'
                  : 'none',
                zIndex: 6,
              }}
            />
          )}

          {!nardsOverturned &&
            topPoints.map((pointNumber, idx) =>
              renderPointStack(pointNumber, idx, true),
            )}
          {!nardsOverturned &&
            bottomPoints.map((pointNumber, idx) =>
              renderPointStack(pointNumber, idx, false),
            )}

          {nardsOverturned &&
            scatterPieces.map((piece, index) => {
              let transform = `rotate(${piece.angle || 0}deg)`;
              if (piece.pose === 'fallen_left') {
                transform = `rotate(${(piece.angle || 0) - 90}deg)`;
              } else if (piece.pose === 'fallen_right') {
                transform = `rotate(${(piece.angle || 0) + 90}deg)`;
              }

              return (
                <div
                  key={`scatter-${index}`}
                  style={{
                    position: 'absolute',
                    left: `${piece.left}px`,
                    top: `${piece.top}px`,
                    width: '32px',
                    height: '32px',
                    backgroundImage: `url(${NARDS_CHECKERS_IMAGES[piece.color]})`,
                    backgroundSize: 'contain',
                    backgroundRepeat: 'no-repeat',
                    imageRendering: 'pixelated',
                    transform,
                    transformOrigin: 'center center',
                    zIndex: piece.z || 25,
                    pointerEvents: 'none',
                  }}
                />
              );
            })}

          {nardsOverturned &&
            scatterDice.map((die, index) => (
              <div
                key={`scatter-die-${index}`}
                style={{
                  position: 'absolute',
                  left: `${die.left}px`,
                  top: `${die.top}px`,
                  width: '28px',
                  height: '28px',
                  backgroundImage: `url(${NARDS_DICE_FLAT[Math.max(1, Math.min(6, die.face || 1))]})`,
                  backgroundSize: 'contain',
                  backgroundRepeat: 'no-repeat',
                  imageRendering: 'pixelated',
                  transform: `rotate(${die.angle || 0}deg)`,
                  transformOrigin: 'center center',
                  zIndex: die.z || 240,
                  pointerEvents: 'none',
                }}
              />
            ))}

          <div
            style={{
              position: 'absolute',
              left: '170px',
              top: '124px',
              width: '32px',
              height: '140px',
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              textAlign: 'center',
              color: 'rgba(255,255,255,0.92)',
              fontSize: '12px',
              fontWeight: 700,
              lineHeight: 0.95,
              letterSpacing: '0.5px',
              textShadow: '0 1px 1px rgba(0,0,0,0.45)',
              zIndex: 30,
              pointerEvents: 'none',
            }}
          >
            {['B', 'A', 'R'].map((letter, index) => (
              <div key={`tav-${index}`}>{letter}</div>
            ))}
          </div>

          {!nardsOverturned && !!nards?.bar_white && (
            <div
              style={{
                position: 'absolute',
                left: '178px',
                bottom: '10px',
                color: '#fff',
                fontSize: '12px',
                zIndex: 30,
              }}
            >
              W:{nards.bar_white}
            </div>
          )}
          {!nardsOverturned && !!nards?.bar_black && (
            <div
              style={{
                position: 'absolute',
                left: '178px',
                top: '10px',
                color: '#fff',
                fontSize: '12px',
                zIndex: 30,
              }}
            >
              B:{nards.bar_black}
            </div>
          )}
        </div>

        <div
          style={{
            marginTop: '8px',
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            flexWrap: 'wrap',
          }}
        >
          <Button
            disabled={!nards?.can_roll}
            onClick={() => act('roll_nards_dice')}
          >
            Roll dice
          </Button>
          <div style={{ display: 'flex', gap: '6px', alignItems: 'center' }}>
            {diceFaces[0] ? (
              <div
                style={{
                  width: '28px',
                  height: '28px',
                  backgroundImage: `url(${diceImageMap[diceFaces[0]]})`,
                  backgroundSize: 'contain',
                  backgroundRepeat: 'no-repeat',
                  imageRendering: 'pixelated',
                }}
              />
            ) : null}
            {diceFaces[1] ? (
              <div
                style={{
                  width: '28px',
                  height: '28px',
                  backgroundImage: `url(${diceImageMap[diceFaces[1]]})`,
                  backgroundSize: 'contain',
                  backgroundRepeat: 'no-repeat',
                  imageRendering: 'pixelated',
                }}
              />
            ) : null}
          </div>
          <div style={{ fontSize: '12px', opacity: 0.8 }}>
            Available dice: {availableRollsText}
          </div>
          <div style={{ fontSize: '12px', opacity: 0.8 }}>
            White borne off: {nards?.off_white || 0}
          </div>
          <div style={{ fontSize: '12px', opacity: 0.8 }}>
            Black borne off: {nards?.off_black || 0}
          </div>
          <Button
            disabled={!nards?.legal_targets?.includes(0)}
            onClick={handleNardsBearOffClick}
          >
            Bear off
          </Button>
        </div>
      </div>
    );
  };

  return (
    <Window width={920} height={780} title={data.board_title || 'Chessboard'}>
      <Window.Content scrollable>
        <div style={{ position: 'relative' }}>
          {renderModePicker()}
          <div style={panelStyle}>
            <div>
              <Section title="Board">
                <div
                  style={{
                    marginBottom: '8px',
                    fontSize: '13px',
                    opacity: 0.9,
                  }}
                >
                  <div>
                    <b>Mode:</b> {data.game_mode_label}
                  </div>
                  {!!data.current_rules_text && (
                    <div>
                      <b>Rules:</b> {data.current_rules_text}
                    </div>
                  )}
                  <div>
                    <b>White:</b> {data.white_player_name}
                  </div>
                  <div>
                    <b>Black:</b> {data.black_player_name}
                  </div>
                  <div>
                    <b>You:</b> {data.my_side}
                  </div>
                  <div>
                    <b>Turn:</b> {data.turn}
                  </div>
                </div>
                {data.game_mode === 'nards'
                  ? renderNardsBoard()
                  : renderClassicBoard()}
                {!hasMode && (
                  <div
                    style={{ marginTop: '8px', fontSize: '12px', opacity: 0.8 }}
                  >
                    No game mode selected. Use the mode switch button.
                  </div>
                )}
              </Section>
            </div>

            <div>
              <Section title="Status">
                <div style={{ marginBottom: '8px' }}>{data.status_text}</div>
                {!!data.result_text && (
                  <div style={{ marginBottom: '8px', color: '#ff9f9f' }}>
                    <b>{data.result_text}</b>
                  </div>
                )}
                {!!data.last_message && (
                  <div style={{ marginBottom: '8px', color: '#d5efb3' }}>
                    {data.last_message}
                  </div>
                )}
                {!!data.mode_switch_pending_text && (
                  <div style={{ marginBottom: '8px', color: '#ffd985' }}>
                    {data.mode_switch_pending_text}
                  </div>
                )}
                {!!data.reset_pending_text && (
                  <div style={{ marginBottom: '8px', color: '#ffd985' }}>
                    {data.reset_pending_text}
                  </div>
                )}
              </Section>

              <Section title="Seats and controls">
                <div style={buttonGroupStyle}>
                  <Button onClick={handleWhiteSeatButton}>
                    {whiteSeatButtonLabel}
                  </Button>
                  <Button onClick={handleBlackSeatButton}>
                    {blackSeatButtonLabel}
                  </Button>
                </div>

                <div style={{ ...buttonGroupStyle, marginTop: '8px' }}>
                  <Button
                    disabled={pauseResumeDisabled}
                    onClick={handlePauseResume}
                  >
                    {pauseResumeLabel}
                  </Button>
                  {!!data.can_resign && (
                    <Button onClick={resignGame}>
                      {confirmResign ? 'Confirm resignation' : 'Resign'}
                    </Button>
                  )}
                  {confirmResign && (
                    <Button onClick={() => setConfirmResign(false)}>
                      Cancel
                    </Button>
                  )}
                  <Button onClick={resetBoard}>
                    {confirmReset ? 'Confirm reset' : 'Reset board'}
                  </Button>
                  {confirmReset && (
                    <Button onClick={() => setConfirmReset(false)}>
                      Cancel
                    </Button>
                  )}
                  {!!data.can_confirm_reset_request && (
                    <Button onClick={() => act('confirm_reset_board')}>
                      Confirm reset
                    </Button>
                  )}
                  {!!data.can_cancel_reset_request && (
                    <Button onClick={() => act('cancel_reset_board')}>
                      Cancel reset request
                    </Button>
                  )}
                  <Button
                    disabled={!data.can_pack}
                    onClick={() => act('pack_board')}
                  >
                    Pack board
                  </Button>
                  <Button
                    disabled={!data.can_flip_board}
                    onClick={() => act('flip_board')}
                  >
                    Flip board
                  </Button>
                </div>

                <div style={{ ...buttonGroupStyle, marginTop: '8px' }}>
                  <Button onClick={openModePicker}>Change mode</Button>
                  {!!data.can_confirm_mode_switch && (
                    <Button onClick={() => act('confirm_mode_switch')}>
                      Confirm mode change
                    </Button>
                  )}
                  {!!data.can_cancel_mode_switch && (
                    <Button onClick={() => act('cancel_mode_switch')}>
                      Cancel request
                    </Button>
                  )}
                </div>

                <div
                  style={{ marginTop: '8px', fontSize: '12px', opacity: 0.8 }}
                >
                  During an active game, pause before changing players. Changing
                  modes after a game has started requires both players' consent.
                </div>
              </Section>

              {!!pendingPromotion && data.game_mode === 'chess' && (
                <Section title="Pawn promotion">
                  <div style={{ marginBottom: '8px' }}>
                    Choose a piece to promote the pawn to.
                  </div>
                  <div style={buttonGroupStyle}>
                    {promotionChoices.map((choice) => (
                      <Button
                        key={choice}
                        onClick={() => submitPromotion(choice)}
                      >
                        {PROMOTION_LABELS[choice] || choice}
                      </Button>
                    ))}
                    <Button onClick={() => setPendingPromotion(null)}>
                      Cancel
                    </Button>
                  </div>
                </Section>
              )}

              <Section title="Move history">
                {!history.length && <div>No moves have been made yet.</div>}
                {!!history.length && (
                  <table
                    style={{
                      width: '100%',
                      borderCollapse: 'collapse',
                      fontSize: '13px',
                    }}
                  >
                    <thead>
                      <tr>
                        <th style={{ textAlign: 'left', paddingBottom: '4px' }}>
                          #
                        </th>
                        <th style={{ textAlign: 'left', paddingBottom: '4px' }}>
                          White
                        </th>
                        <th style={{ textAlign: 'left', paddingBottom: '4px' }}>
                          Black
                        </th>
                      </tr>
                    </thead>
                    <tbody>
                      {history.map((row) => (
                        <tr key={row.turn}>
                          <td
                            style={{ padding: '2px 0', verticalAlign: 'top' }}
                          >
                            {row.turn}.
                          </td>
                          <td
                            style={{
                              padding: '2px 4px 2px 0',
                              verticalAlign: 'top',
                            }}
                          >
                            {row.white || ''}
                          </td>
                          <td
                            style={{ padding: '2px 0', verticalAlign: 'top' }}
                          >
                            {row.black || ''}
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                )}
              </Section>
            </div>
          </div>
        </div>
      </Window.Content>
    </Window>
  );
};
