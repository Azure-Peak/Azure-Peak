//Graggarite shrine
/datum/crafting_recipe/roguetown/structure/zizo_shrine/graggar
	name = "Shrine of Blood"
	always_availible = FALSE	//Has unique assign for certain roles.
	reqs = list(
		/obj/item/bodypart = 2,
		/obj/item/organ/stomach = 1,
	)
	result = /obj/structure/fluff/psycross/zizocross/graggar
	verbage_simple = "construct"
	verbage = "constructs"
	craftsound = 'sound/foley/Building-01.ogg'

/obj/structure/fluff/psycross/zizocross/graggar
	name = "shrine of blood"
	desc = "What a disgusting thing, what type of maniac would make this!?"
	icon = 'icons/roguetown/maniac/creations.dmi'
	icon_state = "creation1"
	divine = FALSE

/datum/faith/inhumen
	name = "Ascendents"
	translated_name = "Вознесенные"
	desc = "<b>Святая Экклезиархия</b>, также известая среди последователей Десяти как <b>пантеон Презренных</b> — совокупность из трёх религиозных течений, сосредоточенных вокруг идеологий тех, кого называют <b>Вознесёнными</b>. Некогда бывшие смертными, Вознесённые овладели божественными силами, выкрав осколки падшего <b>Всеотца</b> в неразберихе <b>Войны в Небесах</b>.\n\
		Идеологии Презренных различны и противоречивы, и хотя при смертной жизни они были товарищами, последователи Трёх могут как действовать сообща, так и против друг друга — их объединяет лишь ненависть к мировому порядку, поддерживаемому Десятью."
	worshippers = "Отвергнутые церковью Десяти, радикалы, нонкомформисты."
	godhead = /datum/patron/inhumen/baotha

/datum/patron/inhumen
	profane_words = list(
		"хуй", "хуя", "хую", "хуем", "хуе",
		"хер", "хера", "херу", "хером", "хере",
		"хрен", "хрена", "хрену", "хреном", "хрене",
		"бля", "бляди", "бляде", "бляду", "блядью", "бляде",
		"пизда", "пизды", "пизде", "пизду", "пиздой", "пизде",
		"жопа", "жопы", "жопе", "жопу", "жопой",
		"сучка", "сучки", "сучке", "сучку", "сучкой", "сучке",
		"мудило", "мудила", "мудиле", "мудилу", "мудилом", "мудиле",
		"пидор", "пидора", "пидору", "пидором", "пидоре",
		"блядь", "бляди", "бляди", "блядь", "блядью", "бляде",
		"хуила", "хуила", "хуиле", "хуилу", "хуилой", "хуиле",
		"уебище", "уебище", "уебище", "уебище", "уебищем", "уебище",
		"мудак", "мудака", "мудаку", "мудака", "мудаком", "мудаке",
		"хуесос", "хуесоса", "хуесосу", "хуесоса", "хуесосом", "хуесосе",
		"шлюха", "шлюхи", "шлюхе", "шлюху", "шлюхой", "шлюхе",
		"сука", "суки", "суке", "суку", "сукой", "суке",
		"ебать", "ебаный", "ебать", "ебать", "ебаным", "ебать",
		"залупа", "залупы", "залупе", "залупу", "залупой", "залупе",
		"залупенец", "залупенца", "залупенцу", "залупенца", "залупенцем", "залупенце"
	)

/datum/patron/inhumen/zizo
	name = "Zizo"
	translated_name = "Зизо"
	rusgodnames = list(
		"Зизо", "Зизо", "Зизо", "Зизо", "Зизо", "Зизо",
		"Несущая Спасение", "Несущей Спасения", "Несущей Спасению", "Несущую Спасение", 
		"Несущей Спасением", "Несущей Спасении",
		"Госпожа Тьмы", "Госпожи Тьмы", "Госпоже Тьмы", "Госпожу Тьмы", 
		"Госпожой Тьмы", "Госпоже Тьмы",
		"Дева Ночи", "Девы Ночи", "Деве Ночи", "Деву Ночи", 
		"Девой Ночи", "Деве Ночи",
		"Дама Прогресса", "Дамы Прогресса", "Даме Прогресса", "Даму Прогресса", 
		"Дамой Прогресса", "Даме Прогресса",
		"Паучья Леди", "Паучьей Леди", "Паучьей Леди", "Паучью Леди", 
		"Паучьей Леди", "Паучьей Леди",
		"Плетущая", "Плетущей", "Плетущей", "Плетущую", 
		"Плетущей", "Плетущей",
		"Ткачиха", "Ткачихи", "Ткачихе", "Ткачиху", 
		"Ткачихой", "Ткачихе"
)

	domain = "Бессмертие, прогресс, кровь, тьма, запретные знания, амбиции."
	desc = "Богиня нежизни, возмездия, метаморфозы и тьмы. Убийца Псайдона, Архивраг пантеона Десяти, презираемая всеми, кроме своих последователей, сама Зизо не видит в смертных объект своей ненависти. Это прекрасно демонстрируется ее главной заповедью, что часто звучит в молитвенных песнопениях её культистов: «Последний же враг истребится — смерть»."
	associated_faith = /datum/faith/cult_of_salvation
	worshippers = "Дроу-лоялисты, некроманты, чародеи, исследователи и практиканты тёмных аспектов магии, некоторые кланы высших вампиров, нежить."
	confess_lines = list(
		"ХВАЛА ЗИЗО!",
		"ДА ЗДРАВСТВУЕТ ЗИЗО!",
		"ЗИЗО СПАСЕТ НАС ОТ СТРАДАНИЙ!",
	)

/datum/patron/inhumen/graggar
	name = "Graggar"
	translated_name = "Граггар"
	rusgodnames = list(
		"Граггар", "Граггара", "Граггару", "Граггара", "Граггаром", "Граггаре",
		"Кровавый Бог", "Кровавого Бога", "Кровавому Богу", "Кровавого Бога", 
		"Кровавым Богом", "Кровавом Боге",
		"Зверь", "Зверя", "Зверю", "Зверя", "Зверем", "Звере",
		"Черное Солнце", "Черного Солнца", "Черному Солнцу", "Черное Солнце", 
		"Черным Солнцем", "Черном Солнце",
		"Проклятая Звезда", "Проклятой Звезды", "Проклятой Звезде", "Проклятую Звезду", 
		"Проклятой Звездой", "Проклятой Звезде",
		"Черное Колесо", "Черного Колеса", "Черному Колесу", "Черное Колесо", 
		"Черным Колесом", "Черном Колесе"
	)

	domain = "Власть, сила, превосходство, завоевание."
	desc = "Бог силы и власти, которая приходит с нею. Пока другие божества обрекают свою паству на жалкое существование в мире, где власть приходит через их благословение и по праву рождения, Граггар провозглашает, что править может каждый, кто достаточно силен, чтобы забрать желаемое. «Слабые унаследуют лишь грязь», предупреждает он, напоминая о судьбе тех, кто не стремится стать сильнее."
	undead_hater = TRUE
	crafting_recipes = list(/datum/crafting_recipe/roguetown/structure/zizo_shrine/graggar)
	worshippers = "Племенные народы, безумцы, маньяки, жестокий люд."
	confess_lines = list(
		"ГРАГГАР - ЗВЕРЬ, КОТОРОМУ Я ПОКЛОНЯЮСЬ!",
		"ЧЕРЕЗ ПРЕВОСХОДСТВО - К БОЖЕСТВЕННОСТИ!",
		"ЧЁРНОЕ СОЛНЦЕ ТРЕБУЕТ КРОВИ!",
	)

/datum/patron/inhumen/matthios
	name = "Matthios"
	translated_name = "Маттиос"
	rusgodnames = list(
		"Маттиос", "Маттиоса", "Маттиосу", "Маттиоса", "Маттиосом", "Маттиосе",
		"Свободный", "Свободного", "Свободному", "Свободного", 
		"Свободным", "Свободном",
		"Разбивающий Оковы", "Разбивающего Оковы", "Разбивающему Оковы", 
		"Разбивающего Оковы", "Разбивающим Оковами", "Разбивающем Оковах",
		"Отец Свободы", "Отца Свободы", "Отцу Свободы", "Отца Свободы", 
		"Отцом Свободы", "Отце Свободы",
		"Отец", "Отца", "Отцу", "Отца", "Отцом", "Отце",
		"Батюшка", "Батюшки", "Батюшке", "Батюшку", "Батюшкой", "Батюшке",
		"Господин Ничего", "Господина Ничего", "Господину Ничего", 
		"Господина Ничего", "Господином Ничего", "Господине Ничего",
		"Ведущий", "Ведущего", "Ведущему", "Ведущего", "Ведущим", "Ведущем",
		"Факел", "Факела", "Факелу", "Факел", "Факелом", "Факеле",
		"Несущий Свет", "Несущего Света", "Несущему Свету", "Несущего Света", 
		"Несущим Светом", "Несущем Свете",
		"Разрушитель Оков", "Разрушителя Оков", "Разрушителю Оков", 
		"Разрушителя Оков", "Разрушителем Оков", "Разрушителе Оков"
	)

	domain = "Анархия, свобода, революция, равенство и братство."
	desc = "Бог абсолютной свободы, анархии и восстания. «Через раздор к процветанию», обещает его главная заповедь, и его последователи пойдут на всё, чтобы претворить её в реальность, разрушив мировой порядок, каким мы его знаем."
	undead_hater = TRUE
	crafting_recipes = list()
	worshippers = "Разбойники, наёмники, революционеры, свободолюбивый люд."
	confess_lines = list(
		"ВСЕ ТИРАНЫ УМРУТ В ОДИНОЧЕСТВЕ!",
		"ПУТЬ К ПРОЦВЕТАНИЮ ЛЕЖИТ ЧЕРЕЗ РАЗДОР!",
		"МЫ СРАВНЯЕМ ЦЕРКВИ И ТЮРЬМЫ С ЗЕМЛЕЙ!",
	)

/datum/patron/inhumen/baotha
	name = "Baotha"
	translated_name = "Баота"
	rusgodnames = list(
		"Баота", "Баоты", "Баоте", "Баоту", "Баотой", "Баоте",
		"Наслаждающаяся", "Наслаждающейся", "Наслаждающейся", "Наслаждающуюся", 
		"Наслаждающейся", "Наслаждающейся",
		"Дарующая Удовольствие", "Дарующей Удовольствие", "Дарующей Удовольствию", 
		"Дарующую Удовольствие", "Дарующей Удовольствием", "Дарующей Удовольствии",
		"Страждущая", "Страждущей", "Страждущей", "Страждущую", 
		"Страждущей", "Страждущей",
		"Утешительница", "Утешительницы", "Утешительнице", "Утешительницу", 
		"Утешительницей", "Утешительнице"
	)

	domain = "Гедонизм, мирские удовольствия, индивидуализм."
	desc = "Баота — богиня гедонизма, мирских наслаждений и страстей. «Живи, люби, смейся!» — говорила она, глядя на суету вокруг себя и усилия окружающих, стремящихся двигать куда-то мир."
	worshippers = "Избалованные богачи, маргиналы, эскаписты."
	undead_hater = TRUE
	crafting_recipes = list()
	confess_lines = list(
		"БАОТА ТРЕБУЕТ УДОВОЛЬСТВИЯ!",
		"ЖИВИ, СМЕЙСЯ, ЛЮБИ!",
		"БАОТА - МОЯ РАДОСТЬ!",
	)

/////////////////////////////////
// Does God Hear Your Prayer ? //
/////////////////////////////////

/datum/patron/proc/can_pray_inhumen(mob/living/follower)
	SHOULD_CALL_PARENT(TRUE)
	// Allows death-bed prayers
	if(follower.has_status_effect(STATUS_EFFECT_UNCONSCIOUS))
		if(follower.has_status_effect(STATUS_EFFECT_SLEEPING))
			to_chat(follower, span_danger("I mustn't be sleeping to pray!"))
			return FALSE	//Stops praying just by sleeping.
	. = TRUE

// Graggar - When bleeding, near blood on ground, zchurch, bad-cross, or ritual chalk
/datum/patron/inhumen/graggar/can_pray_inhumen(mob/living/follower)
	. = ..()
	// Allows prayer in the Zzzzzzzurch(!)
	if(istype(get_area(follower), /area/rogue/indoors/shelter/mountains))
		return TRUE
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That acursed cross interupts my prayers!"))
			return FALSE
	for(var/obj/structure/fluff/psycross/zizocross/graggar/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("This altar has been corrupted by the Ten! It blocks my prayers!"))
			return FALSE
		return TRUE
	// Allows prayer if actively bleeding.
	if(follower.bleed_rate > 0)
		return TRUE
	// Allows prayer near blood.
	for(var/obj/effect/decal/cleanable/blood in view(3, get_turf(follower)))
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/graggar in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Graggar to hear my prayers I must either be in the church of the abandoned, near an altar dedicated to Him, near fresh blood or draw blood of my own!"))
	return FALSE

// Matthios - Basically any way you'd like really, so long as there are comrades with you
/datum/patron/inhumen/matthios/can_pray_inhumen(mob/living/follower)
	. = ..()
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That acursed cross interupts my prayers!"))
			return FALSE
	for(var/mob/living/carbon/human/comrade in view(4, get_turf(follower)))
		if(istype(comrade.patron, /datum/patron/inhumen/matthios))
			return TRUE
	to_chat(follower, span_danger("Matthios will hear any prayer I offer, so long as I have at least one comrade near me!"))
	return FALSE

// Baotha 
/datum/patron/inhumen/baotha/can_pray_inhumen(mob/living/follower)
	. = ..()
	for(var/obj/structure/fluff/psycross/cross in view(4, get_turf(follower)))
		if(cross.divine == TRUE)
			to_chat(follower, span_danger("That acursed cross interupts my prayers!"))
			return FALSE
	// Allows prayers in the bath house - whore.
	if(istype(get_area(follower), /area/rogue/indoors/town/bath))
		return TRUE
	// Allows prayers if actively high on drugs.
	if(follower.has_status_effect(/datum/status_effect/buff/ozium) || follower.has_status_effect(/datum/status_effect/buff/moondust) || follower.has_status_effect(/datum/status_effect/buff/moondust_purest) || follower.has_status_effect(/datum/status_effect/buff/druqks) || follower.has_status_effect(/datum/status_effect/buff/starsugar))
		return TRUE
	// Allows prayers if the user is drunk.
	if(follower.has_status_effect(/datum/status_effect/buff/drunk))
		return TRUE
	// Allows prayers if the user is generally happy.
	if(follower.has_status_effect(/datum/status_effect/mood/vgood))
		return TRUE
	// Allows prayers during sex
	var/list/arousal_data = list()
	SEND_SIGNAL(follower, COMSIG_SEX_GET_AROUSAL, arousal_data)
	if(arousal_data["arousal"] >= 10)
		return TRUE
	// Allows praying atop ritual chalk of the god.
	for(var/obj/structure/ritualcircle/baotha in view(1, get_turf(follower)))
		return TRUE
	to_chat(follower, span_danger("For Baotha to hear my prayers I must either be in the church of the abandoned, within the town's bathhouse, or actively enjoying myself, be that through drugs, sex, or whatever it is that gets my blood pumpin'!"))
	return FALSE
