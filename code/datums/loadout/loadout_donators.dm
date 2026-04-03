//Donator Section
//All these items are stored in the donator_fluff.dm in the azure modular folder for simplicity.
//All should be subtypes of existing weapons/clothes/armor/gear, whatever, to avoid balance issues I guess. Idk, I'm not your boss.
// Please make sure to NOT create a subtype of donator_x/item unless there's a parent type, else it will show up as parent loadout datum due to the implicitly defined parent

/datum/loadout_item/donator
	sort_category = "Donator"

/datum/loadout_item/donator/plex
	name = "Donator Kit - Rapier di Aliseo"
	path = /obj/item/enchantingkit/plexiant
	ckeywhitelist = list("plexiant")

/datum/loadout_item/donator/sru
	name = "Donator Kit - Emerald Dress"
	path = /obj/item/enchantingkit/srusu
	ckeywhitelist = list("cheekycrenando")

/datum/loadout_item/donator/funky
	name = "Trimmed down padded dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/funkydress
	ckeywhitelist = list("funkemonke")

/datum/loadout_item/donator/eekasqueak
	name = "Saffira encrusted tiara"
	path = /obj/item/clothing/head/roguetown/circlet/saffiratiara
	ckeywhitelist = list("eekasqueak")
	sort_category = "Donator"

/datum/loadout_item/donator_strudel1
	name = "Donator Kit - Grenzelhoftian Mage Vest"
	path = /obj/item/enchantingkit/strudel1
	ckeywhitelist = list("toasterstrudes")

/datum/loadout_item/donator/strudel2
	name = "Donator Kit - Xylixian Fasching Leotard"
	path = /obj/item/enchantingkit/strudel2
	ckeywhitelist = list("toasterstrudes")

/datum/loadout_item/donator/bat
	name = "Donator Kit - Handcarved Harp"
	path = /obj/item/enchantingkit/bat
	ckeywhitelist = list("kitchifox")

/datum/loadout_item/donator/mansa
	name = "Donator Kit - Wortträger"
	path = /obj/item/enchantingkit/ryebread
	ckeywhitelist = list("pepperoniplayboy")	//Byond maybe doesn't like spaces. If a name has a space, do it as one continious name.

/datum/loadout_item/donator/rebel
	name = "Donator Kit - Gilded Sallet"
	path = /obj/item/enchantingkit/rebel
	ckeywhitelist = list("rebel0")

/datum/loadout_item/donator/bigfoot
	name = "Donator Kit - Gilded Knight Helm"
	path = /obj/item/enchantingkit/bigfoot
	ckeywhitelist = list("bigfoot02")

/datum/loadout_item/donator/bigfoot_axe
	name = "Donator Kit - Gilded Greataxe"
	path = /obj/item/enchantingkit/bigfoot_axe
	ckeywhitelist = list("bigfoot02")

/datum/loadout_item/donator/zydrasiconocrown
	name = "Donator Kit - Iconoclast Crown"
	path = /obj/item/enchantingkit/zydrasiconocrown
	ckeywhitelist = list("1ceres")

/datum/loadout_item/donator/zydrasiconopauldrons
	name = "Donator Kit - Iconoclast Pauldrons"
	path = /obj/item/enchantingkit/zydrasiconopauldrons
	ckeywhitelist = list("1ceres")

/datum/loadout_item/donator/zydrasiconosash
	name = "Donator Kit - Iconoclast Sash"
	path = /obj/item/enchantingkit/zydrasiconosash
	ckeywhitelist = list("1ceres")

/datum/loadout_item/donator/eiren
	name = "Donator Kit - Regret"
	path = /obj/item/enchantingkit/weapon/eiren
	ckeywhitelist = list("eirenxiv")

/datum/loadout_item/donator/eiren2
	name = "Donator Kit - Lunae"
	path = /obj/item/enchantingkit/weapon/eirensabre
	ckeywhitelist = list("eirenxiv")

/datum/loadout_item/donator/eiren3
	name = "Donator Kit - Cinis"
	path = /obj/item/enchantingkit/eirensabre2
	ckeywhitelist = list("eirenxiv")

/datum/loadout_item/donator/eiren4
	name = "Donator Kit - Darkwood's Embrace"
	path = /obj/item/clothing/suit/roguetown/armor/longcoat/eiren
	ckeywhitelist = list("eirenxiv")

/datum/loadout_item/donator/eiren5
	name = "Donator Kit - Glintstone Longsword"
	path = /obj/item/enchantingkit/weapon/eiren_m
	ckeywhitelist = list("eirenxiv", "magicalbard")

/datum/loadout_item/donator/eiren6
	name = "Donator Kit - Stygian Longsword"
	path = /obj/item/enchantingkit/weapon/eirensword
	ckeywhitelist = list("eirenxiv", "muhsollini")

/datum/loadout_item/donator/waff
	name = "Donator Kit - Weeper's Lathe"
	path = /obj/item/enchantingkit/waff
	ckeywhitelist = list("waffai")

/datum/loadout_item/donator/waff2
	name = "Donator Item - Graverobber's Hat"
	path = /obj/item/clothing/head/roguetown/duelhat/pretzel
	ckeywhitelist = list("waffai")

/datum/loadout_item/donator/inverserun
	name = "Donator Kit - Votive Thorns"
	path = /obj/item/enchantingkit/weapon/inverserun
	ckeywhitelist = list("inverserun")

/datum/loadout_item/donator/zoe
	name = "Donator Kit - Shroud of the Undermaiden"
	path = /obj/item/enchantingkit/zoe
	ckeywhitelist = list("zoetheorc")

/datum/loadout_item/donator/zoe_shovel
	name = "Donator Kit - Silence"
	path = /obj/item/enchantingkit/zoe_shovel
	ckeywhitelist = list("zoetheorc")

/datum/loadout_item/donator/willmbrink
	name = "Donator Item - Royal Gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal
	ckeywhitelist = list("willmbrink")

/datum/loadout_item/donator/willmbrink/sleeves
	name = "Donator Item - Royal Sleeves"
	path = /obj/item/clothing/wrists/roguetown/royalsleeves

/datum/loadout_item/donator/dasfox
	name = "Donator Kit - Archaic Ceremonial Valkyrhelm"
	path = /obj/item/enchantingkit/dasfox_helm
	ckeywhitelist = list("dasfox", "purplepineapple") // on request by dasfox

/datum/loadout_item/donator/dasfox/cuirass
	name = "Donator Kit - Archaic Ceremonial Cuirass"
	path = /obj/item/enchantingkit/dasfox_cuirass

/datum/loadout_item/donator/dasfox/periapt
	name = "Donator Item - Defiled Astratan Periapt"
	path = /obj/item/clothing/neck/roguetown/psicross/astrata/dasfox
	ckeywhitelist = list("dasfox")

/datum/loadout_item/donator/dasfox/lance
	name = "Donator Item - Decorated Lance"
	path = /obj/item/enchantingkit/dasfox_lance
	ckeywhitelist = list("dasfox", "cre77") // on request by dasfox

/datum/loadout_item/donator/ryan
	name = "Donator Item - Western Estates Caparison"
	path = /obj/item/caparison/ryan
	ckeywhitelist = list("ryan180602")

/datum/loadout_item/donator/ryan/psy_helm
	name = "Donator Kit - Unorthodoxist Psydonite Helm"
	path = /obj/item/enchantingkit/ryan_psyhelm

/datum/loadout_item/donator/koruu
	name = "Donator Item - Well-Worn Bamboo Hat"
	path = /obj/item/clothing/head/roguetown/mentorhat/koruu
	ckeywhitelist = list("koruu", "painfeeler", "poots13", "vakiova", "maesune")

/datum/loadout_item/donator/koruu/glaive
	name = "Donator Kit - Glaive"
	path = /obj/item/enchantingkit/koruu_glaive

/datum/loadout_item/donator/koruu/kukri
	name = "Donator Kit - Leachwhacker"
	path = /obj/item/enchantingkit/weapon/koruu_kukri
	ckeywhitelist = list("koruu", "pneumothorax", "ryan180602", "vakiova", "maesune")

/datum/loadout_item/donator/koruu/kukri/warden
	name = "Donator Kit - Warden Leachwhacker"
	path = /obj/item/enchantingkit/weapon/koruu_kukri/warden

/datum/loadout_item/donator/dakken
	name = "Donator Kit - Armoured Avantyne Barbute"
	path = /obj/item/enchantingkit/dakken_zizhelm
	ckeywhitelist = list("dakken12") 

/datum/loadout_item/donator/dakken/sword
	name = "Donator Kit - Avantyne Threaded Sword"
	path = /obj/item/enchantingkit/dakken_alloybsword
	ckeywhitelist = list("dakken12") 

/datum/loadout_item/donator/stinketh
	name = "Donator Kit - Silver Shashka"
	path = /obj/item/enchantingkit/stinketh_shashka
	ckeywhitelist = list("stinkethstonketh")

/datum/loadout_item/donator/stinketh/pike
	name = "Donator Kit - Pike"
	path = /obj/item/enchantingkit/stinketh_pike
	ckeywhitelist = list("stinkethstonketh")

/datum/loadout_item/donator/drd
	name = "Donator Kit - Ornate Longsword"
	path = /obj/item/enchantingkit/drd_lsword
	ckeywhitelist = list("drd2021")

/datum/loadout_item/donator/drd/caparison
	name = "Donator Item - House Woerden Caparison"
	path = /obj/item/caparison/drd

/datum/loadout_item/donator/drd/shield
	name = "Donator Kit - House Woerden Shield"
	path = /obj/item/enchantingkit/weapon/drd_shield

/datum/loadout_item/donator/lmwevil/brassbeak
	name = "Donator Item - Brass Beak Mask"
	path = /obj/item/enchantingkit/lmwevil_brassbeak
	ckeywhitelist = list("lmwevil")

/datum/loadout_item/donator/shudderfly/eoranspike
	name = "Donator Kit - Eoran Spike"
	path = /obj/item/enchantingkit/shudderfly_dagger
	ckeywhitelist = list("shudderfly")

/datum/loadout_item/donator/maesune
	name = "Donator Item - Mercantile Union's Garb"
	path = /obj/item/clothing/suit/roguetown/shirt/maesune
	ckeywhitelist = list("maesune", "koruu", "inverserun", "vaki ova", "ryan180602")

/datum/loadout_item/donator/maesune/shield
	name = "Donator Kit - Silver Shield"
	path = /obj/item/enchantingkit/weapon/maesune_shield

/datum/loadout_item/donator/maesune/sabre
	name = "Donator Kit - Decorated Sabre"
	path = /obj/item/enchantingkit/weapon/maesune_sabre

/datum/loadout_item/donator/nerocavalier
	name = "Donator Kit - Blacksteel Longsword"
	path = /obj/item/enchantingkit/weapon/noire_flsword
	ckeywhitelist = list("nerocavalier")

/datum/loadout_item/donator/walkthewaste
	name = "Donator Item - Worn Bamboo Hat"
	path = /obj/item/clothing/head/roguetown/mentorhat/walkthewaste
	ckeywhitelist = list("walkthewaste")

