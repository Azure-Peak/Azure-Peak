#define MT_BOMB_HIT "bomb_hit"
#define BOMB_HIT_IMMUNITY_DURATION 1 SECONDS
#define BOMB_CRIT_LEFTOVERS pick("smithereens", "thin gruel", "bits", "spare parts", "pieces", "kingdom come", "another timeline", "yesterday", "hell", "PSYDON's embrace", "Necra's embrace", "Zizo's embrace", "Astrata and back")
#define BOMB_SOUND pick('sound/misc/explode/bottlebomb (1).ogg', 'sound/misc/explode/bottlebomb (2).ogg')

/mob/living/proc/can_be_gibbed()
	// lame checks here, to hard-block them from being affected by the bomb crits
	var/list/gib_blacklist = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon,
		/mob/living/simple_animal/hostile/retaliate/rogue/dragon,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll,
		/mob/living/simple_animal/hostile/retaliate/rogue/minotaur,
		/mob/living/simple_animal/hostile/retaliate/rogue/revenant,
		/mob/living/carbon/human/species/familiar,
	)

	var/list/species_blacklist = list(
		/datum/species/familiar,
		/datum/species/white_stag,
	)
	// lazy checks here
	if(maxHealth > 500 || HAS_TRAIT(src, TRAIT_HARDDISMEMBER) || HAS_TRAIT(src, TRAIT_NODISMEMBER)) // most high-end monsters have HP above 1000, so this is a safe number I hope / HARDDISMEMBER for the lazy people who don't want to be updating this over and over when making their own mobs
		return FALSE

	for(var/mob_type in gib_blacklist)
		if(istype(src, mob_type))
			return FALSE

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.dna?.species)
			for(var/species_type in species_blacklist)
				if(istype(H.dna.species, species_type))
					return FALSE
	return TRUE

/obj/item/explosive
	name = "explosive"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	grid_width = 32
	grid_height = 32
	abstract_type = /obj/item/explosive
	var/mob/thrower
	var/PVE_damage = 40
	var/tripcrit = 0
	var/exploding = FALSE
	/// Goes off when it lands after being thrown
	var/fragile = FALSE
	/// Chance a thrown fragile explosive fails to go off
	var/prob2fail = 0

/obj/item/explosive/proc/stowed()
	for(var/atom/A = loc; A; A = A.loc)
		if(ismob(A) && HAS_TRAIT(A, TRAIT_BOMBER_EXPERT))
			var/mob/M = A
			return !(src in M.held_items)
	return FALSE

/obj/item/explosive/proc/light()
	detonate()

/obj/item/explosive/proc/blast(turf/T, forced)
	return

/obj/item/explosive/proc/detonate(forced)
	if(QDELETED(src) || exploding)
		return FALSE
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	exploding = TRUE
	STOP_PROCESSING(SSfastprocess, src)
	blast(T, forced)

	var/mob/owner
	if(isliving(thrower) && HAS_TRAIT(thrower, TRAIT_BOMBER_EXPERT)) // these guys know what they're doing, but a random joe can kill themselves trying sure
		owner = thrower
	for(var/obj/item/explosive/E in range(2, T)) // look what you FUCKING did you rascal
		if(E == src || E.exploding || QDELETED(E) || !isturf(E.loc))
			continue
		if(owner)
			E.thrower = owner
			E.tripcrit = 100
		E.detonate(TRUE)

	qdel(src)
	return TRUE

/obj/item/explosive/proc/crit(mob/living/target, damtype, armor)
	playsound(get_turf(target), 'sound/combat/tf2crit.ogg', 100, FALSE)
	if(target.can_be_gibbed())
		target.visible_message(span_crit("<b>Critical hit!</b> The explosive blasts them to [BOMB_CRIT_LEFTOVERS]!"))
		target.gib(TRUE, TRUE, FALSE, TRUE)
		return
	target.visible_message(span_crit("<b>Critical hit!</b> The explosive deals devastating damage!"))
	target.apply_damage(PVE_damage, damtype, BODY_ZONE_CHEST, armor)

/obj/item/explosive/ex_act()
	if(!stowed())
		detonate(TRUE)

/obj/item/explosive/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(throwingdatum)
		thrower = throwingdatum.thrower
	if(!fragile)
		return ..()
	..()
	sleep(1)
	if(QDELETED(src))
		return
	if(prob(prob2fail))
		extinguish()
		return
	detonate()

/obj/item/explosive/attackby(obj/item/I, mob/user, params)
	..()
	if(anchored || (!istype(I, /obj/item/natural/fibers) && !istype(I, /obj/item/natural/bundle/fibers)))
		return
	if(locate(/obj/item/tripwire) in get_turf(user))
		to_chat(user, span_warning("There is already a trap here."))
		return

	user.visible_message(span_warning("[user] begins to prepare [src]."), span_notice("I begin to set-up [src] with [I]."))
	if(istype(I, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/bundle = I
		bundle.use(1)
	else
		qdel(I)

	var/expert = HAS_TRAIT(user, TRAIT_BOMBER_EXPERT)
	if(!do_after(user, expert ? 0.75 SECONDS : (7 SECONDS - user.get_skill_level(/datum/skill/craft/traps)), TRUE, src))
		to_chat(user, span_warning("I stop preparing [src]."))
		new /obj/item/natural/fibers(user.loc)
		if(!expert && prob(20))
			to_chat(user, span_warningbig("Uh oh."))
			light()
		return

	var/obj/item/explosive/fused/tripbomb/trip = new(get_turf(src))
	trip.payload = type
	trip.icon = icon
	trip.icon_state = initial(icon_state)
	trip.add_overlay(mutable_appearance('icons/roguetown/items/misc.dmi', "tripbomb"))
	trip.setter = WEAKREF(user)
	trip.tripcrit = tripcrit
	var/obj/item/tripwire/wire = new(get_turf(user))
	wire.dir = user.dir
	wire.payload = trip
	trip.trips += wire
	if(expert)
		trip.alpha = 30
		wire.alpha = 30

	user.visible_message(span_warning("[user] finishes setting up [trip]."), span_notice("I finish setting up [trip]."))
	qdel(src)

/obj/item/explosive/fused
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	grid_height = 64
	abstract_type = /obj/item/explosive/fused
	var/fuze = 50
	var/lit = FALSE

/obj/item/explosive/fused/light()
	if(QDELETED(src) || lit || exploding)
		return
	lit = TRUE
	icon_state = "[initial(icon_state)]-lit"
	START_PROCESSING(SSfastprocess, src)
	playsound(loc, 'sound/items/firelight.ogg', 100)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/explosive/fused/extinguish()
	. = ..()
	if(!lit || exploding)
		return
	lit = FALSE
	STOP_PROCESSING(SSfastprocess, src)
	playsound(loc, 'sound/items/firesnuff.ogg', 100)
	icon_state = initial(icon_state)
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()

/obj/item/explosive/fused/fire_act()
	if(!stowed())
		light()

/obj/item/explosive/fused/spark_act()
	fire_act()

/obj/item/explosive/fused/process()
	if(!lit)
		return PROCESS_KILL
	if(--fuze <= 0)
		detonate(TRUE)
		return PROCESS_KILL

/obj/item/explosive/fused/bottle
	name = "bottle bomb"
	desc = "A fiery explosion waiting to be coaxed from its glass prison."
	icon_state = "bbomb"
	flags_ai_inventory = AI_ITEM_THROWING
	fragile = TRUE
	prob2fail = 5
	var/spawn_shard = FALSE
	/// Radius of the weak fire left behind
	var/firerange = 3

/obj/item/explosive/fused/bottle/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click with a torch, lamptern, flint, or other ignition source to light its fuse. Alternatively, the fuse can be lit by using it on a hearth, brazier, scone, or other ignition source.")
	. += span_info("Once lit, most bombs will detonate after a very short period of time.")

/obj/item/explosive/fused/bottle/Initialize(mapload)
	. = ..()
	fuze = rand(40, 60)

/obj/item/explosive/fused/bottle/blast(turf/T, forced)
	var/critbang = 0
	var/can_crit = FALSE
	if(isliving(thrower))
		var/mob/living/M = thrower
		critbang = min(50, (M.get_skill_level(/datum/skill/craft/engineering) * 5) + (M.STALUC * 2)) + tripcrit // caps at 50% chance, tripmines are excluded from the cap
		can_crit = HAS_TRAIT(M, TRAIT_BOMBER_EXPERT)

	playsound(T, 'sound/items/firesnuff.ogg', 100)

	for(var/mob/living/target in range(1, T))
		if(target == thrower && can_crit)
			continue
		if(target.mob_timers[MT_BOMB_HIT] && world.time < target.mob_timers[MT_BOMB_HIT] + BOMB_HIT_IMMUNITY_DURATION)
			continue
		target.mob_timers[MT_BOMB_HIT] = world.time

		if(spawn_shard)
			embed_bomb_shrapnel(target, /obj/item/natural/glass_shard/shrapnel)

		var/scorched = get_scorch_stacks(target)
		var/armor = target.run_armor_check(BODY_ZONE_CHEST, "fire", blade_dulling = BCLASS_BURN, damage = PVE_damage, no_debuff = TRUE)
		target.apply_damage(PVE_damage, BURN, BODY_ZONE_CHEST, armor)
		target.apply_status_effect(/datum/status_effect/debuff/staggered)

		if(can_crit && !target.mind && ((target.stat != CONSCIOUS && target.can_be_gibbed()) || (scorched && prob(critbang))))
			crit(target, BURN, armor)
			continue

		apply_scorch_stack(target, 1)

	explosion(T, light_impact_range = 2, smoke = (tripcrit > 0), adminlog = FALSE, soundin = BOMB_SOUND, bomb_owner = thrower)

	var/spread = (lit || forced) ? firerange : 1 // all credits to ryon!!!
	for(var/turf/open/O in dview(spread, T))
		if(istransparentturf(O) || cheap_hypotenuse(O.x, O.y, T.x, T.y) > spread || (locate(/obj/effect/curtain_fire) in O))
			continue
		var/obj/effect/curtain_fire/weak/F = new(O)
		F.caster_ref = WEAKREF(thrower)

/obj/item/explosive/fused/powder
	abstract_type = /obj/item/explosive/fused/powder
	PVE_damage = 120
	/// Radius in which mobs take blast damage, falling off with distance
	var/blastrange = 3
	/// Structures in the blast radius take damage too
	var/razes = FALSE
	var/devrange = 0
	var/heavyrange = 1
	var/lightrange = 4
	var/flamerange = 0
	var/ignorecap = FALSE

/obj/item/explosive/fused/powder/blast(turf/T, forced)
	for(var/atom/movable/A in dview(blastrange, T))
		if(QDELETED(A))
			continue
		var/falloff = 1 - get_dist(A, T) / (blastrange + 1)
		if(isliving(A))
			var/mob/living/L = A
			var/dmg = PVE_damage * falloff
			var/armor = L.run_armor_check(BODY_ZONE_CHEST, "blunt", blade_dulling = BCLASS_BLUNT, damage = dmg, no_debuff = TRUE)
			L.apply_damage(dmg, BRUTE, BODY_ZONE_CHEST, armor)
			L.apply_status_effect(/datum/status_effect/debuff/staggered)
		else if(razes && isstructure(A))
			var/obj/structure/S = A
			S.take_damage(PVE_damage * 2 * falloff, BRUTE, "blunt", FALSE)
	//IMPORTANT!! go into walls /turf/closed/wall/ and see /turf/closed/wall/ex_act. Its bounded with /proc/explosion. Same for /obj/structure and /obj/structure/ex_act because if you going to fuck intergity or whatever this shit called players will skin you alive for breaking their equipment and keys
	//also /turf/open/floor/ex_act for comment above
	explosion(T, extreme_impact_range = devrange, heavy_impact_range = heavyrange, light_impact_range = lightrange, ignorecap = ignorecap, flame_range = flamerange, smoke = TRUE, soundin = BOMB_SOUND)

/obj/item/explosive/fused/powder/stick
	name = "blastpowder stick"
	desc = "A bewicked vessel, filled to the brim with explosive powder. Ignition begets eruption; a dizzying shockwave which pulverizes stone, wood, and flesh alike with little discrimination."
	icon_state = "tnt_stick"

/obj/item/explosive/fused/powder/satchel
	name = "blastpowder satchel"
	desc = "A bewicked satchel, stuffed with a multitude of explosive-filled sticks. Too heavy to throw, and too powerful to withstand - for nothing but dust and echoes will remain, once \
	the shockwave abates. </br>'When the fuse reaches its zenith, the blastpowder will detonate. The explosion will generate a temperature of almost one hundred million thermes. Don't be \
	here when it blows.'"
	icon_state = "satchel_bomb"
	w_class = WEIGHT_CLASS_BULKY
	throw_range = 2
	throw_speed = 0.3
	grid_width = 256
	grid_height = 256
	PVE_damage = 250
	blastrange = 6
	razes = TRUE
	devrange = 3
	heavyrange = 5
	lightrange = 8
	flamerange = 5

//admin only mega bomb, should never be made craftable
/obj/item/explosive/fused/powder/satchel/mega
	name = "mega blastpowder satchel"
	desc = "An overfilled satchel of blastpowder originally made by Lubbin Bleat, Otava's famed sheep-kin bathhouse attendant and ruler of the slumberbeat.. \
	</br>This bomb has been outlawed by all of Psydonia's kingdoms, and labled as a threat by both the Churches of the Pantheon and Orthodoxy. \
	</br> <font color='FF0000'>IF YOU SEE A LIT WICK, YOU BEST RUN AWAY QUICK!</font>"
	dropshrink = 5
	throw_range = 1
	PVE_damage = 800
	blastrange = 10
	devrange = 10
	heavyrange = 15
	lightrange = 40
	flamerange = 10
	ignorecap = TRUE //removing restrictions, may the gods have mercy on you all

/obj/item/explosive/fused/tripbomb
	name = "trip bomb"
	desc = "A detonation waiting to be coaxed from its glass prison. This one lies in wait."
	icon_state = "bbomb"
	w_class = WEIGHT_CLASS_NORMAL
	anchored = TRUE
	dropshrink = 0.5
	/// Explosive spawned and set off when the trap is sprung
	var/payload = /obj/item/explosive/fused/bottle
	var/list/obj/item/tripwire/trips = list()
	var/datum/weakref/setter

/obj/item/explosive/fused/tripbomb/Destroy()
	for(var/obj/item/tripwire/W as anything in trips)
		W.payload = null
		qdel(W)
	trips = null
	return ..()

/obj/item/explosive/fused/tripbomb/light()
	detonate()

/obj/item/explosive/fused/tripbomb/detonate(forced)
	if(QDELETED(src) || exploding)
		return FALSE
	exploding = TRUE
	var/mob/owner = setter?.resolve()
	var/obj/item/explosive/E = new payload(loc)
	E.thrower = owner
	E.tripcrit = tripcrit
	qdel(src)
	if(istype(E, /obj/item/explosive/fused))
		var/obj/item/explosive/fused/F = E
		F.fuze = (owner && HAS_TRAIT(owner, TRAIT_BOMBER_EXPERT)) ? 0.25 SECONDS : 1 SECONDS
	E.light()
	return TRUE

/obj/item/explosive/fused/tripbomb/proc/disarm(mob/user, atom/target)
	var/skill = user.get_skill_level(/datum/skill/craft/traps)
	if(!do_after(user, HAS_TRAIT(user, TRAIT_BOMBER_EXPERT) ? 0.75 SECONDS : (7 SECONDS - skill), TRUE, target))
		to_chat(user, span_warning("I stop slicing [target]."))
		if(!prob(skill * 10))
			to_chat(user, span_warningbig("Oh no."))
			light()
		return
	if(QDELETED(src) || exploding)
		return
	new payload(loc)
	qdel(src)

/obj/item/explosive/fused/tripbomb/attackby(obj/item/I, mob/user, params)
	if(user.used_intent.blade_class == BCLASS_CUT && I.wlength == WLENGTH_SHORT)
		disarm(user, src)
		return
	if(istype(I, /obj/item/natural/dirtclod))
		alpha = 90 - user.get_skill_level(/datum/skill/craft/traps) * 10
		qdel(I)
	return ..()

/obj/item/tripwire
	name = "fibre tripwire"
	desc = "You almost missed it - phew. Best cut it with a blade to disarm it."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "wire"
	anchored = TRUE
	var/obj/item/explosive/fused/tripbomb/payload
	var/triggered = FALSE

/obj/item/tripwire/Destroy()
	if(payload)
		payload.trips -= src
		payload = null
	var/turf/T = get_turf(src)
	if(T)
		new /obj/item/natural/fibers(T)
	return ..()

/obj/item/tripwire/attackby(obj/item/I, mob/user, params)
	if(user.used_intent.blade_class == BCLASS_CUT && I.wlength == WLENGTH_SHORT)
		if(!triggered && payload)
			payload.disarm(user, src)
		return
	if(istype(I, /obj/item/natural/dirtclod))
		alpha = 90 - user.get_skill_level(/datum/skill/craft/traps) * 10
		qdel(I)
	return ..()

/obj/item/tripwire/Crossed(atom/movable/O)
	..()
	if(triggered || !isliving(O) || QDELETED(payload))
		return
	var/mob/living/victim = O
	var/mob/owner = payload.setter?.resolve()
	if(owner && victim == owner && HAS_TRAIT(owner, TRAIT_BOMBER_EXPERT))
		return
	if(victim.STALUC >= 10 && prob((victim.STALUC - 10) * 10))
		to_chat(victim, span_warning("Your foot narrowly misses [src]. Be careful!"))
		return
	triggered = TRUE
	playsound(victim, 'sound/items/knife_open.ogg', 100, TRUE)
	victim.visible_message(span_warningbig("[victim] steps on [src]!"),
		span_warningbig("I feel the snapping of twine under my boot!"))
	victim.Slowdown(5)
	if(victim.STAINT <= 10 || victim.STAPER <= 10 || !victim.mind)
		victim.Immobilize(5)
		victim.emote(pick("huh","whimper","fwhine","gasp"))
	payload.tripcrit = 50
	payload.light()

/obj/item/explosive/impact
	name = "impact grenade"
	desc = "A fragile canister, filled with an explosive surprise. Shards of flint line its thin sleeve, aching to ignite at the slightest disturbance."
	icon_state = "impact_grenade"
	dropshrink = 0.6
	throw_speed = 1
	abstract_type = /obj/item/explosive/impact
	fragile = TRUE
	/// Bomber experts refuse to set this off in their hands
	var/cautious = TRUE

/obj/item/explosive/impact/attack_self(mob/user)
	. = ..()
	if(cautious && HAS_TRAIT(user, TRAIT_BOMBER_EXPERT))
		to_chat(user, span_warning("Out of all the things you'd want to be fiddling with, you choose the worst? Bad idea."))
		return
	detonate()

/obj/item/explosive/impact/shrapnel
	/// Number of shrapnel fragments flung outwards on detonation
	var/shards = 10

/obj/item/explosive/impact/shrapnel/blast(turf/T, forced)
	var/critbang = 0
	var/can_crit = FALSE
	if(isliving(thrower))
		var/mob/living/M = thrower
		critbang = (M.get_skill_level(/datum/skill/craft/engineering) * 10) + (M.STALUC * 2) + tripcrit
		can_crit = HAS_TRAIT(M, TRAIT_BOMBER_EXPERT)

	for(var/mob/living/target in T)
		if(target == thrower && can_crit)
			continue
		if(target.mob_timers[MT_BOMB_HIT] && world.time < target.mob_timers[MT_BOMB_HIT] + BOMB_HIT_IMMUNITY_DURATION)
			continue
		target.mob_timers[MT_BOMB_HIT] = world.time

		var/armor = target.run_armor_check(BODY_ZONE_CHEST, "blunt", blade_dulling = BCLASS_BLUNT, damage = PVE_damage, no_debuff = TRUE)
		target.apply_damage(PVE_damage, BRUTE, BODY_ZONE_CHEST, armor)
		target.apply_status_effect(/datum/status_effect/debuff/staggered)

		if(can_crit && !target.mind && prob(critbang + (target.stat != CONSCIOUS ? 50 : 0)))
			crit(target, BRUTE, armor)

	for(var/i in 1 to shards)
		var/obj/projectile/bullet/bombshard/P = new(T)
		if(can_crit)
			P.firer = thrower
		P.fire(i * 360 / shards + rand(-10, 10))

	explosion(T, heavy_impact_range = 1, light_impact_range = 4, smoke = (tripcrit > 0), adminlog = FALSE, soundin = BOMB_SOUND, bomb_owner = thrower)

/obj/projectile/bullet/bombshard
	name = "shrapnel"
	damage = 20
	range = 6
	woundclass = BCLASS_PIERCE
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'

/obj/projectile/bullet/bombshard/on_hit(atom/target, blocked = FALSE)
	if(target == firer && HAS_TRAIT(firer, TRAIT_BOMBER_EXPERT))
		return
	. = ..()
	if(isliving(target) && prob(50))
		embed_bomb_shrapnel(target, /obj/item/bomb_shrapnel, 1)

/obj/item/smokeshell
	name = "gas belcher shell"
	desc = "A vented canister, bereft of its noxious payload. How long can you hold your breath?"
	dropshrink = 0.6
	icon_state = "smokeshell_blank"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	throw_speed = 1
	grid_width = 32
	grid_height = 32

/obj/item/explosive/impact/smoke
	name = "gas belcher"
	desc = "A vented canister, filled with an obfuscating payload. Wisps of charsmoke occasionally escape from its ported maw."
	icon_state = "smokeshell_blue"
	cautious = FALSE
	var/datum/effect_system/smoke_spread/smoke_type = /datum/effect_system/smoke_spread
	var/smokerange = 2
	/// Left behind once the payload is spent
	var/residue = /obj/item/smokeshell
	var/smokesound = 'sound/misc/explode/incendiary (1).ogg'
	var/smokevol = 100

/obj/item/explosive/impact/smoke/blast(turf/T, forced)
	playsound(T, smokesound, smokevol)
	var/datum/effect_system/smoke_spread/smoke = new smoke_type
	smoke.set_up(smokerange, T)
	smoke.start()
	new residue(T)

/obj/item/explosive/impact/smoke/poison_gas
	name = "poison gas belcher"
	desc = "A vented canister, filled with a noxious payload. Even a mere whiff of its verdant surprise threatens to choke you apart."
	icon_state = "smokeshell_green"
	smoke_type = /datum/effect_system/smoke_spread/poison_gas

/obj/item/explosive/impact/smoke/healing_gas
	name = "healing gas belcher"
	desc = "A vented canister, filled with a medicinal payload. The crimson smoke tickles your lips; a taste not unlike sweetened lifeblood."
	icon_state = "smokeshell_red"
	smoke_type = /datum/effect_system/smoke_spread/healing_gas

/obj/item/explosive/impact/smoke/fire_gas
	name = "burning gas belcher"
	desc = "A vented canister, filled with a fiery payload. It feels uncomfortably hot in your palm, and carries a curious scent - not unlike roasted frybirds."
	icon_state = "smokeshell_orange"
	smoke_type = /datum/effect_system/smoke_spread/fire_gas

/obj/item/explosive/impact/smoke/blind_gas
	name = "blinding gas belcher"
	desc = "A vented canister, filled with an irritating payload. Your eyes are already watering from its ebbed fumes, and the numbness threatens to shutter your lids without resistance."
	icon_state = "smokeshell_blue"
	smoke_type = /datum/effect_system/smoke_spread/blind_gas

/obj/item/explosive/impact/smoke/mute_gas
	name = "silent gas belcher"
	desc = "A vented canister, filled with a numbing payload. A strange prickling sensation graces your mind and throat, not unlike the 'pins and needles' of a sleeping limb."
	icon_state = "smokeshell_purple"
	smoke_type = /datum/effect_system/smoke_spread/mute_gas

/obj/item/explosive/impact/smoke/bomb
	name = "smoke bomb"
	desc = "A soft sphere with an alchemical mixture and a dispersion mechanism hidden inside. Any pressure will detonate it."
	icon_state = "smokebomb"
	dropshrink = 0
	slot_flags = ITEM_SLOT_HIP
	throw_speed = 0.5
	grid_height = 64
	flags_ai_inventory = AI_ITEM_THROWING
	smokerange = 3
	residue = /obj/item/natural/ash
	smokesound = 'sound/items/smokebomb.ogg'
	smokevol = 50

/obj/item/natural/glass_shard/shrapnel
	name = "jagged shard"
	embedding = list("embedded_pain_multiplier" = 1.2, "embed_chance" = 100, "embedded_fall_chance" = 0)

/obj/item/natural/glass_shard/shrapnel/dropped(mob/user)
	. = ..()
	if(QDELETED(src))
		return
	if(prob(25))
		return
	var/turf/T = get_turf(user)
	qdel(src)
	if(T)
		new /obj/effect/decal/cleanable/debris/glassy(T)

/obj/item/bomb_shrapnel
	name = "jagged shrapnel"
	desc = "A jagged fragment of explosive debris. Tough luck..."
	icon_state = ""
	invisibility = INVISIBILITY_MAXIMUM
	embedding = list("embedded_pain_multiplier" = 1.2, "embed_chance" = 100, "embedded_fall_chance" = 0)

/obj/item/bomb_shrapnel/dropped(mob/user)
	. = ..()
	if(QDELETED(src))
		return
	var/turf/T = get_turf(user)
	qdel(src)
	if(T)
		new /obj/effect/decal/cleanable/debris/stony(T)

// speshul embed that checks your armor durability percentage and tries to go through it, the more damaged your armor(s), the more likely you'll get shrapnel, and vice versa
/proc/embed_bomb_shrapnel(mob/living/target, shrapnel_type = /obj/item/natural/glass_shard/shrapnel, most = 3)
	if(!target || !iscarbon(target))
		return FALSE

	var/mob/living/carbon/C = target
	var/list/valid_bodyparts = list()

	for(var/obj/item/bodypart/limb in C.bodyparts)
		if(limb.body_zone in list(BODY_ZONE_CHEST, BODY_ZONE_L_LEG, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_R_ARM))
			valid_bodyparts += limb

	if(!length(valid_bodyparts))
		return FALSE

	var/hit_any = FALSE
	var/shrapnel_amount = rand(1, min(most, length(valid_bodyparts)))

	for(var/i = 1 to shrapnel_amount)
		if(!length(valid_bodyparts))
			break

		var/obj/item/bodypart/limb = pick_n_take(valid_bodyparts)
		var/obj/item/protection

		for(var/obj/item/I in C.get_equipped_items())
			if(!(I.body_parts_covered & limb.body_part))
				continue

			protection = I
			break

		var/protection_chance = 0

		if(protection && protection.max_integrity)
			var/eff_maxint = protection.max_integrity - (protection.max_integrity * protection.integrity_failure)
			var/eff_currint = max(protection.obj_integrity - (protection.max_integrity * protection.integrity_failure), 0)

			if(eff_maxint > 0)
				protection_chance = round((eff_currint / eff_maxint) * 100)

		if(protection && prob(protection_chance))
			limb.receive_damage(10)
			hit_any = TRUE
			continue

		var/obj/item/shrapnel = new shrapnel_type
		limb.add_embedded_object(shrapnel, FALSE, TRUE, TRUE)
		hit_any = TRUE

	return hit_any

/obj/effect/curtain_fire/weak
	name = "spilt flames"
	desc = "A thin film of burning bottle-fire."
	icon_state = "1"
	lifetime = 10 SECONDS
	tick_damage = 15
	scorch = 0

#undef MT_BOMB_HIT
#undef BOMB_HIT_IMMUNITY_DURATION
#undef BOMB_CRIT_LEFTOVERS
#undef BOMB_SOUND
