const tierLabels = {
  1: 'Tier I - Routine',
  2: 'Tier II - Risky',
  3: 'Tier III - Dangerous',
  4: 'Tier IV - Deadly',
  5: 'Tier V - Lethal',
  6: 'Tier VI - Mythic',
};

const contractGroups = {
  'Guild Errands': 'Guild Errands',
  Bounties: 'Bounties',
};

const contractTypes = {
  Retrieval: 'Retrieval',
  Courier: 'Courier',
  Hunt: 'Hunt',
  'Clear Out': 'Clear Out',
  Raid: 'Raid',
  Boss: 'Boss',
};

const contractDescriptions = {
  Retrieval: 'Recover lost or planted items and return them to the guild.',
  Courier: 'Deliver a marked parcel from the pickup site to its destination.',
  Hunt: 'Track down a routine hostile target or a small pack.',
  'Clear Out': 'Purge a hostile cluster from a known region.',
  Raid: 'Take on a heavy hostile force in organized numbers.',
  Boss: 'Hunt a singular elite threat with a much higher payout.',
};

const resolveText = (key, args = {}) => {
  const amount = args['amount'];
  const deposit = args['deposit'];
  const refund = args['refund'];
  const reward = args['reward'];
  const contractType = args['contract_type'];
  const tier = args['tier'];

  switch (key) {
    case 'consult.no_user':
      return 'No user found.';
    case 'consult.no_account':
      return 'You need a bank account before the ledger will issue contracts.';
    case 'consult.limit_reached':
      return 'You have reached your active contract limit.';
    case 'notice.choose_contract':
      return 'Choose a contract group, contract type, and threat tier.';
    case 'notice.compass_carried':
      return 'You already carry a quest compass.';
    case 'notice.compass_already_claimed':
      return 'The ledger will not attune another quest compass to you.';
    case 'notice.compass_attuned':
      return 'The ledger attunes a quest compass to you. Use it on a contract scroll to link it.';
    case 'notice.choose_all_fields':
      return 'Choose a contract group, type, and tier before requesting a contract.';
    case 'notice.group_unavailable':
      return 'That contract group is no longer available.';
    case 'notice.type_unavailable':
      return 'That contract type is no longer available.';
    case 'notice.invalid_contract':
      return 'Invalid contract type selected.';
    case 'notice.no_location':
      return 'No suitable quest location is currently available.';
    case 'notice.generate_failed':
      return 'Failed to generate quest content for that contract.';
    case 'notice.insufficient_funds':
      return `Insufficient balance funds. You need ${amount} amna in your meister.`;
    case 'notice.issued_contract':
      return `Issued ${contractTypes[contractType] || contractType} at ${tierLabels[tier] || 'unknown tier'}. Deposit charged: ${deposit} amna.`;
    case 'notice.not_assigned':
      return 'You are not assigned to that contract.';
    case 'notice.no_completed_contract':
      return 'No completed contract is ready to turn in.';
    case 'notice.turn_in_success':
      return `Contract turned in. Reward dispensed: ${reward} amna.`;
    case 'notice.turn_in_not_ready':
      return 'That contract is not ready to turn in.';
    case 'notice.no_scroll_input':
      return 'No contract scroll found in the input area.';
    case 'notice.scroll_no_contract':
      return 'That scroll has no assigned contract.';
    case 'notice.abandoned_issuer_return':
      return 'The contract was abandoned and the deposit returned to the issuer.';
    case 'notice.abandoned_refund':
      return `Contract abandoned. Refund returned: ${refund} amna.`;
    case 'preview.possible_targets':
      return 'Possible Targets';
    case 'preview.contract':
      return 'Contract Preview';
    case 'preview.choose_type':
      return 'Choose a contract type to preview what the ledger can issue.';
    case 'preview.non_hunt':
      return 'This contract does not hunt living targets, so there are no creature previews to display.';
    case 'preview.choose_tier':
      return 'Choose a threat tier to preview possible targets.';
    case 'preview.no_valid':
      return 'No valid hostile previews are available for the selected contract.';
    case 'preload.initializing':
      return 'Initializing ledger records and target previews.';
    case 'preload.waiting':
      return 'Preparing available contract entries...';
    case 'compass.action.get':
      return 'Claim quest compass';
    case 'compass.action.carried':
      return 'Quest compass already carried';
    case 'compass.action.claimed':
      return 'Quest compass already claimed';
    default:
      return key;
  }
};

export default {
  windowTitle: 'Grand Contract Ledger',
  labels: {
    contractLimit: 'Contract Limit',
    currentRole: 'Current Role',
    availableActions: 'Available Actions',
    contractDraft: 'Contract Draft',
    group: 'Group',
    type: 'Type',
    threat: 'Threat',
    draft: 'Draft',
    none: 'None',
    notSelected: 'Not selected',
    risk: 'Risk',
    spawnWeight: 'Spawn weight',
    compass: 'Compass',
    language: 'Language',
    consultContracts: 'Consult Contracts',
    turnInContract: 'Turn in Contract',
    abandonContract: 'Abandon Contract',
    printIssuedContracts: 'Print Issued Contracts',
    getContract: 'Get Contract',
  },
  contractGroups,
  contractTypes,
  contractDescriptions,
  tierLabels,
  resolveText,
  formatTierBand: (minimumTier, maximumTier) =>
    `${tierLabels[minimumTier] || 'Tier ?'} to ${tierLabels[maximumTier] || 'Tier ?'}`,
  formatDraftTitle: (contractType) => `${contractType} Contract`,
  formatPreviewGroup: (groupMin, groupMax) => {
    if (groupMin === groupMax) {
      if (groupMin <= 1) {
        return 'Solo';
      }
      return `Pack of ${groupMin}`;
    }
    return `Pack of ${groupMin}-${groupMax}`;
  },
  noContractSelectedTitle: 'No contract selected',
  noContractSelectedDescription:
    'Choose a contract group and contract type to preview it.',
  hiddenTargets: (count) =>
    `And ${count} more possible targets for this selection.`,
};
