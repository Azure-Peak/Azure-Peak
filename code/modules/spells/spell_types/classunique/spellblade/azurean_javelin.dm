/* Azurean Javelin - Phalangite ranged AP projectile with slow
Conjures a phantom spear and hurls it. Armor-piercing, applies slowdown on hit.
Does NOT throw your actual weapon. (You can still toss it with
Recall Weapon or a manual throw)

Normal Throw: 25 damage, 20 AP - 5 damage pierces shitty leather.
Empowered Throw: 50 damage, 20 AP - 10 damage pierces hardened leather. Cannot pierce plate (80). Still slows

To make it versatile for dungeon support - if it is a stab intent,
it is a direct throw. Cut intent turns it into an arced throw that
flies over allies.

CD: 12 seconds, you are not a true ranged class and you can literally
rotate tossing your actual spear risk free unlike a real melee. Plus,
it is an AP projectile and high impact vs other light.

*/

/obj/effect/proc_holder/spell/invoked/projectile/azurean_javelin
	name = "Azurean Javelin"
	desc = "The ancient art of skirmishers in arcyne form - conjure a phantom spear and hurl it. \
		Armor-piercing (20 AP), slows the target on hit for 4 seconds regardless of armor. \
		At 3+ momentum: consumes 3 to double damage. \
		In Stab stance: direct throw. In Cut stance: arced throw (flies over allies)."
	clothes_req = FALSE
	range = 7
	projectile_type = /obj/projectile/energy/azurean_javelin
	sound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg')
	releasedrain = 30
	chargedrain = 1
	chargetime = 20
	recharge_time = 10 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 0
	chargedloop = /datum/looping_sound/invokegen
	action_icon = 'icons/mob/actions/spellblade.dmi'
	overlay_state = "azurean_javelin" // Icon by Prominence. Reversed Azurean_Phalanx in a different direction
	invocations = list("Pilum Azureum!")
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE
	var/base_damage = 25
	var/empowered_mult = 2
	var/momentum_cost = 3

/obj/effect/proc_holder/spell/invoked/projectile/azurean_javelin/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	if(!arcyne_get_weapon(H))
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		revert_cast()
		return

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released — empowered javelin!"))

	var/final_damage = empowered ? (base_damage * empowered_mult) : base_damage

	var/datum/intent/current_intent = H.a_intent
	var/blade_class = current_intent?.blade_class || BCLASS_STAB
	if(empowered)
		if(blade_class == BCLASS_CUT)
			projectile_type = /obj/projectile/energy/azurean_javelin/empowered/arc
		else
			projectile_type = /obj/projectile/energy/azurean_javelin/empowered
	else
		if(blade_class == BCLASS_CUT)
			projectile_type = /obj/projectile/energy/azurean_javelin/arc
		else
			projectile_type = /obj/projectile/energy/azurean_javelin

	projectile_var_overrides = list("damage" = final_damage)

	. = ..()

/obj/projectile/energy/azurean_javelin
	name = "Azurean Javelin"
	icon_state = "air_blade_stab"
	damage = 25
	woundclass = BCLASS_STAB
	nodamage = FALSE
	speed = 1.5 // Slow enough to dodge not so slow you will never hit
	armor_penetration = 20
	hitsound = 'sound/combat/hits/bladed/genthrust (1).ogg'

/obj/projectile/energy/azurean_javelin/on_hit(target)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		if(L.anti_magic_check())
			visible_message(span_warning("[src] disperses on contact with [L]!"))
			playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
			return BULLET_ACT_BLOCK
		L.apply_status_effect(/datum/status_effect/debuff/azurean_javelin_slow)
		to_chat(L, span_danger("An arcyne javelin pierces through — my movements are sluggish!"))
		if(firer)
			log_combat(firer, L, "javelin-struck")

/obj/projectile/energy/azurean_javelin/empowered
	name = "Empowered Azurean Javelin"
	icon_state = "youreyesonly"

/obj/projectile/energy/azurean_javelin/arc
	name = "Arced Azurean Javelin"
	arcshot = TRUE

/obj/projectile/energy/azurean_javelin/empowered/arc
	name = "Empowered Arced Azurean Javelin"
	arcshot = TRUE

/datum/status_effect/debuff/azurean_javelin_slow
	id = "azurean_javelin_slow"
	duration = 4 SECONDS
	effectedstats = list(STATKEY_SPD = -3)
	alert_type = null
