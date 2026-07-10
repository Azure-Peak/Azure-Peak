//Donator Section
//All these items are stored in the donator_fluff.dm in the azure modular folder for simplicity.
//All should be subtypes of existing weapons/clothes/armor/gear, whatever, to avoid balance issues I guess. Idk, I'm not your boss.
//Please make sure to NOT create a subtype of donator_x/item unless there's a parent type, else it will show up as parent loadout datum due to the implicitly defined parent

/datum/loadout_item/donator
	sort_category = "Donator"

/////////////////////////////
// ! Unlocked Donor Kits ! //
/////////////////////////////
//Anything that can be accessed by anyone listed as a Donator, regardless of their CKEY. Could add some of these as higher-end Triumph purchases, down the line.

/datum/loadout_item/donator/universal
	donator_unlocked = TRUE

/datum/loadout_item/donator/universal/azurosa
	name = "Gift - Azurosa Flower"
	path = /obj/item/alch/rosa/azure

/datum/loadout_item/donator/universal/azurosa_seeds
	name = "Gift - Azurosa Flower, Seeds"
	path = /obj/item/storage/belt/rogue/pouch/azurosa_seeds

/datum/loadout_item/donator/universal/azurosa_crown
	name = "Gift - Azurosa Flowers, Crown"
	path = /obj/item/flowercrown/rosa/azure

/datum/loadout_item/donator/universal/azurosa_bouquet
	name = "Gift - Azurosa Flowers, Bouquet"
	path = /obj/item/bouquet/rosa/azure

/datum/loadout_item/donator/universal/cackledagger
	name = "Gift - Kit, Cackledagger"
	path = /obj/item/enchantingkit/cackledagger

/datum/loadout_item/donator/universal/longsword
	name = "Gift - Kit, Elegant Longsword"
	path = /obj/item/enchantingkit/weapon/donator_longsword

/datum/loadout_item/donator/universal/longsword_imbued
	name = "Gift - Kit, Imbued Longsword"
	path = /obj/item/enchantingkit/weapon/donator_imbuedlongsword

/datum/loadout_item/donator/universal/cloak_goldmaillekini
	name = "Gift - Golden Maillekini"
	path = /obj/item/clothing/cloak/donator_goldmaillekini

/datum/loadout_item/donator/universal/maille_chainkini
	name = "Gift - Kit, Maillekini"
	path = /obj/item/enchantingkit/maillekini

/datum/loadout_item/donator/universal/highheelshoes
	name = "Gift - High-Heeled Shoes"
	path = /obj/item/clothing/shoes/roguetown/simpleshoes/heels

/datum/loadout_item/donator/universal/highheelshoes_gold
	name = "Gift - High-Heeled Shoes, Gold"
	path = /obj/item/clothing/shoes/roguetown/simpleshoes/heels/donator_gold

/datum/loadout_item/donator/universal/highheelshoes_silver
	name = "Gift - High-Heeled Shoes, Silver"
	path = /obj/item/clothing/shoes/roguetown/simpleshoes/heels/donator_silver

/datum/loadout_item/donator/universal/elegant_armory
	name = "Gift - Kit, Elegant Armory"
	path = /obj/item/enchantingkit/donator_universal_armory

/datum/loadout_item/donator/universal/elegant_whip
	name = "Gift - Kit, Elegant Whip"
	path = /obj/item/enchantingkit/weapon/donator_universal_whips

/datum/loadout_item/donator/universal/elegant_urumi
	name = "Gift - Kit, Elegant Urumi"
	path = /obj/item/enchantingkit/weapon/donator_universal_urumi

/datum/loadout_item/donator/universal/elegant_shield
	name = "Gift - Kit, Elegant Shield"
	path = /obj/item/enchantingkit/donator_universal_shield

/datum/loadout_item/donator/universal/grenzshortsword
	name = "Gift - Kit, Katzbalger Shortsword"
	path = /obj/item/enchantingkit/weapon/donator_universal_grenzshortsword

/datum/loadout_item/donator/universal/grenzrapier
	name = "Gift - Kit, Smallsword-Style Rapier"
	path = /obj/item/enchantingkit/donator_universal_grenzrapier

/datum/loadout_item/donator/universal/cuirassplackart
	name = "Gift - Kit, Armored Plackart"
	path = /obj/item/enchantingkit/plackart

/datum/loadout_item/donator/universal/jadehalfmask_donator
	name = "Gift - Kit, Jade Halfask"
	path = /obj/item/enchantingkit/jadehalfmask

/datum/loadout_item/donator/universal/maille_cropped
	name = "Gift - Kit, Cropped Haubergeon"
	path = /obj/item/enchantingkit/croppedhaubergeon

/datum/loadout_item/donator/universal/maille_throwback
	name = "Gift - Kit, Elven Haubergeon"
	path = /obj/item/enchantingkit/elvenchainmail

/datum/loadout_item/donator/universal/cuirass_heartplate
	name = "Gift - Kit, Heartplate"
	path = /obj/item/enchantingkit/heartplate

/datum/loadout_item/donator/universal/armor_gothic_iron
	name = "Gift - Kit, Gothic Iron Armor"
	path = /obj/item/enchantingkit/gothicironarmor

/datum/loadout_item/donator/universal/armor_gothic_steel
	name = "Gift - Kit, Gothic Steel Armor"
	path = /obj/item/enchantingkit/gothicsteelarmor

/datum/loadout_item/donator/universal/cuirass_throwback
	name = "Gift - Kit, Heroic Leather Cuirass"
	path = /obj/item/enchantingkit/heroicleathercuirass

/datum/loadout_item/donator/universal/armor_triheartfelt
	name = "Gift - Kit, Azurian Plate Armor"
	path = /obj/item/enchantingkit/triheartfelt

/datum/loadout_item/donator/universal/headpiece_decoration
	name = "Gift - Oathtaker's Orle"
	path = /obj/item/clothing/head/roguetown/decoration/orle

/datum/loadout_item/donator/universal/cloak_oathkeeperlong
	name = "Gift - Oathtaker's Noble Longcoat"
	path = /obj/item/clothing/cloak/tabard/stabard/surcoat/donator_oathkeeper

/datum/loadout_item/donator/universal/cloak_oathkeepershort
	name = "Gift - Oathtaker's Noble Shortcoat"
	path = /obj/item/clothing/cloak/tabard/stabard/donator_oathkeeper

/datum/loadout_item/donator/universal/headpiece_oathkeeperdec
	name = "Gift - Oathtaker's Decoration, Shieldcrest"
	path = /obj/item/clothing/head/roguetown/decoration/orle/donator_oathkeeper

/datum/loadout_item/donator/universal/headpiece_greatplume
	name = "Gift - Helmet Cosmetic, Greatplume"
	path = /obj/item/clothing/head/roguetown/decoration/greatplume

/datum/loadout_item/donator/universal/armorpiece_shoulderguard
	name = "Gift - Armor Cosmetic, Shoulderguard"
	path = /obj/item/clothing/cloak/tabard/stabard/donator_shoulderguard

/datum/loadout_item/donator/universal/headpiece_orle
	name = "Gift - Helmet Cosmetic, Orle"
	path = /obj/item/clothing/head/roguetown/decoration/orle/donator_dyeable

//Brief explanation - as Spear found out, using a Morphing Elixir on a storage item works.. but permenantly deletes -anything- stored inside.
//To prevent any chance of someone accidentally destroying a round-important item, I'm replacing the kits with the main thing..
// ..for now(?). If someone else comes around and adds a check that prevents belts with stored items inside from being transformed, then they can -
// - restore the original Morphing Elixir filepaths, saved below.______qdel_list_wrapper(list/L)

/datum/loadout_item/donator/universal/doublet
	name = "Gift - Doublet"
	path = /obj/item/clothing/suit/roguetown/shirt/doublet

/datum/loadout_item/donator/universal/doublet_apoth
	name = "Gift - Doublet, Pale Green"
	path = /obj/item/clothing/suit/roguetown/shirt/apothshirt/donator

/datum/loadout_item/donator/universal/belt
	name = "Gift - Belt of Caped Leather"
	path = /obj/item/storage/belt/rogue/leather/donator //If-or-when the aforementioned bug's fixed, replace this with /obj/item/enchantingkit/beltleather.

/datum/loadout_item/donator/universal/belt_fur
	name = "Gift - Belt of Caped Fur"
	path = /obj/item/storage/belt/rogue/leather/donator_fur //If-or-when the aforementioned bug's fixed, replace this with /obj/item/enchantingkit/beltfur.

/datum/loadout_item/donator/universal/belt_bronze
	name = "Gift - Belt of Bronze Maille"
	path = /obj/item/storage/belt/rogue/leather/donator_bronze 

/datum/loadout_item/donator/universal/belt_iron
	name = "Gift - Belt of Iron Maille"
	path = /obj/item/storage/belt/rogue/leather/donator_iron //If-or-when the aforementioned bug's fixed, replace this with /obj/item/enchantingkit/beltironmaille.

/datum/loadout_item/donator/universal/belt_steel
	name = "Gift - Belt of Maille"
	path = /obj/item/storage/belt/rogue/leather/donator_steel //If-or-when the aforementioned bug's fixed, replace this with /obj/item/enchantingkit/beltsteelmaille.

/datum/loadout_item/donator/universal/belt_leathergirdle
	name = "Gift - Belted Girdle of Leather"
	path = /obj/item/storage/belt/rogue/leather/donator_leathergirdle

/datum/loadout_item/donator/universal/belt_bronzegirdle
	name = "Gift - Belted Plackart of Bronze"
	path = /obj/item/storage/belt/rogue/leather/donator_bronzegirdle

/datum/loadout_item/donator/universal/belt_irongirdle
	name = "Gift - Belted Plackart of Iron"
	path = /obj/item/storage/belt/rogue/leather/donator_irongirdle

/datum/loadout_item/donator/universal/belt_steelgirdle
	name = "Gift - Belted Plackart of Steel"
	path = /obj/item/storage/belt/rogue/leather/donator_steelgirdle

/datum/loadout_item/donator/universal/armorpiece_shoulderguard
	name = "Gift - Armor Cosmetic, Shoulderguard"
	path = /obj/item/clothing/cloak/tabard/stabard/donator_shoulderguard

/datum/loadout_item/donator/universal/armorpiece_armharness
	name = "Gift - Armor Cosmetic, Arm Harness"
	path = /obj/item/enchantingkit/donator_universal_armharness

/////////////////////////////
// ! Player / Donor Kits ! //
/////////////////////////////
//Anything that's locked behind the CKEY(s) of another. Only those in the 'ckeywhitelist' field'll be able to see-and-take these from the Loadout.

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

/datum/loadout_item/donator/ketrai
	name = "Octopus hat"
	path = /obj/item/clothing/head/roguetown/octopus
	ckeywhitelist = list("ketrai", "alfalah")
	sort_category = "Donator"

/datum/loadout_item/donator/strudel1
	name = "Donator Kit - Grenzelhoftian Mage Vest"
	path = /obj/item/enchantingkit/strudel1
	ckeywhitelist = list("toasterstrudes")

/datum/loadout_item/donator/strudel2
	name = "Donator Kit - Xylixian Fasching Leotard"
	path = /obj/item/enchantingkit/strudel2
	ckeywhitelist = list("toasterstrudes")

/datum/loadout_item/donator/strudel3
	name = "Donator Kit - Etruscan Design Cloak"
	path = /obj/item/enchantingkit/strudel3
	ckeywhitelist = list("toasterstrudes")

/datum/loadout_item/donator/strudel4
	name = "Donator Kit - Form-fitting Padded Gambeson"
	path = /obj/item/enchantingkit/strudel4
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
	name = "Donator Kit - Aureline"
	path = /obj/item/enchantingkit/bigfoot_axe
	ckeywhitelist = list("bigfoot02")

/datum/loadout_item/donator/zydrasiconocrown
	name = "Donator Kit - Iron Gardbrace & Fauld"
	path = /obj/item/enchantingkit/zydrashauberk
	ckeywhitelist = list("1ceres")

/datum/loadout_item/donator/zydrasgreataxe
	name = "Donator Kit - Bourreau"
	path = /obj/item/enchantingkit/zydrasgreataxe
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
	path = /obj/item/enchantingkit/weapon/eirensabre2
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
	path = /obj/item/enchantingkit/weapon/waff
	ckeywhitelist = list("waffai")

/datum/loadout_item/donator/waff2
	name = "Donator Item - Graverobber's Hat"
	path = /obj/item/clothing/head/roguetown/duelhat/pretzel
	ckeywhitelist = list("waffai")

/datum/loadout_item/donator/waff3
	name = "Donator Kit - Xenolalia"
	path = /obj/item/enchantingkit/weapon/wafflamberge
	ckeywhitelist = list("waffai")

/datum/loadout_item/donator/inverserun
	name = "Donator Kit - Votive Thorns"
	path = /obj/item/enchantingkit/weapon/inverserun
	ckeywhitelist = list("inverserun")

/datum/loadout_item/donator/inverserun/amdir
	name = "Donator Kit - Amdir"
	path = /obj/item/enchantingkit/weapon/arra_amdir
	ckeywhitelist = list("inverserun","vakiova","maesune","koruu","rezathedwarf","theneogamer42")

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

/datum/loadout_item/donator/willmbrink/padded_dress
	name = "Donator Item - Padded Dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/willmbrink

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
	ckeywhitelist = list("maesune", "koruu", "inverserun", "vakiova", "ryan180602")

/datum/loadout_item/donator/maesune/shield
	name = "Donator Kit - Silver Shield"
	path = /obj/item/enchantingkit/weapon/maesune_shield

/datum/loadout_item/donator/maesune/sabre
	name = "Donator Kit - Decorated Sabre"
	path = /obj/item/enchantingkit/weapon/maesune_sabre

/datum/loadout_item/donator/walkthewaste
	name = "Donator Item - Worn Bamboo Hat"
	path = /obj/item/clothing/head/roguetown/mentorhat/walkthewaste
	ckeywhitelist = list("walkthewaste")

/datum/loadout_item/donator/sci_flamesword
	name = "Donator Item - Flametongue"
	path = /obj/item/enchantingkit/sci_flame
	ckeywhitelist = list("scidragon")

/datum/loadout_item/donator/sci_sandsword
	name = "Donator Item - Sandlash"
	path = /obj/item/enchantingkit/sci_sand
	ckeywhitelist = list("scidragon")

/datum/loadout_item/donator/aisuwand
    name = "Donator Kit - Crystalline Rapier"
    path = /obj/item/enchantingkit/aisuwand
    ckeywhitelist = list("aisu9")

/datum/loadout_item/donator/regnum
	name = "Donator Item - Regnum"
	path = /obj/item/enchantingkit/weapon/regnum
	ckeywhitelist = list("nauticall")

/datum/loadout_item/donator/aeternum
	name = "Donator Item - Aeternum"
	path = /obj/item/enchantingkit/weapon/aeternum
	ckeywhitelist = list("nauticall")

/datum/loadout_item/donator/crown_hat
	name = "Donator Item - Crown Hat"
	path = /obj/item/clothing/head/roguetown/crown_hat
	ckeywhitelist = list("nauticall")

/datum/loadout_item/donator/porcelainmask
	name = "Donator Item - Porcelain Mask"
	path = /obj/item/clothing/mask/rogue/iamcrystalclear
	ckeywhitelist = list("iamcrystalclear")

/datum/loadout_item/donator/darling
	name = "Donator Item - Darling"
	path = /obj/item/enchantingkit/weapon/darling
	ckeywhitelist = list("castortroy23")

/datum/loadout_item/donator/sumquoderis
	name = "Donator Item - Sum Quod Eris"
	path = /obj/item/enchantingkit/weapon/sumquoderis
	ckeywhitelist = list("rivercadaver")

/datum/loadout_item/donator/euthanasia
	name = "Donator Item - Euthanasia"
	path = /obj/item/enchantingkit/weapon/euthanasia
	ckeywhitelist = list("rivercadaver")

/datum/loadout_item/donator/wyrd_cloak
	name = "Donator Item - Wyrd Cloak"
	path = /obj/item/clothing/suit/roguetown/armor/longcoat/wyrd_cloak
	ckeywhitelist = list("nekosam")

/datum/loadout_item/donator/dark_delight
	name = "Donator Item - Dark Delight"
	path = /obj/item/enchantingkit/weapon/nicksonessang
	ckeywhitelist = list("nicksone")

/datum/loadout_item/donator/koruu_silver_kukri
	name = "Donator Kit - Psydonic Leachwhacker"
	path = /obj/item/enchantingkit/weapon/koruu_kukri_silver
	ckeywhitelist = list("koruu", "pepperoniplayboy")

/datum/loadout_item/donator/koruu_longsword
	name = "Donator Kit - Excaliber"
	path = /obj/item/enchantingkit/weapon/koruu_longsword
	ckeywhitelist = list("koruu", "pneumothorax")

/datum/loadout_item/donator/koruu_etrusc
	name = "Donator Kit - Colada"
	path = /obj/item/enchantingkit/weapon/koruu_etrusc
	ckeywhitelist = list("koruu", "pneumothorax")

/datum/loadout_item/donator/koruu_judgement
	name = "Donator Kit - A Durthurian Tale"
	path = /obj/item/enchantingkit/weapon/koruu_judgement
	ckeywhitelist = list("koruu", "pneumothorax")

/datum/loadout_item/donator/magi1138
	name = "Donator Kit - Stolen Xylix Cloak"
	path = /obj/item/clothing/cloak/magi1138
	ckeywhitelist = list("magi1138")

/datum/loadout_item/donator/magi1138/specs
	name = "Donator Kit - Modified Nocshade Lens-pair"
	path = /obj/item/clothing/mask/rogue/spectacles/magi1138

/datum/loadout_item/donator/nero_sword
	name = "Donator Kit - Sylvan Longsword"
	path = /obj/item/enchantingkit/weapon/nero_lsword
	ckeywhitelist = list("nerocavalier","yeeteryieter","irlcatgirl","wickedcybs","spartanbobby","eirenxiv","freestylalt","lagomorphica")

/datum/loadout_item/donator/nero_dagger
	name = "Donator Kit - Sylvan Dagger"
	path = /obj/item/enchantingkit/weapon/nero_dagger
	ckeywhitelist = list("nerocavalier","yeeteryieter","irlcatgirl","wickedcybs","spartanbobby","eirenxiv","freestylalt","lagomorphica")

/datum/loadout_item/donator/nero_sabre
	name = "Donator Kit - Sylvan Sabre"
	path = /obj/item/enchantingkit/weapon/nero_sabre
	ckeywhitelist = list("nerocavalier","yeeteryieter","irlcatgirl","wickedcybs","spartanbobby","eirenxiv","freestylalt","lagomorphica")

/datum/loadout_item/donator/des_gaebolg
	name = "Dontaor Kit - Gae Bolg"
	path = /obj/item/enchantingkit/weapon/des_gaebolg
	ckeywhitelist = list("desminus")

/datum/loadout_item/donator/pes_guitar
	name = "Donator Item - Red-Stained Guitar"
	path = /obj/item/rogue/instrument/guitar/pes_guitar
	ckeywhitelist = list("pessime959")

/datum/loadout_item/donator/vakiova
	name = "Donator Item - Gravetender Coat"
	path = /obj/item/clothing/cloak/vaki_gravetender
	ckeywhitelist = list("vakiova", "maesune", "astartee")

/datum/loadout_item/donator/sakuyzo
	name = "Donator Kit - Hævatein"
	path = /obj/item/enchantingkit/weapon/sakuyzo
	ckeywhitelist = list("sakuzyo")

/datum/loadout_item/donator/ollanius_maille
	name = "Donator Kit - Shoulderless Haubergeon"
	path = /obj/item/enchantingkit/ollanius_maille
	ckeywhitelist = list("ollanius")

/datum/loadout_item/donator/ollanius_sword
	name = "Donator Kit - Azurosa-Wrapped Sword"
	path = /obj/item/enchantingkit/weapon/ollanius
	ckeywhitelist = list("ollanius")

/datum/loadout_item/donator/jade_guitar
	name = "Donator Item - Gilbranzed Guitar"
	path = /obj/item/rogue/instrument/guitar/jade_guitar
	ckeywhitelist = list("jademanique")

/datum/loadout_item/donator/olygsword
    name = "Donator Kit - Gre'as'anto d'Shar"
    path = /obj/item/enchantingkit/olygsword
    ckeywhitelist = list("olympus7")
	
/datum/loadout_item/donator/bobby
	name = "Donator Kit - Holy Astratan Bascinet"
	path = /obj/item/enchantingkit/bobby_helm
	ckeywhitelist = list("spartanbobby") 

/datum/loadout_item/donator/ollanius_sword
	name = "Donator Kit - Azurosa-Wrapped Sword"
	path = /obj/item/enchantingkit/weapon/ollanius
	ckeywhitelist = list("ollanius")

/datum/loadout_item/donator/spaz_helm
	name = "Donator Kit - Hound-Nosed Bascinet"
	path = /obj/item/enchantingkit/spaz_helm
	ckeywhitelist = list("seniorspaz")
