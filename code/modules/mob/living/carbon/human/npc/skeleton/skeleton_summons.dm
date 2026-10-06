/mob/living/carbon/human/species/skeleton/npc/summon //Unique skilled NPC summons exclusive to necromancers, these guys are a menace to fight.
	npc_archetype = /datum/npc_archetype/skeleton/summon

/mob/living/carbon/human/species/skeleton/npc/summon/after_creation()
	. = ..()
	energy = max_energy //Always combat-ready
	for(var/obj/item/equipped_item in get_equipped_items() + held_items)
		equipped_item.AddComponent(/datum/component/item_on_drop/dust)
	for(var/obj/item/held_item in held_items)
		ADD_TRAIT(held_item, TRAIT_NODROP, TRAIT_GENERIC)
