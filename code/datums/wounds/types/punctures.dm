/datum/wound/puncture
	name = "puncture"
	whp = 40
	sewn_whp = 20
	bleed_rate = 0.4
	sewn_bleed_rate = 0.04
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.2
	sewn_clotting_threshold = 0.1
	sew_threshold = 75
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE

/datum/wound/puncture/small
	name = "small puncture"
	whp = 20
	sewn_whp = 10
	bleed_rate = 0.2
	sewn_bleed_rate = 0.02
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.1
	sewn_clotting_threshold = 0.1
	sew_threshold = 35

/datum/wound/puncture/large
	name = "gaping puncture"
	whp = 40
	sewn_whp = 20
	bleed_rate = 1
	sewn_bleed_rate = 0.1
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.5
	sewn_clotting_threshold = 0.25
	sew_threshold = 100

/datum/wound/dynamic/puncture
	name = "puncture"
	whp = 1
	sewn_whp = 0
	bleed_rate = 1
	sewn_bleed_rate = 0.04
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.2
	sewn_clotting_threshold = 0.1
	sew_threshold = 20
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE
	severity_names = list(
		"shallow" = 3,
		"deep" = 6,
		"gnarly" = 9,
		"vicious" = 12,
		"lethal" = 20,
	)

//Puncture (Stab -- not Pick) Omniwounds
//Vaguely: Not nearly as painful, higher bleed cap, easier to sew / heal.

#define PUNC_UPG_WHPRATE 0.5
#define PUNC_UPG_SEWRATE 0.65
#define PUNC_UPG_PAINRATE 0.1
#define PUNC_UPG_CLAMP_RAW 1.3
#define PUNC_ARMORED_BLEED_CLAMP 7

/datum/wound/dynamic/puncture/upgrade(dam, armor)
	whp += (dam * PUNC_UPG_WHPRATE)
	if(!armor)
		set_bleed_rate(PUNC_UPG_CLAMP_RAW)
	else
		switch(dam)
			if(1 to 4)
				set_bleed_rate(bleed_rate + 0.3)
			if(5 to 9)
				set_bleed_rate(bleed_rate + 0.4)
			if(10 to 13)
				set_bleed_rate(bleed_rate + 0.5)
			if(14 to 99)	//At 80 armor and 30 base damage this would require ~16 STR
				set_bleed_rate(bleed_rate + 0.75)
	sew_threshold += (dam * PUNC_UPG_SEWRATE)
	woundpain += (dam * PUNC_UPG_PAINRATE)
	armor_check(armor, PUNC_ARMORED_BLEED_CLAMP)
	update_name()
	..()

#undef PUNC_UPG_WHPRATE
#undef PUNC_UPG_SEWRATE
#undef PUNC_UPG_PAINRATE
#undef PUNC_UPG_CLAMP_RAW
#undef PUNC_ARMORED_BLEED_CLAMP

/datum/wound/dynamic/gouge
	name = "gouge"
	whp = 1
	sewn_whp = 0
	bleed_rate = 1
	sewn_bleed_rate = 0.04
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.2
	sewn_clotting_threshold = 0.1
	sew_threshold = 20
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = FALSE
	severity_names = list(
		"shallow" = 2,
		"deep" = 4,
		"gnarly" = 8,
		"vicious" = 12,
		"lethal" = 20,
	)

//Gouge (Pick) Omniwounds
//Vaguely: Not very painful, not very bleedy, but you can't cauterize them. You're still better off using stab every time.
//Addendum: This was made with the assumption that pick intent penetrates most armors (and being able to crit through them).

#define GOUGE_UPG_BLEEDRATE 0.01
#define GOUGE_UPG_WHPRATE 1
#define GOUGE_UPG_SEWRATE 0.3
#define GOUGE_UPG_PAINRATE 0.01
#define GOUGE_UPG_CLAMP_ARMORED 0.5
#define GOUGE_UPG_CLAMP_RAW 0.5
#define GOUGE_ARMORED_BLEED_CLAMP 4

/datum/wound/dynamic/gouge/upgrade(dam, armor)
	whp += (dam * GOUGE_UPG_WHPRATE)
	set_bleed_rate(bleed_rate + clamp((dam * GOUGE_UPG_BLEEDRATE), 0.1, ((armor > 0) ? GOUGE_UPG_CLAMP_ARMORED : GOUGE_UPG_CLAMP_RAW)))
	sew_threshold += (dam * GOUGE_UPG_SEWRATE)
	woundpain += (dam * GOUGE_UPG_PAINRATE)
	armor_check(armor, GOUGE_ARMORED_BLEED_CLAMP)
	update_name()
	..()

#undef GOUGE_UPG_BLEEDRATE
#undef GOUGE_UPG_WHPRATE
#undef GOUGE_UPG_SEWRATE
#undef GOUGE_UPG_PAINRATE
#undef GOUGE_UPG_CLAMP_ARMORED
#undef GOUGE_UPG_CLAMP_RAW
#undef GOUGE_ARMORED_BLEED_CLAMP

/datum/wound/puncture/drilling
	name = "drilling"
	check_name = span_bloody("<B>DRILLING</B>")
	severity = WOUND_SEVERITY_SUPERFICIAL
	whp = 40
	sewn_whp = 20
	bleed_rate = 1
	sewn_bleed_rate = 0.1
	clotting_rate = null
	clotting_threshold = null
	sew_threshold = 100
	passive_healing = 0
	sleep_healing = 0

/datum/wound/puncture/drilling/sew_wound()
	qdel(src)
	return TRUE

/datum/wound/puncture/drilling/cauterize_wound()
	qdel(src)
	return TRUE
