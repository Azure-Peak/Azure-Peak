//Donator Section
//All these items are stored in the donator_fluff.dm in the azure modular folder for simplicity.
//All should be subtypes of existing weapons/clothes/armor/gear, whatever, to avoid balance issues I guess. Idk, I'm not your boss.
//Please make sure to NOT create a subtype of donator_x/item unless there's a parent type, else it will show up as parent loadout datum due to the implicitly defined parent

/datum/loadout_item/donator
	sort_category = "Donator"

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
	ckeywhitelist = list("funkemonke", "droolingcowboy")

/datum/loadout_item/donator/fregian_mage
	name = "Violet Silk Gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/steward/donator_fregian_mage
	ckeywhitelist = list("lucine")

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

/datum/loadout_item/donator/eiren4
	name = "Donator Kit - Darkwood's Embrace"
	path = /obj/item/clothing/suit/roguetown/armor/longcoat/eiren
	ckeywhitelist = list("eirenxiv")

/datum/loadout_item/donator/eiren5
	name = "Donator Kit - Glintstone Longsword"
	path = /obj/item/enchantingkit/weapon/eiren_m
	ckeywhitelist = list("eirenxiv", "magicalbard", "naorgteine")

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
	ckeywhitelist = list("dasfox")

/datum/loadout_item/donator/dasfox/lance
	name = "Donator Item - Decorated Lance"
	path = /obj/item/enchantingkit/dasfox_lance
	ckeywhitelist = list("dasfox", "cre77") // on request by dasfox

/datum/loadout_item/donator/dasfox/tyesca_brigandine
	name = "Donator Item - fencer's brigandine"
	path = /obj/item/enchantingkit/tyesca_brigandine

/datum/loadout_item/donator/dasfox/tyesca_montante
	name = "Donator Item - Tyesca's montante"
	path = /obj/item/enchantingkit/weapon/tyesca_sword

/datum/loadout_item/donator/dasfox/tyesca_cloak
	name = "Donator Item - Tyesca's cloak"
	path = /obj/item/clothing/cloak/raincloak/tyesca

/datum/loadout_item/donator/dasfox/tyesca_scabbard
	name = "Donator Item - Tyesca's scabbard"
	path = /obj/item/rogueweapon/scabbard/sword/tyesca

/datum/loadout_item/donator/dasfox/ranger_woadsleeve
	name = "Donator Kit - Ranger's Woadmaille Bodysleeve"
	path = /obj/item/enchantingkit/dasfox_ranger_woadsleeve

/datum/loadout_item/donator/dasfox/ranger_undersuit
	name = "Donator Kit - Ranger's Undersuit"
	path = /obj/item/enchantingkit/dasfox_ranger_undersuit

/datum/loadout_item/donator/dasfox/ranger_demigaunts
	name = "Donator Kit - Ranger's Woadwoven Demigaunts"
	path = /obj/item/enchantingkit/dasfox_ranger_demigaunts

/datum/loadout_item/donator/dasfox/ranger_schynbalds
	name = "Donator Kit - Ranger's Woadwoven Stirruped Schynbalds"
	path = /obj/item/enchantingkit/dasfox_ranger_schynbalds

/datum/loadout_item/donator/dasfox/ranger_mantle
	name = "Donator Item - Black Oak Ranger's Mantle"
	path = /obj/item/clothing/cloak/dasfox_ranger

/datum/loadout_item/donator/ryan
	name = "Donator Item - Western Estates Caparison"
	path = /obj/item/caparison/ryan
	ckeywhitelist = list("ryan180602")

/datum/loadout_item/donator/ryan/psy_helm
	name = "Donator Kit - Unorthodoxist Psydonite Helm"
	path = /obj/item/enchantingkit/ryan_psyhelm

/datum/loadout_item/donator/ryan/naginata
	name = "Donator Kit - +5 Common Profane Naginata"
	path = /obj/item/enchantingkit/weapon/ryan_naginata

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
	ckeywhitelist = list("koruu", "pneumothorax", "ryan180602", "vakiova", "maesune", "nooriginality")

/datum/loadout_item/donator/koruu/kukri/warden
	name = "Donator Kit - Warden Leachwhacker"
	path = /obj/item/enchantingkit/weapon/koruu_kukri/warden
	ckeywhitelist = list("koruu", "pneumothorax", "ryan180602", "vakiova", "maesune", "dakken12", "nooriginality")

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

/datum/loadout_item/donator/drd/tiara
	name = "Donator Item - Ornate Coronet"
	path = /obj/item/clothing/head/roguetown/nyle/consortcrown/drd

/datum/loadout_item/donator/drd/smallsword
	name = "Donator Kit - 'Mære'"
	path = /obj/item/enchantingkit/drd_rapier

/datum/loadout_item/donator/drd/caparison
	name = "Donator Item - House Woerden Caparison"
	path = /obj/item/caparison/drd

/datum/loadout_item/donator/drd/shield
	name = "Donator Kit - House Woerden Shield"
	path = /obj/item/enchantingkit/weapon/drd_shield

/datum/loadout_item/donator/lmwevil/brassbeak
	name = "Donator Item - Brass Beak Mask"
	path = /obj/item/enchantingkit/lmwevil_brassbeak
	ckeywhitelist = list("lmwevil", "theeternalflame")

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
	ckeywhitelist = list("koruu", "pepperoniplayboy", "nooriginality")

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
	ckeywhitelist = list("nerocavalier","yeeteryieter","irlcatgirl","wickedcybs","spartanbobby","eirenxiv","freestylalt","lagomorphica","purplepineapple","stalkerino","shadowradar1212","omicega","revennui","mattatlas","gabopwn")

/datum/loadout_item/donator/nero_dagger
	name = "Donator Kit - Sylvan Dagger"
	path = /obj/item/enchantingkit/weapon/nero_dagger
	ckeywhitelist = list("nerocavalier","yeeteryieter","irlcatgirl","wickedcybs","spartanbobby","eirenxiv","freestylalt","lagomorphica","purplepineapple","stalkerino","shadowradar1212","omicega","revennui","mattatlas","gabopwn")

/datum/loadout_item/donator/nero_sabre
	name = "Donator Kit - Sylvan Sabre"
	path = /obj/item/enchantingkit/weapon/nero_sabre
	ckeywhitelist = list("nerocavalier","yeeteryieter","irlcatgirl","wickedcybs","spartanbobby","eirenxiv","freestylalt","lagomorphica","purplepineapple","stalkerino","shadowradar1212","omicega","revennui","mattatlas","gabopwn")

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

/datum/loadout_item/donator/lime_helm
	name = "Donator Kit - Serpentine Bascinet"
	path = /obj/item/enchantingkit/limetease
	ckeywhitelist = list("limetease", "simplypoodle")

/datum/loadout_item/donator/lime_dress
	name = "Donator Item - Noviciate Robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/limetease
	ckeywhitelist = list("limetease", "simplypoodle", "ketrai", "shiroseschnee", "kimmieweeb")

/datum/loadout_item/donator/lime_dress_color
	name = "Donator Item - Colorable Noviciate Robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/limetease/color
	ckeywhitelist = list("limetease", "simplypoodle", "ketrai", "shiroseschnee", "kimmieweeb")

/datum/loadout_item/donator/lime_swordspear
	name = "Donator Kit - Ornate Swordspear"
	path = /obj/item/enchantingkit/limetease_swordspear
	ckeywhitelist = list("limetease")

/datum/loadout_item/donator/gazelleskull
	name = "Donator Item - Gazelle Skull"
	path = /obj/item/clothing/head/roguetown/decoration/gazelleskull
	ckeywhitelist = list("shiroseschnee")

/datum/loadout_item/donator/morto_staff
	name = "Donator Kit - Frozen Vow"
	path = /obj/item/enchantingkit/morto_staff
	ckeywhitelist = list("mortosasye")

/datum/loadout_item/donator/mortosasye_deepcutdress
	name = "Donator Item - Deep Cut Dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/donator_mortosasye_deepcutdress
	ckeywhitelist = list("mortosasye")

/datum/loadout_item/donator/mortosasye_sunrisegown
	name = "Donator Item - Sunrise Gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress/donator_mortosasye_sunrisegown
	ckeywhitelist = list("mortosasye")

/datum/loadout_item/donator/mortosasye_goldendiadem
	name = "Donator Item - Golden Diadem"
	path = /obj/item/clothing/head/roguetown/circlet/donator_mortosasye_golddiadem
	ckeywhitelist = list("mortosasye", "flybrokenwings")

/datum/loadout_item/donator/morto_crown
	name = "Donator Kit - Sun Crown"
	path = /obj/item/enchantingkit/morto_crown
	ckeywhitelist = list("mortosasye")

/datum/loadout_item/donator/racobio_staff
	name = "Donator Kit - Obsidian Tower"
	path = /obj/item/enchantingkit/racobio_staff
	ckeywhitelist = list("racobio")

/datum/loadout_item/donator/cobb_conviction
	name = "Donator Kit - Conviction"
	path = /obj/item/enchantingkit/weapon/cobb_conviction
	ckeywhitelist = list("cobbantichrist")

/datum/loadout_item/donator/athena_solace
	name = "Donator Kit - Solace"
	path = /obj/item/enchantingkit/weapon/athena_solace
	ckeywhitelist = list("athena14")

/datum/loadout_item/donator/longest_night
	name = "Donator Item - Longest Night Cloak"
	path = /obj/item/clothing/cloak/longest_night
	ckeywhitelist = list("shiroseschnee")

/datum/loadout_item/donator/moonlightdussack
	name = "Donator Kit - Moonlight Dussack"
	path = /obj/item/enchantingkit/weapon/moonlightdussack
	ckeywhitelist = list("shiroseschnee")

/datum/loadout_item/donator/kadeguandao
	name = "Donator Kit - Dawn Cometh"
	path = /obj/item/enchantingkit/weapon/kadeguandao
	ckeywhitelist = list("shiroseschnee", "Zerantio", "elox2000")

/datum/loadout_item/donator/kadedao
	name = "Donator Kit - Spring Cometh"
	path = /obj/item/enchantingkit/weapon/kadedao
	ckeywhitelist = list("shiroseschnee", "Zerantio", "elox2000")

/datum/loadout_item/donator/forgefiend_wrench
	name = "Donator Kit - Forgefiend Wrench"
	path = /obj/item/enchantingkit/weapon/forgefiend_wrench
	ckeywhitelist = list("tamaya")

/datum/loadout_item/donator/falling_star
	name = "Donator Kit - Falling Star"
	path = /obj/item/enchantingkit/weapon/falling_star
	ckeywhitelist = list("octus")

/datum/loadout_item/donator/aticius_fls
	name = "Donator Kit - For Love's Sake"
	path = /obj/item/enchantingkit/aticius_fls
	ckeywhitelist = list("aticius")

/datum/loadout_item/donator/chivalre_aasimar
	name = "Donator Kit - Aasimari Equipment"
	path = /obj/item/enchantingkit/chivalre_aasimar
	ckeywhitelist = list("oddbomber3768")

/datum/loadout_item/donator/chivalre_aasimar_sack
	name = "Donator Kit - Aasimari Equipment, Sackful"
	path = /obj/item/storage/roguebag/donator_chivalre_elixirs
	ckeywhitelist = list("oddbomber3768")

/datum/loadout_item/donator/truill_flowerblade
	name = "Donator Kit - Beflowered Longsword"
	path = /obj/item/enchantingkit/truill_flowerblade
	ckeywhitelist = list("truill")

/datum/loadout_item/donator/rhynnrhynn_brigandine
	name = "Donator Kit - Jacketed Brigandine"
	path = /obj/item/enchantingkit/rhynnrhynn_brigandine
	ckeywhitelist = list("rhynnrhynn")

/datum/loadout_item/donator/rhynnrhynn_longcloak
	name = "Donator Item - Ladylike Longcloak"
	path = /obj/item/clothing/cloak/donator_rhynn
	ckeywhitelist = list("rhynnrhynn")

/datum/loadout_item/donator/rhynnrhynn_longcloak_broche
	name = "Donator Item - Ladylike Longcloak's Broche"
	path = /obj/item/clothing/head/roguetown/decoration/broche
	ckeywhitelist = list("rhynnrhynn")

/datum/loadout_item/donator/rhynnrhynn_staff_glow
	name = "Donator Kit - Celestial Staff, Glowing"
	path = /obj/item/enchantingkit/rhynnrhynn_staff_glow
	ckeywhitelist = list("rhynnrhynn")

/datum/loadout_item/donator/rhynnrhynn_staff_crested
	name = "Donator Kit - Celestial Staff, Crested"
	path = /obj/item/enchantingkit/rhynnrhynn_staff_crested
	ckeywhitelist = list("rhynnrhynn")

/datum/loadout_item/donator/rhynnrhynn_staff_winged
	name = "Donator Kit - Celestial Staff, Winged"
	path = /obj/item/enchantingkit/rhynnrhynn_staff_winged
	ckeywhitelist = list("rhynnrhynn")

/datum/loadout_item/donator/rhynnrhynn_staff_solar
	name = "Donator Kit - Celestial Staff, Solar"
	path = /obj/item/enchantingkit/rhynnrhynn_staff_solar
	ckeywhitelist = list("rhynnrhynn")

/datum/loadout_item/donator/lamprey_stechhelm
	name = "Donator Kit - Stechhelm"
	path = /obj/item/enchantingkit/lamprey_stechhelm
	ckeywhitelist = list("derpi559")

/datum/loadout_item/donator/squidqueen_longcoat
	name = "Donator Kit - Ragged Longcoat"
	path = /obj/item/enchantingkit/squidqueen_longcoat
	ckeywhitelist = list("lmwevil")

/datum/loadout_item/donator/squidqueen_longcoat_alt
	name = "Donator Kit - Frayed Longcoat"
	path = /obj/item/enchantingkit/squidqueen_longcoat_alt
	ckeywhitelist = list("lmwevil")

/datum/loadout_item/donator/squidqueen_harlottoga
	name = "Donator Item - Harlotous Toga"
	path = /obj/item/clothing/cloak/tabard/donator_squidqueen_harlottoga
	ckeywhitelist = list("lmwevil")

/datum/loadout_item/donator/hellpossum_apostle_armor
	name = "Donator Kit - Apostle's Armor"
	path = /obj/item/enchantingkit/hellpossum_apostle_armor
	ckeywhitelist = list("dasfox", "purplepineapple", "bigfoot02", "ryan180602", "oddbomber3768", "yeeteryieter")

/datum/loadout_item/donator/hellpossum_robed_apostle_armor
	name = "Donator Kit - Apostle's Armor, Robed"
	path = /obj/item/enchantingkit/hellpossum_robed_apostle_armor
	ckeywhitelist = list("dasfox", "purplepineapple", "bigfoot02", "ryan180602", "oddbomber3768", "yeeteryieter")

/datum/loadout_item/donator/hellpossum_apostle_helm
	name = "Donator Kit - Apostle's Burgeonet"
	path = /obj/item/enchantingkit/hellpossum_apostle_helm
	ckeywhitelist = list("dasfox", "purplepineapple", "bigfoot02", "ryan180602", "oddbomber3768", "yeeteryieter")

/datum/loadout_item/donator/hellpossum_apostle_winghelm
	name = "Donator Kit - Apostle's Burgeonet, Winged"
	path = /obj/item/enchantingkit/hellpossum_apostle_winghelm
	ckeywhitelist = list("dasfox", "purplepineapple", "bigfoot02", "ryan180602", "oddbomber3768", "yeeteryieter")

/datum/loadout_item/donator/hellpossum_apostle_wingsallet
	name = "Donator Kit - Apostle's Sallet, Winged"
	path = /obj/item/enchantingkit/hellpossum_apostle_wingsallet
	ckeywhitelist = list("dasfox", "purplepineapple", "bigfoot02", "ryan180602", "oddbomber3768", "yeeteryieter")

/datum/loadout_item/donator/rosy/birdmask
	name = "Donator Kit - Beaked Mask"
	path = /obj/item/enchantingkit/rosy/birdmask
	ckeywhitelist = list("rosysaturniidae")

/datum/loadout_item/donator/nero_woodlandcloak
	name = "Gift - Woodland Mantle"
	path = /obj/item/clothing/cloak/furcloak/woodland
	ckeywhitelist = list("nerocavalier","yeeteryieter","irlcatgirl","wickedcybs","spartanbobby","eirenxiv","freestylalt","lagomorphica","purplepineapple","stalkerino","shadowradar1212","omicega","revennui","mattatlas","gabopwn")

/datum/loadout_item/donator/nero_woodlandhood
	name = "Gift - Woodland Shawl"
	path = /obj/item/clothing/head/roguetown/roguehood/shawlhood/woodland
	ckeywhitelist = list("nerocavalier","yeeteryieter","irlcatgirl","wickedcybs","spartanbobby","eirenxiv","freestylalt","lagomorphica","purplepineapple","stalkerino","shadowradar1212","omicega","revennui","mattatlas","gabopwn")

/datum/loadout_item/donator/nero_woodlandbrigplackart
	name = "Donator Kit - Woodland Brigandine"
	path = /obj/item/enchantingkit/nero_woodlandbrigplackart
	ckeywhitelist = list("nerocavalier","yeeteryieter","irlcatgirl","wickedcybs","spartanbobby","eirenxiv","freestylalt","lagomorphica","purplepineapple","stalkerino","shadowradar1212","omicega","revennui","mattatlas","gabopwn")

/datum/loadout_item/donator/lagomorphica_obligatoire
	name = "Donator Kit - Obligatoire"
	path = /obj/item/enchantingkit/weapon/donator_lagomorphica_obligatoire
	ckeywhitelist = list("lagomorphica","stalkerino")

/datum/loadout_item/donator/lagomorphica_delirante
	name = "Donator Kit - Delirante"
	path = /obj/item/enchantingkit/weapon/donator_lagomorphica_delirante
	ckeywhitelist = list("lagomorphica","stalkerino")

/datum/loadout_item/donator/lagomorphica_traitresse
	name = "Donator Kit - Traitresse"
	path = /obj/item/enchantingkit/weapon/donator_lagomorphica_traitresse
	ckeywhitelist = list("lagomorphica","stalkerino")

/datum/loadout_item/donator/stalkerino_drowsword
	name = "Donator Kit - Skikuldic Sword"
	path = /obj/item/enchantingkit/weapon/donator_stalkerino_drowsword
	ckeywhitelist = list("lagomorphica","stalkerino")

/datum/loadout_item/donator/stalkerino_drowcrossbow
	name = "Donator Kit - Skikuldic Crossbow"
	path = /obj/item/enchantingkit/donator_stalkerino_drowcrossbow
	ckeywhitelist = list("lagomorphica","stalkerino")

/datum/loadout_item/donator/stalkerino_drowhelmet
	name = "Donator Kit - Skikudic Savoyard"
	path = /obj/item/enchantingkit/donator_stalkerino_drowhelmet
	ckeywhitelist = list("lagomorphica","stalkerino")

/datum/loadout_item/donator/chivalre_drowmantle
	name = "Donator Kit - Scourge Mantle"
	path = /obj/item/enchantingkit/donator_chivalre_drowmantle
	ckeywhitelist = list("oddbomber3768", "wickedcybs")

/datum/loadout_item/donator/chivalre_drowgreatflail
	name = "Donator Kit - Jagged Skikuldic Greatflail"
	path = /obj/item/enchantingkit/donator_chivalre_drowgreatflail
	ckeywhitelist = list("oddbomber3768")

/datum/loadout_item/donator/chivalre_drowgreatflailalt
	name = "Donator Kit - Smooth Skikuldic Greatflail"
	path = /obj/item/enchantingkit/donator_chivalre_drowgreatflailalt
	ckeywhitelist = list("oddbomber3768")

/datum/loadout_item/donator/rivercadaver_tabis
	name = "Donator Item - Tabis"
	path = /obj/item/enchantingkit/donator_rivercadaver_tabis
	ckeywhitelist = list("rivercadaver","poots13","nooriginality","helenmoder","oddbomber3768","waffai","castortroy23","persephoneq")

/datum/loadout_item/donator/flybrokenwings_drowparasol
	name = "Donator Item - Skikuldic Parasol"
	path = /obj/item/rogueweapon/mace/donator_flybrokenwings_parasol
	ckeywhitelist = list("flybrokenwings")

/datum/loadout_item/donator/flybrokenwings_drowpants
	name = "Donator Item - Underdweller's Trousers"
	path =/obj/item/clothing/under/roguetown/trou/artipants/donator_thistle
	ckeywhitelist = list("flybrokenwings")

/datum/loadout_item/donator/flybrokenwings_drowshirt
	name = "Donator Item - Underdweller's Shirt"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer/donator_thistle
	ckeywhitelist = list("flybrokenwings")

/datum/loadout_item/donator/flybrokenwings_drowgloves
	name = "Donator Item - Underdweller's Gloves"
	path = /obj/item/clothing/gloves/roguetown/cloth/donator_thistle
	ckeywhitelist = list("flybrokenwings")

/datum/loadout_item/donator/flybrokenwings_drowboots
	name = "Donator Item - Underdweller's Shoes"
	path = /obj/item/clothing/shoes/roguetown/boots/leather/donator_thistle
	ckeywhitelist = list("flybrokenwings")

/datum/loadout_item/donator/flybrokenwings_drowapron
	name = "Donator Item - Underdweller's Apron"
	path = /obj/item/clothing/cloak/apron/blacksmith/donator_thistle
	ckeywhitelist = list("flybrokenwings")

/datum/loadout_item/donator/flybrokenwings_drowcloak
	name = "Donator Item - Underdweller's Cloak"
	path = /obj/item/clothing/cloak/poncho/donator_thisle
	ckeywhitelist = list("flybrokenwings")

/datum/loadout_item/donator/flybrokenwings_case
	name = "Gift - Kit, Cased Satchel"
	path = /obj/item/enchantingkit/donator_case
	ckeywhitelist = list("flybrokenwings")

/datum/loadout_item/donator/naman_lance
	name = "Donator Kit - Noble Lance"
	path = /obj/item/enchantingkit/donator_naman_lance
	ckeywhitelist = list("copperwilson")

/datum/loadout_item/donator/naman_sabre
	name = "Donator Kit - Noble Sabre"
	path = /obj/item/enchantingkit/donator_naman_sabre
	ckeywhitelist = list("copperwilson")

/datum/loadout_item/donator/naman_tassetedbeltpack
	name = "Donator Kit - Tasseted Beltpack"
	path = /obj/item/enchantingkit/donator_naman_tassetedbeltpack
	ckeywhitelist = list("copperwilson")

/datum/loadout_item/donator/naman_triumph_tassetedbeltpack
	name = "Donator Item - Tasseted Beltpack"
	path = /obj/item/storage/backpack/rogue/satchel/beltpack/donator_naman
	triumph_cost = 7 //Player-requested alternative.
	ckeywhitelist = list("copperwilson")

/datum/loadout_item/donator/naman_deccoatofplates
	name = "Donator Kit - Decorated Coat Of Plates"
	path = /obj/item/enchantingkit/donator_naman_deccoatofplates
	ckeywhitelist = list("copperwilson")

/datum/loadout_item/donator/naman_scarfedridercloak
	name = "Donator Item - Rider's Scarfed Cloak"
	path = /obj/item/clothing/cloak/half/rider/donator_naman
	ckeywhitelist = list("copperwilson","nooriginality","maesune","koruu","ghostinthetoaster")

/datum/loadout_item/donator/sanshoom_prowlerrobe
	name = "Donator Kit - Prowler Robe"
	path = /obj/item/enchantingkit/donator_sanshoom_prowlerrobe
	ckeywhitelist = list("sanshoom")

/datum/loadout_item/donator/sanshoom_prowlermask
	name = "Donator Kit - Prowler Mask"
	path = /obj/item/enchantingkit/donator_sanshoom_prowlermask
	ckeywhitelist = list("sanshoom")

/datum/loadout_item/donator/trueterrydactyl_shibari
	name = "Donator Item - Smallclothes, Shibari"
	path = /obj/item/undies/bikini/shibari
	ckeywhitelist = list("trueterrydactyl")

/datum/loadout_item/donator/guidesa_bonebuckler
	name = "Donator Kit - Bone Buckler"
	path = /obj/item/enchantingkit/weapon/guidesa_bonebuckler
	ckeywhitelist = list("guidesu")

/datum/loadout_item/donator/guidesa_bonesickle
	name = "Donator Kit - Bone Sickle"
	path = /obj/item/enchantingkit/weapon/guidesa_bonesickle
	ckeywhitelist = list("guidesu")

/datum/loadout_item/donator/glassfeddockterr_bighat
	name = "Donator Item - Eryn's Archwyzardry Hat"
	path = /obj/item/clothing/head/roguetown/wizhat/bighat
	ckeywhitelist = list("glassfeddockterr")

/datum/loadout_item/donator/koruu_cadwyncloak_ravox
	name = "Donator Item - Sefirot's Cloak"
	path = /obj/item/clothing/cloak/templar/ravoxcleric/koruu
	ckeywhitelist = list("koruu", "oddbomber3768", "nooriginality", "vakiova", "maesune")

/datum/loadout_item/donator/koruu_cadwynhelm_ravox
	name = "Donator Item - Gebura"
	path = /obj/item/enchantingkit/donator_koruu_ravoxclerichelm
	ckeywhitelist = list("koruu", "oddbomber3768", "nooriginality", "vakiova", "maesune")

/datum/loadout_item/donator/bloom_coat
	name = "Donator Item - Royal Coat"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/rosacoat/three
	ckeywhitelist = list("bloom77")

/datum/loadout_item/donator/koruu_cadwyncloak_astrata
	name = "Donator Item - Cloak of the Order of the Sun"
	path = /obj/item/clothing/cloak/templar/astratancleric/koruu
	ckeywhitelist = list("koruu", "oddbomber3768", "nooriginality", "vakiova", "maesune")

/datum/loadout_item/donator/koruu_cadwynhelm_astrata
	name = "Donator Item - Lux In Tenebris"
	path = /obj/item/enchantingkit/donator_koruu_astrataclerichelm
	ckeywhitelist = list("koruu", "oddbomber3768", "nooriginality", "vakiova", "maesune")

/datum/loadout_item/donator/lief_friend
	name = "Donator Item - Aurum's Amulets"
	path = /obj/item/clothing/neck/roguetown/psicross/liefdonator
	ckeywhitelist = list("linxsysart", "pessime959")

/datum/loadout_item/donator/rezathedwarf
	name = "Donator Item - Noah's Glimmering Cloak"
	path = /obj/item/clothing/cloak/half/donator_rezathedwarf
	ckeywhitelist = list("rezathedwarf", "maesune")

/datum/loadout_item/donator/rezathedwarf/blade
	name = "Donator Kit - The Enclave Blade"
	path = /obj/item/enchantingkit/weapon/donator_rezathedwarf_blade

/datum/loadout_item/donator/lime_saber
	name = "Donator Kit - Malignant Blade"
	path = /obj/item/enchantingkit/weapon/limesaber
	ckeywhitelist = list("limetease")

/datum/loadout_item/donator/rosa_silveredguitar
	name = "Donator Item - Silvered Rosa Guitar"
	path = /obj/item/rogue/instrument/guitar/rosa_silveredguitar
	ckeywhitelist = list("limetease", "simplypoodle", "gentlemanlyheadcrab")

/datum/loadout_item/donator/silvered_guitar
	name = "Donator Item - Silvered Guitar"
	path = /obj/item/rogue/instrument/guitar/silveredguitar
	ckeywhitelist = list("limetease", "simplypoodle", "gentlemanlyheadcrab")

/datum/loadout_item/donator/mystogan_radiantmask
	name = "Donator Item - Radiant Golden Mask"
	path = /obj/item/clothing/mask/rogue/facemask/goldmask/radiant
	ckeywhitelist = list("mystoganzi")

/datum/loadout_item/donator/lief_ring
	name = "Donator Item - Blortz Incrusted Blacksteel Ring"
	path = /obj/item/clothing/ring/lief_ring
	ckeywhitelist = list("linxsysart", "pessime959")

/datum/loadout_item/donator/boemanerds
	name = "Donator Item - plate corslet morphkit"
	path = /obj/item/enchantingkit/triumph_armorkini_steel
	ckeywhitelist = list("boemanerds", "bulaven")

/datum/loadout_item/donator/boemanerds/iron
	name = "Donator Item - iron plate corslet morphkit"
	path = /obj/item/enchantingkit/triumph_armorkini_iron
	ckeywhitelist = list("boemanerds", "bulaven")

/datum/loadout_item/donator/yoshi_estoc
	name = "Donator Kit - Xylixian Estoc"
	path = /obj/item/enchantingkit/weapon/yoshi_estoc
	ckeywhitelist = list("limetease", "yosheh3") //yosheh3's ckey is Yosheh_3, but in the logic check its checking against yosheh3 so this is a workaround.

/datum/loadout_item/donator/limeastratatabard
	name = "Donator Item - Astratan Tabard"
	path = /obj/item/clothing/cloak/tabard/limeastratatabard
	ckeywhitelist = list("limetease")


/datum/loadout_item/donator/limetabard
	name = "Donator Item - Leathery Tabard"
	path = /obj/item/clothing/cloak/tabard/limetabard

/datum/loadout_item/donator/limeastratahelm
	name = "Donator Item - Astratan Helmet"
	path = /obj/item/enchantingkit/limeastratahelm
	ckeywhitelist = list("limetease")

/datum/loadout_item/donator/guidress
	name = "Donator Item - Gilded Dress"
	path = /obj/item/clothing/cloak/poncho/guidress
	ckeywhitelist = list("guimontag", "limetease")

/datum/loadout_item/donator/ulqbelt
	name = "Donator Item - Potionkeeper's Belt"
	path = /obj/item/storage/belt/rogue/leather/ulqbelt
	ckeywhitelist = list("seraphlemonade")

/datum/loadout_item/donator/ulqsusbelt
	name = "Donator Item - Potionkeeper's Messy Belt"
	path = /obj/item/storage/belt/rogue/leather/ulqsusbelt
	ckeywhitelist = list("seraphlemonade")

/datum/loadout_item/donator/saxyman
	name = "Donator Item - Prototype Strange Mask"
	path = /obj/item/clothing/mask/rogue/facemask/steel/confessor/mrsaxyman
	ckeywhitelist = list("mrsaxyman")

/datum/loadout_item/donator/lockwoodcloak
	name = "Donator Item - Courtly Cloak"
	path = /obj/item/clothing/cloak/rosa/two
	ckeywhitelist = list("XLockwoodx")

/datum/loadout_item/donator/lockwoodjacket
	name = "Donator Item - Sanguine Jacket"
	path = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/courtphysician/female/lockwood
	ckeywhitelist = list("XLockwoodx")
