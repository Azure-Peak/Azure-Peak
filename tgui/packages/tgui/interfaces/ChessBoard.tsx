import {
  type CSSProperties,
  type ReactNode,
  useEffect,
  useRef,
  useState,
} from 'react';
import { Button } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  badgeStyle,
  cardStyle,
  FONT_SMALL,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  SERIF,
  TITLE,
  TITLE_FONT,
} from './common/parchment';

type Side = 'w' | 'b';
type Mode = 'chess' | 'checkers' | 'nards';

type Seat = {
  name: string | null;
  mine: BooleanLike;
  away: BooleanLike;
};

type GridData = {
  cells: (string | null)[];
  selected: number;
  targets: number[];
  last: [number, number];
  check?: number;
  scatter: ([number, number, number, number] | null)[] | null;
};

type NardsData = {
  points: number[];
  bar: [number, number];
  off: [number, number];
  dice: [number, number];
  nonce: number;
  rolls: number[];
  can_roll: BooleanLike;
  selected: number;
  targets: number[];
  scatter: [Side, number, number, number, number][] | null;
  scatter_dice: [number, number, number, number][] | null;
};

type Data = {
  mode: Mode | null;
  label: string | null;
  rules: string | null;
  variant: BooleanLike;
  seats: [Seat, Seat];
  side: Side | null;
  solo: BooleanLike;
  turn: Side | null;
  live: BooleanLike;
  started: BooleanLike;
  result: string | null;
  status: string;
  message: string | null;
  history: [string, string | null][];
  pending_label: string | null;
  pending_mode: Mode | null;
  pending_variant: BooleanLike;
  mode_name: string | null;
  can_answer_mode: BooleanLike;
  can_cancel_mode: BooleanLike;
  reset_name: string | null;
  reset_left: number;
  can_answer_reset: BooleanLike;
  can_cancel_reset: BooleanLike;
  can_start: BooleanLike;
  can_pause: BooleanLike;
  can_resign: BooleanLike;
  can_pack: BooleanLike;
  can_flip: BooleanLike;
  board: GridData | NardsData | null;
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

const SQUARE = 48;
const LIGHT = '#f0d9b5';
const DARK = '#b58863';
const MARK_LAST = 'rgba(205, 190, 70, 0.5)';
const MARK_PICK = 'rgba(59, 106, 53, 0.55)';
const MARK_MOVE = 'rgba(59, 106, 53, 0.65)';
const MARK_CHECK =
  'radial-gradient(circle, rgba(190, 30, 20, 0.9) 0%, rgba(190, 30, 20, 0.4) 45%, transparent 75%)';

const NARDS_W = 372;
const NARDS_H = 392;

const SIDE_NAME: Record<Side, string> = { w: 'White', b: 'Black' };

/// Width, height and vertical nudge of each chess sprite on its square
const PIECE_SIZE: Record<string, [number, number, number]> = {
  p: [29, 29, 0],
  r: [35, 35, 0],
  n: [39, 39, -3],
  b: [41, 43, -7],
  q: [44, 46, -8],
  k: [44, 46, -10],
};

const PROMOTIONS = ['q', 'r', 'b', 'n'];

const MODES: {
  key: Mode;
  name: string;
  blurb: string;
  variants: string[];
}[] = [
  {
    key: 'chess',
    name: 'Chess',
    blurb: 'The game of kings. Checkmate the enemy king.',
    variants: ['Set up'],
  },
  {
    key: 'checkers',
    name: 'Checkers',
    blurb: 'Jump and capture across the dark squares.',
    variants: ['Short kings', 'Flying kings'],
  },
  {
    key: 'nards',
    name: 'Backgammon',
    blurb: 'Race your checkers home by the roll of the dice.',
    variants: ['Short rules', 'Long rules'],
  },
];

const range = (from: number, to: number) => {
  const step = from <= to ? 1 : -1;
  const out: number[] = [];
  for (let i = from; i !== to + step; i += step) {
    out.push(i);
  }
  return out;
};

const sprite = (url: string, style: CSSProperties): CSSProperties => ({
  position: 'absolute',
  backgroundImage: `url(${url})`,
  backgroundRepeat: 'no-repeat',
  backgroundSize: 'contain',
  backgroundPosition: 'center bottom',
  imageRendering: 'pixelated',
  pointerEvents: 'none',
  ...style,
});

const fill: CSSProperties = {
  position: 'absolute',
  inset: 0,
  pointerEvents: 'none',
};

const frameStyle: CSSProperties = {
  position: 'relative',
  alignSelf: 'center',
  padding: '20px',
  background: 'linear-gradient(135deg, #5d3b20 0%, #4a2e18 55%, #3a2312 100%)',
  borderRadius: '4px',
  boxShadow:
    '0 3px 10px rgba(40, 20, 5, 0.45), inset 0 0 0 1px rgba(255, 220, 160, 0.15)',
};

const coordStyle: CSSProperties = {
  position: 'absolute',
  color: '#e6cfa3',
  fontSize: '11px',
  textAlign: 'center',
  userSelect: 'none',
};

const capsStyle: CSSProperties = {
  fontSize: FONT_SMALL,
  color: INK_FAINT,
  letterSpacing: '1px',
  textTransform: 'uppercase',
};

const panelCard: CSSProperties = { ...cardStyle, marginBottom: 0 };

const requestCard: CSSProperties = {
  ...panelCard,
  background: 'rgba(196, 140, 40, 0.18)',
  borderColor: SEAL_AMBER,
};

const rowStyle: CSSProperties = {
  display: 'flex',
  flexWrap: 'wrap',
  gap: '4px',
  marginTop: '6px',
};

export const ChessBoard = () => {
  const { data } = useBackend<Data>();
  const [picker, setPicker] = useState(false);
  const flip = data.side === 'b' && !data.solo;
  const myTurn = !!data.live && !!data.side && data.side === data.turn;

  useEffect(() => setPicker(false), [data.mode, data.variant]);

  return (
    <Window width={800} height={650} title="Chessboard" theme="parchment">
      <Window.Content scrollable>
        <div
          style={{
            display: 'flex',
            gap: '14px',
            padding: '12px 14px',
            height: '100%',
            boxSizing: 'border-box',
            fontFamily: SERIF,
            color: INK,
          }}
        >
          <div
            style={{
              width: '424px',
              flexShrink: 0,
              display: 'flex',
              flexDirection: 'column',
              gap: '8px',
            }}
          >
            <SeatBar side={flip ? 'w' : 'b'} />
            {data.mode === 'nards' ? (
              <NardsBoard flip={flip} myTurn={myTurn} />
            ) : (
              <GridBoard flip={flip} myTurn={myTurn} />
            )}
            <SeatBar side={flip ? 'b' : 'w'} />
          </div>
          <SidePanel myTurn={myTurn} openPicker={() => setPicker(true)} />
        </div>
        {(picker || !data.mode) && (
          <ModePicker
            onClose={data.mode ? () => setPicker(false) : undefined}
          />
        )}
      </Window.Content>
    </Window>
  );
};

const SeatBar = (props: { side: Side }) => {
  const { act, data } = useBackend<Data>();
  const { side } = props;
  const seat = data.seats[side === 'w' ? 0 : 1];
  const active = !!data.live && data.turn === side;
  const nards = data.mode === 'nards' ? (data.board as NardsData) : null;

  let button: ReactNode = null;
  if (!seat.name) {
    button = (
      <Button icon="chair" onClick={() => act('sit', { side })}>
        Sit
      </Button>
    );
  } else if (seat.mine) {
    button = (
      <Button icon="sign-out-alt" onClick={() => act('stand', { side })}>
        Get up
      </Button>
    );
  } else if (seat.away) {
    button = (
      <Button
        icon="user-slash"
        tooltip="They have walked away from the board."
        onClick={() => act('stand', { side })}
      >
        Clear seat
      </Button>
    );
  }

  return (
    <div
      style={{
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        height: '38px',
        padding: '0 6px 0 8px',
        background: active ? 'rgba(196, 140, 40, 0.22)' : 'var(--p-card-bg)',
        border: `1px solid ${active ? SEAL_AMBER : INK_FAINT}`,
        borderLeft: `4px solid ${active ? SEAL_AMBER : INK_FAINT}`,
        borderRadius: '2px',
      }}
    >
      <span
        style={{
          width: '14px',
          height: '14px',
          flexShrink: 0,
          borderRadius: '50%',
          background: side === 'w' ? '#f6ecd4' : '#2b1d10',
          border: `1px solid ${INK}`,
        }}
      />
      <div style={{ flex: 1, minWidth: 0, lineHeight: 1.2 }}>
        <div
          style={{
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
            fontWeight: seat.name ? 'bold' : 'normal',
            fontStyle: seat.name ? 'normal' : 'italic',
            color: seat.name ? INK : INK_FAINT,
          }}
        >
          {seat.name || 'Empty seat'}
          {!!seat.mine && <span style={badgeStyle(SEAL_GREEN)}>You</span>}
          {!!seat.away && !seat.mine && (
            <span style={badgeStyle(INK_FAINT)}>Away</span>
          )}
        </div>
        <div style={{ fontSize: FONT_SMALL, color: INK_SOFT }}>
          {SIDE_NAME[side]}
          {active && ' · to move'}
          {nards && ` · ${nards.off[side === 'w' ? 0 : 1]}/15 borne off`}
        </div>
      </div>
      {button}
    </div>
  );
};

const GridBoard = (props: { flip: boolean; myTurn: boolean }) => {
  const { act, data } = useBackend<Data>();
  const { flip, myTurn } = props;
  const grid = data.board as GridData | null;
  const selected = grid?.selected || 0;
  const [promo, setPromo] = useState(0);

  useEffect(() => setPromo(0), [selected]);

  const cells = grid?.cells || [];
  const targets = grid?.targets || [];
  const scatter = grid?.scatter;
  const checkers = data.mode === 'checkers';
  const images = checkers ? CHECKERS_IMAGES : CHESS_IMAGES;
  const ranks = flip ? range(1, 8) : range(8, 1);
  const files = flip ? range(8, 1) : range(1, 8);

  const click = (idx: number) => {
    if (!myTurn) {
      return;
    }
    const rank = Math.ceil(idx / 8);
    if (
      data.mode === 'chess' &&
      targets.includes(idx) &&
      cells[selected - 1]?.[1] === 'p' &&
      (rank === 1 || rank === 8)
    ) {
      setPromo(idx);
      return;
    }
    act('square', { square: idx });
  };

  const renderPiece = (idx: number, piece: string) => {
    let [w, h, dy] = PIECE_SIZE[piece[1]] || [35, 35, 0];
    let dx = 0;
    if (checkers) {
      w = h = piece[1] === 'k' ? 34 : 32;
      dx = -1;
      dy = 3;
    }
    let transform = `translate(${dx}px, ${dy}px)`;
    const fall = scatter?.[idx - 1];
    if (fall) {
      transform += ` translate(${fall[1]}px, ${fall[2]}px) rotate(${fall[0] + fall[3]}deg)`;
    }
    return (
      <div
        style={sprite(images[piece], {
          width: `${w}px`,
          height: `${h}px`,
          left: `${(SQUARE - w) / 2}px`,
          bottom: '1px',
          transform,
          zIndex: 2,
        })}
      />
    );
  };

  const renderSquare = (idx: number, light: boolean) => {
    const piece = cells[idx - 1];
    const target = targets.includes(idx);
    const own = !!piece && piece[0] === data.side;
    const last = !scatter && (grid?.last[0] === idx || grid?.last[1] === idx);
    return (
      <div
        key={idx}
        onClick={() => click(idx)}
        style={{
          position: 'relative',
          width: `${SQUARE}px`,
          height: `${SQUARE}px`,
          background: light ? LIGHT : DARK,
          cursor: myTurn && (own || target) ? 'pointer' : 'default',
        }}
      >
        {last && <div style={{ ...fill, background: MARK_LAST }} />}
        {idx === selected && <div style={{ ...fill, background: MARK_PICK }} />}
        {idx === grid?.check && (
          <div style={{ ...fill, background: MARK_CHECK }} />
        )}
        {!!piece && renderPiece(idx, piece)}
        {target && (
          <div
            style={{
              ...fill,
              zIndex: 3,
              background: piece
                ? `radial-gradient(circle, transparent 62%, ${MARK_MOVE} 64%)`
                : `radial-gradient(circle, ${MARK_MOVE} 18%, transparent 20%)`,
            }}
          />
        )}
      </div>
    );
  };

  return (
    <div style={frameStyle}>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: `repeat(8, ${SQUARE}px)`,
          boxShadow: '0 0 0 2px #2c1a0c',
        }}
      >
        {ranks.map((rank) =>
          files.map((file) =>
            renderSquare((rank - 1) * 8 + file, (file + rank) % 2 === 1),
          ),
        )}
      </div>
      {files.map((file, i) => (
        <div
          key={`f${file}`}
          style={{
            ...coordStyle,
            left: `${20 + i * SQUARE}px`,
            bottom: '3px',
            width: `${SQUARE}px`,
          }}
        >
          {'abcdefgh'[file - 1]}
        </div>
      ))}
      {ranks.map((rank, i) => (
        <div
          key={`r${rank}`}
          style={{
            ...coordStyle,
            top: `${20 + i * SQUARE}px`,
            left: 0,
            width: '20px',
            lineHeight: `${SQUARE}px`,
          }}
        >
          {rank}
        </div>
      ))}
      {!!promo && (
        <div
          style={{
            position: 'absolute',
            inset: 0,
            zIndex: 10,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            background: 'rgba(30, 18, 6, 0.55)',
            borderRadius: '4px',
          }}
        >
          <div
            style={{
              ...panelCard,
              background: 'var(--p-bg)',
              textAlign: 'center',
            }}
          >
            <div style={{ fontWeight: 'bold', marginBottom: '6px' }}>
              Promote the pawn
            </div>
            <div style={{ display: 'flex', gap: '6px' }}>
              {PROMOTIONS.map((kind) => {
                const [w, h] = PIECE_SIZE[kind];
                return (
                  <div
                    key={kind}
                    onClick={() => {
                      act('square', { square: promo, promote: kind });
                      setPromo(0);
                    }}
                    style={{
                      position: 'relative',
                      width: '52px',
                      height: '58px',
                      cursor: 'pointer',
                      background: LIGHT,
                      border: `1px solid ${INK_FAINT}`,
                      borderRadius: '2px',
                    }}
                  >
                    <div
                      style={sprite(CHESS_IMAGES[`${data.side}${kind}`], {
                        width: `${w}px`,
                        height: `${h}px`,
                        left: `${(52 - w) / 2}px`,
                        bottom: '4px',
                      })}
                    />
                  </div>
                );
              })}
            </div>
            <Button mt={1} icon="times" onClick={() => setPromo(0)}>
              Cancel
            </Button>
          </div>
        </div>
      )}
    </div>
  );
};

const pointX = (i: number) => (i < 6 ? 8 + i * 28 : 196 + (i - 6) * 28);

const NardsBoard = (props: { flip: boolean; myTurn: boolean }) => {
  const { act, data } = useBackend<Data>();
  const { flip, myTurn } = props;
  const nards = data.board as NardsData | null;
  const [rolling, setRolling] = useState<[number, number] | null>(null);
  const seenNonce = useRef(nards?.nonce);

  useEffect(() => {
    const nonce = nards?.nonce;
    if (!nonce || nonce === seenNonce.current) {
      seenNonce.current = nonce;
      return;
    }
    seenNonce.current = nonce;
    const face = () => 1 + Math.floor(Math.random() * 6);
    let ticks = 0;
    setRolling([face(), face()]);
    const handle = window.setInterval(() => {
      ticks += 1;
      if (ticks >= 8) {
        window.clearInterval(handle);
        setRolling(null);
        return;
      }
      setRolling([face(), face()]);
    }, 90);
    return () => window.clearInterval(handle);
  }, [nards?.nonce]);

  if (!nards) {
    return null;
  }

  const flipped = !!nards.scatter;
  const topRow = flip ? range(1, 12) : range(13, 24);
  const bottomRow = flip ? range(24, 13) : range(12, 1);
  const faces = rolling || nards.dice;
  const diceImages = rolling ? NARDS_DICE_ROLL : NARDS_DICE_FLAT;

  const renderStack = (point: number, i: number, top: boolean) => {
    const value = nards.points[point - 1];
    const count = Math.abs(value);
    if (!count) {
      return null;
    }
    const url = NARDS_CHECKERS_IMAGES[value > 0 ? 'w' : 'b'];
    const shown = Math.min(count, 15);
    const size = shown >= 13 ? 24 : shown >= 10 ? 26 : 32;
    const natural = Math.max(8, size - 10);
    const step =
      shown <= 1
        ? 0
        : size + natural * (shown - 1) <= 144
          ? natural
          : Math.max(6, Math.floor((144 - size) / (shown - 1)));
    const left = pointX(i) + Math.floor((28 - size) / 2);
    const y = (n: number) =>
      top ? 8 + n * step : NARDS_H - 8 - size - n * step;
    const nodes: ReactNode[] = [];
    for (let n = 0; n < shown; n++) {
      nodes.push(
        <div
          key={`${point}-${n}`}
          style={sprite(url, {
            left: `${left}px`,
            top: `${y(n)}px`,
            width: `${size}px`,
            height: `${size}px`,
            zIndex: 10 + n,
          })}
        />,
      );
    }
    if (count > 5) {
      nodes.push(
        <div
          key={`${point}-count`}
          style={{
            position: 'absolute',
            left: `${pointX(i) + 4}px`,
            top: `${y(shown - 1) + size / 2 - 7}px`,
            width: '20px',
            height: '14px',
            lineHeight: '14px',
            textAlign: 'center',
            fontSize: '10px',
            fontWeight: 'bold',
            color: '#fff',
            background: 'rgba(0, 0, 0, 0.7)',
            borderRadius: '7px',
            zIndex: 30,
            pointerEvents: 'none',
          }}
        >
          {count}
        </div>,
      );
    }
    return nodes;
  };

  const mark = (on: boolean, picked: boolean): CSSProperties => {
    if (picked) {
      return {
        background: 'rgba(196, 140, 40, 0.22)',
        outline: '2px solid rgba(196, 140, 40, 0.95)',
      };
    }
    if (on) {
      return {
        background: 'rgba(59, 106, 53, 0.2)',
        outline: '2px solid rgba(59, 106, 53, 0.9)',
      };
    }
    return {};
  };

  const renderHotspot = (point: number, i: number, top: boolean) => (
    <div
      key={`hot-${point}`}
      onClick={() => myTurn && act('point', { point })}
      style={{
        position: 'absolute',
        left: `${pointX(i)}px`,
        top: top ? '8px' : '240px',
        width: '28px',
        height: '144px',
        cursor: myTurn ? 'pointer' : 'default',
        zIndex: 40,
        ...mark(nards.targets.includes(point), nards.selected === point),
      }}
    />
  );

  const renderBarStack = (side: Side, upper: boolean) => {
    const count = nards.bar[side === 'w' ? 0 : 1];
    if (!count || flipped) {
      return null;
    }
    const top = upper ? 120 : 248;
    return (
      <>
        <div
          style={sprite(NARDS_CHECKERS_IMAGES[side], {
            left: '174px',
            top: `${top}px`,
            width: '24px',
            height: '24px',
            zIndex: 20,
          })}
        />
        {count > 1 && (
          <div
            style={{
              ...coordStyle,
              left: '172px',
              top: `${top + 26}px`,
              width: '28px',
              fontWeight: 'bold',
              zIndex: 20,
            }}
          >
            ×{count}
          </div>
        )}
      </>
    );
  };

  return (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
      <div style={frameStyle}>
        <div
          style={{
            position: 'relative',
            width: `${NARDS_W}px`,
            height: `${NARDS_H}px`,
            overflow: 'hidden',
            boxShadow: '0 0 0 2px #2c1a0c',
          }}
        >
          <svg
            width={NARDS_W}
            height={NARDS_H}
            style={{ position: 'absolute', inset: 0 }}
          >
            <rect width={NARDS_W} height={NARDS_H} fill="#caa173" />
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
            {range(0, 11).map((i) => {
              const x = pointX(i);
              const colour = i % 2 ? LIGHT : DARK;
              return (
                <g key={i}>
                  <polygon
                    points={`${x},8 ${x + 28},8 ${x + 14},152`}
                    fill={colour}
                  />
                  <polygon
                    points={`${x},384 ${x + 28},384 ${x + 14},240`}
                    fill={colour}
                  />
                </g>
              );
            })}
          </svg>
          {!flipped && (
            <>
              {topRow.map((point, i) => renderStack(point, i, true))}
              {bottomRow.map((point, i) => renderStack(point, i, false))}
              {topRow.map((point, i) => renderHotspot(point, i, true))}
              {bottomRow.map((point, i) => renderHotspot(point, i, false))}
              <div
                onClick={() => myTurn && act('point', { point: 25 })}
                style={{
                  position: 'absolute',
                  left: '170px',
                  top: '8px',
                  width: '32px',
                  height: '376px',
                  cursor: myTurn ? 'pointer' : 'default',
                  zIndex: 25,
                  ...mark(false, nards.selected === 25),
                }}
              />
            </>
          )}
          {renderBarStack(flip ? 'w' : 'b', true)}
          {renderBarStack(flip ? 'b' : 'w', false)}
          {(nards.scatter || []).map(([side, tilt, left, top, angle], i) => (
            <div
              key={`s${i}`}
              style={sprite(NARDS_CHECKERS_IMAGES[side], {
                left: `${left}px`,
                top: `${top}px`,
                width: '32px',
                height: '32px',
                transform: `rotate(${tilt + angle}deg)`,
                zIndex: 10 + i,
              })}
            />
          ))}
          {(nards.scatter_dice || []).map(([face, left, top, angle], i) => (
            <div
              key={`d${i}`}
              style={sprite(NARDS_DICE_FLAT[face], {
                left: `${left}px`,
                top: `${top}px`,
                width: '28px',
                height: '28px',
                transform: `rotate(${angle}deg)`,
                zIndex: 100 + i,
              })}
            />
          ))}
        </div>
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
        <Button
          icon="dice"
          disabled={!nards.can_roll}
          onClick={() => act('roll')}
        >
          Roll
        </Button>
        {faces.map((face, i) =>
          face ? (
            <div
              key={i}
              style={{ position: 'relative', width: '28px', height: '28px' }}
            >
              <div
                style={sprite(diceImages[face], {
                  inset: 0,
                })}
              />
            </div>
          ) : null,
        )}
        <div style={{ flex: 1, fontSize: FONT_SMALL, color: INK_SOFT }}>
          {nards.rolls.length > 0 && `Left to play: ${nards.rolls.join(', ')}`}
        </div>
        <Button
          icon="sign-out-alt"
          disabled={!myTurn || !nards.targets.includes(0)}
          onClick={() => act('point', { point: 0 })}
        >
          Bear off
        </Button>
      </div>
    </div>
  );
};

const SidePanel = (props: { myTurn: boolean; openPicker: () => void }) => {
  const { act, data } = useBackend<Data>();
  const { myTurn, openPicker } = props;
  const log = useRef<HTMLDivElement>(null);
  const history = data.history || [];

  useEffect(() => {
    log.current?.scrollTo(0, log.current.scrollHeight);
  }, [history.length]);

  let tone = INK_SOFT;
  if (data.result || data.status.includes('Check')) {
    tone = SEAL_RED;
  } else if (myTurn) {
    tone = SEAL_GREEN;
  }

  let startHint: string | undefined;
  if (!data.can_start) {
    startHint = data.side
      ? 'Both seats must be filled.'
      : 'Sit down to start the game.';
  }

  return (
    <div
      style={{
        flex: 1,
        minWidth: 0,
        display: 'flex',
        flexDirection: 'column',
        gap: '8px',
      }}
    >
      <div style={panelCard}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={capsStyle}>Game</div>
            <div
              style={{ fontFamily: TITLE_FONT, color: TITLE, fontSize: '18px' }}
            >
              {data.label || 'None chosen'}
            </div>
          </div>
          <Button icon="chess-board" onClick={openPicker}>
            Change
          </Button>
        </div>
        {!!data.rules && (
          <div
            style={{
              fontSize: FONT_SMALL,
              color: INK_SOFT,
              fontStyle: 'italic',
              marginTop: '2px',
            }}
          >
            {data.rules}
          </div>
        )}
      </div>

      <div style={{ ...panelCard, borderLeft: `4px solid ${tone}` }}>
        <div style={{ fontWeight: 'bold', fontSize: FONT_TITLE, color: tone }}>
          {data.status}
        </div>
        {!!data.message && data.message !== data.status && (
          <div
            style={{
              fontSize: FONT_SMALL,
              color: INK_SOFT,
              fontStyle: 'italic',
              marginTop: '2px',
            }}
          >
            {data.message}
          </div>
        )}
        {!!data.mode && !data.result && (
          <div style={rowStyle}>
            {!data.live && (
              <Button
                icon="play"
                disabled={!data.can_start}
                tooltip={startHint}
                onClick={() => act('start')}
              >
                {data.started ? 'Resume' : 'Start game'}
              </Button>
            )}
            {!!data.can_pause && (
              <Button icon="pause" onClick={() => act('pause')}>
                Pause
              </Button>
            )}
            {!!data.can_resign && (
              <Button.Confirm
                icon="flag"
                confirmContent="Really resign?"
                onClick={() => act('resign')}
              >
                Resign
              </Button.Confirm>
            )}
          </div>
        )}
      </div>

      {!!data.pending_label && (
        <div style={requestCard}>
          <div>
            <b>{data.mode_name}</b> proposes switching to{' '}
            <b>{data.pending_label}</b>.
          </div>
          <div style={rowStyle}>
            {!!data.can_answer_mode && (
              <Button
                icon="check"
                onClick={() =>
                  act('mode', {
                    mode: data.pending_mode,
                    variant: data.pending_variant ? 1 : 0,
                  })
                }
              >
                Agree
              </Button>
            )}
            {!!data.can_cancel_mode && (
              <Button icon="times" onClick={() => act('cancel_mode')}>
                {data.can_answer_mode ? 'Decline' : 'Withdraw'}
              </Button>
            )}
          </div>
        </div>
      )}

      {!!data.reset_name && (
        <div style={requestCard}>
          <div>
            <b>{data.reset_name}</b>
            {data.reset_left
              ? ` will reset the board and clear the seats in ${data.reset_left}s.`
              : ' asks to reset the board.'}
          </div>
          <div style={rowStyle}>
            {!!data.can_answer_reset && (
              <Button icon="check" onClick={() => act('reset')}>
                Agree
              </Button>
            )}
            {!!data.can_cancel_reset && (
              <Button icon="times" onClick={() => act('cancel_reset')}>
                {data.can_answer_reset ? 'Decline' : 'Cancel'}
              </Button>
            )}
          </div>
        </div>
      )}

      <div
        style={{
          ...panelCard,
          flex: 1,
          minHeight: '80px',
          padding: 0,
          display: 'flex',
          flexDirection: 'column',
        }}
      >
        <div
          style={{
            ...capsStyle,
            padding: '5px 10px',
            borderBottom: `1px solid ${INK_FAINT}`,
          }}
        >
          Moves
        </div>
        <div ref={log} style={{ flex: 1, overflowY: 'auto', padding: '2px 0' }}>
          {history.length ? (
            history.map(([white, black], i) => (
              <div
                key={i}
                style={{
                  display: 'grid',
                  gridTemplateColumns: '30px 1fr 1fr',
                  gap: '4px',
                  padding: '1px 10px',
                  fontSize: FONT_SMALL,
                  background: i % 2 ? 'transparent' : 'rgba(122, 86, 22, 0.08)',
                }}
              >
                <span style={{ color: INK_FAINT }}>{i + 1}.</span>
                <span>{white}</span>
                <span>{black}</span>
              </div>
            ))
          ) : (
            <div
              style={{
                padding: '6px 10px',
                color: INK_FAINT,
                fontStyle: 'italic',
                fontSize: FONT_SMALL,
              }}
            >
              No moves yet.
            </div>
          )}
        </div>
      </div>

      <div style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
        <Button.Confirm
          icon="undo"
          disabled={!data.mode}
          confirmContent="Reset the board?"
          tooltip="Set the pieces back up. Mid-match, the other player must agree."
          onClick={() => act('reset')}
        >
          Reset
        </Button.Confirm>
        <Button.Confirm
          icon="random"
          disabled={!data.can_flip}
          confirmContent="Flip it?"
          onClick={() => act('flip')}
        >
          Flip board
        </Button.Confirm>
        <Button
          icon="box"
          disabled={!data.can_pack}
          tooltip={
            data.can_pack ? undefined : 'Finish or reset the game first.'
          }
          onClick={() => act('pack')}
        >
          Pack up
        </Button>
      </div>
    </div>
  );
};

const ModePicker = (props: { onClose?: () => void }) => {
  const { act, data } = useBackend<Data>();
  const { onClose } = props;
  const midgame = data.history.length > 0 && !data.result;

  return (
    <div
      style={{
        position: 'fixed',
        inset: 0,
        zIndex: 50,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        background: 'rgba(40, 24, 8, 0.55)',
        fontFamily: SERIF,
        color: INK,
      }}
    >
      <div
        style={{
          ...panelCard,
          width: '430px',
          padding: '14px 18px',
          background: 'var(--p-bg)',
          boxShadow: '0 8px 28px rgba(30, 15, 0, 0.55)',
        }}
      >
        <div
          style={{
            fontFamily: TITLE_FONT,
            color: TITLE,
            fontSize: '20px',
            textAlign: 'center',
          }}
        >
          Set up the board
        </div>
        <div
          style={{
            textAlign: 'center',
            color: INK_SOFT,
            fontStyle: 'italic',
            fontSize: FONT_SMALL,
            marginBottom: '8px',
          }}
        >
          {midgame
            ? 'A match is under way, so your opponent must agree to a change.'
            : 'Pick a game to lay out.'}
        </div>
        {MODES.map((mode) => (
          <div
            key={mode.key}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '10px',
              padding: '8px 0',
              borderTop: `1px dashed ${INK_FAINT}`,
            }}
          >
            <div style={{ flex: 1 }}>
              <div style={{ fontWeight: 'bold' }}>{mode.name}</div>
              <div style={{ fontSize: FONT_SMALL, color: INK_SOFT }}>
                {mode.blurb}
              </div>
            </div>
            <div
              style={{ display: 'flex', flexDirection: 'column', gap: '2px' }}
            >
              {mode.variants.map((label, variant) => {
                const current =
                  data.mode === mode.key && !!data.variant === !!variant;
                return (
                  <Button
                    key={label}
                    fluid
                    selected={current}
                    disabled={current}
                    onClick={() => {
                      act('mode', { mode: mode.key, variant });
                      onClose?.();
                    }}
                  >
                    {label}
                  </Button>
                );
              })}
            </div>
          </div>
        ))}
        {!!onClose && (
          <div style={{ textAlign: 'center', marginTop: '6px' }}>
            <Button icon="times" onClick={onClose}>
              Close
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};
