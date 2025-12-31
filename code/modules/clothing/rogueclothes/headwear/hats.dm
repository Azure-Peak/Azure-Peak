// Hats not meant to have armor
/obj/item/clothing/head/roguetown/strawhat
	name = "straw hat"
	desc = "It's scratchy and rustic, but at least it keeps the sun off your head while you toil in the fields."
	icon_state = "strawhat"
	sewrepair = TRUE
	salvage_result = /obj/item/natural/fibers
	salvage_amount = 2 // Minor materials loss

/obj/item/clothing/head/roguetown/puritan
	name = "buckled hat"
	icon_state = "puritan_hat"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/puritan/armored
	name = "puritan's hat" //Puritan hat subtype, meant for the Exorcist's heaviest classes. Steel skullcap-tier protection.
	desc = "A buckled capotain, woven atop a steel skull cap. Discrete enough to wear for a diplomatic affair, but durable enough to thwart a heathen's blade."
	icon_state = "puritan_hat"
	sewrepair = FALSE
	armor = ARMOR_PLATE
	blocksound = PLATEHIT
	body_parts_covered = HEAD|HAIR
	max_integrity = ARMOR_INT_HELMET_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/head/roguetown/nightman
	name = "teller's hat"
	icon_state = "tophat"
	color = CLOTHING_BLACK
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/bardhat
	name = "bard's hat"
	icon_state = "bardhat"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/smokingcap
	name = "smoking cap"
	icon_state = "smokingc"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/fancyhat
	name = "fancy hat"
	desc = "A fancy looking hat with colorful feathers sticking out of it."
	icon_state = "fancy_hat"
	item_state = "fancyhat"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/fedora
	name = "archeologist's hat"
	desc = "A strangely-shaped hat with dust caked onto its aged leather."
	icon_state = "curator"
	item_state = "curator"
	sewrepair = TRUE
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/head/roguetown/hatfur
	name = "fur hat"
	desc = "A comfortable warm hat lined with fur."
	icon_state = "hatfur"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/papakha
	name = "papakha"
	icon_state = "papakha"
	item_state = "papakha"
	sewrepair = TRUE
	armor = ARMOR_CLOTHING
	blocksound = SOFTHIT
	salvage_result = /obj/item/natural/fur
	salvage_amount = 1

/obj/item/clothing/head/roguetown/hatblu
	name = "fur hat"
	desc = "A blue hat lined with fur."
	icon_state = "hatblu"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/fisherhat
	name = "straw hat"
	desc = "A hat worn by fishermen to protect from the sun."
	icon_state = "fisherhat"
	item_state = "fisherhat"
	sewrepair = TRUE
//	color = "#fbc588"
	//dropshrink = 0.75

/obj/item/clothing/head/roguetown/flathat
	name = "flat hat"
	icon_state = "flathat"
	item_state = "flathat"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/explorerhat
	name = "explorer's hat"
	desc = "How many secrets can I uncover this week?"
	icon_state = "explorerhat"
	item_state = "explorerhat"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/deserthood
	name = "desert hood"
	desc = "If only it was this warm."
	icon_state = "desert_hood"
	item_state = "desert_hood"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/chaperon
	name = "chaperon hat"
	desc = "A utilitarian yet fashionable hat traditionally made from a hood. Usually worn as a status symbol."
	icon_state = "chaperon"
	item_state = "chaperon"
	sewrepair = TRUE
	//dropshrink = 0.75

/obj/item/clothing/head/roguetown/cookhat
	name = "cook hat"
	desc = "A hat which designates one as well-versed in the arts of cooking."
	icon_state = "chef"
	item_state = "chef"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/chaperon/greyscale
	name = "chaperon hat"
	desc = "A utilitarian yet fashionable hat traditionally made from a hood. This one has been treated to take dyes more easily."
	icon_state = "chap_alt"
	item_state = "chap_alt"
	color = "#dbcde0"

/obj/item/clothing/head/roguetown/chaperon/noble
	name = "noble's chaperon"
	desc = "A decorated chaperon worn by the more influential members of society."
	icon_state = "noblechaperon"
	item_state = "noblechaperon"
	detail_tag = "_detail"
	color = CLOTHING_WHITE
	detail_color = COLOR_ASSEMBLY_GOLD

/obj/item/clothing/head/roguetown/chaperon/noble/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/chaperon/noble/bailiff
	name = "Marshal's chaperon"
	desc = "A noble's chaperon made for the local Marshal. \"How terribly unfortunate you are!\""
	color = "#641E16"
	detail_color = "#b68e37ff"

/obj/item/clothing/head/roguetown/chaperon/noble/guildmaster
	name = "Guildmaster's chapereon"
	desc = "A noble's chaperon made for the guildmaster."
	color = "#1b1717ff"
	detail_color = "#b68e37ff"

/obj/item/clothing/head/roguetown/chaperon/noble/hand
	name = "hand's chaperon"
	desc = "A noble's chaperon made for the right hand man. \"Heavy is the head that bears the crown.\""
	color = CLOTHING_AZURE
	detail_color = CLOTHING_WHITE

/obj/item/clothing/head/roguetown/chaperon/councillor
	name = "chaperon hat"
	desc = "A fancy hat worn by nobles."
	icon_state = "chap_alt"
	item_state = "chap_alt"
	color = "#7dcea0"

/obj/item/clothing/head/roguetown/chaperon/greyscale/elder
	name = "elder's chaperon hat"
	color = "#007fff"

/obj/item/clothing/head/roguetown/chef
	name = "chef's hat"
	desc = "A hat which designates one as well-versed in the arts of cooking."
	icon_state = "chef"
	sewrepair = TRUE
	//dropshrink = 0.75

/obj/item/clothing/head/roguetown/cap
	name = "cap"
	desc = "A light cap made of cloth, usually worn under a helmet."
	icon_state = "armingcap"
	item_state = "armingcap"
	flags_inv = HIDEEARS
	sewrepair = TRUE
	//dropshrink = 0.75

/obj/item/clothing/head/roguetown/knitcap
	name = "knit cap"
	desc = "A simple knitted cap."
	icon_state = "knitcap"
	sewrepair = TRUE
	//dropshrink = 0.75

/obj/item/clothing/head/roguetown/cap/dwarf
	color = "#cb3434"

/obj/item/clothing/head/roguetown/headband
	name = "headband"
	desc = "A simple headband to keep sweat out of your eyes."
	icon_state = "headband"
	item_state = "headband"
	sewrepair = TRUE
	//dropshrink = 0.75
	dynamic_hair_suffix = null

/obj/item/clothing/head/roguetown/headband/bloodied
	name = "bloodied headband"
	desc = "A headband that's been soaked in the blood of a terrible nitebeast. The coagulative properties of cursed blood has stiffened the cloth, gifting it a texture not unlike spongy leather. Wearing it emboldens you with determination."
	icon_state = "headband"
	item_state = "headband"
	color = "#851a16"
	armor = ARMOR_LEATHER_GOOD
	max_integrity = ARMOR_INT_HELMET_LEATHER
	body_parts_covered = HEAD|HAIR|EARS
	prevent_crits = PREVENT_CRITS_NONE
	sewrepair = TRUE
	//dropshrink = 0.75
	dynamic_hair_suffix = null

	///Reen's work. Should make it so that you obtain special traits when taking it on-and-off, without outright removing inherent traits.
	var/traited = FALSE

/obj/item/clothing/head/roguetown/headband/bloodied/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_SILVER_BLESSED, TRAIT_GENERIC)
		ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)

/obj/item/clothing/head/roguetown/headband/bloodied/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.head == src)
		REMOVE_TRAIT(user, TRAIT_SILVER_BLESSED, TRAIT_GENERIC)
		REMOVE_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)

/obj/item/clothing/head/roguetown/headband/naledi
	name = "sojourner's headband"
	desc = "A traditional garment, carried by those who survived the lonesome pilgrimage through Naledi's cursed dunes. Like a helmet, it will ward off killing blows; but unlike a helmet, it will keep the sweat out of your eyes and the mistakes out of your incantations. </br>'..We had our tests; we had our places of sin and vice. We were to look out for brother and sister, arm-in-arm, to ensure none of us fell. And yet we all did. We all allowed that to become what is. The daemons that roam our streets, that snatch our children from our bed, that eat our wives and break our husbands. They are us, our own creations and perversions. They are humanity as humanity sees itself, made manifest through our own twisted arcyne magicks..'"
	icon_state = "headband"
	color = "#48443b"
	sewrepair = TRUE
	resistance_flags = FIRE_PROOF
	armor = ARMOR_SPELLSINGER //Higher-tier protection for pugilist-centric classes. Fits the 'glass cannon' style, and prevents instant death through a glancing headshot on the intended archetype. 
	blade_dulling = DULLING_BASHCHOP
	body_parts_covered = HEAD|HAIR|EARS
	max_integrity = ARMOR_INT_SIDE_STEEL //High leather-tier protection and critical resistances, steel-tier integrity. Integrity boost encourages hand-to-hand parrying. Weaker than the Psydonic Thorns.
	blocksound = SOFTHIT
	//dropshrink = 0.75
	dynamic_hair_suffix = null

/obj/item/clothing/head/roguetown/headband/monk
	name = "monk's headband"
	desc = "A winding length of cloth, meticulously lined with heavy leather strips. Errant impacts are thwarted, yet not a degree of vision is impaired; valuable traits, for the Monk who must enlighten their villains with a white-knuckled sermon. </br>'..I kick ass for the Lord!'"
	icon_state = "headband"
	color = "#bfb8a9"
	sewrepair = TRUE
	resistance_flags = FIRE_PROOF
	armor = ARMOR_SPELLSINGER //Highest preset protection value for head armor, without leaving people unable to sleep with the headband on. Should be appropriate for the Monk's role.
	body_parts_covered = HEAD|HAIR|EARS
	max_integrity = ARMOR_INT_SIDE_STEEL //High leather-tier protection and critical resistances, steel-tier integrity.
	blocksound = SOFTHIT
	//dropshrink = 0.75
	dynamic_hair_suffix = null

/obj/item/clothing/head/roguetown/headband/monk/barbarian
	name = "hunter's headband"
	desc = "A winding length of cloth, meticulously lined with heavy leather strips. Errant impacts are thwarted, yet not a degree of vision is impaired; valuable traits, for those who have taken the mantle of confronting monsters with overwhelming strength. </br>'..All it takes for evil to triumph is for good men to do nothing.'"
	max_integrity = ARMOR_INT_HELMET_LEATHER //Far less durable than the Monk's variant. Remember that the Barbarian retrieves solid weapon skills and armor, even as a pugilist.

/obj/item/clothing/head/roguetown/inqhat
	name = "inquisitorial hat"
	desc = "A fine leather slouch, beplumed with a crimson feather and fitted with a hidden steel skull cap. It serves as a reminder that the Holy Otavan Inquisition triumphs in one avenue above all else - fashion. </br>'To keep ones vision away from the heavens, and focused on the sin beneath the soil.'"
	icon_state = "inqhat"
	item_state = "inqhat"
	max_integrity = 200
	armor = ARMOR_SPELLSINGER
	body_parts_covered = HEAD|HAIR|EARS
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/headband/red
	color = CLOTHING_RED

/obj/item/clothing/head/roguetown/priesthat
	name = "priest's hat"
	desc = ""
	icon_state = "priest"
	//dropshrink = 0
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	dynamic_hair_suffix = "+generic"
	sellprice = 77
	worn_x_dimension = 64
	worn_y_dimension = 64
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/reqhat
	name = "serpent crown"
	desc = ""
	icon_state = "reqhat"
	sellprice = 100
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/head/roguetown/headdress
	name = "nemes"
	desc = "A foreign silk headdress."
	icon_state = "headdress"
	sellprice = 10
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/headdress/alt
	icon_state = "headdressalt"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/nun
	name = "nun's veil"
	desc = "A humble hat for the faithful."
	icon_state = "nun"
	sellprice = 5
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/hennin
	name = "hennin"
	desc = "A hat typically worn by women in nobility."
	icon_state = "hennin"
	sellprice = 19
	dynamic_hair_suffix = "+generic"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/bucklehat //lifeweb sprite
	name = "folded hat"
	desc = "A plain leather hat with decorative buckle. Made popular by the ne'er-do-wells of Etrusca."
	icon_state = "bucklehat"
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/duelhat //lifeweb sprite
	name = "duelist's hat"
	desc = "A feathered leather hat, to show them all your superiority."
	icon_state = "duelhat"
	sewrepair = TRUE
	color = COLOR_ALMOST_BLACK	
	detail_tag = "_detail"
	detail_color = COLOR_SILVER

/obj/item/clothing/head/roguetown/wizhat
	name = "wizard hat"
	desc = "Used to distinguish dangerous wizards from senile old men."
	icon_state = "wizardhat"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	dynamic_hair_suffix = "+generic"
	worn_x_dimension = 64
	worn_y_dimension = 64
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/wizhat/red
	icon_state = "wizardhatred"

/obj/item/clothing/head/roguetown/wizhat/yellow
	icon_state = "wizardhatyellow"

/obj/item/clothing/head/roguetown/wizhat/green
	icon_state = "wizardhatgreen"

/obj/item/clothing/head/roguetown/wizhat/black
	icon_state = "wizardhatblack"

/obj/item/clothing/head/roguetown/wizhat/gen
	icon_state = "wizardhatgen"

/obj/item/clothing/head/roguetown/wizhat/gen/wise
	name = "wise hat"
	sellprice = 100
	desc = "Only the wisest of nimrods wear this."

/obj/item/clothing/head/roguetown/wizhat/gen/wise/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/wise = user
	if(slot == SLOT_HEAD)
		wise.change_stat(STATKEY_INT, 2, "wisehat")
		to_chat(wise, span_green("I gain wisdom."))

/obj/item/clothing/head/roguetown/wizhat/gen/wise/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/wise = user
	if(wise.get_item_by_slot(SLOT_HEAD) == src)
		wise.change_stat(STATKEY_INT, -2, "wisehat")
		to_chat(wise, span_red("I lose wisdom."))

/obj/item/clothing/head/roguetown/shawl
	name = "shawl"
	desc = "Keeps the hair in check, and looks proper."
	icon_state = "shawl"

/obj/item/clothing/head/roguetown/articap
	name = "artificer's cap"
	desc = "A sporting cap with a small gear adornment. Popular fashion amongst engineers."
	icon_state = "articap"

/obj/item/clothing/head/roguetown/brimmed
	desc = "A simple brimmed hat that provides some relief from the sun."
	icon_state = "brimmed"

// azure addition - random wizard hats

/obj/item/clothing/head/roguetown/wizhat/random/Initialize()
	icon_state = pick("wizardhatred", "wizardhatyellow", "wizardhatgreen", "wizardhat")
	..()

/obj/item/clothing/head/roguetown/witchhat
	name = "witch hat"
	desc = "Fair is foul, and foul is fair; Hover through the fog and filthy air."
	icon_state = "witch"
	item_state = "witch"
	icon = 'icons/roguetown/clothing/head.dmi'
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/archercap
	name = "archer's cap"
	desc = "For the merry men."
	icon_state = "archercap"

/obj/item/clothing/head/roguetown/physician
	name = "doctor's hat"
	desc = "My cure is most effective."
	icon_state = "physhat"


/obj/item/clothing/head/roguetown/helmet/tricorn
	slot_flags = ITEM_SLOT_HEAD
	name = "tricorn"
	desc = "A triangular hat with its brim turned in on itself. Quite a new-fangled design, but one gaining popularity \
	among sailors in particular."
	body_parts_covered = HEAD|HAIR|EARS|NOSE
	icon_state = "tricorn"
	armor = ARMOR_CLOTHING
	max_integrity = 100
	prevent_crits = list(BCLASS_BLUNT, BCLASS_TWIST)
	anvilrepair = null
	smeltresult = null
	sewrepair = TRUE
	blocksound = SOFTHIT
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1


/obj/item/clothing/head/roguetown/helmet/tricorn/skull
	icon_state = "tricorn_skull"
	desc = "It has a skull sewn onto it. A clear sign of piracy"

/obj/item/clothing/head/roguetown/helmet/tricorn/lucky
	name = "lucky tricorn"
	desc = "A weathered tricorn that has seen many skirmishes. You'd feel lucky with this on your head."
	armor = ARMOR_LEATHER

/obj/item/clothing/head/roguetown/helmet/bandana
	slot_flags = ITEM_SLOT_HEAD
	name = "bandana"
	desc = "A simple triangular length of fabric, typically worn tied around the head as decoration, or to constrict \
	long hair during intensive work."
	body_parts_covered = HEAD|HAIR|EARS|NOSE
	icon_state = "bandana"
	armor = ARMOR_CLOTHING
	prevent_crits = list(BCLASS_TWIST)
	anvilrepair = null
	smeltresult = null
	sewrepair = TRUE
	blocksound = SOFTHIT
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

/obj/item/clothing/head/roguetown/veiled
	name = "nurse's veil"
	desc = "A chirurgeon's bonnet, veiled with petal-stuffed linen. The stitchwork is often donned by the likes of wandering plague doctors and clerics; especially, those who're beholden to Pestra and Psydon."
	icon_state = "veil"
	item_state = "veil"
	detail_tag = "_detail"
	color = CLOTHING_WHITE
	detail_color = CLOTHING_WHITE
	flags_inv = HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT|HIDEEARS
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|HAIR|EARS|NECK|MOUTH|NOSE|EYES
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	blocksound = SOFTHIT
	max_integrity = 100
	sewrepair = TRUE

/obj/item/clothing/head/roguetown/veiled/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/veiled/ComponentInitialize()
	..()
	AddComponent(/datum/component/adjustable_clothing, (NECK|HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/foley/equip/cloak (3).ogg', null, (UPD_HEAD|UPD_MASK))	

/obj/item/clothing/head/roguetown/veiled/loudmouth
	name = "loudmouth's headcover"
	desc = "Said to be worn by only the loudest and proudest. The mask is adjustable."
	icon_state = "loudmouth"
	item_state = "loudmouth"
	color = CLOTHING_RED

/obj/item/clothing/head/roguetown/maidhead
	name = "maid headdress"
	desc = "A decorative cloth headband clearly indicating the wearer as a maid."
	icon_state = "maidhead"
	item_state = "maidhead"
	icon = 'icons/roguetown/clothing/special/maids.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/maids.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/maids.dmi'
