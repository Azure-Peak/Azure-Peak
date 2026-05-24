export type PollSnapshot = {
  total: number;
  noble: number;
  clergy: number;
  inquisition: number;
  courtier: number;
  garrison: number;
  guilds: number;
  merchant: number;
  burgher: number;
  adventurer: number;
  mercenary: number;
  peasant: number;
};

export type RoyalSnapshot = {
  total: number;
  contract_levy: number;
  headeater_levy: number;
  import_tariff: number;
  export_duty: number;
  other_fees: number;
};

export type ExemptSnapshot = {
  total: number;
  contract: number;
  headeater: number;
  import: number;
  export: number;
  fines: number;
  poll_tax: number;
};

export type StandingSnapshot = {
  revenue: number;
  fulfilled: number;
  expired: number;
  petitioned: number;
  petition_pledge_spent: number;
};

export type TreasurySnapshot = {
  starting: number;
  rural_taxes: number;
  poll: PollSnapshot;
  royal: RoyalSnapshot;
  exempt: ExemptSnapshot;
  fines_income: number;
  stockpile_exports: number;
  stockpile_revenue: number;
  stockpile_direct_imports: number;
  standing: StandingSnapshot;
  shortages_ended: number;
  wages_paid: number;
  treasury_transfers: number;
  stockpile_imports: number;
  banditry_losses: number;
  banditry_owed: number;
  treasury_debt_repaid: number;
  treasury_debt_owed: number;
  bankruptcy_count: number;
  arrears_count: number;
  forfeiture_amount: number;
  forfeiture_count: number;
  total_revenue: number;
  total_expenses: number;
  net_treasury: number;
  trade_balance: number;
  foreign_trade_volume: number;
  effective_tax_rate: number | null;
  exemption_share: number | null;
  taxes_evaded: number;
};

export type EconomySnapshot = {
  mammons_held: number;
  mammons_deposited: number;
  mammons_withdrawn: number;
  noble_income: number;
  bathmatron_vault: number;
  sold_to_stockpile: number;
  taxes_evaded: number;
  trade_exported_real: number;
  trade_exported_bm: number;
  trade_exported_total: number;
  trade_imported: number;
  merchant_levy_collected: number;
  merchant_levy_taxed: number;
  gnome_margin: number;
  favor_from_sendoffs: number;
  favor_from_navigator: number;
  favor_from_goldface: number;
  favor_from_silverface: number;
  favor_penalties: number;
  favor_high: number;
  goldface: number;
  silverface: number;
  copperface: number;
  purity: number;
  peddler: number;
};

export type RealmRow = {
  name: string;
  hails: number;
  avg_dock_min: number | null;
  favor_earned: number;
};

export type ShipSnapshot = {
  realms: RealmRow[];
  total_hails: number;
};

export type RealBucket = {
  name: string;
  sold: number;
  relieved: number;
};

export type BmBucket = {
  name: string;
  sold: number;
};

export type BucketSnapshot = {
  real: RealBucket[];
  black_market: BmBucket[];
};

export type ContractsSnapshot = {
  generated_total: number;
  generated_pool: number;
  generated_rumor: number;
  generated_defense: number;
  taken_total: number;
  taken_pool: number;
  taken_rumor: number;
  taken_defense: number;
  completed_total: number;
  completed_pool: number;
  completed_rumor: number;
  completed_defense: number;
  abandoned: number;
  rerolled: number;
  mammons_paid: number;
  mammons_taxed: number;
  mammons_forfeited: number;
};

export type RoyalFavorsSnapshot = {
  pledge_generated: number;
  pledge_consumed: number;
  pledge_unused: number;
  rumor_generated: number;
  rumor_consumed: number;
  rumor_unused: number;
};

export type EconomicChronicleData = {
  treasury_balance: number;
  treasury: TreasurySnapshot;
  economy: EconomySnapshot;
  ships: ShipSnapshot;
  buckets: BucketSnapshot;
  contracts: ContractsSnapshot;
  royal_favors: RoyalFavorsSnapshot;
};
