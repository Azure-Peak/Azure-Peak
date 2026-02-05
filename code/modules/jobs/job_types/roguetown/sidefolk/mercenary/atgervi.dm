/datum/advclass/mercenary/atgervi
	name = "Atgervi"
	tutorial = "You are a Varangian of the Gronn Highlands. Warrior-Traders most known for their exploits into the Raneshen Empire, which will be forever remembered by historians."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/atgervi
	subclass_languages = list(/datum/language/gronnic)
	cmode_music = 'sound/music/combat_vagarian.ogg'
	class_select_category = CLASS_CAT_GRONN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,	
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/atgervi
	allowed_patrons = ALL_GRONNIC_PATRONS //Subvariant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.

/datum/outfit/job/roguetown/mercenary/atgervi/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a Varangian of the Gronn Highlands. Warrior-Traders whose exploits into the Raneshen Empire will be forever remembered by historians."))
	H.mind?.current.faction += "[H.name]_faction"
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi
	gloves = /obj/item/clothing/gloves/roguetown/angle/atgervi
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
	pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
	backr = /obj/item/rogueweapon/shield/atgervi
	backl = /obj/item/storage/backpack/rogue/satchel/black
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle //They didn't have neck protection before.
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baothagronn
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_2)	//Capped to T1 miracles.
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 1

/datum/advclass/mercenary/atgervi/shaman
	name = "Atgervi Shaman"
	tutorial = "You are a Shaman of the Fjall, The Northern Empty. Shamans are savage combatants who commune with the Ecclesical Beast Gods through ritualistic violence, rather than idle prayer."
	outfit = /datum/outfit/job/roguetown/mercenary/atgervishaman
	subclass_languages = list(/datum/language/gronnic)
	cmode_music = 'sound/music/combat_shaman2.ogg'
	traits_applied = list(TRAIT_STRONGBITE, TRAIT_CIVILIZEDBARBARIAN, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_NOPAINSTUN, TRAIT_BLOOD_RESISTANCE)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_INT = -1,
		STATKEY_PER = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/mercenary/atgervishaman
	allowed_patrons = ALL_GRONNIC_PATRONS //Subvariant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.

/datum/outfit/job/roguetown/mercenary/atgervishaman/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	to_chat(H, span_warning("You are a Shaman of the Fjall, The Northern Empty. Shamans are savage combatants who commune with the Ecclesical Beast gods through ritualistic violence, rather than idle prayer."))
	H.mind?.current.faction += "[H.name]_faction"
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

	head = /obj/item/clothing/head/roguetown/helmet/leather/shaman_hood
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronnfur
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/flashlight/flare/torch
	H.put_in_hands(new /obj/item/rogueweapon/handclaw/gronn)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baothagronn
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 1


/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi
	name = "varangian hauberk"
	desc = "The pride of the Highland mercenaries, this hauberk is a well crafted blend of chain and leather woven into a dense, protective coat."
	icon_state = "atgervi_raider_mail"
	item_state = "atgervi_raider_mail"
	max_integrity = 400

/obj/item/clothing/suit/roguetown/armor/leather/heavy/atgervi
	name = "shamanic coat"
	desc = "A furred, protective coat. Often made by hand, it embodies the second trial of the Iskarn Shamans: To honor the leopard is to desire for more."
	icon_state = "atgervi_shaman_coat"
	item_state = "atgervi_shaman_coat"

/obj/item/clothing/under/roguetown/trou/leather/atgervi
	name = "fur pants"
	desc = "Thick fur pants made to endure the coldest winds, offering a share of protection from the fangs and claws of beasts and men alike."
	icon_state = "atgervi_pants"
	item_state = "atgervi_pants"
	
/obj/item/clothing/gloves/roguetown/angle/atgervi
	name = "fur-lined leather gloves"
	desc = "Dense, padded gloves made for the harshest of climates and the wildest of beasts encountered in the untamed highlands."
	icon_state = "atgervi_raider_gloves"
	item_state = "atgervi_raider_gloves"
	color = "#ffffff"

/obj/item/clothing/gloves/roguetown/plate/atgervi
	name = "beast claws"
	desc = "A menacing pair of plated claws, whose forging methods are a closely protected tradition of the Shamans. The four claws embodying the Four Great Beasts, decorated with symbols of the Gods they praise and the Gods they reject."
	icon_state = "atgervi_shaman_gloves"
	item_state = "atergvi_shaman_gloves"

/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi
	name = "owl helmet"
	desc = "A carefully forged steel helmet in the shape of an owl's face, with added chain to cover the face and neck against many blows."
	icon_state = "atgervi_raider"
	item_state = "atgervi_raider"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	body_parts_covered = FULL_HEAD|NECK
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/atgervi.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	block2add = null
	worn_x_dimension = 32
	worn_y_dimension = 48

/obj/item/clothing/head/roguetown/helmet/leather/saiga/atgervi
	name = "moose hood"
	desc = "A deceptively strong moosehide hood with a pair of large heavy antlers. It is the reward of the fourth trial of the Iskarn Shamans: To slay a Grinning Moose in the final hunt alone - and fashion a hood from its head."
	icon_state = "atgervi_shaman"
	item_state = "atgervi_shaman"
	flags_inv = HIDEEARS|HIDEFACE
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/atgervi.dmi'
	flags_inv = HIDEEARS
	bloody_icon = 'icons/effects/blood64.dmi'
	worn_x_dimension = 32
	worn_y_dimension = 48
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/shoes/roguetown/boots/leather/atgervi
	name = "atgervi leather boots"
	desc = "A pair of strong leather boots, designed to endure both the heat of battle and the frigid cold of the Northern Empty."
	icon_state = "atgervi_boots"
	item_state = "atgervi_boots"

/obj/item/rogueweapon/shield/atgervi
	name = "kite shield"
	desc = "A large, but light wooden shield with a steel boss in the center to deflect blows more easily."
	icon_state = "atgervi_shield"
	item_state = "atgervi_shield"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	force = 15
	throwforce = 10
	dropshrink = 0.8
	coverage = 80
	attacked_sound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	parrysound = list('sound/combat/parry/shield/towershield (1).ogg','sound/combat/parry/shield/towershield (2).ogg','sound/combat/parry/shield/towershield (3).ogg')
	max_integrity = 300
	experimental_inhand = FALSE

/obj/item/rogueweapon/shield/atgervi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("onback")
				return list("shrink" = 0.7,"sx" = -17,"sy" = -15,"nx" = -15,"ny" = -15,"wx" = -12,"wy" = -15,"ex" = -18,"ey" = -15,"nturn" = 0,"sturn" = 0,"wturn" = 180,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 1,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
	name = "Bearded Axe"
	desc = "A large axe easily wielded in one hand or two, with a large, hooked axehead, designed for the brutal ripping and tearing of flesh and armor alike."
	icon_state = "atgervi_axe"
	item_state = "atgervi_axe"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	wlength = WLENGTH_LONG
	experimental_onhip = TRUE
	wdefense = 5
	max_blade_int = 250
	force = 26
	force_wielded = 33

/obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -9,"sy" = -8,"nx" = 9,"ny" = -7,"wx" = -7,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 2,"sy" = -8,"nx" = -6,"ny" = -3,"wx" = 3,"wy" = -4,"ex" = 4,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -44,"sturn" = 45,"wturn" = 47,"eturn" = 33,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.6,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 180,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 1,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

///////////////////////////////
// GRONN-SPECIFIC PSICROSSES //
///////////////////////////////

/obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
	name = "carved talisman" //plotting talisman
	desc = "'The hunt, the studying of your prey, the learning of its routes, the knowledge our ancestors passed down, the empowerment of your people and yourself. Learn of the world, or fade away.'  </br>  </br>The Plotting Wolf embodies the virtues of progress and knowledge, so that no obstacle nor threat to the homeland remains insurmountable. To understand the truths of beast-and-bronze is to lighten the future's hardships. Do not humor magicka, however, for playing with fire shall always end in someone being burned."
	icon_state = "gronnzizo"

/obj/item/clothing/neck/roguetown/psicross/inhumen/baothagronn
	name = "carved talisman" //relishing talisma
	desc = "'“The excess of desire, the want of more, the glory of victory, the lover's embrace. Embrace the Leopard, or forget your strength.'  </br>  </br>The Relishing Leopard embodies the virtues of love and glory, both in battle and at home. Enjoy the flesh, the drink, and the spice; but be wary to avoid overindulgence, for it shall leave you despondant and lethargic. To become too comfortable is to become weak, and such weakness would turn you into a delicious snack for the Leopard." 
	icon_state = "gronnbaotha"

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
	name = "carved talisman" //starving talisman
	desc = "'“The hunger, the destruction, the impending frost, the enemy of my enemy. Feed the Bear, or be consumed.'  </br>  </br>The Starving Bear embodies not a virtue, but the necessity to thrive above all else. Avarice is not a sin, but a virtue; to ensure that the homeland never suffers from poverty nor starvation again. Pillage, plunder, and perforate the wealth that others would keep from you, but do not forget that every choice begets consequences."
	icon_state = "gronnmatthios"

/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
	name = "carved talisman" //grinning talisman
	desc = "'The battle, the combat, the violence, the rush of victory, the honored glories. Defeat the foe, or die with them.'  </br>  </br>The Grinning Moose embodies the virtues of strengh and domination; to survive both the homeland's frigid blizzards and those who'd seek to maraude its countrymen. Be untamed and unstoppable, but do not lose yourself in the haze; for even the Moose was chained, once. Kill your own without reason, and the chain shall be tugged; and your soul, too, shall be impaled on their horns."
	icon_state = "gronngraggar"

/obj/item/clothing/neck/roguetown/psicross/dendor/gronn
	name = "carved talisman" //volfskinned talisman
	desc = "'The world above, of knifetoothed plants and rotting carrion. From jungle to desert, even the stones are nature. Heed its call with the respect it commands, or succumb to madness.'  </br>  </br>The Volfskinned Man embodies the virtue of nature and temperance; to live in harmony with the world and its spirits. Pluck a jackberry, plant a seed - Slay a beast, see no part wasted. Yet, temperance must be shown; to take from the world without respect-nor-exchange is to curse the homeland with misfortune. Yet, to completely embrace the world's primality is to lose your humanity - and worse, to become the very beast you hunt."
	icon_state = "gronndendor"

/obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
	name = "carved talisman" //hadal talisman
	desc = "'The chaos below, of coldblack pressure and crushing weight. Be the current. Control the waves. Reign your sails and hold fast against the storm, or be washed away onto an odyssey with no end.'  </br>  </br>The Spiraling Kraken is no virtue, but a presence; the homeland's nautical warden, who's tentacled presence is as unpredictable as the oceans it lords over. To embrace the uncertainty of lyfe is to be rewarded with fortune and mercy when it is most needed. Do not embrace such futility, however, lest you are swept away with all the others into the abyss."
	icon_state = "gronnabyssor"

/obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special
	name = "carved talisman" //familial talisman
	desc = "'The memories of the past, and the dreams of the future. A fetish of a beaste, and the carvings of a force that no one beyond your homeland could understand. Sail gracefully, countryman.'"

//
