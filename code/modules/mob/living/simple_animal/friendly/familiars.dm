#define FAMILIAR_SEE_IN_DARK 10
#define FAMILIAR_MIN_BODYTEMP 200
#define FAMILIAR_MAX_BODYTEMP 400

// ok here's how it's going to be. there are four base types for familiars: fae, infernal, elemental, and void.
// every subtype is purely aesthetic to keep the system reasonable to balance.
// if you add mechanical differences between the subtypes i will find you.

/*
	Familiar list and buffs below. 
	Sprites by Diltyrr (those aren't good gah)

	Quick AI pictures idea for each of them : https://imgbox.com/g/MvanomKazA
*/

/mob/living/simple_animal/pet/familiar
	name = "Generic Wizard familiar"
	desc = "The spirit of what makes a familiar (You shouldn't be seeing this.)"

	icon = 'icons/roguetown/mob/familiars.dmi'

	pass_flags = PASSMOB //We don't want them to block players.
	base_intents = list(INTENT_HELP)
	melee_damage_lower = 1
	melee_damage_upper = 2

	dextrous = TRUE
	gender = NEUTER

	// this should go down in a fireball or two—so be careful
	maxHealth = WOLF_HEALTH
	health = WOLF_HEALTH

	speak_chance = 1
	turns_per_move = 5
	mob_size = MOB_SIZE_SMALL
	density = FALSE
	see_in_dark = FAMILIAR_SEE_IN_DARK
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = FAMILIAR_MIN_BODYTEMP
	maxbodytemp = FAMILIAR_MAX_BODYTEMP
	unsuitable_atmos_damage = 1
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	faction = list(FACTION_ROGUEANIMAL, FACTION_NEUTRAL)
	speed = 0.8
	breedchildren = 0 //Yeah no, I'm not falling for this one.
	dodgetime = 20
	held_items = list(null, null)
	pooptype = null
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	var/obj/item/mouth = null
	var/tier = 0 // increments once per dae survived; gates the stronger abilities
	var/mob/living/carbon/familiar_summoner = null
	var/inherent_spell = null
	var/t1_spell = null
	var/tutorial_message = null
	var/tierup_messages = list()
	var/t2_spell = null
	var/summoning_emote = null
	var/list/valid_healing_items = list() // what planar materials can heal you?
	var/planar_origin = "void" // what plane are we from? avoids a bunch of istype checks
	
//As far as I am aware, you cannot pat out fire as a familiar at least not in time for it to not kill you, this seems fair.
/mob/living/simple_animal/pet/familiar/fire_act(added, maxstacks)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living, extinguish_mob)), 1 SECONDS)

/mob/living/simple_animal/pet/familiar/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TINYPAWS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_NOVICE)
	AddComponent(/datum/component/footstep, footstep_type)
	TryAddFlight()
	icon_dead = icon_living // to prevent sprite updating weirdness with vestige revival

/mob/living/simple_animal/pet/familiar/death(gibbed)
	. = ..(gibbed)
	var/obj/item/magic/familiar_vestige/vestige = new /obj/item/magic/familiar_vestige(loc)
	vestige.stored_familiar = src
	src.loc = vestige
	vestige.desc = "The vestige of [src.name], a fallen [GLOB.familiar_display_names[src.type]]. Likely worth a lot to the magos that summoned [src.p_them()]!"

/mob/living/simple_animal/pet/familiar/proc/TryAddFlight()
	if(movement_type & (FLYING | FLOATING))
		verbs += list(/mob/living/simple_animal/proc/fly_up,
		/mob/living/simple_animal/proc/fly_down)

// they can wear pouches and amulets around their neck, for sovl
/mob/living/simple_animal/pet/familiar/can_equip(obj/item/I, slot, disable_warning, bypass_equip_delay_self)
	return slot == SLOT_NECK

/mob/living/simple_animal/pet/familiar/proc/can_bite()
	for(var/obj/item/grabbing/grab in grabbedby) //Grabbed by the mouth
		if(grab.sublimb_grabbed == BODY_ZONE_PRECISE_MOUTH)
			return FALSE
			
	return TRUE

/mob/living/simple_animal/pet/familiar/is_literate()
	return TRUE

/mob/living/simple_animal/pet/familiar/proc/grant_tier_abilities(tier)
	if(tier==1 && t1_spell)
		var/spell_instance = new t1_spell
		if(spell_instance && src.mind)
			src.mind.AddSpell(spell_instance)
	if(tier==2 && t2_spell)
		var/spell_instance = new t2_spell
		if(spell_instance && src.mind)
			src.mind.AddSpell(spell_instance)
	return

/mob/living/simple_animal/pet/familiar/proc/debug_force_tierup()
	GLOB.tod="night"
	do_time_change()

/mob/living/simple_animal/pet/familiar/do_time_change()
	. = ..()
	if(src.planar_origin!="void" && GLOB.tod == "night" && tier < 2)
		tier++
		to_chat(src, span_info("As another nite falls, your powers grow, adjusting more to the mortal plane."))
		if(LAZYLEN(tierup_messages) && tierup_messages[tier])
			to_chat(src, tierup_messages[tier])
		grant_tier_abilities(tier)

/mob/living/simple_animal/pet/familiar/death()
	. = ..()
	emote("deathgasp")
	if(familiar_summoner)
		to_chat(familiar_summoner, span_warning("[src.name] has fallen, and your bond dims. They may be recalled yet, should you recover their vestige."))

/mob/living/simple_animal/pet/familiar/Destroy()
    if(familiar_summoner && familiar_summoner.mind)
        familiar_summoner.mind.RemoveSpell(/datum/action/cooldown/spell/message_familiar)
    return ..()

/mob/living/simple_animal/pet/familiar/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/magic))
		var/obj/item/magic/magicmaterial = I
		for(var/item_type in valid_healing_items)
			if(istype(magicmaterial,item_type))
				if(health == maxHealth)
					to_chat(user, "[src] is already healthy!")
					return
				to_chat(user, "I start healing [src] with [magicmaterial].")
				if(do_mob(user, src, 20))
					var/heal_amount = magicmaterial.tier * 0.25
					visible_message("[src] absorbs [magicmaterial] and is healed.")
					adjustBruteLoss(-maxHealth * heal_amount)
					qdel(magicmaterial)
					return
	. = ..()

/mob/living/simple_animal/pet/familiar/examine(mob/user)
	var/list/ret = ..()
	var/datum/familiar_prefs/prefs = src.client?.prefs?.familiar_prefs
	if(!prefs)
		return ret
	if(!prefs.familiar_headshot_link || !istype(prefs.familiar_headshot_link)) // prefs object from the dev period before we had examines; update them
		prefs.instantiate_examine_prefs()
		return ret
	if((valid_headshot_link(src, prefs.familiar_headshot_link[planar_origin], TRUE)) && (user.client?.prefs.chatheadshot))
		ret.Insert(2, "<img src=[prefs.familiar_headshot_link[planar_origin]] width=100 height=100/>")
	if(prefs.familiar_flavortext_display[planar_origin] || prefs.familiar_headshot_link[planar_origin] || prefs.familiar_ooc_notes_display[planar_origin])
		ret.Insert(ret.len-1, "<a href='?src=[REF(src)];task=view_fam_headshot;'>Examine closer</a>")
	return ret

// mobility/utility focused. innocuous. can fly, and brew potions, but not much else
/mob/living/simple_animal/pet/familiar/fae
	name = "Sprite"
	desc = "One of the lowest of the lesser fae, these playful embodiments of nature are beloved of mages for their mobility and affinity for alchemy."
	animal_species = "Sprite"
	summoning_emote = "A flower sprouts in the center of the rune, blossoming into a small faerie!"
	icon_state = "sprite"
	icon_living = "sprite"
	speak_emote = list("rustles", "flutters", "creaks")
	var/list/ingredients = list()
	var/maxingredients = 4
	var/brewing = 0
	var/should_brew = FALSE
	pass_flags = PASSTABLE | PASSMOB
	inherent_spell = list(/datum/action/cooldown/spell/projectile/lesser_fetch/fae)
	movement_type = FLYING
	t1_spell = /obj/effect/proc_holder/spell/invoked/reagent_bite
	t2_spell = /datum/action/cooldown/spell/fae_brew
	tutorial_message = span_notice("As a native of the faewyld, you are able to fly, and kneestingers will not harm you. In addition, you can lash out with a vine to retrieve small objects at a distance.")
	tierup_messages = list(
		span_info("You can now act as a reagent container, holding up to 90 drams of any solution. You can also deliver 5 drams at a time of your stored solution with an alchemical bite."),
		span_info("You now act as a portable cauldron, able to be fed alchemical reagents and brew them into potions. You do not need water to do so. Any attempts to brew potion beyond your reagent capacity will result in reagents being voided.")
	)
	valid_healing_items = list(/obj/item/magic/fae)
	planar_origin = "fae"

/mob/living/simple_animal/pet/familiar/fae/Initialize()
	. = ..()
	create_reagents(90, TRANSPARENT)
	ADD_TRAIT(src, TRAIT_CICERONE, TRAIT_GENERIC) // alchemy familiar
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_GENERIC) // they're literally nature spirits
	ADD_TRAIT(src, TRAIT_KEENEARS, TRAIT_GENERIC) // to fit with their recon focus

/mob/living/simple_animal/pet/familiar/fae/examine(mob/user)
	var/list/ret = ..()
	if(!ret)
		ret = list() // temp fix for a cascading runtime
	if(reagents)
		if(reagents.flags & TRANSPARENT)
			if(length(reagents.reagent_list))
				if(user.can_see_reagents() || (user.Adjacent(src) && (user.get_skill_level(/datum/skill/craft/alchemy) >= 2 || HAS_TRAIT(user, TRAIT_CICERONE)))) //Show each individual reagent
					ret.Insert(LAZYLEN(ret)-1, "[src.p_they()] contain[src.gender==PLURAL?"":"s"]:")
					for(var/datum/reagent/R in reagents.reagent_list)
						ret.Insert(LAZYLEN(ret)-1, "[round(R.volume, 0.1)] [UNIT_FORM_STRING(round(R.volume, 0.1))] of <font color=[R.color]>[R.name]</font>")
				else //Otherwise, just show the total volume
					var/total_volume = 0
					var/reagent_color
					for(var/datum/reagent/R in reagents.reagent_list)
						total_volume += R.volume
					reagent_color = mix_color_from_reagents(reagents.reagent_list)
					if(total_volume < 1)
						ret.Insert(LAZYLEN(ret)-1, "[src.p_they()] contain[src.gender==PLURAL?"":"s"] less than 1 [UNIT_FORM_STRING(1)] of <font color=[reagent_color]>something.</font>")
					else
						ret.Insert(LAZYLEN(ret)-1, "[src.p_they()] contain[src.gender==PLURAL?"":"s"] [round(total_volume)] [UNIT_FORM_STRING(round(total_volume))] of <font color=[reagent_color]>something.</font>")
			else
				ret.Insert(LAZYLEN(ret)-1, "[src]'s stomach is empty.")
		else if(reagents.flags & AMOUNT_VISIBLE)
			if(reagents.total_volume)
				ret.Insert(LAZYLEN(ret)-1, span_notice("[src.p_they()] [src.gender==PLURAL?"have":"has"] [round(reagents.total_volume)] [UNIT_FORM_STRING(round(reagents.total_volume))] left."))
			else
				ret.Insert(LAZYLEN(ret)-1, span_danger("[src]'s stomach is empty."))
	return ret

/mob/living/simple_animal/pet/familiar/fae/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers) && tier >= 1)
		var/datum/reagents/container_reagents=I.reagents
		if(istype(container_reagents) && user.used_intent.type == INTENT_POUR && container_reagents.total_volume>0 && !reagents.holder_full())
			user.visible_message(
				span_notice("I begin feeding [src] from [I]..."),
				span_notice("[user] begins feeding [src] from [I]...")
			)
			while(!reagents.holder_full() && do_mob(user, src, 1 SECONDS) && container_reagents.trans_to(src,5,transfered_by=user))
				user.visible_message(
					span_notice("I feed [src] from [I]..."),
					span_notice("[user] feeds [src] from [I]...")
				)
		else if(istype(container_reagents) && user.used_intent.type == /datum/intent/fill)
			src.visible_message(,
				span_notice("I begin filling [user]'s [I.name]..."),
				span_notice("[src] begins filling [user]'s [I.name]...")
			)
			while(!container_reagents.holder_full() && do_mob(user, src, 1 SECONDS) && reagents.trans_to(I,5,transfered_by=user))
				src.visible_message(
					span_notice("I fill [I] with some of my solution..."),
					span_notice("[src] fills [I] with some solution...")
				)
	else if(istype(I, /obj/item/alch) && tier >= 2)
		if(ingredients.len >= maxingredients)
			to_chat(user, "<span class='warning'>Nothing else can fit.</span>")
			return FALSE
		if(!isnull(locate(I.type) in ingredients))
			to_chat(user, "<span class='warning'>[src] has already been feed \a [I]! That would ruin the mixture!</span>")
			return FALSE
		if(!user.transferItemToLoc(I,src))
			to_chat(user, "<span class='warning'>[I] is stuck to my hand!</span>")
			return FALSE
		to_chat(user, "<span class='info'>I feed [I] to [src].</span>")
		ingredients += I
		return TRUE
	. = ..()

/mob/living/simple_animal/pet/familiar/fae/attack_hand(mob/living/carbon/human/M)
	if(ingredients.len)
		var/obj/item/I = ingredients[ingredients.len]
		ingredients -= I
		I.loc = M.loc
		M.put_in_active_hand(I)
		M.visible_message("<span class='info'>[src] spits [I] into [M]'s hand.</span>")
		return
	. = ..()

/mob/living/simple_animal/pet/familiar/fae/Life()
	. = ..()
	if(brewing && !ingredients.len)
		brewing = 0
	if(brewing && !should_brew)
		brewing = 0
	if(tier>=2 && ingredients.len && should_brew)
		if(brewing < 20)
			if(brewing == 0)
				src.visible_message(span_info("[src] bubbles softly, beginning to mix the ingredients into a potion..."))
			brewing++
		else if(brewing)
			var/list/outcomes = list()
			for(var/obj/item/ing in src.ingredients)
				if(!istype(ing,/obj/item/alch))
					continue
				var/obj/item/alch/alching = ing
				if(alching.major_pot != null)
					if(outcomes[alching.major_pot] != null)
						outcomes[alching.major_pot] += 3
					else
						outcomes[alching.major_pot] = 3
				if(alching.med_pot != null)
					if(outcomes[alching.med_pot] != null)
						outcomes[alching.med_pot] += 2
					else
						outcomes[alching.med_pot] = 2
				if(alching.minor_pot != null)
					if(outcomes[alching.minor_pot] != null)
						outcomes[alching.minor_pot] += 1
					else
						outcomes[alching.minor_pot] = 1
			sortTim(outcomes,cmp=/proc/cmp_numeric_dsc,associative = 1)
			if(outcomes[outcomes[1]] >= 5)
				var/result_path = outcomes[1]
				var/datum/alch_cauldron_recipe/found_recipe = new result_path
				var/amt2raise = familiar_summoner?.STAINT*2
				// Handle skillgating
				if(!familiar_summoner)
					brewing = 0
					src.visible_message(span_info("[src] needs their summoner's alchemical knowledge to brew anything."))
					return
				if(found_recipe.skill_required > familiar_summoner?.get_skill_level(/datum/skill/craft/alchemy))
					brewing = 0
					src.visible_message(span_warning("[src] emits a gurgling noise, the ingredients melding into a disgusting mess! Perhaps a more skilled alchemist is needed for this recipe."))
					for(var/obj/item/ing in src.ingredients)
						qdel(ing)
					src.reagents.add_reagent(/datum/reagent/yuck, min(reagents.maximum_volume - reagents.total_volume, 90)) // do not overfill
					// Learn from your failure (Yeah you can technically still grind this way you just blow through a lot of ingredients)
					familiar_summoner?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE) 
					return
				for(var/obj/item/ing in src.ingredients)
					qdel(ing)
				if(found_recipe.output_reagents.len)
					src.reagents.add_reagent_list(found_recipe.output_reagents)
				if(found_recipe.output_items.len)
					for(var/itempath in found_recipe.output_items)
						new itempath(get_turf(src))
				//handle player perception and reset for next time
				src.visible_message("<span class='info'>[src] emits a gurgling noise and a faint [found_recipe.smells_like] smell.</span>")
				record_featured_stat(FEATURED_STATS_ALCHEMISTS, familiar_summoner)
				record_round_statistic(STATS_POTIONS_BREWED)
				//give xp for /datum/skill/craft/alchemy
				familiar_summoner?.adjust_experience(/datum/skill/craft/alchemy, amt2raise, FALSE)
				playsound(src, "bubbles", 100, TRUE)
				playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)
				ingredients = list()
				brewing = 0
				qdel(found_recipe)
			else
				brewing = 0
				src.visible_message("<span class='info'>[src] emits an unpleasant gurgle, the ingredients failing to meld together at all...</span>")
				playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)

// this makes you kinda valid because it's, you know a demon, so it gets to be a bit stronger. cuddle the campfire dog
/mob/living/simple_animal/pet/familiar/infernal
	name = "Hellhound"
	desc = "A caniform lesser infernal, the heat it radiates is almost comforting. Though daemon-binding is generally frowned upon, the power it grants is tempting to many."
	summoning_emote = "Flame erupts in the center of the rune, coalescing into a hellish canid!"
	icon_state = "hellhound"
	icon_living = "hellhound"
	speak_emote = list("growls","crackles")
	tutorial_message = span_notice("As a weaker denizen of the hells, your fire is tame enough to act as a campfire: you can be cooked on, or rested near to aid in recuperation. You also shine with a small amount of light, and flames will not harm you.")
	tierup_messages = list(
		span_info("You can now bring a mote of infernal flame to bear with a bite, igniting anything you desire."),
		span_info("As your flame grows, you can manifest it more directly, surging around you to burn anything unfortunate enough to be nearby.")
	)
	t1_spell = /obj/effect/proc_holder/spell/invoked/incendiary_bite
	t2_spell = /obj/effect/proc_holder/spell/self/infernal_surge
	var/healing_range = 1
	var/static/list/acceptable_beds = list(/obj/structure/bed, /obj/structure/flora/roguetree/stump, /obj/item/bedsheet)
	valid_healing_items = list(/obj/item/magic/infernal)
	planar_origin = "infernal"

// they get to glow because they're on fire
/mob/living/simple_animal/pet/familiar/infernal/Initialize()
	. = ..()
	src.set_light_range(LIGHT_RANGE_FIRE)
	src.set_light_color(LIGHT_COLOR_FIRE)
	if(src.light_system == STATIC_LIGHT)
		src.update_light()

// in case it wasn't obvious enough that this is license for people to be mad at you
// update 2026-04-16: it wasn't obvious enough STILL. have some role-specific prodding to do some conflict
/mob/living/simple_animal/pet/familiar/infernal/examine(mob/user)
	var/list/ret = ..()
	ret.Insert(2,span_userdanger("A DAEMON...!"))
	if(HAS_TRAIT(user, TRAIT_CLERGY))
		ret.Insert(3, span_notice("Vile Archdevil-spawn! Binding such things is forbidden! Brook not daemonbinders!"))
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		ret.Insert(3, span_notice("Summoning daemons to kill is one thing. Bringing one to Psydonia in full is blatant disrespect of His sacrifice! Brook not daemonbinders!"))
	return ret

/mob/living/simple_animal/pet/familiar/infernal/Life()
	. = ..()
	var/list/hearers_in_range = get_hearers_in_LOS(healing_range, src, RECURSIVE_CONTENTS_CLIENT_MOBS)
	for(var/mob/living/carbon/human/human in hearers_in_range)
		var/distance = get_dist(src, human)
		if(distance > healing_range || human.construct)
			continue
		if(!human.has_status_effect(/datum/status_effect/buff/campfire_stamina))
			to_chat(human, span_info("The warmth of [src.name]'s flames comforts me, affording me a short rest. I would need to lie down on a bed to get a better rest."))
		human.apply_status_effect(/datum/status_effect/buff/campfire_stamina)
		human.add_stress(/datum/stressevent/campfire)
		if(human.resting && !human.cmode)
			var/valid_bed = FALSE
			var/turf/T = get_turf(human)
			for(var/obj/O in T.contents)
				for(var/path in acceptable_beds)
					if(ispath(O.type, path))
						valid_bed = TRUE
						break
				if(valid_bed)
					break
			if(valid_bed)
				if(!human.has_status_effect(/datum/status_effect/buff/campfire))
					to_chat(human, span_info("Settling in near [src.name]'s warmth lifts the burdens of the week."))
				human.apply_status_effect(/datum/status_effect/buff/campfire)

/mob/living/simple_animal/pet/familiar/infernal/attackby(obj/item/I, mob/living/user, params)
	var/datum/skill/craft/cooking/cs = user?.get_skill_level(/datum/skill/craft/cooking)
	var/cooktime_divisor = get_cooktime_divisor(cs)
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
			to_chat(user, "<span class='warning'>I wouldn't be able to cook this over the fire...</span>")
			return FALSE
		var/obj/item/A = user.get_inactive_held_item()
		if(A)
			var/foundstab = FALSE
			for(var/X in A.possible_item_intents)
				var/datum/intent/D = new X
				if(D.blade_class in GLOB.stab_bclasses)
					foundstab = TRUE
					break
			if(foundstab)
				var/prob2spoil = 33
				if(cs)
					to_chat(world,span_warning("[cs]"))
					prob2spoil = 1
				var/already_rolled = FALSE
				user.visible_message("<span class='notice'>[user] starts to cook [I] over [src.name]'s flame...</span>")
				for(var/i in 1 to 6)
					if(do_after(user, 30 / cooktime_divisor, target = src))
						var/obj/item/reagent_containers/food/snacks/S = I
						var/obj/item/C
						if(prob(prob2spoil) && !already_rolled)
							user.visible_message("<span class='warning'>[user] burns [S].</span>")
							if(user.client?.prefs.showrolls)
								to_chat(user, "<span class='warning'>Critfail... [prob2spoil]%.</span>")
							C = S.cooking(1000, 1000, null)
						else
							already_rolled = TRUE
							C = S.cooking(S.cooktime/4, S.cooktime/4, src)
						if(C)
							user.dropItemToGround(S, TRUE)
							qdel(S)
							C.forceMove(get_turf(user))
							user.put_in_hands(C)
							break
					else
						break
	. = ..()

// the fuck did you expect
/mob/living/simple_animal/pet/familiar/infernal/fire_act(added,max_stacks)
	return

/mob/living/simple_animal/pet/familiar/elemental
	name = "Warden"
	desc = "One of the smaller elementals, this strange being is hard and unyielding as stone, yet malleable as clay when it needs to be."
	summoning_emote = "The ground begins to rumble as a pile of raw earth erupts, forming into the rough visage of a humanoid figure!"
	icon_state = "warden"
	icon_living = "warden"
	maxHealth = WOLF_HEALTH_UNDEAD // more durable than the others
	health = WOLF_HEALTH_UNDEAD
	speak_emote = list ("rumbles", "grinds")
	inherent_spell = list(/datum/action/cooldown/spell/magicians_stone/elemental) 
	t1_spell = /datum/action/cooldown/spell/arcyne_forge/elemental
	t2_spell = /datum/action/cooldown/spell/arcyne_forge/elemental/t2
	valid_healing_items = list(/obj/item/magic/elemental)
	tierup_messages = list(
		span_info("You can now shape your earthen form into tools and weapons, including those capable of repairing equipment."),
		span_info("You can now use the ground itself to shape tools and weapons, instead of using your own body.")
	)
	planar_origin = "elemental"

// so they can actually do repairs
/mob/living/simple_animal/pet/familiar/elemental/Initialize()
	. = ..()
	src.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_APPRENTICE)
	src.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_APPRENTICE)
	src.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, SKILL_LEVEL_APPRENTICE)
	src.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE)

/mob/living/simple_animal/pet/familiar/void
	name = "Void Drakeling"
	desc = "A small draconic being, gazing inquisitively at the world around it. It pulses with an unfamiliar power." // we don't put all the details here bcs this can be seen by nonmages
	summoning_emote = "The drakeling opens its eyes... they gleam with a voracious hunger!" // not an actual summoning emote since that's handled in the aurafarm session
	animal_species = "Void Drakeling"
	icon_state = "drakeling"
	icon_living = "drakeling"
	speak_emote = list("growls","murmurs")
	tutorial_message = span_notice("You are a new being, weak and without any notable traits. This will not do! Summon and consume mindless planar beings to grow your powers. One from each plane will suffice, for now. Add their natures to your own, and grow strong.")
	var/list/essences_consumed = list()
	var/list/beam_parts = list()
	inherent_spell = list(/obj/effect/proc_holder/spell/invoked/consume)
	valid_healing_items = list(/obj/item/magic/fae, /obj/item/magic/elemental, /obj/item/magic/infernal) // hungy
	planar_origin = "void"

/mob/living/simple_animal/pet/familiar/void/fire_act(added, maxstacks)
	if(essences_consumed.Find("infernal"))
		return FALSE
	. = ..()

/mob/living/simple_animal/pet/familiar/void/examine(mob/user)
	var/list/ret = ..()
	var/knows = FALSE
	knows |= istype(user, /mob/living/simple_animal/pet/familiar)
	// kind of horrid but this ensures only "proper" casters get to be knowers 
	if(user.mind)
		knows |= (user.mind.mage_aspect_config && user.mind.mage_aspect_config["major"])
	if(knows)
		ret.Insert(2, span_userdanger("AN ABBERANT...?"))
		ret[3] = "A fragment of a void abberant's power, torn away and fashioned into a familiar; its eyes shine with a voracious hunger. What work of hubris has been wrought, here? Who would—or even could—create such a thing?"
	return ret

/mob/living/simple_animal/pet/familiar/void/proc/grant_essence(type)
	switch(type)
		if("fae") // faerie movement, inherits spell
			to_chat(src, span_notice("As you absorb the essence of the faewyld, you take on some of its nature. You can now fly, and you've gained the ability to retrieve objects at a distance."))
			src.pass_flags = PASSTABLE | PASSMOB
			src.movement_type = FLYING
			TryAddFlight()
			src.mind.AddSpell(new /datum/action/cooldown/spell/projectile/lesser_fetch/fae/void)
		if("infernal") // nerfed abberant beam, fire res
			to_chat(src, span_notice("As you absorb the essence of the hells, you take on some of their nature. Flames will harm you no more, and you can now manifest an abberant beam to blast your foes."))
			src.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fire_obelisk_beam/drakeling)
		if("elemental") // stat buff, inherits spell
			to_chat(src, span_notice("As you absorb the essence of the depths, you take on some of its nature. Your body grows sturdier, and you can now tear stones from the earth itself."))
			src.maxHealth = WOLF_HEALTH_UNDEAD
			src.health = WOLF_HEALTH_UNDEAD
			src.STACON += 2
			src.STAWIL += 2
			src.mind.AddSpell(new /datum/action/cooldown/spell/magicians_stone/elemental/void)

/mob/living/simple_animal/pet/familiar/elemental/pondstone_toad
    name = "Pondstone Toad"
    desc = "This damp, heavy toad pulses with unseen strength. Its skin is cool and lined with mineral veins."
    animal_species = "Pondstone Toad"
    summoning_emote = "A deep thrum echoes beneath your feet, and a mossy toad pushes itself free from the earth, humming low."
    icon_state = "pondstone"
    icon_living = "pondstone"
    icon_dead = "pondstone_dead"
    speak_emote = list("croaks low", "grumbles")

/mob/living/simple_animal/pet/familiar/fae/mist_lynx
    name = "Mist Lynx"
    desc = "A ghostlike lynx, its eyes gleaming like twin moons. It never seems to blink, even when you're not looking."
    animal_species = "Mist Lynx"
    summoning_emote = "Mist coils into feline shape, resolving into a lynx with pale fur and unblinking silver eyes."
    icon_state = "mist"
    icon_living = "mist"
    icon_dead = "mist_dead"
    alpha = 150
    speak_emote = list("purrs softly", "whispers")

/mob/living/simple_animal/pet/familiar/fae/rune_rat
    name = "Rune Rat"
    desc = "This rat leaves fading runes in the air as it twitches. The smell of old paper clings to its fur."
    animal_species = "Rune Rat"
    summoning_emote = "A faint spark dances through the air. A rat with a softly glowing tail scampers into existence."
    icon_state = "runerat"
    icon_living = "runerat"
    icon_dead = "runerat_dead"
    speak_emote = list("squeaks", "chatters")

/mob/living/simple_animal/pet/familiar/fae/vaporroot_wisp
    name = "Vaporroot Wisp"
    desc = "This vaporroot wisp shimmers and shifts like smoke but feels solid enough to lean on."
    animal_species = "Vaporroot"
    summoning_emote = "A swirl of silvery mist gathers, coalescing into a small wisp of vaporroot."
    icon_state = "vaporroot"
    icon_living = "vaporroot"
    icon_dead = "vaporroot_dead"
    alpha = 150
    speak_emote = list("whispers", "murmurs")

/mob/living/simple_animal/pet/familiar/infernal/ashcoiler
	name = "Ashcoiler"
	desc = "This long-bodied snake coils slowly, like a heated rope. Its breath carries a faint scent of burnt herbs. Though daemon-binding is generally frowned upon, the power it grants is tempting to many."
	summoning_emote = "Dust rises and circles before coiling into a gray-scaled creature that radiates dry, residual warmth."
	animal_species = "Ashcoiler"
	icon_state = "ashcoiler"
	icon_living = "ashcoiler"
	speak_emote = list("hisses", "rasps")

/mob/living/simple_animal/pet/familiar/fae/glimmer_hare
	name = "Glimmer Hare"
	desc = "A quick, nervy creature. Light bends strangely around its translucent body."
	summoning_emote = "The air glints, and a translucent hare twitches into existence."
	animal_species = "Glimmer Hare"
	alpha = 150
	icon_state = "glimmer"
	icon_living = "glimmer"
	speak_emote = list("chatters quickly", "chirps")

/mob/living/simple_animal/pet/familiar/fae/hollow_antlerling
	name = "Hollow Antlerling"
	desc = "A dog-sized deer with gleaming hollow antlers that emit flute-like sounds."
	summoning_emote = "A musical chime sounds. A tiny deer with antlers like bone flutes steps gently into view."
	animal_species = "Hollow Antlerling"
	icon_state = "antlerling"
	icon_living = "antlerling"
	speak_emote = list("chimes softly", "calls out")

/mob/living/simple_animal/pet/familiar/elemental/gravemoss_serpent
	name = "Gravemoss Serpent"
	desc = "Its scales are flecked with lichen and grave-dust. Wherever it passes, roots twitch faintly in the soil."
	summoning_emote = "The ground heaves faintly as a long, moss-veiled serpent uncoils from it."
	animal_species = "Gravemoss Serpent"
	icon_state = "gravemoss"
	icon_living = "gravemoss"
	speak_emote = list("hisses low", "mutters")

/mob/living/simple_animal/pet/familiar/fae/starfield_crow
	name = "Starfield Zad"
	desc = "Its glossy feathers shimmer with shifting constellations, eyes gleaming with uncanny awareness even in the darkest shadows."
	summoning_emote = "A rift in the air reveals a fragment of the starry void, from which a sleek zad with feathers like the night sky takes flight."
	animal_species = "Starfield Crow"
	icon_state = "crow_flying"
	icon_living = "crow_flying"
	speak_emote = list("caws quietly", "croaks")

/mob/living/simple_animal/pet/familiar/infernal/emberdrake
	name = "Emberdrake"
	desc = "Tiny and warm to the touch, this drake's wingbeats stir old memories. Runes flicker behind it like afterimages. Though daemon-binding is generally frowned upon, the power it grants is tempting to many."
	summoning_emote = "A hush falls as glowing ash collects into a fluttering emberdrake."
	animal_species = "Emberdrake"
	icon_state = "emberdrake"
	icon_living = "emberdrake"
	speak_emote = list("crackles", "speaks warmly")

/mob/living/simple_animal/pet/familiar/fae/ripplefox
	name = "Ripplefox"
	desc = "They flicker when not directly observed. Leaves no tracks. You're not always sure they're still nearby."
	summoning_emote = "A ripple in the air becomes a sleek fox, their fur twitching between shades of color as they pads forth."
	animal_species = "Ripplefox"
	icon_state = "ripple"
	icon_living = "ripple"
	speak_emote = list("whispers fast", "speaks quickly")

/mob/living/simple_animal/pet/familiar/fae/whisper_stoat
	name = "Whisper Stoat"
	desc = "Its gaze is too knowing. It tilts its head as if listening to something inside your skull."
	summoning_emote = "A thought twists into form, a tiny stoat slinks into view."
	animal_species = "Whisper Stoat"
	icon_state = "whisper"
	icon_living = "whisper"
	speak_emote = list("mutters", "speaks softly")

/mob/living/simple_animal/pet/familiar/elemental/thornback_turtle
	name = "Thornback Turtle"
	desc = "It barely moves, but seems unshakable. Vines twist gently around its limbs."
	summoning_emote = "The ground gives a slow rumble. A turtle with a bark-like shell emerges from the soil."
	animal_species = "Thornback Turtle"
	icon_state = "thornback"
	icon_living = "thornback"
	speak_emote = list("rumbles", "speaks slowly")

/mob/living/simple_animal/pet/familiar/elemental/brass_thrum
    name = "Brass Thrum"
    desc = "A mechanical spider-like creature of brass and whirring gears, its movements precise and accompanied by a faint, rhythmic hum."
    animal_species = "Brass Thrum"
    icon = 'icons/mob/drone.dmi'
    icon_state = "drone_clock"
    icon_living = "drone_clock"
    summoning_emote = "A metallic clatter as a brass spider-like automaton unfolds itself."

/mob/living/simple_animal/pet/familiar/elemental/gemspire_beetle
    name = "Gemspire Beetle"
    desc = "A four-legged, spider-like automaton adorned with crystalline spires, blending arcane energy with intricate clockwork."
    animal_species = "Gemspire Beetle"
    icon = 'icons/mob/drone.dmi'
    icon_state = "drone_gem"
    icon_living = "drone_gem"
    summoning_emote = "A faint chime as a gem-encrusted mechanical beetle scuttles into view."
    speak_emote = "chimes"

#undef FAMILIAR_SEE_IN_DARK
#undef FAMILIAR_MIN_BODYTEMP
#undef FAMILIAR_MAX_BODYTEMP
