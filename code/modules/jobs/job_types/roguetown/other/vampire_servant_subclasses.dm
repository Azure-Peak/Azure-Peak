//VAMPIRE SERVANT CLASSES//
// These classes are high in skills/traits to give them potental to be good drivers for roleplay gimmics under the vlord. Such as making a feast, where the town shows up and finds themselves the feast suddenly.
//Or perhaps hosting tournies where the victors get turned into vampyric champions hand-picked by the vlord. Or perhaps as a smithing operation where people mysteriously disappear delivering materials but then show up fighting in good  gear later.

//The general shtick behind these classes is that they are absolute statbeasts for crafting, or utility. In the case of servantry, a lot of skills usually pretty useless to antagonists when it comes to large-scale fighting, like farming.
//Or music despite not getting bard mechanics (which is intentional), they're also able to make disguises.

//In the case of the forgemaster, they're basically your weapon and armor producer, that labors away in the manor or wherever you setup, they've a good deal of mining skill to get started wherever you pick to setup your dastardly lair.
//These classes go with pretty low-end stat weighting, they're not meant to be spammed as frontline fighters. I mean you can do it anyway but expect them to die. They do not come with armor.

//I expect the hyperwar vlord to have 1-3 and the gimmic one with anywhere of 2-6 of these. They're pretty much lich sapper skele skilline in mind. They've a little bit of extra utility but nothing great unless you invest into it.
//They also have medium amounts of mammon to work with, so they can try to spin or run their own thing if you set them loose. Or to buy things for your/their shtick in town.


/datum/advclass/vampservant
	name = "Vampiric Servant"
	tutorial = "Servitude unto death, was your motto; O' how long it has been since you've died, how sweet the taste of blood; yet you still serve your master's tireless chores. Tend the mansion, heed your lord's command, assist with construction, their will be done."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/other/vampservant
	traits_applied = list(TRAIT_CICERONE, TRAIT_SEEDKNOW, TRAIT_SEWING_EXPERT, TRAIT_HOMESTEAD_EXPERT, TRAIT_KEENEARS) //Very good utility, leaning towards RP gimmics.
	category_tags = list(CTAG_VAMPSERVANT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1,
		// 7 point statline, non-combat role but far-better than keep maids. Gets more traits to make up for lack of master crafting skills over the bat.
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN, //So you don't immedately die in a fight if you somehow get into one
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN, //Needed to get into places.
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //Vampire maids also have to tend the bloodbags.
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN, //Lets them do spy stuff, since they're just a "harmless" maid to most. Still need the actual lockpick set though.
		//roleplay specialist
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT, //Expert in some labor skills, they are the lich sapper skele equiv-ish, with some cavets
		/datum/skill/craft/carpentry = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT, //I mean, its a harmless fluff skill; let them do something while there's nothing to do or entertain the court.
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/tanning = SKILL_LEVEL_EXPERT, //Making disguises and style is your speciality
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_MASTER, //Go forth and break their kneecaps my child.
		/datum/skill/labor/farming = SKILL_LEVEL_EXPERT, //Little roundtime to be wasted tending crops, lets them just /get it over with/ so they can continue antagging at the same time. If you want to do a feast gimmic anyway.
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_EXPERT, //Sunlight limits their time outside, higher than forgemaster so they can supply them better
		//They do not get mining or engineering talent, go forgemaster for that
	)


/datum/outfit/job/roguetown/other/vampservant/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Servitude unto death, was your motto; O' how long it has been since you've died, how sweet the taste of blood; yet you still serve your master's tireless chores. Tend the mansion, heed your lord's command, assist with construction, their will be done."))
	if(H.mind)
		H.set_blindness(0)
		var/choice_list = list("Butler", "Maid")
		var/choice = input(H, "What is your occupation?", "WHAT MASQUERADE DO YOU BEAR?") as anything in choice_list

		switch(choice)
			if("Maid")
				head = /obj/item/clothing/head/roguetown/maidband
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/maidfancy
				cloak = /obj/item/clothing/cloak/apron/waist/fancymaid
				belt = /obj/item/storage/belt/rogue/leather/sash/maid
				shoes = /obj/item/clothing/shoes/roguetown/simpleshoes
			if("Butler")
				pants = /obj/item/clothing/under/roguetown/tights/formalfancy
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/formal
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
				armor = /obj/item/clothing/suit/roguetown/armor/leather/vest/black
				belt = /obj/item/storage/belt/rogue/leather/suspenders

	backr = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern //useful for lighting the candles when the lord kills the sun
	beltr = /obj/item/flint
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/rogueweapon/huntingknife/chefknife = 1,
		/obj/item/needle/thorn = 1,
		/obj/item/kitchen/rollingpin = 1,
		/obj/item/bottle_kit = 1,
		/obj/item/reagent_containers/peppermill = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

/datum/advclass/vampforgemaster
	name = "Vampiric Forgemaster"
	tutorial = "You were promised forever to perfect your craft and you recieved it, at a cost of eternal servitude and a never-ending taste for blood. Now you solely smith for your lord's army and allies, their will be done."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/other/vampforgemaster
	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT, TRAIT_HOMESTEAD_EXPERT) //Extra for price-checking since your role might also be to fund your master, homestead for lumberjack skill
	category_tags = list(CTAG_VAMPSERVANT)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_STR = 2,
		STATKEY_LCK = 2,
		// 8 point statline, non-combat role, a straight upgrade to towner smith.
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN, //Intentionally less-fight capable than maids in exchange for being PURE smith and build.
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN, //Needed to get into places or build higher up.
		//crafting specialist
		/datum/skill/craft/crafting = SKILL_LEVEL_MASTER,
		/datum/skill/craft/masonry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/engineering = SKILL_LEVEL_EXPERT, //semi-artificer too, didn't want to go all-in with arcayne skill since otherwise they might end up handing out enchantments to vamps, I don't want that to be common
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_MASTER, //higher intentionally, for profit making purposes in a round's time.
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/smelting = SKILL_LEVEL_MASTER,
		/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT, //Another niche in the field, they can disarm traps at least
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN, //Capable but often better supplied
		// They do not much for farming, nor any medical talent or the jack-of-all-trades of servants, pick that if you want those quirks.
	)


/datum/outfit/job/roguetown/other/vampforgemaster/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You were promised forever to perfect your craft and you recieved it, at a cost of eternal servitude and a never-ending taste for blood. Now you solely smith for your lord's army and allies, their will be done."))
	if(H.mind)
		H.set_blindness(0)
		var/choice_list = list("Smith", "Artificer") //Doesn't get arcayne, inherently. Sorry but I'm not having servants do enchantments.
		var/choice = input(H, "What is your occupation?", "WHAT MASQUERADE DO YOU BEAR?") as anything in choice_list

		switch(choice)
			if("Smith") //Similar to towner blacksmith in appearance
				head = /obj/item/clothing/head/roguetown/hatblu
				cloak = /obj/item/clothing/cloak/apron/blacksmith
				armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
				pants = /obj/item/clothing/under/roguetown/trou //More rugged appearance
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
				shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
			if("Artificer") //Pretty much town artificer in appearance
				head = /obj/item/clothing/head/roguetown/articap
				armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
				cloak = /obj/item/clothing/cloak/apron/waist/brown
				pants = /obj/item/clothing/under/roguetown/trou/artipants
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather

	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	beltl = /obj/item/rogueweapon/pick //intended, you'll be upgrading that pretty fast.
	beltr = /obj/item/storage/hip/orestore/bronze
	backl = /obj/item/storage/backpack/rogue/backpack
	belt = /obj/item/storage/belt/rogue/leather
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/handsaw = 1,
		/obj/item/rogueweapon/chisel = 1,
		/obj/item/clothing/mask/rogue/spectacles/golden = 1, //For style/construction maintenance, in backpack since they'd get replaced by eyepatches from flaws.
		/obj/item/rogueweapon/hammer/iron = 1, //You already get these mapped in but in case you get 3 forgemasters somehow, they won't be useless. Also to pair with chisel.
		/obj/item/rogueweapon/tongs = 1,
		/obj/item/flint = 1
		)

//Exists so vampires have something to revive people they accidentally kill from feeding, any allies or potentally slip into the clinic and process their vamp allies through. Weakest of laboring outside of their medical niché vs other servants
/datum/advclass/vampphysician
	name = "Vampiric Physician"
	tutorial = "You were promised forever to further your medical research and perfect your art of needle and scapel alike and recieve it at the cost of eternal servitude and a never ending taste for blood. Now you serve your lord eternal, from a fatal feeding frenzy to granting fallen travellers that very same chance you had. Now you'll be sewing and stitching a future, in your lord's vision."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/other/vampphysician
	traits_applied = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT, TRAIT_NOSTINK, TRAIT_HOMESTEAD_EXPERT, TRAIT_EMPATH, TRAIT_STEELHEARTED) //Medical class, specialises in accidental killings or reviving fallen allies. !!!UNTIL LUX REVIVALS WORK ON VAMPS OR A MAP REWORK HAPPENS. YOU'LL NEED TO EITHER HAVE ZURCH ACCESS OR BREAK INTO THE CLINIC FOR A CHAIR TO REVIVE VAMPS!!!
	category_tags = list(CTAG_VAMPSERVANT)
	subclass_stats = list(
		STATKEY_SPD = 2, //Corpse thievery duty
		STATKEY_INT = 4,
		STATKEY_PER = 1,
		STATKEY_LCK = 1,
		// 8 point statline, non-combat role equiv of barber doc kind of.
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE, //Weaker since non-combat role
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN, //Needed to follow your allies.
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_MASTER, //Your entire shtick, sire. High because vamps accumilate insanely high burns, very fast. So they sort of need the levels.
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT, //Decently high, but this is the skill I want grinded a bit
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN, //Needed to get into the clinic to use the chair for fellow vamps or get around.
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN, //Decent enough to try to put up a small stall or help your allies and not be completely useless
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN, // Farming for ingredients, maids are better at this. Woe is you.
	)


/datum/outfit/job/roguetown/other/vampphysician/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You were promised forever to further your medical research and perfect your art of needle and scapel alike and recieve it at the cost of eternal servitude and a never ending taste for blood. Now you serve your lord eternal, from a fatal feeding frenzy to granting fallen travellers that very same chance you had. Now you'll be sewing and stitching a future, in your lord's vision."))
	mask = /obj/item/clothing/mask/rogue/physician //intentional look, rest is intentionally closer to barber doc appearance with a mix of the OG court physician getup from old roguetown code.
	head = /obj/item/clothing/head/roguetown/physician
	neck = /obj/item/clothing/neck/roguetown/coif //Non-combat role, get it upgraded
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/physician
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/surgery_bag/full
	beltr = /obj/item/rogueweapon/huntingknife/chefknife/cleaver // some self defense and tree cutting
	pants = /obj/item/clothing/under/roguetown/trou/leather/mourning
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/natural/worms/leech/cheele = 1,
		/obj/item/heart_blood_canister/filled = 4, //Needs more due to not having a stockpiled chest nor a chair.
		/obj/item/bait/leech = 3,
		/obj/item/folding_alchcauldron_stored = 1, //Nessessary
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1
		)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
