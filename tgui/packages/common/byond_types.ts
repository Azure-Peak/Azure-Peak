//! This file has a bunch of BYOND's types mapped out in TypeScript form
//! Such as color matricies, filter info, etc.

/**
 * https://www.byond.com/docs/ref/#/atom/var/blend_mode
 */
export enum BlendMode {
  BLEND_DEFAULT = 0,
  BLEND_OVERLAY = 1,
  BLEND_ADD = 2,
  BLEND_SUBTRACT = 3,
  BLEND_MULTIPLY = 4,
  BLEND_INSET_OVERLAY = 5,
}

/**
 * Value of list(rgb(), rgb(), rgb()), etc
 */
export type ColorMatrixRow =
  | [string, string, string]
  | [string, string, string, string]
  | [string, string, string, string, string];

/**
 * https://www.byond.com/docs/ref/#/{notes}/color-matrix
 */
// biome-ignore format: keep the color matrix type readable
export type ColorMatrix =
  // RGB-only: 9 required values, with up to 3 constant-column values
  | [
      rr: number, rg: number, rb: number,
      gr: number, gg: number, gb: number,
      br: number, bg: number, bb: number,
      cr?: number, cg?: number, cb?: number,
    ]

  // RGBA: 16 required values, with up to 4 constant-column values
  | [
      rr: number, rg: number, rb: number, ra: number,
      gr: number, gg: number, gb: number, ga: number,
      br: number, bg: number, bb: number, ba: number,
      ar: number, ag: number, ab: number, aa: number,
      cr?: number, cg?: number, cb?: number, ca?: number,
    ]

  // Row-by-row representation
  | [
      red: ColorMatrixRow | null,
      green: ColorMatrixRow | null,
      blue: ColorMatrixRow | null,
      alpha?: ColorMatrixRow | null,
      constant?: ColorMatrixRow | null,
    ];

export enum ColorSpace {
  COLORSPACE_RGB = 0,
  COLORSPACE_HSV = 1,
  COLORSPACE_HSL = 2,
  COLORSPACE_HCY = 3,
}

export enum AlphaFlags {
  None = 0,
  MaskInverse = 1 << 0,
  MaskSwap = 1 << 1,
}

export enum DisplaceFlags {
  None = 0,
  FilterOverlay = 1 << 0,
}

export enum LayerFlags {
  None = 0,
  FilterOverlay = 1 << 0,
  FilterUnderlay = 1 << 1,
}

export enum OutlineFlags {
  None = 0,
  OutlineSharp = 1 << 0,
  OutlineSquare = 1 << 1,
}

export enum RaysFlags {
  None = 0,
  FilterOverlay = 1 << 0,
  FilterUnderlay = 1 << 1,
}

export enum RippleFlags {
  None = 0,
  WaveBounded = 1 << 1,
}

export enum WaveFlags {
  None = 0,
  WaveSideways = 1 << 0,
  WaveBounded = 1 << 1,
}

/**
 * Custom data we add to our filters
 */
export type FilterMetadata = {
  name: string;
  priority: number;
};

/**
 * All filter arguments and types as of BYOND 516.1688.
 *
 * https://www.byond.com/docs/ref/#/{notes}/filters
 */
export type FilterInfo = FilterMetadata &
  // https://www.byond.com/docs/ref/#/{notes}/filters/alpha
  (
    | {
        type: 'alpha';
        x?: number;
        y?: number;
        icon?: string;
        render_source?: string;
        flags?: AlphaFlags;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/angular_blur
    | {
        type: 'angular_blur';
        x?: number;
        y?: number;
        size?: number;
        offset?: number;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/bloom
    | {
        type: 'bloom';
        threshold?: string;
        size?: number;
        offset?: number;
        alpha?: number;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/blur
    | {
        type: 'blur';
        size?: number;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/color
    | {
        type: 'color';
        color?: ColorMatrix;
        space?: ColorSpace;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/displace
    | {
        type: 'displace';
        x?: number;
        y?: number;
        size?: number | null;
        icon?: string;
        render_source?: string;
        flags?: DisplaceFlags;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/drop_shadow
    | {
        type: 'drop_shadow';
        x?: number;
        y?: number;
        size?: number;
        offset?: number;
        color?: string;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/layer
    | {
        type: 'layer';
        x?: number;
        y?: number;
        icon?: string;
        render_source?: string;
        flags?: LayerFlags;
        color?: string | ColorMatrix;
        transform?: TransformMatrix | null;
        blend_mode?: BlendMode;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/motion_blur
    | {
        type: 'motion_blur';
        x?: number;
        y?: number;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/outline
    | {
        type: 'outline';
        size?: number;
        color?: string;
        flags?: OutlineFlags;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/radial_blur
    | {
        type: 'radial_blur';
        x?: number;
        y?: number;
        size?: number;
        offset?: number;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/rays
    | {
        type: 'rays';
        x?: number;
        y?: number;
        size?: number;
        color?: string;
        offset?: number;
        density?: number;
        threshold?: number;
        factor?: number;
        flags?: RaysFlags;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/ripple
    | {
        type: 'ripple';
        x?: number;
        y?: number;
        size?: number;
        repeat?: number;
        radius?: number;
        falloff?: number;
        flags?: RippleFlags;
      }
    // https://www.byond.com/docs/ref/#/{notes}/filters/wave
    | {
        type: 'wave';
        x?: number;
        y?: number;
        size?: number;
        offset?: number;
        flags?: WaveFlags;
      }
  );

// Derived types for GLOB.master_filter_info to ensure it's correct
export type FilterType = FilterInfo['type'];
export type FilterProps<K extends FilterType> = Omit<
  Extract<FilterInfo, { type: K }>,
  'type' | 'name' | 'priority'
>;
export type FilterDefaults<K extends FilterType> = Required<FilterProps<K>>;
export type FilterFlags = Record<string, number>;
export type FilterOptions = Record<string, Record<string, number>>;

export type MasterFilterEntry<K extends FilterType> = {
  defaults: FilterDefaults<K>;
  flags?: FilterFlags;
  options?: FilterOptions;
};

export type MasterFilterInfo = {
  [K in FilterType]: MasterFilterEntry<K>;
};

/**
 * Custom mapping provided by /datum/filter_editor/ui_data()
 *
 * https://www.byond.com/docs/ref/#/matrix
 */
// biome-ignore format: keep the matrix type readable
export type TransformMatrix = {
  a: number; d: number;
  b: number; e: number;
  c: number; f: number;
};
