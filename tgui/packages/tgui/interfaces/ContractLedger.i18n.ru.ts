const tierLabels = {
  1: 'Тир I - Рутинный',
  2: 'Тир II - Рискованный',
  3: 'Тир III - Опасный',
  4: 'Тир IV - Смертельный',
  5: 'Тир V - Гибельный',
  6: 'Тир VI - Мифический',
};

const contractGroups = {
  'Guild Errands': 'Поручения гильдии',
  Bounties: 'Охотничьи контракты',
};

const contractTypes = {
  Retrieval: 'Поиск',
  Courier: 'Доставка',
  Hunt: 'Охота',
  'Clear Out': 'Зачистка',
  Raid: 'Налёт',
  Boss: 'Босс',
};

const contractDescriptions = {
  Retrieval: 'Найдите потерянные или подброшенные предметы и верните их в гильдию.',
  Courier: 'Доставьте помеченную посылку с точки получения в место назначения.',
  Hunt: 'Выследите обычную враждебную цель или малую стаю.',
  'Clear Out': 'Зачистите враждебное скопление в известном регионе.',
  Raid: 'Примите бой против тяжёлой организованной группы врагов.',
  Boss: 'Выследите одиночную элитную угрозу за повышенную награду.',
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
      return 'Пользователь не найден.';
    case 'consult.no_account':
      return 'Для получения контрактов нужен банковский счёт.';
    case 'consult.limit_reached':
      return 'Вы достигли лимита активных контрактов.';
    case 'notice.choose_contract':
      return 'Выберите группу контракта, тип контракта и тир угрозы.';
    case 'notice.compass_carried':
      return 'У вас уже есть квестовый компас.';
    case 'notice.compass_already_claimed':
      return 'Книга Контрактов больше не настроит на вас ещё один квестовый компас.';
    case 'notice.compass_attuned':
      return 'Книга Контрактов настроила на вас квестовый компас. Используйте его на свитке, чтобы связать их.';
    case 'notice.choose_all_fields':
      return 'Перед получением задания выберите группу, тип и тир.';
    case 'notice.group_unavailable':
      return 'Эта группа контрактов больше недоступна.';
    case 'notice.type_unavailable':
      return 'Этот тип контракта больше недоступен.';
    case 'notice.invalid_contract':
      return 'Выбран некорректный тип контракта.';
    case 'notice.no_location':
      return 'Сейчас нет подходящей точки для такого контракта.';
    case 'notice.generate_failed':
      return 'Не удалось сгенерировать содержимое контракта.';
    case 'notice.insufficient_funds':
      return `Недостаточно средств. Нужно ${amount} amna на вашем счёте.`;
    case 'notice.issued_contract':
      return `Выдан контракт ${contractTypes[contractType] || contractType} (${tierLabels[tier] || 'неизвестный тир'}). Залог: ${deposit} amna.`;
    case 'notice.not_assigned':
      return 'Этот контракт назначен не вам.';
    case 'notice.no_completed_contract':
      return 'Нет готового к сдаче завершённого контракта.';
    case 'notice.turn_in_success':
      return `Контракт сдан. Выплачено: ${reward} amna.`;
    case 'notice.turn_in_not_ready':
      return 'Этот контракт ещё не готов к сдаче.';
    case 'notice.no_scroll_input':
      return 'Во входной зоне нет свитка контракта.';
    case 'notice.scroll_no_contract':
      return 'У этого свитка нет назначенного контракта.';
    case 'notice.abandoned_issuer_return':
      return 'Контракт отменён, залог возвращён выдавшему его лицу.';
    case 'notice.abandoned_refund':
      return `Контракт отменён. Возврат: ${refund} amna.`;
    case 'preview.possible_targets':
      return 'Возможные цели';
    case 'preview.contract':
      return 'Предпросмотр контракта';
    case 'preview.choose_type':
      return 'Выберите тип контракта, чтобы увидеть возможные варианты.';
    case 'preview.non_hunt':
      return 'Этот контракт не связан с охотой на живые цели, поэтому здесь нет карточек существ.';
    case 'preview.choose_tier':
      return 'Выберите тир угрозы, чтобы увидеть возможные цели.';
    case 'preview.no_valid':
      return 'Для выбранного контракта не найдено подходящих враждебных целей.';
    case 'preload.initializing':
      return 'Книга Контрактов подготавливает записи и превью целей.';
    case 'preload.waiting':
      return 'Подготовка доступных записей контракта...';
    case 'compass.action.get':
      return 'Получить квестовый компас';
    case 'compass.action.carried':
      return 'Квестовый компас уже у вас';
    case 'compass.action.claimed':
      return 'Квестовый компас уже был получен';
    default:
      return key;
  }
};

export default {
  windowTitle: 'Книга Контрактов',
  labels: {
    contractLimit: 'Лимит контрактов',
    currentRole: 'Текущая роль',
    availableActions: 'Доступные действия',
    contractDraft: 'Черновик контракта',
    group: 'Группа',
    type: 'Тип',
    threat: 'Угроза',
    draft: 'Черновик',
    none: 'Нет',
    notSelected: 'Не выбрано',
    risk: 'Опасность',
    spawnWeight: 'Вес спавна',
    compass: 'Компас',
    language: 'Язык',
    consultContracts: 'Просмотреть контракты',
    turnInContract: 'Сдать контракт',
    abandonContract: 'Отказаться от контракта',
    printIssuedContracts: 'Печать выданных контрактов',
    getContract: 'Получить контракт',
  },
  contractGroups,
  contractTypes,
  contractDescriptions,
  tierLabels,
  resolveText,
  formatTierBand: (minimumTier, maximumTier) =>
    `${tierLabels[minimumTier] || 'Тир ?'} до ${tierLabels[maximumTier] || 'Тир ?'}`,
  formatDraftTitle: (contractType) => `Контракт: ${contractType}`,
  formatPreviewGroup: (groupMin, groupMax) => {
    if (groupMin === groupMax) {
      if (groupMin <= 1) {
        return 'Одиночка';
      }
      return `Группа из ${groupMin}`;
    }
    return `Группа ${groupMin}-${groupMax}`;
  },
  noContractSelectedTitle: 'Контракт не выбран',
  noContractSelectedDescription:
    'Выберите группу и тип контракта, чтобы посмотреть предпросмотр.',
  hiddenTargets: (count) =>
    `И ещё ${count} возможных целей для этого выбора.`,
};
