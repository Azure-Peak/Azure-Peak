/datum/body_marking_set
	///The preview name of the body marking set. HAS to be unique
	var/name
	///List of the body markings in this set
	var/body_marking_list

/datum/body_marking_set/none
	name = "None"
	body_marking_list = list()

/datum/body_marking_set/gradient
	name = "Gradient"
	body_marking_list = list(
		/datum/body_marking/gradient
		)

/datum/body_marking_set/socks
	name = "Socks"
	body_marking_list = list(
		/datum/body_marking/sock
		)

/datum/body_marking_set/belly
	name = "Belly"
	body_marking_list = list(
		/datum/body_marking/belly
		)

/datum/body_marking_set/bellysocks
	name = "Belly & Socks"
	body_marking_list = list(
		/datum/body_marking/belly,
		/datum/body_marking/sock,
	)

/datum/body_marking_set/bellysockstertiary
	name = "Belly & Socks"
	body_marking_list = list(
		/datum/body_marking/belly,
		/datum/body_marking/sock/tertiary,
	)

/datum/body_marking_set/bellyscale
	name = "Scaled Belly"
	body_marking_list = list(
		/datum/body_marking/bellyscale
	)

/datum/body_marking_set/kobold_scale
	name = "Kobold Scales"
	body_marking_list = list(
		/datum/body_marking/kobold_scale
	)

/datum/body_marking_set/tiger
	name = "Tiger"
	body_marking_list = list(
		/datum/body_marking/tiger
	)

/datum/body_marking_set/tiger_dark
	name = "Tiger (Dark)"
	body_marking_list = list(
		/datum/body_marking/tiger/dark
	)

//MOTH

/datum/body_marking_set/moth

/datum/body_marking_set/moth/reddish
	name = "Reddish"
	body_marking_list = list(/datum/body_marking/moth/reddish)

/datum/body_marking_set/moth/royal
	name = "Royal"
	body_marking_list = list(/datum/body_marking/moth/royal)

/datum/body_marking_set/moth/gothic
	name = "Gothic"
	body_marking_list = list(/datum/body_marking/moth/gothic)

/datum/body_marking_set/moth/whitefly
	name = "Whitefly"
	body_marking_list = list(/datum/body_marking/moth/whitefly)

/datum/body_marking_set/moth/burnt_off
	name = "Burnt Off"
	body_marking_list = list(/datum/body_marking/moth/burnt_off)

/datum/body_marking_set/moth/deathhead
	name = "Deathhead"
	body_marking_list = list(/datum/body_marking/moth/deathhead)

/datum/body_marking_set/moth/poison
	name = "Poison"
	body_marking_list = list(/datum/body_marking/moth/poison)

/datum/body_marking_set/moth/ragged
	name = "Ragged"
	body_marking_list = list(/datum/body_marking/moth/ragged)

/datum/body_marking_set/moth/moonfly
	name = "Moonfly"
	body_marking_list = list(/datum/body_marking/moth/moonfly)

/datum/body_marking_set/moth/oakworm
	name = "Oakworm"
	body_marking_list = list(/datum/body_marking/moth/oakworm)

/datum/body_marking_set/moth/jungle
	name = "Jungle"
	body_marking_list = list(/datum/body_marking/moth/jungle)

/datum/body_marking_set/moth/witchwing
	name = "Witchwing"
	body_marking_list = list(/datum/body_marking/moth/witchwing)

/datum/body_marking_set/moth/lovers
	name = "Lovers"
	body_marking_list = list(/datum/body_marking/moth/lovers)


// Every ent preset wears the Sticks growth on the limbs by default; the Heartwood
// pieces sit on top of them.
/datum/body_marking_set/ent_birch
	name = "Birch"
	body_marking_list = list(
		/datum/body_marking/ent/chest/birch_mark,
		/datum/body_marking/ent/limbs/birch,
		/datum/body_marking/ent/limbs/sticks,
		)

/datum/body_marking_set/ent_oak
	name = "Oak"
	body_marking_list = list(
		/datum/body_marking/ent/chest/oak_mark,
		/datum/body_marking/ent/limbs/oak,
		/datum/body_marking/ent/limbs/sticks,
		)

/datum/body_marking_set/ent_swamp
	name = "Swamp"
	body_marking_list = list(
		/datum/body_marking/ent/chest/swamp_mark,
		/datum/body_marking/ent/chest/swamp_over,
		/datum/body_marking/ent/limbs/swamp,
		/datum/body_marking/ent/limbs/sticks,
		)

/datum/body_marking_set/ent_bloom
	name = "Bloom"
	body_marking_list = list(
		/datum/body_marking/ent/head/bloom,
		/datum/body_marking/ent/chest/grass,
		/datum/body_marking/ent/chest/petals_lower,
		/datum/body_marking/ent/limbs/petals,
		/datum/body_marking/ent/limbs/sticks,
		)
