/mob/living/carbon/human/species/wildshape/cat/accursed

/mob/living/carbon/human/species/wildshape/cat/accursed/gain_inherent_skills()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
		src.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
		src.adjust_skillrank(/datum/skill/misc/tracking, 1, TRUE)

		src.STASTR = 2
		src.STACON = 2
		src.STAWIL = 7
		src.STAPER = 14
		src.STASPD = 18
		src.STALUC = 12

		AddSpell(new /obj/effect/proc_holder/spell/self/catclaws)
		AddSpell(new /obj/effect/proc_holder/spell/targeted/woundlick)
		src.real_name = "cat"

/mob/living/carbon/human/species/wildshape/bear/accursed

/mob/living/carbon/human/species/wildshape/bear/accursed/gain_inherent_skills()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)

		STASTR = 14
		STACON = 14
		STAWIL = 13
		STAPER = 8
		STASPD = 6
		STAINT = 8

		AddSpell(new /obj/effect/proc_holder/spell/self/bearclaws)
		real_name = "direbear"
		faction += "bears"

/mob/living/carbon/human/species/wildshape/direvolf/accursed

/mob/living/carbon/human/species/wildshape/direvolf/accursed/gain_inherent_skills()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)

		STASTR = 14
		STACON = 14
		STAWIL = 13
		STAPER = 8
		STASPD = 6
		STAINT = 8

		AddSpell(new /obj/effect/proc_holder/spell/self/direvolfclaws)
		AddSpell(new /obj/effect/proc_holder/spell/self/howl/call_of_the_moon)
		real_name = "direvolf" //So we don't get a random name
		faction += "wolfs" // It IS a wolf

/mob/living/carbon/human/species/wildshape/saiga/accursed

/mob/living/carbon/human/species/wildshape/saiga/accursed/gain_inherent_skills()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)

		src.STASTR = 10
		src.STACON = 13
		src.STAWIL = 18
		src.STASPD = 13

		AddSpell(new /obj/effect/proc_holder/spell/self/saigahoofs)
		src.real_name = "saiga"

/mob/living/carbon/human/species/wildshape/spider/accursed

/mob/living/carbon/human/species/wildshape/spider/accursed/gain_inherent_skills()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE) //For the bog mainly
		src.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)

		src.STASTR = 12
		src.STACON = 6
		src.STAWIL = 7
		src.STAPER = 12
		src.STASPD = 14

		AddSpell(new /obj/effect/proc_holder/spell/self/spiderfangs)
		AddSpell(new /obj/effect/proc_holder/spell/self/createhoney)
		AddSpell(new /obj/effect/proc_holder/spell/self/weaveweb)
		real_name = "beespider"
		faction += "spiders" // It IS a spider

/mob/living/carbon/human/species/wildshape/fox/accursed

/mob/living/carbon/human/species/wildshape/fox/accursed/gain_inherent_skills()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_APPRENTICE, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, SKILL_LEVEL_EXPERT, TRUE)
		src.adjust_skillrank(/datum/skill/misc/hunting, SKILL_LEVEL_JOURNEYMAN, TRUE)

		src.STASTR = 8
		src.STACON = 6
		src.STAPER = 10
		src.STASPD = 16

		AddSpell(new /obj/effect/proc_holder/spell/self/foxclaws)
		AddSpell(new /obj/effect/proc_holder/spell/targeted/woundlick)
		src.real_name = "vernard"
		src.faction += "wolfs"

/mob/living/carbon/human/species/wildshape/volf/accursed

/mob/living/carbon/human/species/wildshape/volf/accursed/gain_inherent_skills()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/tracking, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/hunting, 4, TRUE)

		src.STASTR = 7
		src.STACON = 7
		src.STAPER = 12
		src.STASPD = 13

		AddSpell(new /obj/effect/proc_holder/spell/self/wolfclaws)
		AddSpell(new /obj/effect/proc_holder/spell/self/howl/call_of_the_moon)
		src.real_name = "volf"
		src.faction += "wolfs"
