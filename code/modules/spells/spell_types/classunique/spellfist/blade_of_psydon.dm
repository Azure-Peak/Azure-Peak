/obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon
	castdrain = SPELLCOST_MINOR_SUMMON
	school = "transmutation"

/obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/bladeofpsydon
	name = "Blade of Psydon"
	desc = "The manifestation of the higher concept of a blade itself. Said to be drawn upon from Noc's treasury of wisdom, each casting a poor facsimile of the perfect weapon They hold.\n\n\
	Centuries ago, the wise Yogi of Naledi travelled to the city of Tarichea, to learn their arts of Spellbladery, and perfected the art of arcyne weapon conjuration, to lend the fists of Psydon a blade when time calls for a cutting edge..."
	clothes_req = FALSE
	drawmessage = "I imagine the perfect weapon, forged by arcyne knowledge, it's edge flawless. \
	I feel it in my mind's eye -- but it's just out of reach. I pull away it's shadow, a bad copy, and yet it is one of a great weapon nonetheless... "
	dropmessage = "Letting go, I watch the blade lose it's form, unable to stay stable without my energy rooting it to this world..."
	overlay_state = "boundkatar"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	hand_path = /obj/item/melee/touch_attack/rogueweapon/bladeofpsydon

/obj/item/melee/touch_attack/rogueweapon/bladeofpsydon
	name = "\improper arcyne katar"
	desc = "This blade throbs, translucent and iridiscent, blueish arcyne energies running through it's translucent surface..."
	catchphrase = null
	icon = 'icons/mob/actions/roguespells.dmi'
	icon_state = "katar_bound"
	charges = 20
	force = 24
	possible_item_intents = list(/datum/intent/katar/cut, /datum/intent/katar/thrust)
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_HUGE
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 999
	max_integrity = 50
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/unarmed
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	wdefense = 0 // Like other katar meant to be used with unarmed parry
	wbalance = WBALANCE_SWIFT
	can_parry = TRUE

/obj/item/melee/touch_attack/rogueweapon/attack_self()
	attached_spell.remove_hand()
