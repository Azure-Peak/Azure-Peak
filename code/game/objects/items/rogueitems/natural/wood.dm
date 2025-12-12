/obj/item/grown/log/tree
	icon = 'icons/roguetown/items/natural.dmi'
	name = "log"
	desc = "A big tree log. It's very heavy and cumbersome, best cut into pieces for more uses."
	icon_state = "log"
	blade_dulling = DULLING_CUT
	attacked_sound = 'sound/misc/woodhit.ogg'
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	max_integrity = 30
	static_debris = list(/obj/item/grown/log/tree/small = 1)
	obj_flags = CAN_BE_HIT
	resistance_flags = FLAMMABLE
	twohands_required = TRUE
	gripped_intents = list(/datum/intent/hit)
	possible_item_intents = list(/datum/intent/hit)
	obj_flags = CAN_BE_HIT
	w_class = WEIGHT_CLASS_HUGE
	var/quality = SMELTERY_LEVEL_NORMAL // For it not to ruin recipes that need it
	var/lumber = /obj/item/grown/log/tree/small //These are solely for lumberjack calculations
	var/lumber_amount = 1

/obj/item/grown/log/tree/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/woodstaff,
		/datum/crafting_recipe/roguetown/survival/quarterstaff,
		/datum/crafting_recipe/roguetown/survival/recurvepartial,
		/datum/crafting_recipe/roguetown/survival/longbowpartial,
		/datum/crafting_recipe/roguetown/survival/oar,
		/datum/crafting_recipe/roguetown/survival/boat,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/grown/log/tree/attacked_by(obj/item/I, mob/living/user) //This serves to reward woodcutting
	user.changeNext_move(CLICK_CD_INTENTCAP)
	var/skill_level = user.get_skill_level(/datum/skill/labor/lumberjacking)
	var/planking_time = (40 - (skill_level * 5))
	if(lumber_amount && I.tool_behaviour == TOOL_SAW)
		playsound(get_turf(src.loc), 'sound/foley/sawing.ogg', 100)
		user.visible_message("<span class='notice'>[user] starts sawing [src] to smaller pieces.</span>")
		if(do_after(user, planking_time))
			new /obj/item/grown/log/tree/small(get_turf(src.loc))
			new /obj/item/grown/log/tree/small(get_turf(src.loc))
			if(prob(skill_level + user.goodluck(2)))	// when sawing instead of essence you get extra small log
				new /obj/item/grown/log/tree/small(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
			user.mind.add_sleep_experience(/datum/skill/labor/lumberjacking, (user.STAINT*0.5))
			new /obj/effect/decal/cleanable/debris/woody(get_turf(src))
			qdel(src)
			return
	if(user.used_intent.blade_class == BCLASS_CHOP && lumber_amount && lumber)
		var/lumber_time = (40 - (skill_level * 5))
		var/minimum = 1
		playsound(src, 'sound/misc/woodhit.ogg', 100, TRUE)
		if(!do_after(user, lumber_time, target = user))
			return
		if(skill_level > 0) // If skill level is 1 or higher, we get more minimum wood!
			minimum = 2
		lumber_amount = rand(minimum, max(round(skill_level), minimum))
		var/sound_played = FALSE
		for(var/i = 0; i < lumber_amount; i++)
			new lumber(get_turf(src))
				// Scaling is less steep than tanning as lumberjacking is easier to level and get
			if(prob(skill_level + user.goodluck(2)))
				new /obj/item/natural/cured/essence(get_turf(user))
				if(!sound_played)
					sound_played = TRUE
					to_chat(user, span_warning("Dendor weeps..."))
					playsound(src,pick('sound/items/gem.ogg'), 100, FALSE)
		if(!skill_level)
			to_chat(user, span_info("Due to inexperience, I ruin some of the timber..."))
		user.mind.add_sleep_experience(/datum/skill/labor/lumberjacking, (user.STAINT*0.5))
		playsound(src, destroy_sound, 100, TRUE)
		qdel(src)
		return TRUE
	..()

/obj/item/grown/log/tree/small
	name = "small log"
	desc = "Piece of lumber cut from a larger log. Suitable for building."
	icon_state = "logsmall"
	grid_width = 64
	grid_height = 96
	attacked_sound = 'sound/misc/woodhit.ogg'
	max_integrity = 30
	static_debris = list(/obj/item/grown/log/tree/stick = 3)
	firefuel = 20 MINUTES
	twohands_required = FALSE
	gripped_intents = null
	w_class = WEIGHT_CLASS_BULKY
	smeltresult = /obj/item/rogueore/coal/charcoal
	lumber_amount = 0

/obj/item/grown/log/tree/small/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/stoneaxe,
		/datum/crafting_recipe/roguetown/survival/stonehammer,
		/datum/crafting_recipe/roguetown/survival/stonepick,
		/datum/crafting_recipe/roguetown/survival/stonehoe,
		/datum/crafting_recipe/roguetown/survival/woodspade,
		/datum/crafting_recipe/roguetown/survival/woodhammer,
		/datum/crafting_recipe/roguetown/survival/stonesword,
		/datum/crafting_recipe/roguetown/survival/woodclub,
		/datum/crafting_recipe/roguetown/survival/fishingcage,
		/datum/crafting_recipe/roguetown/survival/rod,
		/datum/crafting_recipe/roguetown/survival/bowpartial,
		/datum/crafting_recipe/roguetown/survival/recurvepartial,
		/datum/crafting_recipe/roguetown/survival/longbowpartial,
		/datum/crafting_recipe/roguetown/survival/billhook,
		/datum/crafting_recipe/roguetown/survival/goedendag,
		/datum/crafting_recipe/roguetown/survival/woodsword,
		/datum/crafting_recipe/roguetown/survival/woodshield,
		/datum/crafting_recipe/roguetown/survival/spoon,
		/datum/crafting_recipe/roguetown/survival/fork,
		/datum/crafting_recipe/roguetown/survival/platter,
		/datum/crafting_recipe/roguetown/survival/rollingpin,
		/datum/crafting_recipe/roguetown/survival/woodbucket,
		/datum/crafting_recipe/roguetown/survival/woodcup,
		/datum/crafting_recipe/roguetown/survival/woodtray,
		/datum/crafting_recipe/roguetown/survival/woodbowl,
		/datum/crafting_recipe/roguetown/survival/pipe,
		/datum/crafting_recipe/roguetown/survival/paperscroll,
		/datum/crafting_recipe/roguetown/survival/boneaxe,
		/datum/crafting_recipe/roguetown/survival/prosthetic/woodleftarm,
		/datum/crafting_recipe/roguetown/survival/prosthetic/woodrightarm,
		/datum/crafting_recipe/roguetown/survival/prosthetic/woodleftleft,
		/datum/crafting_recipe/roguetown/survival/prosthetic/woodrightleg,
		/datum/crafting_recipe/roguetown/survival/tarot_deck,
		/datum/crafting_recipe/roguetown/survival/heatershield,
		/datum/crafting_recipe/roguetown/survival/peasantry/thresher/whetstone,
		/datum/crafting_recipe/roguetown/survival/peasantry/shovel/whetstone,
		/datum/crafting_recipe/roguetown/survival/peasantry/hoe/whetstone,
		/datum/crafting_recipe/roguetown/survival/peasantry/pitchfork/whetstone,
		/datum/crafting_recipe/roguetown/survival/peasantry/peasantwarflail,
		/datum/crafting_recipe/roguetown/survival/peasantry/waraxe,
		/datum/crafting_recipe/roguetown/survival/peasantry/warspear_hoe,
		/datum/crafting_recipe/roguetown/survival/peasantry/warspear_pitchfork,
		/datum/crafting_recipe/roguetown/survival/peasantry/scythe,)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/grown/log/tree/small/attackby(obj/item/I, mob/living/user, params)
	if(item_flags & IN_STORAGE)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	var/skill_level = user.get_skill_level(/datum/skill/craft/carpentry)
	var/planking_time = (35 - (skill_level * 5))
	var/woodtotal = 1
	switch (skill_level) //how many planks you get is random, but higher with more carpentry skill
		if (0)
			woodtotal = 1
		if (1)
			woodtotal = 1
		if (2)
			woodtotal = pick(1,2)
		if (3)
			woodtotal = pick(1,2,3)
		if (4)
			woodtotal = pick(2,3)
		if (5)
			woodtotal = pick(2,3,4)
		if (6)
			woodtotal = pick(3,4)
		else
			woodtotal = 1
	if(HAS_TRAIT(user, TRAIT_MASTER_CARPENTER)) //we give extra to those in the role
		woodtotal += pick(1,2)
	if(I.tool_behaviour == TOOL_SAW)
		playsound(get_turf(src.loc), 'sound/foley/sawing.ogg', 100)
		user.visible_message("<span class='notice'>[user] starts sawing planks from [src].</span>")
		if(do_after(user, planking_time))
			if(user.is_holding(src))
				user.dropItemToGround(src)
			for(var/i=1, i<=woodtotal, ++i)
				new /obj/item/natural/wood/plank(get_turf(src.loc))
			user.mind.add_sleep_experience(/datum/skill/craft/carpentry, (user.STAINT*0.5))
			new /obj/effect/decal/cleanable/debris/woody(get_turf(src))
			qdel(src)
			return
	..()

/obj/item/grown/log/tree/bowpartial
	name = "crude bowstave"
	desc = "A partially completed bow, waiting to be strung."
	icon_state = "bowpartial"
	max_integrity = 30
	firefuel = 10 MINUTES
	twohands_required = FALSE
	gripped_intents = null
	w_class = WEIGHT_CLASS_BULKY
	smeltresult = /obj/item/rogueore/coal
	lumber_amount = 0

/obj/item/grown/log/tree/bowpartial/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/bow,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/grown/log/tree/bowpartial/recurve
	name = "recurve bowstave"
	desc = "An incomplete recurve bow, waiting to be strung."
	icon = 'icons/roguetown/items/64x.dmi'
	icon_state = "recurve_bowstave"

/obj/item/grown/log/tree/bowpartial/recurve/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/recurvebow,
		)

/obj/item/grown/log/tree/bowpartial/longbow
	name = "long bowstave"
	desc = "An incomplete longbow, waiting to be strung."
	icon = 'icons/roguetown/items/64x.dmi'
	icon_state = "long_bowstave"

/obj/item/grown/log/tree/bowpartial/longbow/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/longbow,
		)

/obj/item/grown/log/tree/stick
	name = "stick"
	icon_state = "stick1"
	desc = "A tree branch perhaps."
	blade_dulling = 0
	max_integrity = 20
	static_debris = null
	firefuel = 5 MINUTES
	obj_flags = null
	w_class = WEIGHT_CLASS_NORMAL
	twohands_required = FALSE
	gripped_intents = null
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP
	lumber_amount = 0
	grid_width = 32
	grid_height = 32

/obj/item/grown/log/tree/stick/Crossed(mob/living/L)
	. = ..()
	if(istype(L))
		var/prob2break = 33
		if(L.m_intent == MOVE_INTENT_SNEAK)
			prob2break = 0
		if(L.m_intent == MOVE_INTENT_RUN)
			prob2break = 100
		if (L.is_flying()) //if you're flying you shouldn't break things on the ground
			prob2break = 0
		if(prob(prob2break))
			if(!(HAS_TRAIT(L, TRAIT_AZURENATIVE) || HAS_TRAIT(L, TRAIT_WOODWALKER) && L.m_intent != MOVE_INTENT_RUN))
				playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			qdel(src)
			if (L.alpha == 0 && L.rogue_sneaking) // not anymore you're not
				L.update_sneak_invis(TRUE)
			if(!HAS_TRAIT(L, TRAIT_WOODWALKER))	
				L.consider_ambush()

/obj/item/grown/log/tree/stick/Initialize()
	icon_state = "stick[rand(1,2)]"
	..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/fishingcage,
		/datum/crafting_recipe/roguetown/survival/woodspade,
		/datum/crafting_recipe/roguetown/survival/stonetongs,
		/datum/crafting_recipe/roguetown/survival/stoneknife,
		/datum/crafting_recipe/roguetown/survival/broom,
		/datum/crafting_recipe/roguetown/survival/woodcross,
		/datum/crafting_recipe/roguetown/survival/dye_brush,
		/datum/crafting_recipe/roguetown/survival/peasantry/thresher,
		/datum/crafting_recipe/roguetown/survival/peasantry/shovel,
		/datum/crafting_recipe/roguetown/survival/peasantry/hoe,
		/datum/crafting_recipe/roguetown/survival/peasantry/pitchfork,
		/datum/crafting_recipe/roguetown/survival/wickercloak,
		/datum/crafting_recipe/roguetown/survival/torch,
		/datum/crafting_recipe/roguetown/survival/stonearrow,
		/datum/crafting_recipe/roguetown/survival/stonearrow_five,
		/datum/crafting_recipe/roguetown/survival/wood_stake
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/grown/log/tree/stick/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] snaps [src]."))
	playsound(user,'sound/items/seedextract.ogg', 100, FALSE)
	qdel(src)

/obj/item/grown/log/tree/stick/attack_right(mob/living/user)
	. = ..()
	if(user.get_active_held_item())
		return
	to_chat(user, span_warning("I start to collect [src]..."))
	if(move_after(user, 4 SECONDS, target = src))
		var/stackcount = 0
		for(var/obj/item/grown/log/tree/stick/F in get_turf(src))
			stackcount++
		while(stackcount > 0)
			if(stackcount == 1)
				var/obj/item/grown/log/tree/stick/S = new(get_turf(user))
				user.put_in_hands(S)
				stackcount--
			else if(stackcount >= 2)
				var/obj/item/natural/bundle/stick/B = new(get_turf(user))
				B.amount = clamp(stackcount, 2, 4)
				B.update_bundle()
				stackcount -= clamp(stackcount, 2, 4)
				user.put_in_hands(B)
		for(var/obj/item/grown/log/tree/stick/F in get_turf(src))
			playsound(get_turf(user.loc), 'sound/foley/dropsound/wooden_drop.ogg', 100)
			qdel(F)


/obj/item/grown/log/tree/stick/attackby(obj/item/I, mob/living/user, params)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(user.used_intent?.blade_class == BCLASS_CUT)
		playsound(get_turf(src.loc), 'sound/items/wood_sharpen.ogg', 100)
		user.visible_message(span_notice("[user] starts sharpening [src]."))
		if(do_after(user, 4 SECONDS))
			user.visible_message(span_notice("[user] sharpens [src]."))
			var/obj/item/grown/log/tree/stake/S = new /obj/item/grown/log/tree/stake(get_turf(src.loc))
			if(user.is_holding(src))
				user.dropItemToGround(src)
				user.put_in_hands(S)
			qdel(src)
		else
			user.visible_message(span_warning("[user] sharpens [src]."))
		return
	if(istype(I, /obj/item/grown/log/tree/stick))
		var/obj/item/natural/B = I
		var/obj/item/natural/bundle/stick/N = new(src.loc)
		to_chat(user, "I tie the sticks into a bundle.")
		qdel(B)
		qdel(src)
		user.put_in_hands(N)
	else if(istype(I, /obj/item/natural/bundle/stick))
		var/obj/item/natural/bundle/B = I
		if(istype(src, B.stacktype))
			if(B.amount < B.maxamount)
				B.amount++
				B.update_bundle()
				user.visible_message("[user] adds [src] to [I].", "I add [src] to [I].")
				qdel(src)
			else
				to_chat(user, "I can't add any more sticks to the bundle without it falling apart.")
			return

/obj/item/grown/log/tree/stake
	name = "stake"
	icon_state = "stake"
	desc = "A sharpened piece of wood, fantastic for piercing"
	grid_width = 32
	grid_height = 64
	force = 10
	throwforce = 5
	possible_item_intents = list(/datum/intent/stab, /datum/intent/pick)
	firefuel = 1 MINUTES
	blade_dulling = 0
	max_integrity = 20
	static_debris = null
	tool_behaviour = TOOL_IMPROVISED_RETRACTOR
	obj_flags = null
	w_class = WEIGHT_CLASS_SMALL
	twohands_required = FALSE
	gripped_intents = null
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP
	lumber_amount = 0

/obj/item/grown/log/tree/stake/Initialize()
	. = ..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/whetstone,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/grown/log/tree/stake/attack_obj(obj/O, mob/living/user)
	. = ..()
	if(isitem(O))
		var/obj/item/I = O
		if(istype(I, /obj/item/ingot/iron))
			if(!do_after(user, 4 SECONDS, target = I))
				return
			to_chat(user, span_warning("The [user] breaks an [I] using stake into small parts!"))
			new /obj/item/scrap(get_turf(I))
			new /obj/item/scrap(get_turf(I))
			new /obj/item/scrap(get_turf(I))
			qdel(I)
		if(I.anvilrepair)
			if(I.smeltresult == /obj/item/ingot/iron)
				if(!do_after(user, 4 SECONDS, target = I))
					return
				to_chat(user, span_warning("The [user] breaks an [I] using stake into small parts!"))
				new /obj/item/scrap(get_turf(I))
				qdel(I)

/////////////
// Planks //
////////////

/obj/item/natural/wood/plank
	name = "wooden plank"
	desc = "A flat piece of wood, useful for flooring."
	icon = 'icons/roguetown/items/crafting.dmi'
	icon_state = "plank"
	grid_width = 64
	grid_height = 224
	attacked_sound = 'sound/misc/woodhit.ogg'
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	possible_item_intents = list(/datum/intent/use)
	force = 6
	throwforce = 0
	obj_flags = null
	resistance_flags = FLAMMABLE
	slot_flags = null
	max_integrity = 20
	firefuel = 5 MINUTES
	w_class = WEIGHT_CLASS_BULKY
	sellprice = 4
	bundletype = /obj/item/natural/bundle/plank
	smeltresult = /obj/item/ash
	
/obj/item/natural/wood/plank/attack_right(mob/living/user)
	if(user.get_active_held_item())
		return
	to_chat(user, span_warning("I start to collect [src]..."))
	if(move_after(user, 4 SECONDS, target = src))
		var/stackcount = 0
		for(var/obj/item/natural/wood/plank/F in get_turf(src))
			stackcount++
		while(stackcount > 0)
			if(stackcount == 1)
				var/obj/item/natural/wood/plank/S = new(get_turf(user))
				user.put_in_hands(S)
				stackcount--
			else if(stackcount >= 2)
				var/obj/item/natural/bundle/plank/B = new(get_turf(user))
				B.amount = clamp(stackcount, 2, 6)
				B.update_bundle()
				stackcount -= clamp(stackcount, 2, 6)
				user.put_in_hands(B)
		for(var/obj/item/natural/wood/plank/F in get_turf(src))
			playsound(get_turf(user.loc), 'sound/foley/dropsound/wooden_drop.ogg', 80)
			qdel(F)

/obj/item/natural/bundle/plank
	name = "stack of wooden planks"
	desc = "Several planks in a neat pile."
	icon_state = "plankbundle1"
	item_state = "plankbundle"
	icon = 'icons/roguetown/items/crafting.dmi'
	grid_width = 128
	grid_height = 224
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	throw_range = 2
	firefuel = 10 MINUTES
	w_class = WEIGHT_CLASS_BULKY
	stackname = "plank"
	stacktype = /obj/item/natural/wood/plank
	maxamount = 6
	icon1 = "plankbundle2"
	icon1step = 3
	icon2 = "plankbundle3"
	icon2step = 5
	smeltresult = /obj/item/ash
