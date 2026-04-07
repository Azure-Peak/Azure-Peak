#define FAMILIAR_SEE_IN_DARK 6
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
	faction = list("rogueanimal", "neutral")
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
	var/t2_spell = null
	var/summoning_emote = null
	
//As far as I am aware, you cannot pat out fire as a familiar at least not in time for it to not kill you, this seems fair.
/mob/living/simple_animal/pet/familiar/fire_act(added, maxstacks)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living, extinguish_mob)), 1 SECONDS)

/mob/living/simple_animal/pet/familiar/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CHUNKYFINGERS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	AddComponent(/datum/component/footstep, footstep_type)
	TryAddFlight()

/mob/living/simple_animal/pet/familiar/proc/TryAddFlight()
	if(movement_type & (FLYING | FLOATING))
		verbs += list(/mob/living/simple_animal/proc/fly_up,
		/mob/living/simple_animal/proc/fly_down)


/mob/living/simple_animal/pet/familiar/proc/can_bite()
	for(var/obj/item/grabbing/grab in grabbedby) //Grabbed by the mouth
		if(grab.sublimb_grabbed == BODY_ZONE_PRECISE_MOUTH)
			return FALSE
			
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
	if(GLOB.tod == "night" && tier < 2)
		to_chat(src, span_info("As another nite falls, your powers grow, adjusting more to the mortal plane."))
		tier++
		grant_tier_abilities(tier)

/mob/living/simple_animal/pet/familiar/death()
	. = ..()
	emote("deathgasp")
	if(familiar_summoner)
		to_chat(familiar_summoner, span_warning("[src.name] has fallen, and your bond dims. Yet in the quiet beyond, a flicker of their essence remains."))

/mob/living/simple_animal/pet/familiar/Destroy()
    if(familiar_summoner && familiar_summoner.mind)
        familiar_summoner.mind.RemoveSpell(/datum/action/cooldown/spell/message_familiar)
    return ..()

// mobility/utility focused. innocuous. can fly, and brew potions, but not much else
/mob/living/simple_animal/pet/familiar/fae
	name = "Sprite"
	desc = "One of the lowest of the lesser fae, these playful embodiments of nature are beloved of mages for their mobility and affinity for alchemy."
	animal_species = "Sprite"
	summoning_emote = "A flower sprouts in the center of the rune, blossoming into a small faerie!"
	icon_state = "sprite"
	icon_living = "sprite"
	icon_dead = "leaf_trail"
	speak_emote = list("rustles", "flutters", "creaks")
	var/list/ingredients = list()
	var/maxingredients = 4
	var/brewing = FALSE
	var/brewtime = 0
	pass_flags = PASSTABLE | PASSMOB
	movement_type = FLYING
	t1_spell = /obj/effect/proc_holder/spell/invoked/reagent_bite

/mob/living/simple_animal/pet/familiar/fae/Initialize()
	. = ..()
	create_reagents(90, TRANSPARENT)

/mob/living/simple_animal/pet/familiar/fae/examine(mob/user)
	. = ..()
	if(reagents)
		if(reagents.flags & TRANSPARENT)
			if(length(reagents.reagent_list))
				if(user.can_see_reagents() || (user.Adjacent(src) && (user.get_skill_level(/datum/skill/craft/alchemy) >= 2 || HAS_TRAIT(user, TRAIT_CICERONE)))) //Show each individual reagent
					. += "[src.p_they()] contain[src.gender==PLURAL?"":"s"]:"
					for(var/datum/reagent/R in reagents.reagent_list)
						. += "[round(R.volume, 0.1)] [UNIT_FORM_STRING(round(R.volume, 0.1))] of <font color=[R.color]>[R.name]</font>"
				else //Otherwise, just show the total volume
					var/total_volume = 0
					var/reagent_color
					for(var/datum/reagent/R in reagents.reagent_list)
						total_volume += R.volume
					reagent_color = mix_color_from_reagents(reagents.reagent_list)
					if(total_volume < 1)
						. += "[src.p_they()] contain[src.gender==PLURAL?"":"s"] less than 1 [UNIT_FORM_STRING(1)] of <font color=[reagent_color]>something.</font>"
					else
						. += "[src.p_they()] contain[src.gender==PLURAL?"":"s"] [round(total_volume)] [UNIT_FORM_STRING(round(total_volume))] of <font color=[reagent_color]>something.</font>"
			else
				. += "Nothing."
		else if(reagents.flags & AMOUNT_VISIBLE)
			if(reagents.total_volume)
				. += span_notice("[src.p_they()] [src.gender==PLURAL?"have":"has"] [round(reagents.total_volume)] [UNIT_FORM_STRING(round(reagents.total_volume))] left.")
			else
				. += span_danger("[src]'s stomach is empty.")

/mob/living/simple_animal/pet/familiar/fae/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers) && tier >= 1) 
		var/datum/reagents/container_reagents=I.reagents
		if(istype(container_reagents) && container_reagents.total_volume>0 && !reagents.holder_full())
			user.visible_message(
				span_notice("I begin feeding [src] from [I]..."),
				span_notice("[user] begins feeding [src] from [I]...")
			)
			while(!reagents.holder_full() && container_reagents.trans_to(src,5,transfered_by=user))
				user.visible_message(
					span_notice("I feed [src] from [I]..."),
					span_notice("[user] feeds [src] from [I]...")
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
	if(!familiar_summoner)
		to_chat(M,span_info("You pet [src], binding it to your will! Yeah this is a debug feature shush."))
		familiar_summoner = M
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
	if(tier>=2 && ingredients.len)
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
					brewtime = 0
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
	desc = "A lesser infernal, the heat it radiates is almost comforting. Though daemon-binding is generally frowned upon, the power it grants is tempting to many."
	summoning_emote = "Flame erupts in the center of the rune, coalescing into a hellish canid!"
	icon_state = "hellhound"
	icon_living = "hellhound"
	icon_dead = "emberdrake_dead"
	speak_emote = list("growls","crackles")
	t1_spell = /obj/effect/proc_holder/spell/invoked/incendiary_bite
	t2_spell = /obj/effect/proc_holder/spell/self/infernal_surge
	var/healing_range = 1
	var/static/list/acceptable_beds = list(/obj/structure/bed, /obj/structure/flora/roguetree/stump, /obj/item/bedsheet)

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
	icon_dead = "stonebig1"
	speak_emote = list ("rumbles", "grinds")
	t1_spell = /datum/action/cooldown/spell/arcyne_forge/elemental
	t2_spell = /datum/action/cooldown/spell/arcyne_forge/elemental/t2

/mob/living/simple_animal/pet/familiar/elemental/grant_tier_abilities(tier)
	. = ..()
	if(tier==2)
		src.mind.RemoveSpell(/datum/action/cooldown/spell/arcyne_forge/elemental)

/mob/living/simple_animal/pet/familiar/void
	name = "Void Drakeling"
	desc = "An abberant being of the void, or a fragment of one; its eyes shine with a voracious hunger." // we don't put all the details here bcs this can be seen by nonmages
	summoning_emote = "A small rift opens in the center of the rune! The ritual tears a fragment of draconic power from the other side and forms it into a draconic, if diminutive, shape..."
	animal_species = "Void Drakeling"
	icon_state = "emberdrake" // temp
	icon_living = "emberdrake"
	icon_dead = "emberdrake_dead"
	speak_emote = list("growls","murmurs")

// no time-based tiering system here
/mob/living/simple_animal/pet/familiar/void/do_time_change()
	return

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
	icon_dead = "ashcoiler_dead"
	speak_emote = list("hisses", "rasps")

/mob/living/simple_animal/pet/familiar/fae/glimmer_hare
	name = "Glimmer Hare"
	desc = "A quick, nervy creature. Light bends strangely around its translucent body."
	summoning_emote = "The air glints, and a translucent hare twitches into existence."
	animal_species = "Glimmer Hare"
	alpha = 150
	icon_state = "glimmer"
	icon_living = "glimmer"
	icon_dead = "glimmer_dead"
	speak_emote = list("chatters quickly", "chirps")

/mob/living/simple_animal/pet/familiar/fae/hollow_antlerling
	name = "Hollow Antlerling"
	desc = "A dog-sized deer with gleaming hollow antlers that emit flute-like sounds."
	summoning_emote = "A musical chime sounds. A tiny deer with antlers like bone flutes steps gently into view."
	animal_species = "Hollow Antlerling"
	icon_state = "antlerling"
	icon_living = "antlerling"
	icon_dead = "antlerling_dead"
	speak_emote = list("chimes softly", "calls out")

/mob/living/simple_animal/pet/familiar/elemental/gravemoss_serpent
	name = "Gravemoss Serpent"
	desc = "Its scales are flecked with lichen and grave-dust. Wherever it passes, roots twitch faintly in the soil."
	summoning_emote = "The ground heaves faintly as a long, moss-veiled serpent uncoils from it."
	animal_species = "Gravemoss Serpent"
	icon_state = "gravemoss"
	icon_living = "gravemoss"
	icon_dead = "gravemoss_dead"
	speak_emote = list("hisses low", "mutters")

/mob/living/simple_animal/pet/familiar/fae/starfield_crow
	name = "Starfield Zad"
	desc = "Its glossy feathers shimmer with shifting constellations, eyes gleaming with uncanny awareness even in the darkest shadows."
	summoning_emote = "A rift in the air reveals a fragment of the starry void, from which a sleek zad with feathers like the night sky takes flight."
	animal_species = "Starfield Crow"
	icon_state = "crow_flying"
	icon_living = "crow_flying"
	icon_dead = "crow_dead"
	speak_emote = list("caws quietly", "croaks")

/mob/living/simple_animal/pet/familiar/infernal/emberdrake
	name = "Emberdrake"
	desc = "Tiny and warm to the touch, this drake's wingbeats stir old memories. Runes flicker behind it like afterimages. Though daemon-binding is generally frowned upon, the power it grants is tempting to many."
	summoning_emote = "A hush falls as glowing ash collects into a fluttering emberdrake."
	animal_species = "Emberdrake"
	icon_state = "emberdrake"
	icon_living = "emberdrake"
	icon_dead = "emberdrake_dead"
	speak_emote = list("crackles", "speaks warmly")

/mob/living/simple_animal/pet/familiar/fae/ripplefox
	name = "Ripplefox"
	desc = "They flicker when not directly observed. Leaves no tracks. You're not always sure they're still nearby."
	summoning_emote = "A ripple in the air becomes a sleek fox, their fur twitching between shades of color as they pads forth."
	animal_species = "Ripplefox"
	icon_state = "ripple"
	icon_living = "ripple"
	icon_dead = "ripple_dead"
	speak_emote = list("whispers fast", "speaks quickly")

/mob/living/simple_animal/pet/familiar/fae/whisper_stoat
	name = "Whisper Stoat"
	desc = "Its gaze is too knowing. It tilts its head as if listening to something inside your skull."
	summoning_emote = "A thought twists into form, a tiny stoat slinks into view."
	animal_species = "Whisper Stoat"
	icon_state = "whisper"
	icon_living = "whisper"
	icon_dead = "whisper_dead"
	speak_emote = list("mutters", "speaks softly")

/mob/living/simple_animal/pet/familiar/elemental/thornback_turtle
	name = "Thornback Turtle"
	desc = "It barely moves, but seems unshakable. Vines twist gently around its limbs."
	summoning_emote = "The ground gives a slow rumble. A turtle with a bark-like shell emerges from the soil."
	animal_species = "Thornback Turtle"
	icon_state = "thornback"
	icon_living = "thornback"
	icon_dead = "thornback_dead"
	speak_emote = list("rumbles", "speaks slowly")

#undef FAMILIAR_SEE_IN_DARK
#undef FAMILIAR_MIN_BODYTEMP
#undef FAMILIAR_MAX_BODYTEMP
