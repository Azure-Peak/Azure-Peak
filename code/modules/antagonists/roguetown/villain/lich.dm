/datum/antagonist/lich
	name = "Lich"
	roundend_category = "Lich"
	antagpanel_category = "Lich"
	job_rank = ROLE_LICH
	confess_lines = list(
		"I WILL LIVE ETERNAL!",
		"I AM BEHIND SEVEN PHYLACTERIES!",
		"YOU CANNOT KILL ME!",
	)
	rogue_enabled = TRUE

	var/list/phylacteries = list()
	var/out_of_lives = FALSE

	var/traits_lich = list(
		TRAIT_INFINITE_STAMINA,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_VAMPMANSION,
		TRAIT_NOMOOD,
		TRAIT_NOLIMBDISABLE,
		TRAIT_SHOCKIMMUNE,
		TRAIT_LIMBATTACHMENT,
		TRAIT_SEEPRICES,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_HEAVYARMOR,
		TRAIT_CABAL,
		TRAIT_DEATHSIGHT,
		TRAIT_COUNTERCOUNTERSPELL,
		TRAIT_RITUALIST,
		TRAIT_ARCYNE_T3,
		TRAIT_SELF_SUSTENANCE,
		TRAIT_SILVER_WEAK
		)

	var/STASTR = 10
	var/STASPD = 10
	var/STAINT = 10
	var/STAWIL = 10
	var/STAPER = 10

/datum/antagonist/lich/get_antag_cap_weight()
	return 3

/datum/antagonist/lich/on_gain()
	SSmapping.retainer.liches |= owner
	. = ..()
	owner.special_role = name
	skele_look()
	equip_lich()
	greet()
	save_stats()
	return ..()

/datum/antagonist/lich/greet()
	to_chat(owner.current, span_userdanger("An immortal king cries for new subjects. Subdue and conquer."))
	owner.announce_objectives()
	..()

/datum/antagonist/lich/proc/save_stats()
	STASTR = owner.current.STASTR
	STAPER = owner.current.STAPER
	STAINT = owner.current.STAINT
	STASPD = owner.current.STASPD
	STAWIL = owner.current.STAWIL

/datum/antagonist/lich/proc/set_stats()
	owner.current.STASTR = src.STASTR
	owner.current.STAPER = src.STAPER
	owner.current.STAINT = src.STAINT
	owner.current.STASPD = src.STASPD
	owner.current.STAWIL = src.STAWIL

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
	L.faction = list("undead")

	if (L.charflaw)
		QDEL_NULL(L.charflaw)

	L.mob_biotypes |= MOB_UNDEAD
	replace_eyes(L)

	for (var/obj/item/bodypart/B in L.bodyparts)
		B.skeletonize(FALSE)

	equip_and_traits()
	L.equipOutfit(/datum/outfit/job/roguetown/lich)
	L.set_patron(/datum/patron/inhumen/zizo)
	owner.current.forceMove(pick(GLOB.vlord_starts)) // as opposed to spawning at their normal role spot as a skeleton; which is le bad


/datum/outfit/job/roguetown/lich/pre_equip(mob/living/carbon/human/H) //Equipment is located below
	..()

	H.adjust_skillrank(/datum/skill/misc/reading, 6, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 5, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/staves, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 5, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H?.mind.adjust_spellpoints(27)
	// Give it decent combat stats to make up for loss of 2 extra lives
	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_INT, 5)
	H.change_stat(STATKEY_CON, 5)
	H.change_stat(STATKEY_PER, 3)
	H.change_stat(STATKEY_SPD, 1)

	H.grant_language(/datum/language/undead)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonechill)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_undead_formation)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/bloodlightning)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/minion_order)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gravemark)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/lich_announce)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/tame_undead)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_deadite)
	H.ambushable = FALSE

	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "LICH"), 5 SECONDS)

/datum/antagonist/lich/proc/replace_eyes(mob/living/carbon/human/L)
	var/obj/item/organ/eyes/eyes = L.getorganslot(ORGAN_SLOT_EYES)
	if (eyes)
		eyes.Remove(L, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(L)

/datum/outfit/job/roguetown/lich/post_equip(mob/living/carbon/human/H)
	..()
	var/datum/antagonist/lich/lichman = H.mind.has_antag_datum(/datum/antagonist/lich)
	// One phylactery instead of 3 so that they don't need to get chased down non-stop.
	var/obj/item/phylactery/new_phylactery = new(H.loc)
	lichman.phylacteries += new_phylactery
	new_phylactery.possessor = lichman
	H.equip_to_slot_or_del(new_phylactery,SLOT_IN_BACKPACK, TRUE)

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
		SLOT_HANDS,
		SLOT_BACK_L,
		)

	var/list/equipment_items = list(
		/obj/item/clothing/under/roguetown/chainlegs,
		/obj/item/clothing/shoes/roguetown/boots,
		/obj/item/clothing/neck/roguetown/chaincoif,
		/obj/item/clothing/cloak/raincloak/mortus,
		/obj/item/clothing/suit/roguetown/armor/plate/blacksteel,
		/obj/item/clothing/suit/roguetown/shirt/tunic/ucolored,
		/obj/item/clothing/wrists/roguetown/bracers,
		/obj/item/clothing/gloves/roguetown/chain,
		/obj/item/storage/belt/rogue/leather/black,
		/obj/item/reagent_containers/glass/bottle/rogue/manapot,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/rogueweapon/woodstaff/riddle_of_steel,
		/obj/item/ritechalk,
		/obj/item/storage/backpack/rogue/satchel,
	)
	for (var/i = 1, i <= equipment_slots.len, i++)
		var/slot = equipment_slots[i]
		var/item_type = equipment_items[i]
		body.equip_to_slot_or_del(new item_type, slot, TRUE)

	for (var/trait in traits_lich)
		ADD_TRAIT(body, trait, "[type]")

/datum/antagonist/lich/proc/rise_anew()
	if (!owner.current.mind)
		CRASH("Lich: rise_anew called with no mind")

	var/mob/living/carbon/human/old_body = owner.current
	var/turf/phylactery_turf = get_turf(old_body)
	var/mob/living/carbon/human/new_body = new /mob/living/carbon/human/species/human/northern(phylactery_turf)

	old_body.mind.transfer_to(new_body)

	if (new_body.charflaw)
		QDEL_NULL(new_body.charflaw)

	new_body.real_name = old_body.name
	new_body.dna.real_name = old_body.real_name
	new_body.mob_biotypes |= MOB_UNDEAD
	new_body.faction = list("undead")
	new_body.set_patron(/datum/patron/inhumen/zizo)
	new_body.mind.grab_ghost(force = TRUE)

	for (var/obj/item/bodypart/body_part in new_body.bodyparts)
		body_part.skeletonize(FALSE)

	replace_eyes(new_body)
	set_stats()
	skele_look()
	equip_and_traits()
	// Delete the old body if it still exists
	if (!QDELETED(old_body))
		qdel(old_body)


/obj/item/phylactery
	name = "phylactery"
	desc = "Looks like it is filled with some intense power."
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

/obj/item/phylactery/Initialize(mapload, datum/mind/newmind)
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=1, offset=2, color=rgb(rand(1,255),rand(1,255),rand(1,255)))

/obj/item/phylactery/proc/be_consumed(timer)
	var/offset = prob(50) ? -2 : 2
	animate(src, pixel_x = pixel_x + offset, time = 0.2, loop = -1) //start shaking
	visible_message(span_warning("[src] begins to glow and shake violently!"))

	spawn(timer)
		possessor.owner.current.forceMove(get_turf(src))
		possessor.rise_anew()
		qdel(src)

/obj/effect/proc_holder/spell/self/lich_announce
	name = "Command Will"
	desc = "Send a booming message to the undead under your will."
	recharge_time = 20 SECONDS

/obj/effect/proc_holder/spell/self/lich_announce/cast(list/targets, mob/user)
	if(user.stat)
		return FALSE

	var/calltext = input("Send Your Will To Your Undead", "UNDEAD ANNOUNCE") as text|null
	if(!calltext)
		return FALSE

	priority_announce("[calltext]", title = "Your Lich King Commands", sound = 'sound/misc/deadbell.ogg', sender = user, receiver = /mob/living/carbon/human/species/skeleton)

	..()
