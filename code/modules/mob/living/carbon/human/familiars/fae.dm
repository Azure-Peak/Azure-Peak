// mobility/utility focused. innocuous. can fly, and brew potions, but not much else
/mob/living/carbon/human/species/familiar/fae
	name = "Sprite"
	real_name = "Sprite"
	desc = "One of the lowest of the lesser fae, these playful embodiments of nature are beloved of mages for their mobility and affinity for alchemy."
	race = /datum/species/familiar/fae
	summoning_emote = "A flower sprouts in the center of the rune, blossoming into a small faerie!"
	icon_state = "sprite"
	speak_emote = list("rustles", "flutters", "creaks")
	var/list/ingredients = list()
	var/maxingredients = 4
	var/brewing = 0
	var/should_brew = FALSE
	pass_flags = PASSTABLE | PASSMOB
	inherent_spell = list(/datum/action/cooldown/spell/projectile/fetch/fae)
	movement_type = FLYING
	t1_spell = list(/datum/action/cooldown/spell/rootcheck, /datum/action/cooldown/spell/invisibility/fae)
	t2_spell = list(/datum/action/cooldown/spell/fae_brew, /obj/effect/proc_holder/spell/invoked/reagent_bite)
	tutorial_message = span_notice("As a native of the faewyld, you are able to fly, and kneestingers will not harm you. In addition, you can lash out with a vine to retrieve small objects at a distance.")
	tierup_messages = list(
		span_info("You may now blend into your surroundings at will, and force hidden crops to bloom at your command."),
		span_info("You can now act as a reagent container, holding up to 90 drams of any solution. You can also deliver 5 drams at a time of your stored solution with an alchemical bite. You may also act as a portable cauldron, able to be fed alchemical reagents and brew them into potions. You do not need water to do so. Any attempts to brew potion beyond your reagent capacity will result in reagents being voided.")
	)
	valid_healing_items = list(/obj/item/magic/fae)
	planar_origin = "fae"
	STASPD = 12
	voiceclips = list("plantcross")

/datum/species/familiar/fae
	name = "Faerie"
	id = "fae"
	inherent_traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_TINYPAWS,
		TRAIT_INFINITE_STAMINA,
		TRAIT_NOMOOD,
		TRAIT_NOHUNGER,
		TRAIT_NOPAIN,
		TRAIT_NOBREATH,
		TRAIT_TECHNOPHOBE,
		TRAIT_NODISMEMBER, //Decapping Volfs causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_CRITICAL_WEAKNESS, // ...this should prevent them from being literally unkillable, though
		TRAIT_PIERCEIMMUNE, //Prevents weapon dusting and caltrop effects due to them transforming when killed/stepping on shards.
		TRAIT_NOMETABOLISM, // partly to avoid potion jank, mostly because fae need to store reagents inside themselves
		TRAIT_CICERONE, // alchemy familiar
		TRAIT_KNEESTINGER_IMMUNITY, // they're literally nature spirits
		TRAIT_KEENEARS, // to fit with their recon focus
		TRAIT_NOWW, // no antag familiars pls
		TRAIT_UNLYCKERABLE,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_UNCONVERTIBLE,
	)
	origin = "The Faewyld"
	origin_default = /datum/virtue/origin/familiar/fae

/mob/living/carbon/human/species/familiar/fae/Initialize()
	. = ..()
	create_reagents(90, TRANSPARENT)
	adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE)

/mob/living/carbon/human/species/familiar/fae/is_aligned_leyline(obj/structure/leyline/ley)
	return istype(ley, /obj/structure/leyline/normal/grove)

/mob/living/carbon/human/species/familiar/fae/examine(mob/user)
	var/list/ret = ..()
	if(!ret)
		ret = list() // temp fix for a cascading runtime
	if(reagents)
		if(reagents.flags & TRANSPARENT)
			if(length(reagents.reagent_list))
				if(user.can_see_reagents() || (user.Adjacent(src) && (user.get_skill_level(/datum/skill/craft/alchemy) >= 2 || HAS_TRAIT(user, TRAIT_CICERONE)))) //Show each individual reagent
					ret.Insert(LAZYLEN(ret)-1, "[src.p_they(TRUE)] contain[src.gender==PLURAL?"":"s"]:")
					for(var/datum/reagent/R in reagents.reagent_list)
						ret.Insert(LAZYLEN(ret)-1, "[round(R.volume, 0.1)] [UNIT_FORM_STRING(round(R.volume, 0.1))] of <font color=[R.color]>[R.name]</font>")
				else //Otherwise, just show the total volume
					var/total_volume = 0
					var/reagent_color
					for(var/datum/reagent/R in reagents.reagent_list)
						total_volume += R.volume
					reagent_color = mix_color_from_reagents(reagents.reagent_list)
					if(total_volume < 1)
						ret.Insert(LAZYLEN(ret)-1, "[src.p_they(TRUE)] contain[src.gender==PLURAL?"":"s"] less than 1 [UNIT_FORM_STRING(1)] of <font color=[reagent_color]>something.</font>")
					else
						ret.Insert(LAZYLEN(ret)-1, "[src.p_they(TRUE)] contain[src.gender==PLURAL?"":"s"] [round(total_volume)] [UNIT_FORM_STRING(round(total_volume))] of <font color=[reagent_color]>something.</font>")
			else
				ret.Insert(LAZYLEN(ret)-1, "[src]'s stomach is empty.")
		else if(reagents.flags & AMOUNT_VISIBLE)
			if(reagents.total_volume)
				ret.Insert(LAZYLEN(ret)-1, span_notice("[src.p_they(TRUE)] [src.gender==PLURAL?"have":"has"] [round(reagents.total_volume)] [UNIT_FORM_STRING(round(reagents.total_volume))] left."))
			else
				ret.Insert(LAZYLEN(ret)-1, span_danger("[src]'s stomach is empty."))
	return ret

/mob/living/carbon/human/species/familiar/fae/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/alch) && tier >= 2)
		if(ingredients.len >= maxingredients)
			to_chat(user, "<span class='warning'>Nothing else can fit.</span>")
			return FALSE
		if(!isnull(locate(I.type) in ingredients))
			to_chat(user, "<span class='warning'>[src] has already been feed \a [I]! That would ruin the mixture!</span>")
			return FALSE
		if(!user.transferItemToLoc(I,src))
			to_chat(user, "<span class='warning'>[I] is stuck to my hand!</span>")
			return FALSE
		if(user == src)
			to_chat(user, "<span class='info'>I eat [I].</span>")
		else
			to_chat(user, "<span class='info'>I feed [I] to [src].</span>")
		ingredients += I
		return TRUE
	. = ..()

/mob/living/carbon/human/species/familiar/fae/attack_hand(mob/living/M)
	if(ingredients.len)
		var/obj/item/I = ingredients[ingredients.len]
		ingredients -= I
		I.loc = M.loc
		M.put_in_active_hand(I)
		if(M == src)
			M.visible_message("<span class='info'>[src] spits out [I].</span>")
		else
			M.visible_message("<span class='info'>[src] spits [I] into [M]'s hand.</span>")
		return
	. = ..()

/mob/living/carbon/human/species/familiar/fae/Life()
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
				if(found_recipe.skill_required > max((familiar_summoner?.get_skill_level(/datum/skill/craft/alchemy) || 0), get_skill_level(/datum/skill/craft/alchemy)))
					brewing = 0
					src.visible_message(span_warning("[src] emits a gurgling noise, the ingredients melding into a disgusting mess! Perhaps a more skilled alchemist is needed for this recipe."))
					for(var/obj/item/ing in src.ingredients)
						qdel(ing)
					src.reagents.add_reagent(/datum/reagent/yuck, min(reagents.maximum_volume - reagents.total_volume, 90)) // do not overfill
					// Learn from your failure (Yeah you can technically still grind this way you just blow through a lot of ingredients)
					add_sleep_experience(familiar_summoner, /datum/skill/craft/alchemy, amt2raise)
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
				add_sleep_experience(familiar_summoner, /datum/skill/craft/alchemy, amt2raise)
				playsound(src, "bubbles", 100, TRUE)
				playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)
				ingredients = list()
				brewing = 0
				qdel(found_recipe)
			else
				brewing = 0
				src.visible_message("<span class='info'>[src] emits an unpleasant gurgle, the ingredients failing to meld together at all...</span>")
				playsound(src,'sound/misc/smelter_fin.ogg', 30, FALSE)

/mob/living/carbon/human/species/familiar/fae/mist_lynx
	name = "Mist Lynx"
	desc = "A ghostlike lynx, its eyes gleaming like twin moons. It never seems to blink, even when you're not looking."
	summoning_emote = "Mist coils into feline shape, resolving into a lynx with pale fur and unblinking silver eyes."
	icon_state = "mist"
	alpha = 150
	speak_emote = list("purrs softly", "whispers")
	voiceclips = list('sound/vo/mobs/cat/cat_purr1.ogg', 'sound/vo/mobs/cat/cat_purr2.ogg', 'sound/vo/mobs/cat/cat_purr3.ogg', 'sound/vo/mobs/cat/cat_purr4.ogg',)

/mob/living/carbon/human/species/familiar/fae/rune_rat
	name = "Rune Rat"
	desc = "This rat leaves fading runes in the air as it twitches. The smell of old paper clings to its fur."
	summoning_emote = "A faint spark dances through the air. A rat with a softly glowing tail scampers into existence."
	icon_state = "runerat"
	speak_emote = list("squeaks", "chatters")
	voiceclips = list('sound/vo/mobs/mouse/squeak.ogg')

/mob/living/carbon/human/species/familiar/fae/vaporroot_wisp
	name = "Vaporroot Wisp"
	desc = "This vaporroot wisp shimmers and shifts like smoke but feels solid enough to lean on."
	summoning_emote = "A swirl of silvery mist gathers, coalescing into a small wisp of vaporroot."
	icon_state = "vaporroot"
	alpha = 150
	speak_emote = list("whispers", "murmurs")
	voiceclips = list() // silent on purpose

/mob/living/carbon/human/species/familiar/fae/glimmer_hare
	name = "Glimmer Hare"
	desc = "A quick, nervy creature. Light bends strangely around its translucent body."
	summoning_emote = "The air glints, and a translucent hare twitches into existence."
	alpha = 150
	icon_state = "glimmer"
	speak_emote = list("chatters quickly", "chirps")
	voiceclips = list('sound/vo/mobs/rabbit/rabbit_alert.ogg')

/mob/living/carbon/human/species/familiar/fae/hollow_antlerling
	name = "Hollow Antlerling"
	desc = "A dog-sized deer with gleaming hollow antlers that emit flute-like sounds."
	summoning_emote = "A musical chime sounds. A tiny deer with antlers like bone flutes steps gently into view."
	icon_state = "antlerling"
	speak_emote = list("chimes softly", "calls out")
	voiceclips = list() // i have no ideas

/mob/living/carbon/human/species/familiar/fae/starfield_crow
	name = "Starfield Zad"
	desc = "Its glossy feathers shimmer with shifting constellations, eyes gleaming with uncanny awareness even in the darkest shadows."
	summoning_emote = "A rift in the air reveals a fragment of the starry void, from which a sleek zad with feathers like the night sky takes flight."
	icon_state = "crow_flying"
	speak_emote = list("caws quietly", "croaks")
	voiceclips = list('sound/vo/mobs/bird/CROW_01.ogg', 'sound/vo/mobs/bird/CROW_02.ogg', 'sound/vo/mobs/bird/CROW_03.ogg')

/mob/living/carbon/human/species/familiar/fae/ripplefox
	name = "Ripplefox"
	desc = "They flicker when not directly observed. Leaves no tracks. You're not always sure they're still nearby."
	summoning_emote = "A ripple in the air becomes a sleek fox, their fur twitching between shades of color as they pads forth."
	icon_state = "ripple"
	speak_emote = list("whispers fast", "speaks quickly") // why the FUCK do we have so many fox noises and 13 of them are whining variants
	voiceclips = list('sound/vo/mobs/venard/fox1.ogg','sound/vo/mobs/venard/fox2.ogg','sound/vo/mobs/venard/fox3.ogg','sound/vo/mobs/venard/fox4.ogg','sound/vo/mobs/venard/fox5.ogg','sound/vo/mobs/venard/fox6.ogg','sound/vo/mobs/venard/fox7.ogg','sound/vo/mobs/venard/fox8.ogg','sound/vo/mobs/venard/fox9.ogg','sound/vo/mobs/venard/fox10.ogg','sound/vo/mobs/venard/fox11.ogg','sound/vo/mobs/venard/fox12.ogg','sound/vo/mobs/venard/fox13.ogg', 'sound/vo/yip.ogg', 'sound/vo/yip2.ogg', 'sound/vo/yip3.ogg')

/mob/living/carbon/human/species/familiar/fae/whisper_stoat
	name = "Whisper Stoat"
	desc = "Its gaze is too knowing. It tilts its head as if listening to something inside your skull."
	summoning_emote = "A thought twists into form, a tiny stoat slinks into view."
	icon_state = "whisper"
	speak_emote = list("mutters", "speaks softly")
	voiceclips = list() // i have no ideas
