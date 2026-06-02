/datum/advclass/gnoll/berserker
	name = "Gnoll Berserker"
	tutorial = "You are a warrior feared for your brutality, dedicated to using your might for your own gain. Might equals right, and you are the reminder of such a saying."
	allowed_sexes = list(MALE, FEMALE)
	traits_applied = list(TRAIT_BLOOD_RESISTANCE) // They have the weakest armor and not really much to make up for it. Blood resistance should help them keep fighting without the bloodloss status fucking them even more.

	
	outfit = /datum/outfit/job/roguetown/gnoll/berserker
	cmode_music = 'sound/music/combat_graggar.ogg'
	category_tags = list(CTAG_GNOLL)
	reset_stats = TRUE
	subclass_stats = list(
		// Weighted towards 16 currently. They don't get statpacks or racial stats, so we could consider this about 2 less at least, maybe 3. For about a 13.
		STATKEY_STR = 4,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = 3,
		STATKEY_INT = -2,
		STATKEY_PER = -2
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,

		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,

		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,

		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/hunting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
	)

/datum/outfit/job/roguetown/gnoll/berserker/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor(H)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		don_pelt(H)
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/claws/gnoll/berseker)
		var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff") // cool wrestling moves
		var/technique_choice = input(H,"Choose your TECHNIQUE.", "TOSS THEM.") as anything in techniques
		switch(technique_choice)
			if("Dropkick - Pushback + Extra Damage")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
			if("Chokeslam - Stamina Damage")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
			if("Stunner - Dazed Debuff")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
			if("Headbutt - Vulnerable Debuff")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/gnoll/consume)

/obj/item/rogueweapon/werewolf_claw/gnoll/berserker
	name = "Berserker Claw"
	force = 30
	/* 
	Beserker does 30 * 1.4 = 42 force with their base STR.
	This does about 50 damage with the chop.
	This does 62 integ damage on the strike intent.
	*/
	possible_item_intents = list(/datum/intent/simple/gnoll_cut/berserker, /datum/intent/simple/werewolf/gnoll, /datum/intent/mace/smash/werewolf/gnoll/berserker, /datum/intent/mace/strike/gnoll)

/datum/intent/simple/gnoll_cut/berserker
	/* 
	Deals about  damage through any armor to cause bleed.
	If you are being healed at all by a Miracle you will most likely outheal this anyway. 
	But it should push holy classes to heal more, and others to think twice about fighting a Gnoll without healing at hand.
	*/ 
	name = "Bleed Out"
	desc = "A low damage slash that penetrates through most armor to cause your foes to bleed."
	penfactor = PEN_HEAVY
	damfactor = 0.01

/obj/item/rogueweapon/werewolf_claw/gnoll/berserker/right
	icon_state = "claw_r"
	wlength = WLENGTH_SHORT

/obj/item/rogueweapon/werewolf_claw/gnoll/berserker/left
	icon_state = "claw_l"
	wlength = WLENGTH_SHORT

/datum/intent/mace/smash/werewolf/gnoll/berserker
	maxrange = 5 // Beserker SMASH
