/datum/mind
	COOLDOWN_DECLARE(squad_spawn_cooldown)
	COOLDOWN_DECLARE(treaty_cooldown)

////////////////////////////////////
/datum/job/roguetown/warband_lieutenant
	title = "Warlord's Lieutenant"
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null 
	max_pq = null
	announce_latejoin = FALSE

	tutorial = "You're but one among many who've sworn loyalty to your Warlord. Here within the AZURE PEAK, you come upon the hour where that loyalty \
				shall be put to the test. Slay whom he bids you slay. Burn what he bids you burn. When he bids you to die, die well."
	show_in_credits = TRUE
	give_bank_account = FALSE
	hidden_job = TRUE
	wanderer_examine = TRUE

//////////////////
//////////////////
//////////////////

/datum/job/roguetown/warband_grunt
	title = "Veteran Grunt"
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null
	max_pq = null
	announce_latejoin = FALSE

	tutorial = "You're but one among many who've sworn loyalty to your Lieutenant. Here within the AZURE PEAK, you come upon the hour where that loyalty \
				shall be put to the test. Slay whom he bids you slay. Burn what he bids you burn. When he bids you to die, die well."

	show_in_credits = TRUE
	give_bank_account = FALSE
	hidden_job = TRUE
	wanderer_examine = TRUE

//////////////////
//////////////////
//////////////////

/datum/job/roguetown/warband_envoy
	title = "Warlord's Envoy"
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null
	max_pq = null
	announce_latejoin = FALSE

	show_in_credits = FALSE
	give_bank_account = FALSE
	hidden_job = TRUE
	wanderer_examine = TRUE

/datum/advclass/warband/envoy
	name = "Warlord's Envoy"
	outfit = /datum/outfit/job/roguetown/warband/warband_envoy
	traits_applied = list(TRAIT_LAWEXPERT, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(
		STATKEY_WIL = 4,
		STATKEY_SPD = 3,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = 4,
	)

/datum/outfit/job/roguetown/warband/warband_envoy/pre_equip(mob/living/carbon/human/H, used_slot)
	..()
	to_chat(H, span_warning("As an Envoy, you may return to your Warlord by interacting with a Rally Point. In the event of an emergency, use the ABANDON ENVOY verb in your Warband tab. Failing that, re-enter your corpse."))
	to_chat(H, span_warning("If you embark for diplomacy, you should consider fetching a Treaty from the Campaign Planner."))
	H.verbs += /mob/living/carbon/human/proc/abandon_envoy
	H.verbs += /mob/living/carbon/human/proc/shortcut
	H.verbs += /mob/living/carbon/human/proc/connect_warcamp
	H.verbs += /mob/living/carbon/human/proc/communicate
	H.mind.warband_manager.members += H
	H.pronouns = "he/him"
	backl = /obj/item/storage/backpack/rogue/satchel	
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/grown/log/tree/stake/scout,
		/obj/item/natural/feather
	)
	if(!used_slot)
		H.set_patron(/datum/patron/divine/undivided)
	if(H.mind.warband_manager.linked_faction)
		H.mind.warband_manager.linked_faction.member_names += H.real_name
	var/should_tweak = input(H, "Would you like to tweak your Envoy's name and gender?") in list("Yes", "No")
	if(should_tweak == "Yes")
		H.choose_pronouns_and_body()
		H.choose_name_popup()

	var/style = list("Diplomat","Cleric","Merchant","Nobility")
	var/style_choice = input(H, "How should the ENVOY be styled?", "STYLE") as anything in style
	switch(style_choice)
		if("Diplomat")
			shoes = /obj/item/clothing/shoes/roguetown/boots
			belt = /obj/item/storage/belt/rogue/leather/black
			id = /obj/item/clothing/ring/signet
			if(should_wear_femme_clothes(H))
				cloak = /obj/item/clothing/cloak/half/red
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
				pants = /obj/item/clothing/under/roguetown/tights/black	
			else
				head = /obj/item/clothing/head/roguetown/chaperon/greyscale
				cloak = /obj/item/clothing/cloak/half/red
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
				pants = /obj/item/clothing/under/roguetown/tights/black
		if("Cleric")
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
			pants = /obj/item/clothing/under/roguetown/tights
			belt = /obj/item/storage/belt/rogue/leather/rope
			shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
			id = /obj/item/clothing/ring/signet
			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
		if("Merchant")
			armor = /obj/item/clothing/suit/roguetown/shirt/robe/merchant
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor
			neck = /obj/item/storage/belt/rogue/pouch/coins/rich	// trades the signet ring for a coin pouch
			pants = /obj/item/clothing/under/roguetown/tights/sailor
			belt = /obj/item/storage/belt/rogue/leather/rope
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/appraise/secular)
		if("Nobility")
			ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
			if(should_wear_femme_clothes(H))
				belt = /obj/item/storage/belt/rogue/leather/cloth/lady
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
				id = /obj/item/clothing/ring/signet
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
			else if(should_wear_masc_clothes(H))
				pants = /obj/item/clothing/under/roguetown/tights
				armor = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
				belt = /obj/item/storage/belt/rogue/leather
				id = /obj/item/clothing/ring/signet

///////////////////////////////////////////////////////////
///////////////////////////////////////////////// ASSOCIATE
/* 
	the following variables track association & exile status
		warband_exile_IDs 	// given when someone is exiled | it's the ID of their former warband
		warband_recruiter_name		// given when a veteran is spawned, an outsider is associated, or an exiled veteran is associated by a new lieutenant
		allies				// a list in the warband manager that includes each ally

	ASSOCIATE attempts to give the target as many of your faction tags as it can, and add them as an ally
		you should always be able to give someone your personal faction tag ([user.real_name]_faction)
		exiled characters cannot be added as allies, except by the warlord

	exile & associate are split into two different spells, as accidentally doing one when you meant to do the other could be really rough
*/
/obj/effect/proc_holder/spell/invoked/associate
	name = "Associate"
	desc = "Adds or removes a target from the Warband's list of allies."
	overlay_state = "love"
	range = 16
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	antimagic_allowed = TRUE
	recharge_time = 1 SECONDS
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/associate/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/faction_tag = "warband_[user.mind.warband_ID]"
		var/personal_faction_tag = "[user.real_name]_faction"
		if(target == user)
			to_chat(user, span_warning("I cannot be further associated with myself than I already am."))
			return FALSE
		if(target in user.friends)
			to_chat(user, span_warning("[target.name] would follow me to the Underworld and back. Declaring them a mere 'associate' would be an insult."))
			return FALSE

		if(istype(target, /mob/living/simple_animal))
			if(personal_faction_tag in target.faction)
				target.faction -= personal_faction_tag
				to_chat(user, span_warning("I have released the [target.name] from my protection."))
				return TRUE
			else
				target.faction |= personal_faction_tag
				user.say("Leave the [target.name] be.")
				to_chat(user, span_green("My men will ignore the [target.name]."))
				return TRUE

		if(target.mind && target.mind.special_role == "Warlord's Envoy")
			to_chat(user, span_warning("That's an Envoy."))
			return

		if((personal_faction_tag in target.faction))
			to_chat(user, span_warning("They're already associated with me."))
			if(target.mind && (target.real_name in user.mind.unresolved_exile_names)) // if your subordinate got exiled, using Associate on them affirms that you wanna keep 'em as a pal
				user.mind.unresolved_exile_names -= target.real_name
				to_chat(user, span_warning("Since this was in question, I shall make it official."))
				for(var/mob/living/carbon/human/member in user.mind.warband_manager.members) 
					to_chat(member, span_warning("The [user.job], [user.real_name], acts in defiance of [target.real_name]'s decree of exile and has ordered their men to treat [target.real_name] as an associate."))

			return FALSE

		if(target.mind && target.mind.current)
			if(user.mind.warband_ID in target.mind.warband_exile_IDs) // if they're re-associating with an exile (warband ID is found in their exile ID list)
				if(!(target in user.mind.subordinates)) // only do this if they aren't already a subordinate
					// if a lieutenant's the one doing this, they become a personal ally
					if(user.mind.special_role == "Lieutenant" || user.mind.special_role == "Aspirant Lieutenant") 
						for(var/mob/living/carbon/human/member in user.mind.warband_manager.members) 
							to_chat(member, span_warning("The [user.job], [user.real_name], acts in defiance of [target.real_name]'s decree of exile and has ordered their men to treat [target.real_name] as an associate."))
						if(!target.mind.warband_recruiter_name)
							target.mind.warband_recruiter_name = user.real_name 
						if(!(target in user.mind.subordinates)) // if they weren't our subordinate we adopt them
							user.mind.subordinates += target
						if(!(personal_faction_tag in target.faction))
							target.faction += personal_faction_tag
						return

					// if the warlord's the one doing this, they become a full ally
					else if(user.mind.special_role == "Warlord")
						user.mind.warband_manager.allies += target
						to_chat(user, span_green("I have once again declared [target.name] an ally of our Warband."))
						user.say("Leave that one unharmed.")
						user.linepoint(target)
						return


					return

			if((faction_tag in target.faction))
				to_chat(user, span_warning("They're already associated with us. It'd be pointless."))
				return FALSE

			if(!(faction_tag in target.faction))
				target.faction |= faction_tag
				target.faction |= personal_faction_tag
				user.mind.warband_manager.allies += target

			if(target.mind.special_role && target.mind.warband_ID != user.mind.warband_ID) // if they are an antagonist (and not a warband member), increase disorder
				user.mind.warband_manager.disorder ++
			to_chat(user, span_green("I have declared [target.name] an ally of our Warband."))
			user.say("Leave that one unharmed.")
			user.linepoint(target)
			to_chat(target, span_green("The soldiers of the [user.mind.warband_manager.selected_warband.name] were ordered to leave me unharmed, by decree of their [user.job]."))
			target.mind.warband_recruiter_name = user.real_name // allies are given the recruiter's name as a variable
			for(var/mob/living/warlord in user.mind.warband_manager.members) // warlord should be made aware (unless they're the warlord, in which case they're already aware)
				if(warlord.mind.special_role == "Warlord" && warlord != user)
					to_chat(warlord, span_warning("Word spreads that [user.real_name], my [user.job], ordered their men to give someone safety within our ranks."))
		else
			to_chat(user, span_warning("We cannot associate ourselves with that."))

			return
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/exile
	name = "Exile"
	desc = "Exiles a target from the Warband."
	overlay_state = "curse2"
	range = 16
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	antimagic_allowed = TRUE
	recharge_time = 1 SECONDS
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/exile/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		user.mind.warband_manager.exile(target, user, personal = TRUE)
		return TRUE
	return FALSE


///////////////////////////////////////////////////////
///////////////////////////////////////////////// ORDER
/* 
	give orders to your squad of mobs
	the given order depends on your target

	i considered letting them keep the 'Attack This Single Target' command from skeletons/simplemobs
	but i don't think anyone would enjoy being clicked on like an RTS unit and getting bursted down by a 4+ complex mob deathball
	(admittedly that's still gonna happen if someone tries fighting them alone but Whatever)

*/
/obj/effect/proc_holder/spell/invoked/grunt_order
	name = "Order Grunts"
	desc = "Commands vary based on your target. \n \
	<span style='color:#e8bf67'>FOLLOW:</span> Target yourself. \n \
	<span style='color:#e8bf67'>CHARGE:</span> Target a tile. \n \
	<span style='color:#e8bf67'>NEUTRAL:</span> Target the COMBAT MODE button. A grunt's neutrality is easily disrupted. \n \
	<span style='color:#e8bf67'>FIGHT HARDER:</span> Target the STRONG INTENT button. (Cooldown) \n \
	<span style='color:#e8bf67'>SURVIVE:</span> Target the DEFEND INTENT button. (Cooldown) \n \
	<span style='color:#e8bf67'>EMERGENCY SUMMON:</span> Target the travel tiles leading to your warband's outskirts. \n \
	<span style='color:#e8bf67'>SHATTER MORALE:</span> Target the SPECIAL INTENT button. (Warlord Only | Large Cooldown)"
	range = 12
	associated_skill = /datum/skill/misc/athletics
	chargedrain = 1
	chargetime = 0 SECONDS
	releasedrain = 0 
	recharge_time = 1 SECONDS
	var/order_range = 12
	overlay_state = "recruit_guard"

/mob/living/carbon/human/proc/end_order_exhaustion()
	if(mind)
		mind.order_exhaustion = FALSE
		to_chat(src, span_userdanger("I am prepared to send out another Special Order."))

/obj/effect/proc_holder/spell/invoked/grunt_order/cast(list/targets, mob/user)
	var/mob/caster = user
	var/target = targets[1]

	// target is an intermission travel tile
	// spawn a squad as if it were a Rally Point
	if(istype(target, /obj/structure/fluff/traveltile/warband/azure_to_intermission) || \
		istype(target, /obj/structure/fluff/traveltile/warband/intermission_to_azure) || \
		istype(target, /obj/structure/fluff/traveltile/warband/outskirts_to_intermission))
		var/obj/structure/fluff/traveltile/warband/tile = target
		tile.summon_grunt_squad_at_tile(caster)
		return TRUE

	// ^ if the caster shares the tile's warband ID, the same can be done for the camp-facing outskirts tile, 
	if(istype(target, /obj/structure/fluff/traveltile/warband/outskirts_to_camp))
		var/obj/structure/fluff/traveltile/warband/outskirts_to_camp/camp_tile = target
		if(caster.mind.warband_ID == camp_tile.warband_ID)
			camp_tile.summon_grunt_squad_at_tile(caster)
			return TRUE
		else
			return FALSE

	// target is the caster
	// grunts follow them
	if(target == caster)
		src.process_grunts(order_type = "follow", target = caster)
		return

	// target is a location
	// grunts charge the target location
	else
		var/turf/target_loc = get_turf(target)
		if(target_loc)
			src.process_grunts(order_type = "charge", target_location = target_loc)
			return TRUE
		else
			to_chat(caster, "They cannot go there.")
			return FALSE

// for targeting hud elements
/obj/effect/proc_holder/spell/invoked/grunt_order/InterceptClickOn(mob/living/caster, params, atom/target)
	if(istype(target, /atom/movable/screen/cmode))
		if(!can_cast(caster) || !cast_check(FALSE, caster))
			return FALSE
		src.process_grunts(order_type = "neutral")
		start_recharge()
		return TRUE

	if(istype(target, /atom/movable/screen/rmbintent))
		if(!can_cast(caster) || !cast_check(FALSE, caster))
			return FALSE
		if(target.name == "strong")
			src.process_grunts(order_type = "fight")
		else if(target.name == "defend")
			src.process_grunts(order_type = "survive")
		start_recharge()
		return TRUE

	// those outside the warband w/o the steelhearted trait get extremely stressed out
	// aura farm (temporarily override combat music for all players within 21 tiles)
	if(istype(target, /atom/movable/screen/quad_intents))
		if(!can_cast(caster) || !cast_check(FALSE, caster))
			return FALSE
		if(caster.mind.order_exhaustion)
			to_chat(caster, span_warning("I've given a special order recently. I'll need to wait."))
			return FALSE
		if(ishuman(caster))
			var/mob/living/carbon/human/H = caster
			if(H.mind && H.mind.special_role == "Warlord")
				var/list/horn_sounds = list(
					'sound/misc/warband/warband_warhorn1.ogg',
					'sound/misc/warband/warband_warhorn2.ogg'
				)
				var/chosen_sound = pick(horn_sounds)
				var/sound/S = sound(chosen_sound, repeat = 0, wait = 0, channel = 0, volume = 100) // for those further away / in the upcoming For loop
				playsound(H, chosen_sound, 100, TRUE, 19, pressure_affected = FALSE, ignore_walls = TRUE)
				H.visible_message(span_danger("[H] sounds their warhorn!"))
				var/turf/origin_turf = get_turf(H)
				for(var/mob/living/player in GLOB.player_list)
					if(player.stat == DEAD)
						continue
					if(isbrain(player))
						continue
					if(player == H)
						continue

					var/distance = get_dist(player, origin_turf)
					if(distance > 40)
						continue

					if(distance > 7)
						var/dirtext = " to the "
						var/direction = get_dir(player, origin_turf)
						switch(direction)
							if(NORTH)
								dirtext += "north"
							if(SOUTH)
								dirtext += "south"
							if(EAST)
								dirtext += "east"
							if(WEST)
								dirtext += "west"
							if(NORTHWEST)
								dirtext += "northwest"
							if(NORTHEAST)
								dirtext += "northeast"
							if(SOUTHWEST)
								dirtext += "southwest"
							if(SOUTHEAST)
								dirtext += "southeast"
							else
								dirtext = ", although I cannot make out an exact direction"
						
						SEND_SOUND(player, S)
						to_chat(player, span_warning("I hear a warhorn somewhere [dirtext]."))
				
					// music override
					if(ishuman(player))
						var/mob/living/carbon/human/P = player
						if(P.cmode_music_override != H.mind.warband_manager.combatmusic)
							if(!P.cmode_music_override || P.cmode_music_override.len <= 0)
								P.originalcmode = P.cmode_music
							else if(!P.originalcmode) // if something's already overriding the music, we'll leave it alone
								P.originalcmode = P.cmode_music_override
							P.cmode_music_override = H.mind.warband_manager.combatmusic
							addtimer(CALLBACK(P, TYPE_PROC_REF(/mob/living/carbon/human, restore_original_cmode_music)), 5 MINUTES)
						if(!HAS_TRAIT(P, TRAIT_STEELHEARTED) && P.mind.warband_ID != H.mind.warband_ID && !(P in H.mind.warband_manager.allies))
							P.add_stress(/datum/stressevent/warband_warhorn) // allies & the steelhearted are exempt from the stress hit

				caster.mind.order_exhaustion = TRUE
				addtimer(CALLBACK(caster, TYPE_PROC_REF(/mob/living/carbon/human, end_order_exhaustion)), 25 MINUTES)
				start_recharge()
				return TRUE
		return FALSE

	else
		return ..()

/obj/effect/proc_holder/spell/invoked/grunt_order/proc/process_grunts(order_type, turf/target_location = null, mob/living/target = null)
	var/mob/living/carbon/human/caster = usr
	var/count = 0
	var/msg = ""
	var/cooldown = FALSE

	if((order_type == "fight" || order_type == "survive") && caster.mind.order_exhaustion)
		to_chat(caster, span_warning("I've given a special order recently. I'll need to wait."))
		return

	var/datum/component/squad_controller/manager = caster.GetComponent(/datum/component/squad_controller)
	if(!manager && order_type == "follow")
		manager = caster.AddComponent(/datum/component/squad_controller, caster)

	for(var/mob/other_mob in caster.friends)
		if(!other_mob)
			caster.friends -= other_mob
			continue
		if(get_dist(caster, other_mob) >= 15)
			continue
		if(istype(other_mob, /mob/living/carbon/human/species/human/northern/goon) && !other_mob.client)
			var/mob/living/carbon/human/species/human/northern/goon/grunt = other_mob
			if(grunt.mode == NPC_AI_FLEE)
				continue
			if(!grunt.stat == CONSCIOUS)
				continue

			count += 1
			switch(order_type)
				if("charge")
					if(manager)
						manager.disband_squad()
					grunt.mode = NPC_AI_HUNT
					grunt.start_pathing_to(target_location, force = TRUE)
					msg = "<span style='color:#ec3333'>charge.</span>"
					grunt.target = null
					grunt.next_seek = 0
					grunt.aggressive = TRUE
					grunt.wander = TRUE
					
				if("follow")
					if(manager)
						manager.add_member(grunt)
					
					grunt.mode = NPC_AI_FOLLOW
					grunt.target = target
					grunt.aggressive = FALSE
					grunt.wander = FALSE
					msg = "<span style='color:#57536e'>follow me.</span>"
					
				if("neutral")
					if(manager)
						manager.disband_squad()
					grunt.mode = NPC_AI_IDLE
					grunt.target = null
					grunt.aggressive = FALSE
					msg = "<span style='color:#747474'>stand at ease.</span>"
					grunt.wander = TRUE

				if("fight")
					cooldown = TRUE
					grunt.apply_status_effect(/datum/status_effect/buff/warband_attack)
					msg = "<span style='color:#ff0000'>give 'em hell.</span>"
					
				if("survive")
					cooldown = TRUE
					grunt.apply_status_effect(/datum/status_effect/buff/warband_defend)
					msg = "<span style='color:#ea76d9'>hold fast.</span>"


	if(count>0)
		to_chat(caster, "I've ordered [count] grunts to " + msg)
		if(cooldown)
			caster.mind.order_exhaustion = TRUE
			addtimer(CALLBACK(caster, TYPE_PROC_REF(/mob/living/carbon/human, end_order_exhaustion)), 16 MINUTES)

		if(order_type == "survive")
			var/list/horn_sounds = list(
				'sound/misc/warband/defendhorn_1.ogg',
				'sound/misc/warband/defendhorn_2.ogg'
			)
			var/chosen_sound = pick(horn_sounds)
			playsound(caster, chosen_sound, 100, TRUE, 19, pressure_affected = FALSE, ignore_walls = TRUE)
			caster.visible_message(span_danger("[caster] bellows a slow, cautious tone with their warhorn!"))
		if(order_type == "fight")
			var/list/horn_sounds = list(
				'sound/misc/warband/attackhorn_1.ogg',
				'sound/misc/warband/attackhorn_2.ogg'
			)
			var/chosen_sound = pick(horn_sounds)
			playsound(caster, chosen_sound, 100, TRUE, 19, pressure_affected = FALSE, ignore_walls = TRUE)
			caster.visible_message(span_danger("[caster] signals an assault with a harsh, heavy warhorn!"))
	else
		to_chat(caster, "We weren't able to order anyone.")
