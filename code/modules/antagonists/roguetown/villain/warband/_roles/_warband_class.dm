/datum/advclass
	var/title							// name that exclusively appears in class selection
	var/datum/storytellerlimit			// required storyteller influence for the class to be available
	var/desc
	var/rarity							// storytellers can be chosen as influences multiple times | rarity is the required number of influences before a storyteller-limited class is unlocked
	var/f_name

/datum/mind
	COOLDOWN_DECLARE(squad_spawn_cooldown)
	COOLDOWN_DECLARE(treaty_cooldown)
	var/warband_ID = 0							// character's warband_ID
	var/list/warband_exile_IDs = list()			// when a character is exiled from a warband, we keep the ID of the warband they were exiled from
	var/warbandsetup = FALSE					// failsafe for someone crashing mid-creation | if this is TRUE, they'll get the menu returned on login
	var/list/subordinates = list() 				// a list of a lieutenant's veterans	
	var/list/unresolved_exile_names = list()	// when a lieutenant's subordinate is exiled, they get a choice to resist the decree | if they haven't made the choice, the exile's name will be here
	var/recruiter_name							// the name of someone who recruited the mind as an ally | recruiters will bring along the allies they recruited during a desertion
	var/order_exhaustion = FALSE				// given to a grunt's commander after they send a special order (E.G: fight harder, survive)
	var/squad_size = 2 							// maximum NPC squad size

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

/datum/advclass/warband/envoy
	name = "Warlord's Envoy"
	outfit = /datum/outfit/job/roguetown/warband/warband_envoy
	traits_applied = list(TRAIT_LAWEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = 4,
	)

/datum/outfit/job/roguetown/warband/warband_envoy/pre_equip(mob/living/carbon/human/H, used_slot)
	..()
	to_chat(H, span_warning("As an Envoy, you may return to your Warlord by interacting with a Recruitment Point. In the event of an emergency, use the ABANDON ENVOY verb in your Warband tab. Failing that, re-enter your corpse."))
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
		/obj/item/grown/log/tree/stake	
	)
	if(!used_slot)
		H.set_patron(/datum/patron/divine/undivided)
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
		recruiter_name		// given when a veteran is spawned, an outsider is associated, or an exiled veteran is associated by a new lieutenant
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
						if(!target.mind.recruiter_name)
							target.mind.recruiter_name = user.real_name 
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
			target.mind.recruiter_name = user.real_name // allies are given the recruiter's name as a variable
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
	<span style='color:#e8bf67'>CHARGE:</span> Target the world. \n \
	<span style='color:#e8bf67'>NEUTRAL:</span> Target the Combat Mode button. A grunt's neutrality is easily disrupted. \n \
	<span style='color:#e8bf67'>FIGHT HARDER:</span> Target the STRONG INTENT button. \n \
	<span style='color:#e8bf67'>SURVIVE:</span> Target the DEFEND INTENT button."
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

	else
		return ..()

/obj/effect/proc_holder/spell/invoked/grunt_order/proc/process_grunts(order_type, turf/target_location = null, mob/living/target = null)
	var/mob/living/carbon/human/caster = usr
	var/count = 0
	var/msg = ""
	var/cooldown = FALSE


	for(var/mob/other_mob in caster.friends)
		if(!other_mob)
			caster.friends -= other_mob
			continue
		if(get_dist(caster, other_mob) >= 15) 	// skip them if they're far away
			continue
		if(istype(other_mob, /mob/living/carbon/human/species/human/northern/grunt) && !other_mob.client)
			var/mob/living/carbon/human/species/human/northern/grunt/grunt = other_mob
			if(grunt.mode == NPC_AI_FLEE)		// skip them if they're fleeing
				continue
			if(grunt.stat == UNCONSCIOUS)		// skip them if they got folded
				continue


			count += 1
			switch(order_type)
				if("charge")
					grunt.mode = NPC_AI_FOLLOW
					grunt.start_pathing_to(target_location)
					msg = "<span style='color:#ec3333'>charge.</span>"
					grunt.target = null // we want to ignore combat targets initially, focus on trying to move
					grunt.aggressive = TRUE // make sure they're ready to frag, in case they were on Neutral
					grunt.wander = TRUE
				if("follow")
					grunt.mode = NPC_AI_FOLLOW
					grunt.target = target
					grunt.start_pathing_to(target)
					msg = "<span style='color:#57536e'>follow me.</span>"
					grunt.aggressive = TRUE // make sure they're ready to frag, in case they were on Neutral
					grunt.wander = TRUE
				if("neutral")
					grunt.mode = NPC_AI_IDLE
					grunt.target = null
					grunt.aggressive = FALSE
					msg = "<span style='color:#747474'>stand at ease.</span>"
					grunt.wander = TRUE

				// temp orders / buff orders
				if("fight")
					if(caster.mind.order_exhaustion)
						to_chat(caster, span_warning("I've given a special order recently. I'll need to wait."))
						return
					cooldown = TRUE
					grunt.STASTR = 20
					addtimer(CALLBACK(grunt, TYPE_PROC_REF(/mob/living/carbon/human/species/human/northern/grunt, end_special_order)), 7 SECONDS)
					msg = "<span style='color:#ff0000'>give 'em hell.</span>"
				if("survive")
					if(caster.mind.order_exhaustion)
						to_chat(caster, span_warning("I've given a special order recently. I'll need to wait."))
						return
					cooldown = TRUE
					grunt.STACON = 20
					grunt.STAWIL = 20
					grunt.flee_in_pain = FALSE
					addtimer(CALLBACK(grunt, TYPE_PROC_REF(/mob/living/carbon/human/species/human/northern/grunt, end_special_order)), 15 SECONDS)
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
