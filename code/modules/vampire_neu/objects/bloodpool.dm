#define VAMPCOST_ONE 5000 //heavily chopped down, you're a server-wide antagonist that should be doing stuff, just slightly above your ability to buy roundstart.
#define VAMPCOST_TWO 6000 //Earlygame finish point, most vlords will end up here less than 30 mins into a round if they're good, 1hr if not.
#define VAMPCOST_THREE 7500 //Grab immunity, leave moderately high. This is where they become a major threat.
#define VAMPCOST_FOUR 14000 //Intended to be rather high as its hyperwar mode with sunkill, has to be moderately expensive but affordable so vlord can afford it and upgrade their personal powers through using them passively, for the war to come.
#define ARMOR_COST 5000 //Fairly cheap cause it comes behind a rite cost. We want this mid-early game. One-Time only ritual. Unlocks at Second Upgrade.
#define SUN_STEAL_COST 8000 //Server wide war declaration, mostly useless for Vitabella. Risk/Reward but we want it to be less earlygame but midgame instead of lategame. //MOVED TO AUTOMATIC ON FULLPOWER UPGRADE//
#define SERVANT_COST 800 //Keep these low, so people can play as vampires. We want to scoop up observers/lobby joiners before they get bored.
#define SERVANT_T2_COST 1000 //Same as above, a little bit higher because these roles /can/ actually fight, keep it low so they can get a retinue starting off.
#define SERVANT_T3_COST 4000 //Keep moderately high, these are rarer classes that can cause problems when spammed en-mass. Unlocks at Second Upgrade.

#define CRUCIBLE_MAX_BLOOD 20000
#define CRUCIBLE_MIN_DONOR_BLOOD BLOOD_VOLUME_SURVIVE
#define CRUCIBLE_MIN_DONATION 500
#define CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE 300
#define CRUCIBLE_DONATION_VITAE 3000
#define CRUCIBLE_DONATION_BLOOD 400

#define INITIATE_LORDE 1
#define INITIATE_ANYONE 2

/datum/ui_localization/crimson_crucible
	supported_languages = list(DEFAULT_PREFERRED_UI_LANGUAGE, "ru")

/datum/ui_localization/crimson_crucible/get_language_texts(language_code)
	switch(language_code)
		if("ru")
			return list(
				"number_locale" = "ru-RU",
				"window_title" = "Багровое горнило",
				"header_title" = "БАГРОВОЕ ГОРНИЛО",
				"seals" = list(
					"header" = "V",
					"lord_only" = "М",
					"open" = "О",
				),
				"sections" = list(
					"active_projects" = "Активные ритуалы",
					"available_projects" = "Новые ритуалы",
				),
				"roles" = list(
					"lord" = "Право на власть",
					"vampire" = "Право на жертву",
					"mortal" = "Живая жертва",
				),
				"labels" = list(
					"cup_blood" = "Кровь в чаше",
					"committed" = "Вложено",
					"max_deposit" = "Можно влить",
					"required" = "Нужно",
					"collected" = "Собрано",
					"remaining" = "Осталось",
					"contributors" = "Участники",
					"cost" = "Цена",
					"vitae" = "витэ",
				),
				"actions" = list(
					"deposit_vampire" = "Влить кровь",
					"deposit_mortal" = "Отдать кровь",
					"contribute_lord" = "Направить",
					"contribute_vampire" = "Пожертвовать",
					"cancel" = "Отменить",
					"start" = "Начать",
				),
				"states" = list(
					"no_active_projects" = "Горнило пока молчит. Ни один ритуал не начат.",
					"no_available_projects" = "Нет доступных ритуалов.",
					"no_contributors" = "Пока никто",
					"nonvampire_info" = "Горнило принимает кровь в чашу или уже начатые ритуалы. Новые ритуалы остаются волей клана.",
					"vampire_nonlord_info" = "Начинать новые ритуалы может только Метсуфелат. Остальным доступны только пожертвования крови в чашу и вложения в уже начатые ритуалы.",
					"lord_only" = "(воля Метсуфелата)",
					"open" = "(открытый)",
				),
				"messages" = list(
					"need_adjacent" = "Мне нужно быть рядом с горнилом.",
					"only_lord_start" = "Только Метсуфелат может начинать новые ритуалы.",
					"unknown_project" = "Горнило не смогло распознать этот ритуал.",
					"only_lord_cancel" = "Только Метсуфелат может отменять ритуалы.",
					"cancel_confirm" = "Отменить ритуал \"{project}\"? Вложенная кровь будет возвращена участникам.",
					"cancel_confirm_button" = "Отменить ритуал",
					"cancel_back_button" = "Назад",
					"start_failure_default" = "Условия ритуала еще не выполнены.",
					"project_started" = "Ритуал \"{project}\" начат. Теперь горнилу нужна витэ.",
					"cup_full" = "Чаша горнила уже полна.",
					"reserve" = "Последние {reserve} витэ нельзя отдать горнилу.",
					"min_donation" = "Горнило требует не меньше {amount} витэ за раз.",
					"deposit_prompt" = "Сколько витэ влить в чашу? Максимум: {amount}.",
					"not_enough_blood" = "Горнило не возьмет столько крови. Мне нужно остаться хотя бы с {amount}.",
					"deposit_vampire_success" = "Я влил {amount} витэ в чашу горнила. ({current}/{max})",
					"drain_warning" = "Проклятая магия вытягивает из меня все силы.",
					"deposit_mortal_success" = "Я отдал свою кровь чаше горнила. Чаша приняла {amount} витэ. ({current}/{max})",
					"no_contribution" = "Мне нечего пожертвовать этому ритуалу.",
					"not_enough_vitae" = "Мне не хватает витэ.",
					"contribute_prompt" = "Сколько витэ пожертвовать в \"{project}\"? Максимум: {amount}.",
					"contribute_lord_success" = "Я направил {amount} витэ в \"{project}\". Из чаши: {cup}, моей крови: {personal}. ({paid}/{cost})",
					"contribute_vampire_success" = "Я пожертвовал {amount} витэ в \"{project}\". ({paid}/{cost})",
					"contribute_mortal_complete" = "Я отдал свои силы для проклятого ритуала! Ритуал \"{project}\" завершен.",
					"contribute_mortal_progress" = "Я отдал свои силы для проклятого ритуала! Ритуал \"{project}\" прогрессирует. ({paid}/{cost})",
					"project_complete_announce" = "{project} завершен!",
					"refund_notice" = "Мне вернулось {amount} витэ из отмененного проекта: {project}",
				),
				"contribution" = list(
					"lord_with_cup" = "Можно направить до {amount} витэ; сначала расходуется чаша",
					"vampire" = "Можно пожертвовать до {amount} витэ",
					"mortal" = "Будет пожертвовано: {vitae} витэ и {blood} крови",
				),
				"project_names" = list(
					"Rite of Stirring" = "Обряд пробуждения",
					"Rite of Reclamation" = "Обряд возвращения",
					"Rite of Dominion" = "Обряд владычества",
					"Rite of Sovereignty" = "Обряд суверенитета",
					"Wicked Plate" = "Порочные латы",
					"Steal the Sun" = "Украсть солнце",
					"Summon Vampyre Servant" = "Призвать вампира-слугу",
					"Summon Vampyre Guard" = "Призвать вампира-стража",
					"Summon Vampyre Champion" = "Призвать вампира-чемпиона",
				),
				"project_descriptions" = list(
					"Rite of Stirring" = "Древняя кровь вновь шевелится. Забытые шепоты отзываются в костях земли. Владыка рядом с горнилом получает +2 ко всем характеристикам и +1000 к запасу витэ. Открывает чемпионов.",
					"Rite of Reclamation" = "Запечатанная сила возвращается. Почва, камень и тени вспоминают своего хозяина. Владыка рядом с горнилом получает еще +2 ко всем характеристикам и +1000 к запасу витэ. Открывает ритуалы брони.",
					"Rite of Dominion" = "Завеса времени рвется. Воля Старшего связывает незваных в хватке Земли. Владыка рядом с горнилом получает еще +2 ко всем характеристикам и +1000 к запасу витэ.",
					"Rite of Sovereignty" = "Владыка становится целым. Древняя мощь насыщает каждый камень и каждую жилу. Владыка и его подчиненные получают +2 ко всем характеристикам и +1000 к запасу витэ. Солнце умолкает.",
					"Wicked Plate" = "Полный комплект вампирских лат из кристаллизованной крови. Сталь, серебро и спасение не должны мешать планам Владыки. Ритуал можно провести только один раз.",
					"Steal the Sun" = "Жгучий взор Солнца-Тирана больше не должен мешать планам клана.",
					"Summon Vampyre Servant" = "Верный слуга для трудов, кузни, поместья и мелких поручений. Неонит, может обратить одного тонкокровного, 9 RP.",
					"Summon Vampyre Guard" = "Верный страж для защиты дела или поместья клинком, щитом, луком или магией. Неонит, может обратить одного тонкокровного, 9 RP.",
					"Summon Vampyre Champion" = "Талантливый и опасный чемпион для армии тьмы или скрытого удара по смертным. Анцилла, может обратить пять неонитов, 17 RP.",
				),
				"start_failures" = list(
					"This project cannot be started." = "Этот ритуал нельзя начать.",
					"This project can only be initiated by your Lorde." = "Этот ритуал может начать только Метсуфелат.",
					"This project can only be initiate by your Lorde." = "Этот ритуал может начать только Метсуфелат.",
				),
			)

	return list(
		"number_locale" = "en-US",
		"window_title" = "Crimson Crucible",
		"header_title" = "CRIMSON CRUCIBLE",
		"seals" = list(
			"header" = "V",
			"lord_only" = "L",
			"open" = "O",
		),
		"sections" = list(
			"active_projects" = "Active Rituals",
			"available_projects" = "New Rituals",
		),
		"roles" = list(
			"lord" = "Right of Dominion",
			"vampire" = "Right of Sacrifice",
			"mortal" = "Living sacrifice",
		),
		"labels" = list(
			"cup_blood" = "Blood in cup",
			"committed" = "Committed",
			"max_deposit" = "Available to pour",
			"required" = "Required",
			"collected" = "Collected",
			"remaining" = "Remaining",
			"contributors" = "Contributors",
			"cost" = "Cost",
			"vitae" = "vitae",
		),
		"actions" = list(
			"deposit_vampire" = "Pour blood",
			"deposit_mortal" = "Give blood",
			"contribute_lord" = "Direct",
			"contribute_vampire" = "Contribute",
			"cancel" = "Cancel",
			"start" = "Start",
		),
		"states" = list(
			"no_active_projects" = "The crucible is silent. No ritual has begun.",
			"no_available_projects" = "No rituals are available.",
			"no_contributors" = "No one yet",
			"nonvampire_info" = "The crucible accepts blood into the cup or into rituals already begun. New rites remain the clan's will.",
			"vampire_nonlord_info" = "Only the Methuselah can begin new rituals. Others may fill the cup and aid rituals already in motion.",
			"lord_only" = "(Methuselah's will)",
			"open" = "(open)",
		),
		"messages" = list(
			"need_adjacent" = "I need to be next to the crucible.",
			"only_lord_start" = "Only the Methuselah can begin new rituals.",
			"unknown_project" = "The crucible failed to recognize that ritual.",
			"only_lord_cancel" = "Only the Methuselah can cancel rituals.",
			"cancel_confirm" = "Cancel ritual \"{project}\"? Invested blood will be returned to participants.",
			"cancel_confirm_button" = "Cancel ritual",
			"cancel_back_button" = "Back",
			"start_failure_default" = "The ritual conditions are not fulfilled yet.",
			"project_started" = "Ritual \"{project}\" has begun. The crucible now hungers for vitae.",
			"cup_full" = "The crucible cup is already full.",
			"reserve" = "The last {reserve} vitae cannot be given to the crucible.",
			"min_donation" = "The crucible requires at least {amount} vitae at a time.",
			"deposit_prompt" = "How much vitae should be poured into the cup? Maximum: {amount}.",
			"not_enough_blood" = "The crucible will not take that much blood. I must remain with at least {amount}.",
			"deposit_vampire_success" = "I poured {amount} vitae into the crucible cup. ({current}/{max})",
			"drain_warning" = "Cursed magic drains my strength.",
			"deposit_mortal_success" = "I gave my blood to the crucible cup. The cup accepted {amount} vitae. ({current}/{max})",
			"no_contribution" = "I have nothing to give to that ritual.",
			"not_enough_vitae" = "I do not have enough vitae.",
			"contribute_prompt" = "How much vitae should be given to \"{project}\"? Maximum: {amount}.",
			"contribute_lord_success" = "I directed {amount} vitae into \"{project}\". From the cup: {cup}, from my blood: {personal}. ({paid}/{cost})",
			"contribute_vampire_success" = "I contributed {amount} vitae to \"{project}\". ({paid}/{cost})",
			"contribute_mortal_complete" = "I gave my strength to the cursed ritual! Ritual \"{project}\" is complete.",
			"contribute_mortal_progress" = "I gave my strength to the cursed ritual! Ritual \"{project}\" progresses. ({paid}/{cost})",
			"project_complete_announce" = "{project} has been completed!",
			"refund_notice" = "Received {amount} vitae refund from cancelled project: {project}",
		),
		"contribution" = list(
			"lord_with_cup" = "Can direct up to {amount} vitae; the cup is spent first",
			"vampire" = "Can contribute up to {amount} vitae",
			"mortal" = "Will sacrifice {vitae} vitae and {blood} blood",
		),
		"project_names" = list(
			"Rite of Stirring" = "Rite of Stirring",
			"Rite of Reclamation" = "Rite of Reclamation",
			"Rite of Dominion" = "Rite of Dominion",
			"Rite of Sovereignty" = "Rite of Sovereignty",
			"Wicked Plate" = "Wicked Plate",
			"Steal the Sun" = "Steal the Sun",
			"Summon Vampyre Servant" = "Summon Vampyre Servant",
			"Summon Vampyre Guard" = "Summon Vampyre Guard",
			"Summon Vampyre Champion" = "Summon Vampyre Champion",
		),
		"project_descriptions" = list(
			"Rite of Stirring" = "The ancient blood stirs once more. Forgotten whispers echo through the marrow of the land. The Lorde near the crucible gains +2 to all stats and +1000 vitae pool limit. Unlocks champions.",
			"Rite of Reclamation" = "Strength long sealed returns. The soil, the stone, and the shadows bend again to their rightful master. The Lorde near the crucible gains another +2 to all stats and +1000 vitae pool limit. Unlocks armor rites.",
			"Rite of Dominion" = "The veil of time shreds. The Elder's will pours forth, binding trespassers within the grasp of the Land. The Lorde near the crucible gains another +2 to all stats and +1000 vitae pool limit.",
			"Rite of Sovereignty" = "The Lord is whole. Ancient power saturates every stone and vein. The Lorde and their thralls gain +2 to all stats and +1000 vitae pool limit. The sun falls silent.",
			"Wicked Plate" = "Summon a complete set of vampiric plate armor from crystallized blood. Let not steel, silver, nor salvation inhibit the Lord's plan. This can only be done once.",
			"Steal the Sun" = "The scorching gaze of the Sun-Tyrant shall hamper the clan's plans no more.",
			"Summon Vampyre Servant" = "A loyal servant for chores, forgework, the manor, and trivial tasks. Neonate generation, can sire one Thinblood, 9 RP.",
			"Summon Vampyre Guard" = "A loyal guard to fight for your cause or defend your manor with blade, shield, bow, or magicks. Neonate generation, can sire one Thinblood, 9 RP.",
			"Summon Vampyre Champion" = "A loyal, highly talented champion to herald your army of darkness or strike mortalkind from the shadows. Ancillae generation, can sire five Neonites, 17 RP.",
		),
		"start_failures" = list(
			"This project cannot be started." = "This project cannot be started.",
			"This project can only be initiated by your Lorde." = "This project can only be initiated by your Lorde.",
			"This project can only be initiate by your Lorde." = "This project can only be initiated by your Lorde.",
		),
	)

/obj/structure/vampire/bloodpool
	name = "Crimson Crucible"
	desc = "An ominious bloodstained Crucible, humming with unholy energies and crackling with untold potental. A thick smell of copper invades your nose just looking upon it, is that blood?"
	icon_state = "vat"
	var/current = 0
	var/datum/clan/owner_clan
	var/list/nonvampire_vitae_snapshots = list()

	var/list/active_projects = list()
	var/list/available_project_types = list(
		/datum/vampire_project/servant/servant_t1,
		/datum/vampire_project/servant/servant_t2, //Powerful servants come with second vlord upgrade. Plus armor can be bought at that point.
		/datum/vampire_project/power_growth,
	)
	var/sunstolen = FALSE

/obj/structure/vampire/bloodpool/Initialize()
	. = ..()
	set_light(3, 3, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC)

/obj/structure/vampire/bloodpool/examine(mob/user)
	. = ..()
	to_chat(user, span_boldnotice("Blood level: [current]"))

	if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
		. += span_bloody("A Crucible used for your projects, all Vampires can contribute their vitae towards projects you set. Only you can contribute the last 100 needed to finish a project.")

	// Show active projects
	if(active_projects.len)
		to_chat(user, span_notice("Active Projects:"))
		for(var/project_key in active_projects)
			var/datum/vampire_project/project = active_projects[project_key]
			var/progress_percent = round((project.paid_amount / project.total_cost) * 100, 1)
			to_chat(user, span_notice("- [project.display_name]: [project.paid_amount]/[project.total_cost] ([progress_percent]%)"))

/obj/structure/vampire/bloodpool/attack_hand(mob/living/user)
	if(!istype(user))
		return

	remember_nonvampire_vitae(user)
	ui_interact(user)

/obj/structure/vampire/bloodpool/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/vampire/bloodpool/ui_interact(mob/user, datum/tgui/ui)
	var/mob/living/living_user = user
	if(!istype(living_user))
		return

	remember_nonvampire_vitae(living_user)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		var/list/texts = get_crucible_texts(user)
		ui = new(user, src, "CrimsonCrucible", texts["window_title"])
		ui.open()

/obj/structure/vampire/bloodpool/ui_static_data(mob/user)
	var/list/data = ..()
	data["texts"] = get_crucible_texts(user)
	return data

/obj/structure/vampire/bloodpool/ui_data(mob/user)
	var/list/data = ..()
	var/mob/living/living_user = user
	var/mob/living/carbon/human/human_user
	if(istype(living_user))
		human_user = living_user
	var/is_lord = is_crucible_lord(living_user)
	var/is_vampire = is_crucible_vampire(living_user)
	var/list/texts = get_crucible_texts(user)
	var/list/states = texts["states"]
	var/list/seals = texts["seals"]
	var/list/active_project_data = list()
	var/list/available_project_data = list()
	var/committed_vitae = 0

	if(istype(living_user) && !is_vampire)
		remember_nonvampire_vitae(living_user)

	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		if(!project)
			continue

		var/remaining = max(project.total_cost - project.paid_amount, 0)
		var/max_contribution = istype(living_user) ? get_project_max_contribution(project, living_user) : 0
		var/can_contribute = can_accept_vitae_contribution(project, max_contribution, is_vampire)
		var/list/contributor_names = list()
		for(var/mob/living/contributor in project.contributors)
			var/contributor_name = contributor.real_name
			if(!contributor_name)
				contributor_name = contributor.name
			UNTYPED_LIST_ADD(contributor_names, contributor_name)

		committed_vitae += project.paid_amount
		UNTYPED_LIST_ADD(active_project_data, list(
			"ref" = REF(project),
			"name" = project.ui_project_name(texts),
			"description" = project.ui_project_description(texts),
			"cost" = project.total_cost,
			"paid" = project.paid_amount,
			"remaining" = remaining,
			"progress" = project.total_cost ? round((project.paid_amount / project.total_cost) * 100, 0.1) : 100,
			"isLordOnly" = project.can_be_initiated_by == INITIATE_LORDE,
			"accessText" = project.can_be_initiated_by == INITIATE_LORDE ? states["lord_only"] : states["open"],
			"canContribute" = can_contribute,
			"maxContribution" = max_contribution,
			"maxBloodCost" = is_vampire ? 0 : get_blood_cost_for_vitae(max_contribution),
			"contributorsText" = length(contributor_names) ? jointext(contributor_names, ", ") : states["no_contributors"],
			"contributionText" = can_contribute ? get_project_contribution_text(project, max_contribution, is_lord, is_vampire, texts) : "",
		))

	if(is_lord && istype(human_user))
		for(var/project_type in available_project_types)
			if(project_type in active_projects)
				continue

			var/datum/vampire_project/project = new project_type()
			var/can_start = project.can_start(human_user, src)
			UNTYPED_LIST_ADD(available_project_data, list(
				"type_path" = "[project_type]",
				"name" = project.ui_project_name(texts),
				"description" = project.ui_project_description(texts),
				"cost" = project.total_cost,
				"isLordOnly" = project.can_be_initiated_by == INITIATE_LORDE,
				"accessText" = project.can_be_initiated_by == INITIATE_LORDE ? states["lord_only"] : states["open"],
				"accessSeal" = project.can_be_initiated_by == INITIATE_LORDE ? seals["lord_only"] : seals["open"],
				"canStart" = can_start,
				"lockedReason" = get_project_locked_reason(project, is_lord, can_start, texts),
			))
			qdel(project)

	data["bloodLevel"] = current
	data["maxBlood"] = max(CRUCIBLE_MAX_BLOOD, current)
	data["committedVitae"] = committed_vitae
	data["isLord"] = is_lord
	data["isVampire"] = is_vampire
	var/max_cup_deposit = istype(living_user) ? get_max_cup_deposit(living_user) : 0
	data["canDepositBlood"] = can_accept_cup_deposit(living_user, max_cup_deposit, is_vampire)
	data["maxCupDeposit"] = max_cup_deposit
	data["activeProjects"] = active_project_data
	data["availableProjects"] = available_project_data
	return data

/obj/structure/vampire/bloodpool/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	var/mob/living/user = ui.user
	if(!istype(user))
		return TRUE

	var/list/texts = get_crucible_texts(user)
	var/list/messages = texts["messages"]
	remember_nonvampire_vitae(user)
	if(get_dist(user, src) > 1)
		to_chat(user, span_warning(messages["need_adjacent"]))
		return TRUE

	switch(action)
		if("start_project")
			if(!is_crucible_lord(user))
				to_chat(user, span_warning(messages["only_lord_start"]))
				return TRUE
			var/project_path = params["type_path"]
			if(!project_path)
				project_path = params["typePath"]
			var/project_type = text2path(project_path)
			if(!ispath(project_type, /datum/vampire_project) || !(project_type in available_project_types) || (project_type in active_projects))
				to_chat(user, span_warning(messages["unknown_project"]))
				return TRUE
			start_new_project_tgui(project_type, user, texts)
			return TRUE
		if("contribute")
			var/datum/vampire_project/project = get_active_project_by_ref(params["ref"])
			if(!project)
				return TRUE
			contribute_to_project(project, user, texts)
			return TRUE
		if("deposit_blood")
			deposit_blood_to_cup(user, texts)
			return TRUE
		if("cancel_project")
			if(!is_crucible_lord(user))
				to_chat(user, span_warning(messages["only_lord_cancel"]))
				return TRUE
			var/datum/vampire_project/project = get_active_project_by_ref(params["ref"])
			var/project_type = get_active_project_type(project)
			if(!project || !project_type)
				return TRUE
			var/project_name = project.ui_project_name(texts)
			var/confirm_message = format_crucible_text(messages["cancel_confirm"], list("project" = project_name))
			var/cancel_button = messages["cancel_confirm_button"]
			if(tgui_alert(user, confirm_message, texts["window_title"], list(cancel_button, messages["cancel_back_button"])) != cancel_button)
				return TRUE
			if(QDELETED(src) || !is_crucible_lord(user) || active_projects[project_type] != project)
				return TRUE
			cancel_project(project_type)
			SStgui.update_uis(src)
			return TRUE
	return FALSE

/obj/structure/vampire/bloodpool/proc/get_crucible_texts(mob/user)
	return get_ui_texts(user, /datum/ui_localization/crimson_crucible)

/obj/structure/vampire/bloodpool/proc/format_crucible_text(message, list/replacements)
	if(!istext(message) || !islist(replacements))
		return message

	. = message
	for(var/key in replacements)
		. = replacetext(., "{[key]}", "[replacements[key]]")

/obj/structure/vampire/bloodpool/proc/is_crucible_lord(mob/living/user)
	if(!istype(user))
		return FALSE
	var/mob/living/carbon/human/human_user = user
	if(!istype(human_user))
		return FALSE
	if(human_user.clan?.clan_leader == human_user)
		return TRUE
	return !!human_user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)

/obj/structure/vampire/bloodpool/proc/is_crucible_vampire(mob/living/user)
	if(!istype(user))
		return FALSE
	return !!user.mind?.has_antag_datum(/datum/antagonist/vampire)

/obj/structure/vampire/bloodpool/proc/get_project_contribution_text(datum/vampire_project/project, max_contribution, is_lord, is_vampire, list/texts)
	var/list/contribution_texts = texts["contribution"]
	if(is_vampire)
		if(is_lord)
			return format_crucible_text(contribution_texts["lord_with_cup"], list("amount" = max_contribution))
		return format_crucible_text(contribution_texts["vampire"], list("amount" = max_contribution))
	return format_crucible_text(contribution_texts["mortal"], list("vitae" = max_contribution, "blood" = get_blood_cost_for_vitae(max_contribution)))

/obj/structure/vampire/bloodpool/proc/get_nonvampire_crucible_bloodpool(mob/living/user, bloodpool_amount)
	if(!istype(user))
		return 0
	return max(min(bloodpool_amount, user.maxbloodpool), 0)

/obj/structure/vampire/bloodpool/proc/get_nonvampire_vitae_from_bloodpool(mob/living/user, bloodpool_amount)
	return get_nonvampire_crucible_bloodpool(user, bloodpool_amount) * CLIENT_VITAE_MULTIPLIER

/obj/structure/vampire/bloodpool/proc/get_nonvampire_bloodpool_cost_for_vitae(vitae_amount)
	if(vitae_amount <= 0)
		return 0
	return CEILING(vitae_amount / CLIENT_VITAE_MULTIPLIER, 1)

/obj/structure/vampire/bloodpool/proc/remember_nonvampire_vitae(mob/living/user)
	if(!istype(user) || is_crucible_vampire(user))
		return
	if(!nonvampire_vitae_snapshots)
		nonvampire_vitae_snapshots = list()

	var/current_bloodpool = get_nonvampire_crucible_bloodpool(user, user.bloodpool)
	var/user_ref = REF(user)
	var/list/vitae_snapshot = nonvampire_vitae_snapshots[user_ref]
	if(!islist(vitae_snapshot))
		vitae_snapshot = list(
			"bloodpool" = current_bloodpool,
			"blood_volume" = user.blood_volume,
		)
		nonvampire_vitae_snapshots[user_ref] = vitae_snapshot
		return

	var/snapshotted_blood_volume = vitae_snapshot["blood_volume"]
	if(!snapshotted_blood_volume)
		snapshotted_blood_volume = 0
	if(user.blood_volume < snapshotted_blood_volume)
		vitae_snapshot["bloodpool"] = current_bloodpool
		vitae_snapshot["blood_volume"] = user.blood_volume
		return

	var/snapshotted_bloodpool = vitae_snapshot["bloodpool"]
	if(!snapshotted_bloodpool)
		snapshotted_bloodpool = 0
	if(current_bloodpool > snapshotted_bloodpool)
		vitae_snapshot["bloodpool"] = current_bloodpool
		vitae_snapshot["blood_volume"] = user.blood_volume

/obj/structure/vampire/bloodpool/proc/clear_nonvampire_vitae_snapshot(mob/living/user)
	if(!istype(user) || !nonvampire_vitae_snapshots)
		return
	nonvampire_vitae_snapshots -= REF(user)

/obj/structure/vampire/bloodpool/proc/get_nonvampire_snapshotted_vitae(mob/living/user)
	if(!istype(user) || !nonvampire_vitae_snapshots)
		return 0

	var/list/vitae_snapshot = nonvampire_vitae_snapshots[REF(user)]
	if(!islist(vitae_snapshot))
		return 0

	var/snapshotted_blood_volume = vitae_snapshot["blood_volume"]
	if(!snapshotted_blood_volume)
		snapshotted_blood_volume = 0
	if(user.blood_volume < snapshotted_blood_volume)
		clear_nonvampire_vitae_snapshot(user)
		return get_nonvampire_vitae_from_bloodpool(user, user.bloodpool)

	var/snapshotted_bloodpool = vitae_snapshot["bloodpool"]
	if(!snapshotted_bloodpool)
		snapshotted_bloodpool = 0
	return get_nonvampire_vitae_from_bloodpool(user, snapshotted_bloodpool)

/obj/structure/vampire/bloodpool/proc/get_available_vitae_for_contribution(mob/living/user, is_vampire)
	if(!istype(user))
		return 0

	if(is_vampire)
		var/available_vitae = get_vampire_personal_vitae_for_crucible(user)
		if(is_crucible_lord(user))
			available_vitae += current
		return available_vitae

	var/snapshotted_vitae = get_nonvampire_snapshotted_vitae(user)
	return max(get_nonvampire_vitae_from_bloodpool(user, user.bloodpool), snapshotted_vitae)

/obj/structure/vampire/bloodpool/proc/get_vampire_personal_vitae_for_crucible(mob/living/user)
	if(!istype(user))
		return 0
	return max(user.bloodpool - CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE, 0)

/obj/structure/vampire/bloodpool/proc/get_cup_space()
	return max(CRUCIBLE_MAX_BLOOD - current, 0)

/obj/structure/vampire/bloodpool/proc/get_max_cup_deposit(mob/living/user)
	if(!istype(user))
		return 0
	if(is_crucible_vampire(user))
		return min(get_vampire_personal_vitae_for_crucible(user), get_cup_space())
	return min(get_available_vitae_for_contribution(user, FALSE), get_blood_limited_vitae(user), get_cup_space())

/obj/structure/vampire/bloodpool/proc/can_accept_cup_deposit(mob/living/user, deposit, is_vampire)
	if(!istype(user) || deposit < 1 || get_cup_space() <= 0)
		return FALSE
	if(is_vampire)
		return TRUE
	return deposit >= CRUCIBLE_MIN_DONATION

/obj/structure/vampire/bloodpool/proc/get_project_locked_reason(datum/vampire_project/project, is_lord, can_start, list/texts)
	var/list/messages = texts["messages"]
	if(!is_lord)
		return messages["only_lord_start"]
	if(can_start)
		return ""
	if(project.start_failure_message)
		return project.ui_project_start_failure(texts)
	return messages["start_failure_default"]

/obj/structure/vampire/bloodpool/proc/get_active_project_by_ref(project_ref)
	if(!istext(project_ref))
		return null

	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		if(project && REF(project) == project_ref)
			return project

/obj/structure/vampire/bloodpool/proc/get_active_project_type(datum/vampire_project/project)
	if(!project)
		return null

	for(var/project_type in active_projects)
		if(active_projects[project_type] == project)
			return project_type

/obj/structure/vampire/bloodpool/proc/get_project_max_contribution(datum/vampire_project/project, mob/living/user)
	if(!project || !istype(user))
		return 0

	var/is_vampire = is_crucible_vampire(user)
	var/max_contribution = min(get_available_vitae_for_contribution(user, is_vampire), max(project.total_cost - project.paid_amount, 0))
	if(is_vampire)
		if(!is_crucible_lord(user) && project.display_name != "Wicked Plate" && project.display_name != "World Anchor")
			max_contribution = min(max_contribution, max((project.total_cost - project.paid_amount) - 100, 0))
	else
		max_contribution = min(max_contribution, get_blood_limited_vitae(user))
	if(max_contribution < 0)
		max_contribution = 0

	return max(round(max_contribution), 0)

/obj/structure/vampire/bloodpool/proc/can_accept_vitae_contribution(datum/vampire_project/project, contribution, is_vampire)
	if(!project || contribution < 1)
		return FALSE

	var/remaining = max(project.total_cost - project.paid_amount, 0)
	if(remaining <= 0)
		return FALSE
	if(is_vampire)
		return TRUE
	return contribution >= CRUCIBLE_MIN_DONATION

/obj/structure/vampire/bloodpool/proc/get_blood_limited_vitae(mob/living/user)
	if(!istype(user))
		return 0

	var/available_blood = max(user.blood_volume - CRUCIBLE_MIN_DONOR_BLOOD, 0)
	return max(FLOOR((available_blood * CRUCIBLE_DONATION_VITAE) / CRUCIBLE_DONATION_BLOOD, 1), 0)

/obj/structure/vampire/bloodpool/proc/get_blood_cost_for_vitae(vitae_amount)
	if(vitae_amount <= 0)
		return 0

	return CEILING((vitae_amount * CRUCIBLE_DONATION_BLOOD) / CRUCIBLE_DONATION_VITAE, 1)

/obj/structure/vampire/bloodpool/proc/start_new_project_tgui(project_type, mob/living/user, list/texts)
	if(!ispath(project_type, /datum/vampire_project) || !(project_type in available_project_types) || (project_type in active_projects))
		return

	var/datum/vampire_project/project = new project_type()
	var/list/messages = texts["messages"]
	var/mob/living/carbon/human/human_user
	if(istype(user))
		human_user = user

	if(QDELETED(src) || !istype(human_user) || !is_crucible_lord(human_user))
		qdel(project)
		return
	if(!project.can_start(human_user, src))
		to_chat(user, span_warning(project.ui_project_start_failure(texts)))
		qdel(project)
		return

	project.bloodpool = src
	project.initiator = human_user
	project.initiator_clan = human_user.clan
	project.on_start(human_user)

	active_projects[project_type] = project
	to_chat(user, span_greentext(format_crucible_text(messages["project_started"], list("project" = project.ui_project_name(texts)))))
	SStgui.update_uis(src)

/obj/structure/vampire/bloodpool/proc/deposit_blood_to_cup(mob/living/user, list/texts)
	if(!istype(user))
		return

	var/list/messages = texts["messages"]
	var/is_vampire = is_crucible_vampire(user)
	var/max_deposit = get_max_cup_deposit(user)
	if(!can_accept_cup_deposit(user, max_deposit, is_vampire))
		if(get_cup_space() <= 0)
			to_chat(user, span_warning(messages["cup_full"]))
		else if(is_vampire)
			to_chat(user, span_warning(format_crucible_text(messages["reserve"], list("reserve" = CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE))))
		else
			to_chat(user, span_warning(format_crucible_text(messages["min_donation"], list("amount" = CRUCIBLE_MIN_DONATION))))
		return

	var/deposit = max_deposit
	if(is_vampire)
		deposit = tgui_input_number(user, format_crucible_text(messages["deposit_prompt"], list("amount" = max_deposit)), texts["window_title"], max_deposit, max_deposit, 1)
		if(!deposit || QDELETED(src) || QDELETED(user))
			return
		if(get_dist(user, src) > 1 || !is_crucible_vampire(user))
			return

	max_deposit = get_max_cup_deposit(user)
	if(!can_accept_cup_deposit(user, max_deposit, is_vampire))
		return
	deposit = clamp(round(deposit), 1, max_deposit)
	if(deposit < 1)
		return

	var/blood_cost = 0
	if(is_vampire)
		user.adjust_bloodpool(-deposit)
	else
		blood_cost = get_blood_cost_for_vitae(deposit)
		if(user.blood_volume - blood_cost < CRUCIBLE_MIN_DONOR_BLOOD)
			to_chat(user, span_warning(format_crucible_text(messages["not_enough_blood"], list("amount" = CRUCIBLE_MIN_DONOR_BLOOD))))
			return
		var/bloodpool_cost = get_nonvampire_bloodpool_cost_for_vitae(deposit)
		user.bloodpool = max(get_nonvampire_crucible_bloodpool(user, user.bloodpool) - bloodpool_cost, 0)
		user.blood_volume = max(user.blood_volume - blood_cost, CRUCIBLE_MIN_DONOR_BLOOD)
		clear_nonvampire_vitae_snapshot(user)

	current = min(current + deposit, CRUCIBLE_MAX_BLOOD)
	if(is_vampire)
		to_chat(user, span_greentext(format_crucible_text(messages["deposit_vampire_success"], list("amount" = deposit, "current" = current, "max" = CRUCIBLE_MAX_BLOOD))))
	else
		to_chat(user, span_userdanger(messages["drain_warning"]))
		to_chat(user, span_greentext(format_crucible_text(messages["deposit_mortal_success"], list("amount" = deposit, "current" = current, "max" = CRUCIBLE_MAX_BLOOD))))
	SStgui.update_uis(src)

/obj/structure/vampire/bloodpool/proc/contribute_to_project(datum/vampire_project/project, mob/living/user, list/texts)
	var/project_type = get_active_project_type(project)
	if(!project_type)
		return

	var/list/messages = texts["messages"]
	var/max_contribution = get_project_max_contribution(project, user)
	var/is_vampire = is_crucible_vampire(user)
	if(!can_accept_vitae_contribution(project, max_contribution, is_vampire))
		if(is_vampire)
			if(user.bloodpool <= CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE)
				to_chat(user, span_warning(format_crucible_text(messages["reserve"], list("reserve" = CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE))))
			else
				to_chat(user, span_warning(messages["no_contribution"]))
		else
			to_chat(user, span_warning(format_crucible_text(messages["min_donation"], list("amount" = CRUCIBLE_MIN_DONATION))))
		return

	var/project_name = project.ui_project_name(texts)
	var/contribution = max_contribution
	if(is_vampire)
		contribution = tgui_input_number(user, format_crucible_text(messages["contribute_prompt"], list("project" = project_name, "amount" = max_contribution)), texts["window_title"], max_contribution, max_contribution, 1)
		if(!contribution || QDELETED(src) || QDELETED(project))
			return
		if(active_projects[project_type] != project || get_dist(user, src) > 1)
			return
		max_contribution = get_project_max_contribution(project, user)
		contribution = clamp(round(contribution), 1, max_contribution)
		if(contribution < 1)
			return

	var/blood_cost = 0
	if(!is_vampire)
		blood_cost = get_blood_cost_for_vitae(contribution)
		if(user.blood_volume - blood_cost < CRUCIBLE_MIN_DONOR_BLOOD)
			to_chat(user, span_warning(format_crucible_text(messages["not_enough_blood"], list("amount" = CRUCIBLE_MIN_DONOR_BLOOD))))
			return

	if(get_available_vitae_for_contribution(user, is_vampire) < contribution)
		to_chat(user, span_warning(messages["not_enough_vitae"]))
		return

	var/cup_contribution = 0
	var/personal_contribution = contribution
	if(is_vampire && is_crucible_lord(user))
		cup_contribution = min(current, contribution)
		personal_contribution = contribution - cup_contribution

	if(is_vampire)
		if(personal_contribution > get_vampire_personal_vitae_for_crucible(user))
			to_chat(user, span_warning(messages["not_enough_vitae"]))
			return
		current = max(current - cup_contribution, 0)
		if(personal_contribution > 0)
			user.adjust_bloodpool(-personal_contribution)
	else
		var/bloodpool_cost = get_nonvampire_bloodpool_cost_for_vitae(contribution)
		user.bloodpool = max(get_nonvampire_crucible_bloodpool(user, user.bloodpool) - bloodpool_cost, 0)
	if(!is_vampire)
		user.blood_volume = max(user.blood_volume - blood_cost, CRUCIBLE_MIN_DONOR_BLOOD)
		clear_nonvampire_vitae_snapshot(user)
	project.paid_amount += contribution
	project.cup_paid_amount += cup_contribution
	if(!(user in project.contributors))
		project.contributors += user

	if(is_vampire)
		if(cup_contribution > 0)
			to_chat(user, span_greentext(format_crucible_text(messages["contribute_lord_success"], list("amount" = contribution, "project" = project_name, "cup" = cup_contribution, "personal" = personal_contribution, "paid" = project.paid_amount, "cost" = project.total_cost))))
		else
			to_chat(user, span_greentext(format_crucible_text(messages["contribute_vampire_success"], list("amount" = contribution, "project" = project_name, "paid" = project.paid_amount, "cost" = project.total_cost))))
	else
		to_chat(user, span_userdanger(messages["drain_warning"]))
		if(project.paid_amount >= project.total_cost)
			to_chat(user, span_greentext(format_crucible_text(messages["contribute_mortal_complete"], list("project" = project_name))))
		else
			to_chat(user, span_greentext(format_crucible_text(messages["contribute_mortal_progress"], list("project" = project_name, "paid" = project.paid_amount, "cost" = project.total_cost))))
	if(project.paid_amount >= project.total_cost)
		complete_project(project_type)
	else
		SStgui.update_uis(src)

/obj/structure/vampire/bloodpool/proc/start_new_project(project_type, mob/living/user)
	var/datum/vampire_project/project = new project_type()

	if(!project.can_start(user, src))
		to_chat(user, span_warning(project.start_failure_message))
		qdel(project)
		return

	if(!project.confirm_start(user))
		qdel(project)
		return

	project.bloodpool = src
	project.initiator = user
	project.initiator_clan = user.clan
	project.on_start(user)

	active_projects[project_type] = project

	to_chat(user, span_greentext("Started project: [project.display_name]. Begin contributing vitae to progress."))

/obj/structure/vampire/bloodpool/proc/handle_project_contribution(mob/living/user)
	if(!active_projects.len)
		to_chat(user, span_warning("No active projects to contribute to."))
		return

	var/list/project_choices = list()
	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		var/remaining = project.total_cost - project.paid_amount
		project_choices["[project.display_name] (Remaining: [remaining])"] = project_type

	var/choice = input(user, "Select project to contribute to:", "CONTRIBUTION") as null|anything in project_choices
	if(!choice)
		return

	var/project_type = project_choices[choice]
	var/datum/vampire_project/project = active_projects[project_type]

	project.handle_contribution(user)

/obj/structure/vampire/bloodpool/proc/handle_project_management(mob/living/user)
	if(!active_projects.len)
		to_chat(user, span_warning("No active projects to manage."))
		return

	var/list/project_options = list()
	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		var/progress_percent = round((project.paid_amount / project.total_cost) * 100, 1)
		project_options["[project.display_name] ([progress_percent]%)"] = project_type

	var/choice = input(user, "Select project to manage:", "PROJECT MANAGEMENT") as null|anything in project_options
	if(!choice)
		return

	var/project_type = project_options[choice]
	var/datum/vampire_project/project = active_projects[project_type]

	var/action = input(user, "What would you like to do?", "MANAGEMENT") as null|anything in list("View Details", "Cancel Project")

	switch(action)
		if("View Details")
			project.show_details(user)
		if("Cancel Project")
			if(alert(user, "Cancel [project.display_name]?<BR>All invested vitae will be refunded.", "CANCELLATION", list("Yes", "No")) == "Yes")
				cancel_project(project_type)

/obj/structure/vampire/bloodpool/proc/complete_project(project_type)
	var/datum/vampire_project/project = active_projects[project_type]
	if(!project)
		return

	for(var/mob/living/contributor in project.contributors)
		var/list/texts = get_crucible_texts(contributor)
		var/list/messages = texts["messages"]
		to_chat(contributor, span_boldannounce(format_crucible_text(messages["project_complete_announce"], list("project" = project.ui_project_name(texts)))))
		contributor.playsound_local(get_turf(src), project.completion_sound, 100, FALSE, pressure_affected = FALSE)

	project.on_complete(src)

	active_projects.Remove(project_type)
	qdel(project)
	SStgui.update_uis(src)

/obj/structure/vampire/bloodpool/proc/cancel_project(project_type)
	var/datum/vampire_project/project = active_projects[project_type]
	if(!project)
		return

	project.on_cancel()

	active_projects.Remove(project_type)
	qdel(project)
	SStgui.update_uis(src)

/datum/vampire_project
	var/display_name = "Unknown Project"
	var/description = "A mysterious undertaking."
	var/total_cost = 1000
	var/paid_amount = 0
	var/cup_paid_amount = 0
	var/list/contributors = list()
	var/obj/structure/vampire/bloodpool/bloodpool
	var/mob/living/initiator
	var/datum/clan/initiator_clan
	var/start_failure_message = "This project cannot be started."
	var/completion_sound = 'sound/misc/batsound.ogg'
	var/can_be_initiated_by = INITIATE_LORDE

/datum/vampire_project/proc/ui_project_name(list/texts = null)
	if(islist(texts))
		var/list/project_names = texts["project_names"]
		if(islist(project_names) && project_names[display_name])
			return project_names[display_name]
	return display_name

/datum/vampire_project/proc/ui_project_description(list/texts = null)
	if(islist(texts))
		var/list/project_descriptions = texts["project_descriptions"]
		if(islist(project_descriptions) && project_descriptions[display_name])
			return project_descriptions[display_name]
	return description

/datum/vampire_project/proc/ui_project_start_failure(list/texts = null)
	if(islist(texts))
		var/list/start_failures = texts["start_failures"]
		if(islist(start_failures) && start_failures[start_failure_message])
			return start_failures[start_failure_message]
		var/list/messages = texts["messages"]
		if(islist(messages) && messages["start_failure_default"])
			return messages["start_failure_default"]
	return start_failure_message

/datum/vampire_project/proc/can_start(mob/living/carbon/human/user, obj/structure/vampire/bloodpool/pool, silent = FALSE)
	if(!istype(user) || !istype(pool))
		return FALSE

	if(can_be_initiated_by == INITIATE_ANYONE)
		return TRUE
	else if(can_be_initiated_by == INITIATE_LORDE)
		if(user.clan?.clan_leader == user)
			return TRUE
		else
			if(!silent)
				to_chat(user, span_warning("This project can only be initiated by your Lorde."))
			return FALSE

	return TRUE

/datum/vampire_project/proc/confirm_start(mob/living/user)
	return alert(user, "Begin [display_name]? [description]. Total Cost: [total_cost].You can contribute vitae over time.", "PROJECT START", "MAKE IT SO", "I RESCIND") == "MAKE IT SO"

/datum/vampire_project/proc/on_start(mob/living/user)
	return

/datum/vampire_project/proc/handle_contribution(mob/living/user)
	var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	var/max_contribution = min(user.bloodpool, total_cost - paid_amount)
	if(!lord)
		if(display_name != "Wicked Plate" || display_name != "World Anchor")
			max_contribution = min(user.bloodpool, (total_cost - paid_amount) - 100)

	var/contribution = input(user, "How much vitae to contribute? (Max: [max_contribution])", "CONTRIBUTION") as num|null

	//setting this to 1, since you don't want fractions below 1
	if(!contribution || contribution < 1)
		return

	//setting this to 0, when it was at 1 it was just giving free vitae if it was less than 1 but a 
	contribution = clamp(contribution, 0, max_contribution)

	if(user.bloodpool < contribution)
		to_chat(user, span_warning("I do not have enough vitae."))
		return

	user.adjust_bloodpool(-contribution)
	paid_amount += contribution

	if(!(user in contributors))
		contributors += user

	to_chat(user, span_greentext("Contributed [contribution] vitae to [display_name]. ([paid_amount]/[total_cost])"))

	if(paid_amount >= total_cost)
		bloodpool.complete_project(type)

/datum/vampire_project/proc/show_details(mob/living/user)
	to_chat(user, span_notice("Project: [display_name]"))
	to_chat(user, span_notice("Description: [description]"))
	to_chat(user, span_notice("Progress: [paid_amount]/[total_cost]"))
	to_chat(user, span_notice("Contributors: [english_list(contributors)]"))

/datum/vampire_project/proc/on_complete()
	return

/datum/vampire_project/proc/on_cancel()
	var/cup_refund = min(cup_paid_amount, paid_amount)
	if(cup_refund > 0 && istype(bloodpool))
		bloodpool.current = min(bloodpool.current + cup_refund, CRUCIBLE_MAX_BLOOD)

	var/total_refund = max(paid_amount - cup_refund, 0)
	if(total_refund <= 0 || !length(contributors))
		return

	var/refund_amount = total_refund / contributors.len
	for(var/mob/living/contributor in contributors)
		contributor.adjust_bloodpool(refund_amount)
		if(istype(bloodpool))
			var/list/texts = bloodpool.get_crucible_texts(contributor)
			var/list/messages = texts["messages"]
			to_chat(contributor, span_notice(bloodpool.format_crucible_text(messages["refund_notice"], list("amount" = refund_amount, "project" = ui_project_name(texts)))))
		else
			to_chat(contributor, span_notice("Received [refund_amount] vitae refund from cancelled project: [display_name]"))

// Specific project types
/datum/vampire_project/power_growth
	display_name = "Rite of Stirring"
	description = "The ancient blood stirs once more. Forgotten whispers echo through the marrow of the land. (+2 to all lorde stats + 1000 lorde vitae pool limit + Unlocks Champions)"
	total_cost = VAMPCOST_ONE
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth/can_start(mob/living/user, obj/structure/vampire/bloodpool/pool)
	var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
	return lord && !lord.ascended

/datum/vampire_project/power_growth/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("My power grows through collective sacrifice."))
			to_chat(user, span_warning("I should grow my dominion, so that I shall gain more power through collective sacrifice.")) //Subtle Que for Newer players, to convert/buy servants
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.maxbloodpool += 1000
			bloodpool.available_project_types += /datum/vampire_project/servant/servant_t3 //Stronger commander roles, cheapened so they're locked behind first upgrade rite as to encourage sending them out to thrall people.
			bloodpool.available_project_types -= /datum/vampire_project/power_growth
			bloodpool.available_project_types += /datum/vampire_project/power_growth_2
			break

/datum/vampire_project/power_growth_2
	display_name = "Rite of Reclamation"
	description = "Strength long sealed returns. The soil, the stone, and the shadows bend again to their rightful master. (+2 to all lorde stats + 1000 lorde vitae pool limit + Unlocks armor rites.)"
	total_cost = VAMPCOST_TWO
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_2/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("My power grows through collective sacrifice."))
			to_chat(user, span_warning("I should further develop my vampiric potencies and regain my ancient set of armor.")) //Subtle Que for Newer players, that despite the next upgrade seeming quite close, you should invest into potencies + armor for later.
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			lord_body.maxbloodpool += 1000
			bloodpool.available_project_types += /datum/vampire_project/armor_crafting
			bloodpool.available_project_types -= /datum/vampire_project/power_growth_2
			bloodpool.available_project_types += /datum/vampire_project/power_growth_3
			break

/datum/vampire_project/power_growth_3
	display_name = "Rite of Dominion"
	description = "The veil of time shreds. The Elder's will pours forth, binding trespassers within the grasp of the Land. (+2 to all lorde stats + 1000 lorde vitae pool limit.)"
	total_cost = VAMPCOST_THREE
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_3/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			to_chat(user, span_greentext("My power grows through collective sacrifice, I am nearing completion."))
			to_chat(user, span_warning("I am stronger than ever, I am now immune to grabs.")) //Trait hints
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			ADD_TRAIT(lord_body, TRAIT_GRABIMMUNE, TRAIT_GENERIC) //You're reaching solo-antagonist levels of godhood here.
			lord_body.maxbloodpool += 1000
			bloodpool.available_project_types -= /datum/vampire_project/power_growth_3
			bloodpool.available_project_types += /datum/vampire_project/power_growth_4
			break

/datum/vampire_project/power_growth_4
	display_name = "Rite of Sovereignty"
	description = "The Lord is whole. Ancient power saturates every stone and vein, for the Land and its master are one. (+2 to all stats for thralls +2 to lorde + 1000 lorde and thrall vitae pool limit. Kills the Sun and loudly announces your presence.)"
	total_cost = VAMPCOST_FOUR
	completion_sound = 'sound/misc/batsound.ogg'

/datum/vampire_project/power_growth_4/on_complete()
	// Find nearby vampire lords who can level up
	for(var/mob/living/user in range(1, bloodpool))
		var/datum/antagonist/vampire/lord/lord = user.mind?.has_antag_datum(/datum/antagonist/vampire/lord)
		if(lord && !lord.ascended)
			var/mob/living/carbon/human/lord_body = user
			for(var/S in MOBSTATS)
				lord_body.change_stat(S, 2)
			ADD_TRAIT(lord_body, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC) //I mean, you worked for it. You're now the OG vlord once more, go nuts! The lorde of mass-fragging once more.
			ADD_TRAIT(lord_body, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC) //Kneestinger + other shock sources resistance. Far less hardstuns at this point will stop them.
			SSticker.sunsteal(initiator_clan?.clan_leader) //Universally ensures the town knows a literal calamity is about to show up.
			lord_body.maxbloodpool += 1000
			to_chat(user, span_userdanger("I AM ANCIENT, I AM THE LAND. EVEN THE SUN BOWS TO ME.")) //SEND WORD. THE END IS HERE.
			to_chat(user, span_warning("I will no longer tire nor feel, stamina will no longer affect me, shocks will no longer affect me.")) //Trait hints
			lord.ascended = TRUE
			var/list/all_subordinates = user.clan_position.get_all_subordinates()
			for(var/mob/living/carbon/human/subordinate_body  in all_subordinates)
				subordinate_body.maxbloodpool += 1000
				for(var/S in MOBSTATS)
					subordinate_body.change_stat(S, 2)

			bloodpool.available_project_types -= /datum/vampire_project/power_growth_4
			break

/datum/vampire_project/armor_crafting
	display_name = "Wicked Plate"
	description = "Summon a complete set of vampiric plate armor from crystallized blood. Let not steel, silver, nor salvation inhibit the Lord's plan. This can only be done once."
	total_cost = ARMOR_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/armor_crafting/on_complete(atom/movable/creation_point)
	new /obj/item/clothing/under/roguetown/platelegs/vampire (bloodpool.loc)
	new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/vampire (bloodpool.loc)
	new /obj/item/clothing/suit/roguetown/armor/plate/vampire (bloodpool.loc)
	new /obj/item/clothing/shoes/roguetown/boots/armor/vampire (bloodpool.loc)
	new /obj/item/clothing/head/roguetown/helmet/heavy/vampire (bloodpool.loc)
	new /obj/item/clothing/gloves/roguetown/chain/vampire (bloodpool.loc)
	new /obj/item/clothing/wrists/roguetown/bracers/paalloy/vampire (bloodpool.loc)
	new /obj/item/clothing/neck/roguetown/gorget/paalloy/vampire (bloodpool.loc)
	creation_point.visible_message(span_notice("A complete set of plate armor materializes from the crimson crucible."))

	bloodpool.available_project_types -= /datum/vampire_project/armor_crafting //ONE TIME RITUAL ONLY, we do not want this handed out en-mass.

//CURRENTLY DISABLED AS A SEPERATE RITE, MOVED TO FULL POWER
///datum/vampire_project/sunsteal
//	display_name = "Steal the Sun"
//	description = "The scorching gaze of the Sun-Tyrant shall hamper our plans no more. This project can only be initiated by your Lorde. (Permanent night until the lord dies, most may see this as a declaration of war.)"
//	total_cost = SUN_STEAL_COST
//	completion_sound = 'sound/misc/vcraft.ogg'
//	can_be_initiated_by = INITIATE_LORDE
//
///datum/vampire_project/sunsteal/on_complete(atom/movable/creation_point)
//	var/obj/structure/vampire/bloodpool/bloodpool = creation_point
//	if(!istype(bloodpool))
//		return
//
//	SSticker.sunsteal(initiator_clan?.clan_leader)

/datum/vampire_project/servant/proc/summon(type, atom/feedback_atom)
	feedback_atom.visible_message("The crucible stirs, summoning a servant from the realms beyond...")
	var/list/candidates = pollGhostCandidates("Do you want to play as a Vampire Lord's [type]?", ROLE_VAMPIRE_SUMMON, null, null, 30 SECONDS, POLL_IGNORE_VL_SERVANT)
	if(!LAZYLEN(candidates))
		feedback_atom.visible_message("But alas, the depths are hollow...")
		return FALSE

	var/mob/C = pick(candidates)
	if(!C || !istype(C, /mob/dead))
		feedback_atom.visible_message("But alas, the depths are hollow...")
		return FALSE

	. = TRUE

	if(istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	var/mob/living/carbon/human/species/human/northern/target = new /mob/living/carbon/human/species/human/northern(get_turf(feedback_atom))
	target.key = C.key
	target.visible_message(span_warning("[target] manifests from the crimson crucible in a kneel, before rising upwards."))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, load_char_or_namechoice)), 3 SECONDS)
	switch(type)
		if("Vampire Servant")
			SSjob.EquipRank(target, "Vampire Servant", TRUE) //Labor non-combat roles, they still have some vampyric Progression and can become semi-combat roles.
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_NEONATE) //GENERATION_THINBLOOD is intentionally removed
			target.mind.add_antag_datum(new_antag)
		if("Vampire Guard")
			SSjob.EquipRank(target, "Vampire Guard", TRUE) //Combat-focused roles, they can level vampyric powers partly to become pretty scary to fight.
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_NEONATE)
			target.mind.add_antag_datum(new_antag)
		if("Vampire Spawn")
			SSjob.EquipRank(target, "Vampire Spawn", TRUE) //Rare and powerful champions, they can level vampyric powers to become minibosses, alongside siring 5 additional vampyres of a lower generation.
			var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = GENERATION_ANCILLAE)
			target.mind.add_antag_datum(new_antag)
	ADD_TRAIT(target, TRAIT_BLOODPOOL_BORN, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_DUSTABLE, TRAIT_GENERIC) //They cannot be cured unlike sired vampires, so we let them just dust on death. They get good enough skills to make up for it, less back and forth with revival checking "hey can I cure this one?".

/datum/vampire_project/servant/servant_t1
	display_name = "Summon Vampyre Servant"
	description = "A loyal servant to do your chores and labors for you and your thralls, from toiling the forges below, to tending the manor and trivial tasks. (Generation: Neonate - Can sire 1 Thinblood - 9RP)"
	total_cost = SERVANT_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t1/on_complete(obj/structure/vampire/bloodpool/creation_point)
	if(!summon("Vampire Servant", creation_point))
		on_cancel()

/datum/vampire_project/servant/servant_t2
	display_name = "Summon Vampyre Guard"
	description = "A loyal servant to fight for your cause or defend your manor, be it wit blade and shield, bow and arrow or wit and magicks. (Generation: Neonate - Can sire 1 Thinblood - 9RP)"
	total_cost = SERVANT_T2_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t2/on_complete(obj/structure/vampire/bloodpool/creation_point)
	if(!summon("Vampire Guard", creation_point))
		on_cancel()

/datum/vampire_project/servant/servant_t3
	display_name = "Summon Vampyre Champion"
	description = "A loyal, highly talented and powerful champion to herald your army of darkness, or disrupt mortalkynd from the shadows. (Generation: Ancillae - Can sire 5 Neonites - 17RP)."
	total_cost = SERVANT_T3_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/servant/servant_t3/on_complete(obj/structure/vampire/bloodpool/creation_point)
	if(!summon("Vampire Spawn", creation_point))
		on_cancel()

#undef VAMPCOST_ONE
#undef VAMPCOST_TWO
#undef VAMPCOST_THREE
#undef VAMPCOST_FOUR
#undef ARMOR_COST
#undef SUN_STEAL_COST
#undef SERVANT_COST
#undef SERVANT_T2_COST
#undef SERVANT_T3_COST

#undef CRUCIBLE_MAX_BLOOD
#undef CRUCIBLE_MIN_DONOR_BLOOD
#undef CRUCIBLE_MIN_DONATION
#undef CRUCIBLE_VAMPIRE_BLOODPOOL_RESERVE
#undef CRUCIBLE_DONATION_VITAE
#undef CRUCIBLE_DONATION_BLOOD

#undef INITIATE_LORDE
#undef INITIATE_ANYONE
