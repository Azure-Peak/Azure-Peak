/datum/antagonist/lich
	name = "Lich"
	roundend_category = "Lich"
	antagpanel_category = "Lich"
	job_rank = ROLE_LICH
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	confess_lines = list(
		"I WILL LIVE ETERNAL!",
		"I AM BEHIND COUNTLESS PHYLACTERIES!",
		"YOU CANNOT KILL ME!",
	)
	rogue_enabled = TRUE

	var/list/phylacteries = list()
	var/out_of_lives = FALSE

	//Save our entire statline here.
	var/STASTR = 10
	var/STASPD = 10
	var/STACON = 10
	var/STAINT = 10
	var/STAWIL = 10
	var/STAPER = 10
	var/STALUC = 10

	var/traits_lich = list(
		TRAIT_INFINITE_STAMINA,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_DEATHLESS,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_LICHLAIR, //Ability to far travel to and from our lair.
		TRAIT_NOMOOD,
		TRAIT_NOLIMBDISABLE,
		TRAIT_GRAVEROBBER,
		TRAIT_ALCHEMY_EXPERT,
		TRAIT_MEDICINE_EXPERT,
		TRAIT_SHOCKIMMUNE,
		TRAIT_LIMBATTACHMENT,
		TRAIT_SEEPRICES,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_HEAVYARMOR,
		TRAIT_ARMOR_NOSPDCAP, //Ancient dread; their armor never weighs on their stride.
		TRAIT_CABAL,
		TRAIT_DEATHSIGHT,
		TRAIT_COUNTERCOUNTERSPELL,
		TRAIT_INTELLECTUAL,
		TRAIT_RITUALIST,
		TRAIT_ARCYNE,
		TRAIT_SELF_SUSTENANCE,
		TRAIT_ALCHEMY_EXPERT,
		TRAIT_SILVER_WEAK
		)

/datum/antagonist/lich/get_antag_cap_weight()
	return 3

/datum/antagonist/lich/on_gain()
	SSmapping.retainer.liches |= owner
	. = ..()
	owner.special_role = name
	skele_look()
	equip_lich()
	save_stats()
	set_stats()
	greet()
	return ..()

/datum/antagonist/lich/greet()
	to_chat(owner.current, span_userdanger("An immortal king cries for new subjects. Subdue and conquer."))
	owner.announce_objectives()
	owner.current.playsound_local(get_turf(owner.current), 'sound/villain/lichintro.ogg', 80, FALSE, pressure_affected = FALSE)
	..()

/datum/antagonist/lich/proc/save_stats()
	STASTR = owner.current.STASTR
	STAPER = owner.current.STAPER
	STACON = owner.current.STACON
	STAINT = owner.current.STAINT
	STASPD = owner.current.STASPD
	STAWIL = owner.current.STAWIL
	STALUC = owner.current.STALUC

/datum/antagonist/lich/proc/set_stats()
	owner.current.STASTR = src.STASTR
	owner.current.STAPER = src.STAPER
	owner.current.STACON = src.STACON
	owner.current.STAINT = src.STAINT
	owner.current.STASPD = src.STASPD
	owner.current.STAWIL = src.STAWIL
	owner.current.STALUC = src.STALUC

/datum/antagonist/lich/proc/skele_look()
	var/mob/living/carbon/human/L = owner.current
	L.hairstyle = "Bald"
	L.facial_hairstyle = "Shaved"
	L.update_body()
	L.update_hair()
	L.update_body_parts(redraw = TRUE)

/datum/antagonist/lich/proc/equip_lich()
	owner.unknow_all_people()
	for (var/datum/mind/MF in get_minds())
		owner.become_unknown_to(MF)

	var/mob/living/carbon/human/L = owner.current
	L.cmode_music = 'sound/music/combat_heretic.ogg'
	L.faction = list(FACTION_UNDEAD)

	for(var/datum/charflaw/cf in L.charflaws)
		L.charflaws.Remove(cf)
		QDEL_NULL(cf)

	L.mob_biotypes |= MOB_UNDEAD
	replace_eyes(L)

	for (var/obj/item/bodypart/B in L.bodyparts)
		B.skeletonize(FALSE)

	owner.current.forceMove(pick(GLOB.lich_starts)) // as opposed to spawning at their normal role spot as a skeleton; which is le bad
	equip_and_traits()
	L.equipOutfit(/datum/outfit/job/roguetown/lich)
	L.set_patron(/datum/patron/inhumen/zizo)


/datum/outfit/job/roguetown/lich/pre_equip(mob/living/carbon/human/H) //Equipment is located below
	..()
	//Skilled upto, so we don't have legendary wrestling crit resist fullplate lich or legendary riding lich that nobody can keep up with
	//Some of these will be replaced by class, but its a much healthier lich balance, all in in.

	//Our general combat skills
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE) //Always Master, they virtually always got this anyway
	H.adjust_skillrank_up_to(/datum/skill/combat/staves, 5, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 4, TRUE) //Always expert minimal. Tackle protection + Ability to Overpower most people.
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 4, TRUE) //Protection vs the dorpel floorkick.
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE) //Better than Skeles in swords, Zizo armor sets grant a sword.
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE) //If they take medium set, they can use the shield, very well.
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, 6, TRUE) //always gets legendary knives regardless of specialisation.

	//Mobility Nessessities
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, 3, TRUE) //Above bandits/wretch, despite infinite stamina.
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, 5, TRUE) //Always master minimal, to climb walls most can't (you had infinite stamina anyway).
	H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 6, TRUE) //Doing flips and shit, because its badass. Otherwise misc skill.
	H.adjust_skillrank_up_to(/datum/skill/misc/riding, 4, TRUE)

	//QOL skillup minimals, adjust as-needed
	H.adjust_skillrank_up_to(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/sewing, 2, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/engineering, 2, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/smelting, 3, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/labor/mining, 3, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/labor/lumberjacking, 3, TRUE)

	//Misc skills for immersion/funny moments/repurposing dungeons
	H.adjust_skillrank_up_to(/datum/skill/craft/traps, 4, TRUE) //Takeover dungeons by disabling traps.
	H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 4, TRUE) //Minimal for reviving with lux.
	H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, 4, TRUE) //Lich under table jumpscare.
	H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 3, TRUE) //Keeping doors closed to summon out-of-sight to recover.
	H.adjust_skillrank_up_to(/datum/skill/misc/reading, 6, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, 6, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 6, TRUE)

	H?.mind.setup_mage_aspects(list("mastery" = TRUE, "major" = 2, "minor" = 3, "utilities" = 9, "ward" = TRUE))
	// Give it decent combat stats to make up for loss of 2 extra lives

	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_INT, 6) //Smarter than the court magos
	H.change_stat(STATKEY_CON, 5)
	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_SPD, 1)
	H.change_stat(STATKEY_LCK, 2) //Leadership + Antag role

	H.change_stat(STATKEY_WIL, 7) //Only affects your ability to withstand keeling over from pain while sundered. Intended to be disgustingly high, as they're not supposed to easily fall over.

	H.grant_language(/datum/language/undead)
	// Grant a spellbook so the lich can pick aspects
	H.equip_to_slot_or_del(new /obj/item/rogueweapon/spellbook/grand,SLOT_IN_BACKPACK, TRUE)
	// Grant a chalk so the lich can do rituals
	H.equip_to_slot_or_del(new /obj/item/ritechalk,SLOT_IN_BACKPACK, TRUE)

	if(H.mind)
		// Our outburst version, its unique and a means to avoid softlocks
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb)
		// Lich-specific spells (not from aspects)
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/blood_bolt())
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/remotebomb)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/lich_announce)
		// Other role required spells.
		H.mind.AddSpell(new /datum/action/cooldown/spell/raise_undead_formation)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonechill)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)
		H.mind.AddSpell(new /datum/action/cooldown/spell/tame_undead)
		H.mind.AddSpell(new /datum/action/cooldown/spell/minion_order)
		H.mind.AddSpell(new /datum/action/cooldown/spell/gravemark)
		H.mind.AddSpell(new /datum/action/cooldown/spell/raise_deadite) //Zombifies dead people
		// Our Utility Spells
		H.mind.AddSpell(new /datum/action/cooldown/spell/convert_heretic)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		// This is probably a bad idea, but let's live a little.
		H.mind.AddSpell(new /datum/action/cooldown/spell/summon_terrorhog)
		// Consistancy as they're basically a ruler in the hierarchy above Necromancers
		H.mind.AddSpell(new /datum/action/cooldown/spell/eyebite)
		H.mind.AddSpell(new /datum/action/cooldown/spell/lacrima)
	H.ambushable = FALSE
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/other/lich]

	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "LICH"), 5 SECONDS)

/datum/antagonist/lich/proc/replace_eyes(mob/living/carbon/human/L)
	var/obj/item/organ/eyes/eyes = L.getorganslot(ORGAN_SLOT_EYES)
	if (eyes)
		eyes.Remove(L, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(L)

/datum/antagonist/lich/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire))
		if(!SEND_SIGNAL(examined_datum.owner, COMSIG_DISGUISE_STATUS))
			return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("Another deadite. My Ally.")
	if(istype(examined_datum, /datum/antagonist/lich))
		return span_boldnotice("Another Deadite.")

/datum/outfit/job/roguetown/lich/post_equip(mob/living/carbon/human/H)
	..()
	var/datum/antagonist/lich/lichman = H.mind.has_antag_datum(/datum/antagonist/lich)
	// One phylactery, one second chance.
	var/obj/item/phylactery/new_phylactery = new(H.loc)
	lichman.phylacteries += new_phylactery
	new_phylactery.possessor = lichman
	H.equip_to_slot_or_del(new_phylactery,SLOT_IN_BACKPACK, TRUE)
	H.select_skeleton_features()

/datum/antagonist/lich/proc/consume_phylactery(timer = 10 SECONDS)
	if(phylacteries.len)
		for(var/obj/item/phylactery/phyl in phylacteries)
			phyl.be_consumed(timer)
			phylacteries -= phyl
			return TRUE
	return FALSE


///Called post death to equip new body with armour and stats. Order of equipment matters
/datum/antagonist/lich/proc/equip_and_traits()
	var/mob/living/carbon/human/body = owner.current
	var/list/equipment_slots = list(
		SLOT_HEAD,
		SLOT_PANTS,
		SLOT_SHOES,
		SLOT_NECK,
		SLOT_CLOAK,
		SLOT_ARMOR,
		SLOT_SHIRT,
		SLOT_WRISTS,
		SLOT_GLOVES,
		SLOT_BELT,
		SLOT_BELT_R,
		SLOT_BELT_L,
		SLOT_HANDS,
		SLOT_BACK_L,
		)

	var/list/equipment_items = list(
		/obj/item/clothing/head/roguetown/roguehood/unholy/lich,
		/obj/item/clothing/under/roguetown/chainlegs,
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced,
		/obj/item/clothing/neck/roguetown/chaincoif,
		/obj/item/clothing/suit/roguetown/shirt/robe/unholy/lich,
		/obj/item/clothing/suit/roguetown/armor/plate/blacksteel,
		/obj/item/clothing/suit/roguetown/shirt/tunic/ucolored,
		/obj/item/clothing/wrists/roguetown/bracers,
		/obj/item/clothing/gloves/roguetown/chain,
		/obj/item/storage/belt/rogue/leather/black,
		/obj/item/reagent_containers/glass/bottle/rogue/manapot,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/rogueweapon/woodstaff/implement/grand,
		/obj/item/storage/backpack/rogue/satchel/black,
	)
	for (var/i = 1, i <= equipment_slots.len, i++)
		var/slot = equipment_slots[i]
		var/item_type = equipment_items[i]
		body.equip_to_slot_or_del(new item_type, slot, TRUE)

	for (var/trait in traits_lich)
		ADD_TRAIT(body, trait, "[type]")

	body.update_move_intent_slowdown()

/datum/antagonist/lich/proc/rise_anew()
	if (!owner.current.mind)
		CRASH("Lich: rise_anew called with no mind")

	var/mob/living/carbon/human/old_body = owner.current
	var/turf/phylactery_turf = get_turf(old_body)
	var/mob/living/carbon/human/new_body = new /mob/living/carbon/human/species/human/northern(phylactery_turf)

	old_body.mind.transfer_to(new_body)

	for(var/datum/charflaw/cf in new_body.charflaws)
		new_body.charflaws.Remove(cf)
		QDEL_NULL(cf)

	new_body.real_name = old_body.real_name
	new_body.dna.real_name = old_body.real_name
	new_body.mob_biotypes |= MOB_UNDEAD
	new_body.faction = list(FACTION_UNDEAD)
	new_body.set_patron(/datum/patron/inhumen/zizo)
	new_body.mind.grab_ghost(force = TRUE)
	new_body.ambushable = FALSE
	new_body.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/other/lich] //evil ass voice stays
	// Grant a spellbook so the lich can pick aspects
	new_body.equip_to_slot_or_del(new /obj/item/rogueweapon/spellbook/grand,SLOT_IN_BACKPACK, TRUE)
	// Grant a chalk so the lich can do rituals
	new_body.equip_to_slot_or_del(new /obj/item/ritechalk,SLOT_IN_BACKPACK, TRUE)

	for (var/obj/item/bodypart/body_part in new_body.bodyparts)
		body_part.skeletonize(FALSE)

	replace_eyes(new_body)
	set_stats()
	skele_look()
	equip_and_traits()
	// Delete the old body if it still exists
	if (!QDELETED(old_body))
		old_body.visible_message(
			span_danger("[old_body] is pulled into an unnatural rift.")
		)
		new /obj/effect/temp_visual/bluespace_fissure(get_turf(old_body))
		playsound(get_turf(old_body), 'sound/misc/portalopen.ogg', 100)
		qdel(old_body)


/obj/item/phylactery
	name = "phylactery"
	desc = "An otherworldly crystal that radiates with intense power. </br>Under a light's scrutiny, its crystalline edges refract into the sigil of an inverted psicross. What the hell is this thing.. !?"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	layer = HIGH_OBJ_LAYER
	w_class = WEIGHT_CLASS_TINY
	light_system = MOVABLE_LIGHT
	light_outer_range = 3
	light_color = "#e62424"

	var/datum/antagonist/lich/possessor
	var/datum/mind/mind

/obj/item/phylactery/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 255, "size" = 1))

/obj/item/phylactery/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/inhumen/zizo) //DIVINITY. ASCENSION. ZIZO. ZIZO. ZIZO.
			. += span_rose("A crystalline fragment of divinity, used by Lyches to thwart death's grasp. If a Lych's incarnation is slain, they will be resurrected wherever their nearest phylactrey happens to be, destroying it in the process. Lyches can only be slain, permenantly, once all phylactries linked to their spirit have been destroyed.")
		else if(H.patron.type == /datum/patron/divine/necra || H.patron.type == /datum/patron/divine/astrata || H.patron.type == /datum/patron/divine/undivided) //Tennites think Necra's getting your soul (hah) and in their eyes your divinity is false, because they're baised towards their masters.
			. += span_rose("A crystalline fragment of false divinity, used by Lyches to thwart Necra's grasp. If a Lych's incarnation is slain, they will be resurrected wherever their nearest phylactrey happens to be, destroying it in the process. Lyches can only be slain, permenantly, once all phylactries linked to their spirit have been destroyed.")
		else if(H.patron.type == /datum/patron/old_god) //Psydonites are moderately neutral, as they are wildcards, your divinity is self-made. Interpretation is up to you.
			. += span_rose("A crystalline fragment of self-made divinity, used by Lyches to thwart death's grasp. If a Lych's incarnation is slain, they will be resurrected wherever their nearest phylactrey happens to be, destroying it in the process. Lyches can only be slain, permenantly, once all phylactries linked to their spirit have been destroyed.")

/obj/item/phylactery/proc/be_consumed(timer)
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = -1) //start shaking
	visible_message(span_warning("[src] begins to glow and shake violently!"))

	spawn(timer)
		possessor.owner.current.forceMove(get_turf(src))
		possessor.rise_anew()
		src.visible_message(
			span_danger("the phylactery shatters violently as it tears open a rift and [possessor] steps out where it once was!")
		)
		new /obj/effect/temp_visual/bluespace_fissure(get_turf(src))
		playsound(get_turf(src), 'sound/spellbooks/glass.ogg', 100)
		playsound(get_turf(src), 'sound/misc/portalopen.ogg', 100)
		qdel(src)

/obj/effect/proc_holder/spell/self/lich_announce
	name = "Command Will"
	desc = "Bellow a commandment, which will be heard by all undead creechers - irregardless of their location - underneath your command."
	recharge_time = 20 SECONDS

/obj/effect/proc_holder/spell/self/lich_announce/cast(list/targets, mob/user)
	if(user.stat)
		return FALSE

	var/calltext = sanitize(input("Send Your Will To Your Undead", "UNDEAD ANNOUNCE") as text|null)
	if(!calltext)
		return FALSE

	for(var/datum/antagonist/A in GLOB.antagonists)
		if(!A.owner)
			continue
		if(!istype(A, /datum/antagonist/skeleton) && !istype(A, /datum/antagonist/lich))
			continue
		var/datum/mind/skele = A.owner
		log_game("LICH COMMAND: [user.real_name] ([user.ckey]) commanded their minions: \"[calltext]\"")
		to_chat(skele.current, span_narsie("[span_purple(user.real_name)] shrieks out their commandment: <b>\"[calltext]\"</b>"))
		skele.current.playsound_local(get_turf(A.owner), 'sound/misc/deadbell.ogg', 50, FALSE)

	..()

/datum/action/cooldown/spell/summon_terrorhog
	name = "Summon Terrorhog"
	desc = "First cast allows you to name your very own, loyal Terrorhog. Second cast lets you summon a Terrorhog. This is a single use spell when uses to summon. Beware, drooling feral hogs do not cease their rampage until they are dead, and cannot be leashed properly."
	button_icon = 'icons/mob/actions/classuniquespells/lichspells.dmi'
	button_icon_state = "hog"

	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE
	cooldown_time = 10 SECONDS
	charge_time = 2 SECONDS
	associated_skill = /datum/skill/magic/holy
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF
	spell_color = "#330000"
	var/hog_name = ""

/datum/action/cooldown/spell/summon_terrorhog/cast(atom/cast_on)
	. = ..()
	var/mob/living/caster = owner
	if(!caster)
		return FALSE

	if(hog_name == "")
		var/input_name = tgui_input_text(caster, "What name do you name your loyal pet?", "Name Your Terrorhog", max_length = MAX_NAME_LEN)
		if(!input_name || QDELETED(src) || QDELETED(caster) || owner != caster)
			return FALSE
		hog_name = sanitize_name(input_name)
		name = "Summon [hog_name]"
		desc = "Call your bound beast, [hog_name], forth into reality with a significant delay. This will consume the spell. Beware, drooling feral hogs do not cease their rampage until they are dead, and cannot be leashed properly."
		to_chat(caster, span_notice("You may now cast the spell again on the ground to manifest [hog_name]."))
		return TRUE

	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf || istransparentturf(target_turf) || is_blocked_turf(target_turf))
		to_chat(caster, span_warning("You must target solid ground to anchor the ritual!"))
		return FALSE

	caster.visible_message(span_danger("[caster] begins chanting a deep, primal incantation as lightning arcs nearby!"))
	new /obj/structure/terrorhog_summon_rune(target_turf, hog_name)

	addtimer(CALLBACK(src, .proc/self_consume, caster), 1)
	return TRUE

/datum/action/cooldown/spell/summon_terrorhog/proc/self_consume(mob/living/L)
	if(L?.mind)
		L.mind.RemoveSpell(src)

/obj/structure/terrorhog_summon_rune
	name = "pulsating rune"
	desc = "A violently vibrating runic inscription channeling deep earth energy."
	icon = 'icons/roguetown/misc/rituals.dmi'
	icon_state = "zizo_active"
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	density = FALSE
	light_outer_range = 3
	light_color = LIGHT_COLOR_BLUE
	var/stored_hog_name = "Terrorhog"

/obj/structure/terrorhog_summon_rune/Initialize(mapload, name_to_assign)
	. = ..()
	if(name_to_assign)
		stored_hog_name = name_to_assign

	playsound(src, 'sound/magic/lightning.ogg', 80, TRUE)
	src.visible_message(span_userdanger("A glowing, pulsating rune etches itself into the ground. Reality cracks visibly around it! Something is coming!"))
	new /obj/effect/temp_visual/hunting_phantom/terrorhog_bound(src.loc, stored_hog_name, src)

/obj/effect/temp_visual/hunting_phantom/terrorhog_bound
	name = "approaching horror"
	desc = "A massive abomination approaches"
	spawn_delay = 12 SECONDS
	skip_parent_call = TRUE
	var/assigned_beast_name = ""
	var/obj/structure/terrorhog_summon_rune/linked_rune

/obj/effect/temp_visual/hunting_phantom/terrorhog_bound/Initialize(mapload, incoming_name, obj/structure/terrorhog_summon_rune/source_rune)
	. = ..()
	assigned_beast_name = incoming_name
	linked_rune = source_rune
	var/mob/living/path_cast = /mob/living/carbon/human/species/wildshape/terrorhog
	src.icon = initial(path_cast.icon)
	src.icon_state = initial(path_cast.icon_state)
	src.pixel_x = initial(path_cast.pixel_x)
	src.pixel_y = initial(path_cast.pixel_y)
	src.color = "#777777" 
	animate(src, alpha = 200, time = spawn_delay, easing = EASE_IN)
	playsound(src, 'sound/misc/jumpscare (4).ogg', 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(finalize_spawn_terrorhog)), spawn_delay)

/obj/effect/temp_visual/hunting_phantom/terrorhog_bound/proc/finalize_spawn_terrorhog()
	var/turf/spawn_tile = get_turf(src)
	if(spawn_tile)
		var/mob/living/carbon/human/species/wildshape/terrorhog/H = new(spawn_tile)
		if(istype(H))
			if(assigned_beast_name != "")
				addtimer(CALLBACK(src, PROC_REF(apply_name_async), H, assigned_beast_name), 11)
			H.faction |= FACTION_UNDEAD
		spawn_tile.visible_message(span_boldwarning("With a horrid squeal, the [H.name] lunges out from the shadows!"))
		playsound(spawn_tile, 'sound/items/seedextract.ogg', 100, TRUE)
	if(linked_rune)
		qdel(linked_rune)

/obj/effect/temp_visual/hunting_phantom/terrorhog_bound/proc/apply_name_async(mob/living/carbon/human/species/wildshape/terrorhog/H, name_to_set)
	if(QDELETED(H))
		return
	H.real_name = name_to_set
	H.name = name_to_set
	qdel(src)
