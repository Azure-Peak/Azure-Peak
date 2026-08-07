
// this makes you kinda valid because it's, you know a demon, so it gets to be a bit stronger. cuddle the campfire dog
/mob/living/carbon/human/species/familiar/infernal
	name = "Hellhound"
	desc = "A caniform lesser infernal, the heat it radiates is almost comforting. Though daemon-binding is generally frowned upon, the power it grants is tempting to many."
	summoning_emote = "Flame erupts in the center of the rune, coalescing into a hellish canid!"
	race = /datum/species/familiar/infernal
	speak_emote = list("growls","crackles")
	tutorial_message = span_notice("As a weaker denizen of the hells, your fire is tame enough to act as a campfire: you can be cooked on, or rested near to aid in recuperation. You also shine with a small amount of light, and flames will not harm you.")
	tierup_messages = list(
		span_info("You can now breathe flame, conjuring a line of hellfire in front of you."),
		span_info("As your flame grows, you can manifest it more violently, surging around you to burn anything unfortunate enough to be nearby.")
	)
	inherent_spell = list(/obj/effect/proc_holder/spell/invoked/incendiary_bite)
	t1_spell = list(/datum/action/cooldown/spell/matthios/raze/infernal)
	t2_spell = list(/obj/effect/proc_holder/spell/self/infernal_surge)
	var/healing_range = 1
	var/static/list/acceptable_beds = list(/obj/structure/bed, /obj/structure/flora/roguetree/stump, /obj/item/bedsheet)
	valid_healing_items = list(/obj/item/magic/infernal)
	planar_origin = "infernal"
	voiceclips = list('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/idle (3).ogg')

/datum/species/familiar/infernal
	name = "Infernal"
	id = "infernal"
	inherent_traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_TINYPAWS,
		TRAIT_INFINITE_STAMINA,
		TRAIT_NOMOOD,
		TRAIT_NOHUNGER,
		TRAIT_NOPAIN,
		TRAIT_TECHNOPHOBE,
		TRAIT_NODISMEMBER, //Decapping Volfs causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_CRITICAL_WEAKNESS, // ...this should prevent them from being literally unkillable, though
		TRAIT_PIERCEIMMUNE, //Prevents weapon dusting and caltrop effects due to them transforming when killed/stepping on shards.
		TRAIT_NOMETABOLISM, // partly to avoid potion jank, mostly because fae need to store reagents inside themselves
		TRAIT_NOFIRE,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_SILVER_WEAK,
		TRAIT_NOWW, // no antag familiars pls
		TRAIT_UNLYCKERABLE,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_UNCONVERTIBLE,
	)
	origin = "The Hells"
	origin_default = /datum/virtue/origin/familiar/infernal

// they get to glow because they're on fire
/mob/living/carbon/human/species/familiar/infernal/Initialize()
	. = ..()
	src.set_light_range(LIGHT_RANGE_FIRE)
	src.set_light_color(LIGHT_COLOR_FIRE)
	if(src.light_system == STATIC_LIGHT)
		src.update_light()
	weather_immunities += "lava"

/mob/living/carbon/human/species/familiar/infernal/is_aligned_leyline(obj/structure/leyline/ley)
	return istype(ley, /obj/structure/leyline/normal/decap)

// in case it wasn't obvious enough that this is license for people to be mad at you
// update 2026-04-16: it wasn't obvious enough STILL. have some role-specific prodding to do some conflict
// update 2026-08-02: maybe the role-specific text is enough actually
/mob/living/carbon/human/species/familiar/infernal/examine(mob/user)
	var/list/ret = ..()
	// ret.Insert(2,span_userdanger("A DAEMON...!"))
	if(HAS_TRAIT(user, TRAIT_CLERGY))
		ret.Insert(3, span_notice("Vile Archdevil-spawn! Binding such things is forbidden! Brook not daemonbinders!"))
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		ret.Insert(3, span_notice("Summoning daemons to kill is one thing. Bringing one to Psydonia in full is blatant disrespect of His sacrifice! Brook not daemonbinders!"))
	return ret

/mob/living/carbon/human/species/familiar/infernal/Life()
	. = ..()
	var/list/hearers_in_range = get_hearers_in_LOS(healing_range, src, RECURSIVE_CONTENTS_CLIENT_MOBS)
	for(var/mob/living/carbon/human/human in hearers_in_range)
		if(human == src)
			return // don't get to benefit from your own aura
		var/distance = get_dist(src, human)
		if(distance > healing_range || HAS_TRAIT(human, TRAIT_NOREGEN) || HAS_TRAIT(human, TRAIT_IRONMAN))
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

/mob/living/carbon/human/species/familiar/infernal/attackby(obj/item/I, mob/living/user, params)
	var/datum/skill/craft/cooking/cs = user?.get_skill_level(/datum/skill/craft/cooking)
	var/cooktime_divisor = get_cooktime_divisor(cs)
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/egg))
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
/mob/living/carbon/human/species/familiar/fire_act(added,max_stacks)
	return


/mob/living/carbon/human/species/familiar/infernal/ashcoiler
	name = "Ashcoiler"
	desc = "This long-bodied snake coils slowly, like a heated rope. Its breath carries a faint scent of burnt herbs. Though daemon-binding is generally frowned upon, the power it grants is tempting to many."
	summoning_emote = "Dust rises and circles before coiling into a gray-scaled creature that radiates dry, residual warmth."
	icon_state = "ashcoiler"
	speak_emote = list("hisses", "rasps")
	voiceclips = list('sound/vo/mobs/snake/hiss.ogg')

/mob/living/carbon/human/species/familiar/infernal/emberdrake
	name = "Emberdrake"
	desc = "Tiny and warm to the touch, this drake's wingbeats stir old memories. Runes flicker behind it like afterimages. Though daemon-binding is generally frowned upon, the power it grants is tempting to many."
	summoning_emote = "A hush falls as glowing ash collects into a fluttering emberdrake."
	icon_state = "emberdrake"
	speak_emote = list("crackles", "speaks warmly")

/mob/living/carbon/human/species/familiar/infernal/armour
	name = "Infernal Armour"
	desc = "A suit of accursed armour, its host long swallowed by infernal flames yet the form remains, restless and ready to serve yet another master."
	summoning_emote = "A loud thud rings across as long dormant armour flashes with unlyfe."
	icon_state = "infernal_armour"
	speak_emote = list("crackles")
	voiceclips = list('sound/effects/hood_ignite.ogg')

/mob/living/carbon/human/species/familiar/infernal/sword
	name = "Infernal Blade"
	desc = "A sword once belonging to a hero lost in pits of the underworld upon his demise. It is said to feed upon souls of those who touch it - willing or not."
	summoning_emote = "A blade raises from the deepest pits, singing against the wind."
	icon_state = "infernal_blade"
	speak_emote = list("sings")
	voiceclips = list('sound/magic/bladescrape.ogg', 'sound/magic/scrapeblade.ogg')
