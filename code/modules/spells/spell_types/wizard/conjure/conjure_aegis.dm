/obj/item/rogueweapon/shield/arcyne_aegis
	name = "arcyne aegis"
	desc = "A rare hunk of arcyne energy projected in front of the caster. Slower and more deliberate movement by blades and melee weapons easily pierce through to the squishy Magi behind."
	icon = 'icons/roguetown/weapons/prismatic_weapons64.dmi'
	icon_state = "moonlight_shield"
	pixel_x = -16
	bigboy = TRUE
	wdefense = 9
	coverage = 60
	max_integrity = 200
	force = 5
	unenchantable = TRUE
	sellprice = 0
	static_price = TRUE
	parrysound = list('sound/combat/parry/shield/magicshield (1).ogg', 'sound/combat/parry/shield/magicshield (2).ogg', 'sound/combat/parry/shield/magicshield (3).ogg')
	associated_skill = /datum/skill/combat/shields

/obj/item/rogueweapon/shield/arcyne_aegis/obj_break(damage_flag)
	. = ..()
	if(!QDELETED(src))
		visible_message(span_warning("[src] shatters!"))
		playsound(get_turf(src), 'sound/magic/magic_nulled.ogg', 80)
		qdel(src)

/obj/item/rogueweapon/shield/arcyne_aegis/tome
	name = "arcyne aegis"
	desc = "A shield of arcyne energy projected from a tome. It holds its shape until dispelled, its tome unmade, or its caster is gone."
	wdefense = 10
	coverage = 30
	max_integrity = 120
	associated_skill = /datum/skill/combat/arcyne
	var/datum/weakref/linked_tome

/obj/item/rogueweapon/shield/arcyne_aegis/tome/greater
	name = "greater arcyne aegis"
	wdefense = 10
	coverage = 40
	max_integrity = 220

/obj/item/rogueweapon/shield/arcyne_aegis/tome/grand
	name = "grand arcyne aegis"
	wdefense = 11
	coverage = 60
	max_integrity = 260

/obj/item/rogueweapon/shield/arcyne_aegis/tome/proc/link_tome(obj/item/rogueweapon/spellbook/T)
	linked_tome = WEAKREF(T)

/obj/item/rogueweapon/shield/arcyne_aegis/tome/Destroy()
	var/obj/item/rogueweapon/spellbook/T = linked_tome?.resolve()
	if(T && T.conjured_aegis == src)
		T.conjured_aegis = null
	return ..()
