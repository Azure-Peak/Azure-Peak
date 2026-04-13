/proc/get_templar_patron_dagger(mob/living/carbon/human/H)
	switch(H.patron?.type)
		if(/datum/patron/divine/astrata)
			return /obj/item/rogueweapon/huntingknife/idagger/steel/astrata
		if(/datum/patron/divine/noc)
			return /obj/item/rogueweapon/huntingknife/idagger/steel/noc_twilight
		if(/datum/patron/divine/necra)
			return /obj/item/rogueweapon/huntingknife/idagger/steel/necra_osteotome
		if(/datum/patron/divine/ravox)
			return /obj/item/rogueweapon/huntingknife/idagger/steel/ravox
		if(/datum/patron/divine/malum)
			return /obj/item/rogueweapon/huntingknife/idagger/steel/malum
		if(/datum/patron/divine/dendor)
			return /obj/item/rogueweapon/huntingknife/idagger/steel/dendor
		if(/datum/patron/divine/abyssor)
			return /obj/item/rogueweapon/huntingknife/idagger/steel/abyssor
		if(/datum/patron/divine/eora)
			return /obj/item/rogueweapon/huntingknife/idagger/steel/eora_misericorde
		if(/datum/patron/divine/pestra)
			return /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle
		if(/datum/patron/divine/xylix)
			return /obj/item/rogueweapon/huntingknife/idagger/steel/devilsknife
		if(/datum/patron/divine/undivided)
			return /obj/item/rogueweapon/huntingknife/idagger/steel/undivided
	return null

/obj/item/rogueweapon/huntingknife/idagger/steel/astrata
	name = "dawnbringer"
	desc = "A blade forged in the name of the Sun Tyrant. Radiant, sharp, and imbued with a glimmering sheen.\
	For when Her order demands it."
	icon = 'icons/roguetown/weapons/templar_daggers32.dmi'
	icon_state = "astrata_dagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/ravox
	name = "echo of triumph"
	desc = "It is said that when Ravox killed Graggar, thousands of swords were broken into pieces,\
	and the Warrior-God himself reforged them into smaller blades to be wielded by his most honorable followers.\
	This dagger is reforged in the same manner - reforged from the blade of a broken greatsword, and then tempered with holy steel\n\n\
	Broken, Reforged, Tempered."
	icon = 'icons/roguetown/weapons/templar_daggers32.dmi'
	icon_state = "ravox_dagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/malum
	name = "embertongue"
	desc = "A wavy dagger forged with an unnatural curve. Such curve is hard to maintain and keep right on a dagger -\
	a true sign of the mastery of the smith. Surely, Malum looks favorably upon such a blade."
	icon = 'icons/roguetown/weapons/templar_daggers32.dmi'
	icon_state = "malum_dagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/dendor
	name = "briarfang"
	desc = "A dagger formed out of a piece of heartwood extracted from a sylph, coupled with the remnants of a mad elemental.\
	Neither of these materials should make a sharp or proper blade, yet the handle is as strong as ebony, its edge sharp as obsidian\
	and its blade sturdy as steel. There might be a method to madness, after all."
	icon = 'icons/roguetown/weapons/templar_daggers32.dmi'
	icon_state = "dendor_dagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/abyssor
	name = "riptide fang"
	desc = "A fierce, curved dagger quenched in the blood of an abyssal creechur, with its handles forged out of steel wrapped\
	around its bone. Sharp, and curved, able to butcher and flense with ease. A practical tool, and deadly weapon at once."
	icon = 'icons/roguetown/weapons/templar_daggers32.dmi'
	icon_state = "abyssor_dagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/necra_osteotome
	name = "osteotome"
	desc = "A macabre cleaver. The hilt is made from a human spine reinforced with a steel tang.\
	A reminder of mortality."
	icon = 'icons/roguetown/weapons/templar_daggers32.dmi'
	icon_state = "necra_dagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/noc_twilight
	name = "twilight fang"
	desc = "A large blade with the profile of a rondel dagger. A rondel is not oft thrown, but this blade is unnaturally light when hurled, yet heavy and stiff when wielded.\
	Noc's faithful find it suits them well."
	icon = 'icons/roguetown/weapons/templar_daggers32.dmi'
	icon_state = "noc_dagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/eora_misericorde
	name = "misericorde"
	desc = "A parrying dagger created to be used in the free hand and deliver mercy to the foes you've bested.\
	Eora's love protects; her grace absolves."
	icon = 'icons/roguetown/weapons/templar_daggers32.dmi'
	icon_state = "eora_dagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/devilsknife
	name = "devilsknife"
	desc = "More a sickle than a knife. It is said that Xylix once won these in a game of chance against an archdevil.\
	These are simple reproductions, with jingling bells attached to the blades."
	icon = 'icons/roguetown/weapons/templar_daggers32.dmi'
	icon_state = "devilsknife"

/obj/item/rogueweapon/huntingknife/idagger/steel/undivided
	name = "equilibrium"
	desc = "A kampfmesser adorned for use by crusader orders, balanced to perfection allowing to perform feats a normal one cannot. \
	Their devoted shall find it strikes true in the heart of evil."
	icon = 'icons/roguetown/weapons/templar_daggers32.dmi'
	icon_state = "undivided_dagger"
