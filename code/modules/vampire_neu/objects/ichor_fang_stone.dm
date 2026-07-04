/obj/structure/ichor_stone
	name = "Bloodstained Stone"
	desc = "A blood soaked rock, seemingly used as a pedestal for a blade, it hums softly with unholy energies."
	max_integrity = 999999
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stonebig2"
	color ="#994a4a" // bloodstained look

/obj/structure/ichor_stone/Initialize()
	. = ..()
	set_light(3, 3, 20, l_color = LIGHT_COLOR_BLOOD_MAGIC) //The funny rock, glows now.

/obj/structure/ichor_stone/examine(mob/user)
	. = ..()
	if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
		. += span_bloody("A pedestal for your Ichor Fang. You can also recall it for 500 vitae, even if it gets destroyed.")

/obj/structure/ichor_stone/attack_hand(mob/living/carbon/human/user)
	if(!istype(user))
		return

	var/datum/antagonist/vampire/vampire = user.mind.has_antag_datum(/datum/antagonist/vampire)
	if(!vampire)
		return

	if(user.clan.clan_leader != user)
		return

	if(user.get_vampire_generation() < GENERATION_METHUSELAH)
		return

	if(user.bloodpool < 500)
		to_chat(user, span_warning("You need 500 vitae to summon your sword."))
		return

	var/choice = alert(user, "Would you like to summon your Ichor Fang for 500 vitae?", "CRIMSON STONE", "MAKE IT SO", "I RESCIND")
	if(choice != "MAKE IT SO")
		return

	user.adjust_bloodpool(-500)
	new /obj/item/rogueweapon/sword/long/judgement/vlord(get_turf(src))
