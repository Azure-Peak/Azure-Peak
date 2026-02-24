//Donator Section
//All these items are stored in the donator_fluff.dm in the azure modular folder for simplicity.
//All should be subtypes of existing weapons/clothes/armor/gear, whatever, to avoid balance issues I guess. Idk, I'm not your boss.
// Please make sure to NOT create a subtype of donator_x/item unless there's a parent type, else it will show up as parent loadout datum due to the implicitly defined parent

/datum/loadout_item/donator_plex
	name = "Donator Kit - Rapier di Aliseo"
	path = /obj/item/enchantingkit/plexiant
	ckeywhitelist = list("plexiant")
	sort_category = "Donator"

/datum/loadout_item/donator_sru
	name = "Donator Kit - Emerald Dress"
	path = /obj/item/enchantingkit/srusu
	ckeywhitelist = list("cheekycrenando")
	sort_category = "Donator"

/datum/loadout_item/donator_strudel1
	name = "Donator Kit - Grenzelhoftian Mage Vest"
	path = /obj/item/enchantingkit/strudel1
	ckeywhitelist = list("toasterstrudes")
	sort_category = "Donator"

/datum/loadout_item/donator_strudel2
	name = "Donator Kit - Xylixian Fasching Leotard"
	path = /obj/item/enchantingkit/strudel2
	ckeywhitelist = list("toasterstrudes")
	sort_category = "Donator"

/datum/loadout_item/donator_bat
	name = "Donator Kit - Handcarved Harp"
	path = /obj/item/enchantingkit/bat
	ckeywhitelist = list("kitchifox")
	sort_category = "Donator"

/datum/loadout_item/donator_mansa
	name = "Donator Kit - Wortträger"
	path = /obj/item/enchantingkit/ryebread
	ckeywhitelist = list("pepperoniplayboy")	//Byond maybe doesn't like spaces. If a name has a space, do it as one continious name.
	sort_category = "Donator"

/datum/loadout_item/donator_rebel
	name = "Donator Kit - Gilded Sallet"
	path = /obj/item/enchantingkit/rebel
	ckeywhitelist = list("rebel0")
	sort_category = "Donator"

/datum/loadout_item/donator_bigfoot
	name = "Donator Kit - Gilded Knight Helm"
	path = /obj/item/enchantingkit/bigfoot
	ckeywhitelist = list("bigfoot02")
	sort_category = "Donator"

/datum/loadout_item/donator_bigfoot_axe
	name = "Donator Kit - Gilded Greataxe"
	path = /obj/item/enchantingkit/bigfoot_axe
	ckeywhitelist = list("bigfoot02")
	sort_category = "Donator"

/datum/loadout_item/donator_zydrasiconocrown
	name = "Donator Kit - Iconoclast Crown"
	path = /obj/item/enchantingkit/zydrasiconocrown
	ckeywhitelist = list("1ceres")
	sort_category = "Donator"

/datum/loadout_item/donator_zydrasiconopauldrons
	name = "Donator Kit - Iconoclast Pauldrons"
	path = /obj/item/enchantingkit/zydrasiconopauldrons
	ckeywhitelist = list("1ceres")
	sort_category = "Donator"

/datum/loadout_item/donator_zydrasiconosash
	name = "Donator Kit - Iconoclast Sash"
	path = /obj/item/enchantingkit/zydrasiconosash
	ckeywhitelist = list("1ceres")
	sort_category = "Donator"

/datum/loadout_item/donator_eiren
	name = "Donator Kit - Regret"
	path = /obj/item/enchantingkit/eiren
	ckeywhitelist = list("eirenxiv")
	sort_category = "Donator"

/datum/loadout_item/donator_eiren2
	name = "Donator Kit - Lunae"
	path = /obj/item/enchantingkit/eirensabre
	ckeywhitelist = list("eirenxiv")
	sort_category = "Donator"

/*	Swapped out for _eiren4
/datum/loadout_item/donator_eiren3
	name = "Donator Kit - Cinis"
	path = /obj/item/enchantingkit/eirensabre2
	ckeywhitelist = list("eirenxiv")
*/

/datum/loadout_item/donator_eiren4
	name = "Donator Kit - Darkwood's Embrace"
	path = /obj/item/clothing/suit/roguetown/armor/longcoat/eiren
	ckeywhitelist = list("eirenxiv")
	sort_category = "Donator"

/datum/loadout_item/donator_waff
	name = "Donator Kit - Weeper's Lathe"
	path = /obj/item/enchantingkit/waff
	ckeywhitelist = list("waffai")
	sort_category = "Donator"

/datum/loadout_item/donator_waff2
	name = "Donator Item - Graverobber's Hat"
	path = /obj/item/clothing/head/roguetown/duelhat/pretzel
	ckeywhitelist = list("waffai")
	sort_category = "Donator"

/datum/loadout_item/donator_inverserun
	name = "Donator Kit - Votive Thorns"
	path = /obj/item/enchantingkit/inverserun
	ckeywhitelist = list("inverserun")
	sort_category = "Donator"

/datum/loadout_item/donator_zoe
	name = "Donator Kit - Shroud of the Undermaiden"
	path = /obj/item/enchantingkit/zoe
	ckeywhitelist = list("zoetheorc")
	sort_category = "Donator"

/datum/loadout_item/donator_zoe_shovel
	name = "Donator Kit - Silence"
	path = /obj/item/enchantingkit/zoe_shovel
	ckeywhitelist = list("zoetheorc")
	sort_category = "Donator"

/datum/loadout_item/donator_willmbrink
	name = "Donator Item - Royal Gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal
	ckeywhitelist = list("willmbrink")
	sort_category = "Donator"

/datum/loadout_item/donator_willmbrink/sleeves
	name = "Donator Item - Royal Sleeves"
	path = /obj/item/clothing/wrists/roguetown/royalsleeves
	sort_category = "Donator"

/datum/loadout_item/donator_dasfox
	name = "Donator Kit - Archaic Ceremonial Valkyrhelm"
	path = /obj/item/enchantingkit/dasfox_helm
	ckeywhitelist = list("dasfox", "purplepineapple") // on request by dasfox
	sort_category = "Donator"

/datum/loadout_item/donator_dasfox/cuirass
	name = "Donator Kit - Archaic Ceremonial Cuirass"
	path = /obj/item/enchantingkit/dasfox_cuirass
	sort_category = "Donator"

/datum/loadout_item/donator_dasfox/periapt
	name = "Donator Item - Defiled Astratan Periapt"
	path = /obj/item/clothing/neck/roguetown/psicross/astrata/dasfox
	ckeywhitelist = list("dasfox")
	sort_category = "Donator"

/datum/loadout_item/donator_dasfox/lance
	name = "Donator Item - Decorated Lance"
	path = /obj/item/enchantingkit/dasfox_lance
	ckeywhitelist = list("dasfox", "cre77") // on request by dasfox
	sort_category = "Donator"

/datum/loadout_item/donator_ryan
	name = "Donator Item - Western Estates Caparison"
	path = /obj/item/caparison/ryan
	ckeywhitelist = list("ryan180602")
	sort_category = "Donator"

/datum/loadout_item/donator_ryan/psy_helm
	name = "Donator Kit - Unorthodoxist Psydonite Helm"
	path = /obj/item/enchantingkit/ryan_psyhelm
	sort_category = "Donator"

/datum/loadout_item/donator_koruu
	name = "Donator Kit - Well-Worn Bamboo Hat"
	path = /obj/item/clothing/head/roguetown/mentorhat/koruu
	ckeywhitelist = list("koruu", "painfeeler", "poots13", "vakiova")
	sort_category = "Donator"

/datum/loadout_item/donator_dakken
	name = "Donator Kit - Armoured Avantyne Barbute"
	path = /obj/item/enchantingkit/dakken_zizhelm
	ckeywhitelist = list("dakken12") 
	sort_category = "Donator"

/datum/loadout_item/donator_koruu/glaive
	name = "Donator Kit - Glaive"
	path = /obj/item/enchantingkit/koruu_glaive
	sort_category = "Donator"

/datum/loadout_item/donator_stinketh
	name = "Donator Kit - Silver Shashka"
	path = /obj/item/enchantingkit/stinketh_shashka
	ckeywhitelist = list("stinkethstonketh")
	sort_category = "Donator"

/datum/loadout_item/donator_stinketh/pike
	name = "Donator Kit - Pike"
	path = /obj/item/enchantingkit/stinketh_pike
	ckeywhitelist = list("stinkethstonketh")
	sort_category = "Donator"

/datum/loadout_item/donator_drd/lsword
	name = "Donator Kit - Ornate Longsword"
	path = /obj/item/enchantingkit/drd_lsword
	ckeywhitelist = list("drd2021")
	sort_category = "Donator"
