import type { BooleanLike } from 'tgui-core/react';

export type RecipeMaterial = {
  name: string;
  qty: number;
};

export type CatalogEntry = {
  ref: string;
  name: string;
  category: string;
  price: number;
  ingot: string;
  materials: RecipeMaterial[];
};

export type ManifestLine = {
  ref: string;
  name: string;
  category: string;
  qty: number;
  unit_price: number;
  line_total: number;
};

export type OrderLine = {
  name: string;
  qty: number;
};

export type OrderFulfillment = {
  name: string;
  have: number;
  want: number;
};

export type OrderStatus = 'open' | 'claimed' | 'complete';

export type Order = {
  ref: string;
  commissioner_name: string;
  smith_name: string;
  deposited: number;
  status: OrderStatus;
  lines: OrderLine[];
  materials: RecipeMaterial[];
  fulfillment: OrderFulfillment[];
  done_count: number;
  needed_count: number;
  is_commissioner: BooleanLike;
  is_smith: BooleanLike;
  is_fulfilled: BooleanLike;
  days_left: number;
  expiry_label: string;
  note: string;
};

export type MaterialEntry = {
  path: string;
  name: string;
  price: number;
  priority: BooleanLike;
  enabled: BooleanLike;
};

export type CommissionerData = {
  can_read: BooleanLike;
  is_guildmaster: BooleanLike;
  budget: number;
  my_deposit: number;
  percent_margin: number;
  flat_margin: number;
  item_cap_per_order: number;
  my_manifest_items: number;
  has_active_order: BooleanLike;
  catalog: CatalogEntry[];
  categories: string[];
  ingots: string[];
  group_order: string[];
  manifest: ManifestLine[];
  manifest_total: number;
  orders: Order[];
  materials: MaterialEntry[];
};

export type ActFn = (action: string, params?: Record<string, unknown>) => void;
