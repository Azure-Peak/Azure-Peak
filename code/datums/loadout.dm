GLOBAL_LIST_EMPTY(loadout_items)

/datum/loadout_item
	var/name = "Parent loadout datum"
	var/desc
	var/path
	var/donoritem			//autoset on new if null
	var/list/ckeywhitelist
	var/triumph_cost

/datum/loadout_item/New()
	if(isnull(donoritem))
		if(ckeywhitelist)
			donoritem = TRUE
	var/obj/targetitem = path
	desc = targetitem.desc
	if (triumph_cost)
		desc += "<br><b>Costs [triumph_cost] TRIUMPHS.</b>"

/datum/loadout_item/proc/donator_ckey_check(key)
	if(ckeywhitelist && ckeywhitelist.Find(key))
		return TRUE
	return

//Miscellaneous

/datum/loadout_item/card_deck
	name = "Card Deck"
	path = /obj/item/toy/cards/deck

/datum/loadout_item/farkle_dice
	name = "Farkle Dice Container"
	path = /obj/item/storage/pill_bottle/dice/farkle

/datum/loadout_item/tarot_deck
	name = "Tarot Deck"
	path = /obj/item/toy/cards/deck/tarot

/datum/loadout_item/custom_book
	name = "Custom Book"
	path = /obj/item/book/rogue/loadoutbook

//TOOLS
/datum/loadout_item/paper_parasol
	name = "Paper Parasol"
	path = /obj/item/rogueweapon/mace/parasol

/datum/loadout_item/fine_parasol
	name = "Fine Parasol"
	path = /obj/item/rogueweapon/mace/parasol/noble

//HATS
/datum/loadout_item/shalal
	name = "Keffiyeh"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal

/datum/loadout_item/tricorn
	name = "Tricorn Hat"
	path = /obj/item/clothing/head/roguetown/helmet/tricorn

/datum/loadout_item/nurseveil
	name = "Nurse's Veil"
	path = /obj/item/clothing/head/roguetown/veiled

/datum/loadout_item/archercap
	name = "Archer's cap"
	path = /obj/item/clothing/head/roguetown/archercap

/datum/loadout_item/strawhat
	name = "Straw Hat"
	path = /obj/item/clothing/head/roguetown/strawhat

/datum/loadout_item/witchhat
	name = "Witch Hat"
	path = /obj/item/clothing/head/roguetown/witchhat

/datum/loadout_item/bardhat
	name = "Bard Hat"
	path = /obj/item/clothing/head/roguetown/bardhat

/datum/loadout_item/fancyhat
	name = "Fancy Hat"
	path = /obj/item/clothing/head/roguetown/fancyhat

/datum/loadout_item/furhat
	name = "Fur Hat"
	path = /obj/item/clothing/head/roguetown/hatfur

/datum/loadout_item/smokingcap
	name = "Smoking Cap"
	path = /obj/item/clothing/head/roguetown/smokingcap

/datum/loadout_item/headband
	name = "Headband"
	path = /obj/item/clothing/head/roguetown/headband

/datum/loadout_item/buckled_hat
	name = "Buckled Hat"
	path = /obj/item/clothing/head/roguetown/puritan

/datum/loadout_item/folded_hat
	name = "Folded Hat"
	path = /obj/item/clothing/head/roguetown/bucklehat

/datum/loadout_item/duelist_hat
	name = "Duelist's Hat"
	path = /obj/item/clothing/head/roguetown/duelhat

/datum/loadout_item/hood
	name = "Hood"
	path = /obj/item/clothing/head/roguetown/roguehood

/datum/loadout_item/hijab
	name = "Hijab"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab

/datum/loadout_item/heavyhood
	name = "Heavy Hood"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood

/datum/loadout_item/nunveil
	name = "Nun Veil"
	path = /obj/item/clothing/head/roguetown/nun

/datum/loadout_item/papakha
	name = "Papakha"
	path = /obj/item/clothing/head/roguetown/papakha

/datum/loadout_item/rosa_crown
	name = "Rosa Crown"
	path = /obj/item/flowercrown/rosa

/datum/loadout_item/salvia_crown
	name = "Salvia Crown"
	path = /obj/item/flowercrown/salvia

/datum/loadout_item/matricaria_crown
	name = "Matricaria Crown"
	path = /obj/item/flowercrown/matricaria

/datum/loadout_item/calendula_crown
	name = "Calendula Crown"
	path = /obj/item/flowercrown/calendula

/datum/loadout_item/manabloom_crown
	name = "Manabloom Crown"
	path = /obj/item/flowercrown/manabloom

/datum/loadout_item/briar_crown
	name = "Briar Thorn Crown"
	path = /obj/item/flowercrown/briar

/datum/loadout_item/briarthorns
	name = "Briar Thorns"
	path = /obj/item/clothing/head/roguetown/briarthorns

//CLOAKS
/datum/loadout_item/tabard
	name = "Tabard"
	path = /obj/item/clothing/cloak/tabard

/datum/loadout_item/surcoat
	name = "Surcoat"
	path = /obj/item/clothing/cloak/tabard/stabard

/datum/loadout_item/jupon
	name = "Jupon"
	path = /obj/item/clothing/cloak/tabard/stabard/surcoat

/datum/loadout_item/jupon_short
	name = "Short Jupon"
	path = /obj/item/clothing/cloak/tabard/stabard/surcoat/short

/datum/loadout_item/cape
	name = "Cape"
	path = /obj/item/clothing/cloak/cape

/datum/loadout_item/halfcloak
	name = "Halfcloak"
	path = /obj/item/clothing/cloak/half

/datum/loadout_item/ridercloak
	name = "Rider Cloak"
	path = /obj/item/clothing/cloak/half/rider

/datum/loadout_item/raincloak
	name = "Rain Cloak"
	path = /obj/item/clothing/cloak/raincloak

/datum/loadout_item/furcloak
	name = "Fur Cloak"
	path = /obj/item/clothing/cloak/raincloak/furcloak

/datum/loadout_item/direcloak
	name = "direbear cloak"
	path = /obj/item/clothing/cloak/darkcloak/bear

/datum/loadout_item/lightdirecloak
	name = "light direbear cloak"
	path = /obj/item/clothing/cloak/darkcloak/bear/light

/datum/loadout_item/volfmantle
	name = "Volf Mantle"
	path = /obj/item/clothing/cloak/volfmantle

/datum/loadout_item/eastcloak2
	name = "Leather Cloak"
	path = /obj/item/clothing/cloak/eastcloak2

/datum/loadout_item/thief_cloak
	name = "Rapscallion's Shawl"
	path = /obj/item/clothing/cloak/thief_cloak

/datum/loadout_item/tabardscarlet
	name = "Tabard, Scarlet"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardscarlet

/datum/loadout_item/shroudscarlet
	name = "Tabard's Shroud, Scarlet"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudscarlet

/datum/loadout_item/tabardblack
	name = "Tabard, Black"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardblack

/datum/loadout_item/shroudblack
	name = "Tabard's Shroud, Black"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudblack

/datum/loadout_item/tabardwhite
	name = "Tabard, White"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardwhite

/datum/loadout_item/shroudwhite
	name = "Tabard's Shroud, White"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudwhite

/datum/loadout_item/poncho
	name = "Poncho"
	path = /obj/item/clothing/cloak/poncho

/datum/loadout_item/aproncook
	name = "Apron, Cooking"
	path = /obj/item/clothing/cloak/apron/cook

//SHOES
/datum/loadout_item/darkboots
	name = "Dark Boots"
	path = /obj/item/clothing/shoes/roguetown/boots

/datum/loadout_item/babouche
	name = "Babouche"
	path = /obj/item/clothing/shoes/roguetown/shalal

/datum/loadout_item/nobleboots
	name = "Noble Boots"
	path = /obj/item/clothing/shoes/roguetown/boots/nobleboot

/datum/loadout_item/sandals
	name = "Sandals"
	path = /obj/item/clothing/shoes/roguetown/sandals

/datum/loadout_item/shortboots
	name = "Short Boots"
	path = /obj/item/clothing/shoes/roguetown/shortboots

/datum/loadout_item/gladsandals
	name = "Gladiatorial Sandals"
	path = /obj/item/clothing/shoes/roguetown/gladiator

/datum/loadout_item/ridingboots
	name = "Riding Boots"
	path = /obj/item/clothing/shoes/roguetown/ridingboots

/datum/loadout_item/ankletscloth
	name = "Cloth Anklets"
	path = /obj/item/clothing/shoes/roguetown/boots/clothlinedanklets

/datum/loadout_item/ankletsfur
	name = "Fur Anklets"
	path = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets

/datum/loadout_item/exoticanklets
	name = "Exotic Anklets"
	path = /obj/item/clothing/shoes/roguetown/anklets

/datum/loadout_item/rumaclanshoes
	name = "Raised Sandals"
	path = /obj/item/clothing/shoes/roguetown/armor/rumaclan/shitty

//SHIRTS
/datum/loadout_item/longcoat
	name = "Longcoat"
	path = /obj/item/clothing/suit/roguetown/armor/longcoat

/datum/loadout_item/robe
	name = "Robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe

/datum/loadout_item/phys_robe
	name = "Physicker's Robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/phys

/datum/loadout_item/feld_robe
	name = "Feldsher's Robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/feld

/datum/loadout_item/formalsilks
	name = "Formal Silks"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan

/datum/loadout_item/longshirt
	name = "Shirt"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/black

/datum/loadout_item/shortshirt
	name = "Short-sleeved Shirt"
	path = /obj/item/clothing/suit/roguetown/shirt/shortshirt

/datum/loadout_item/sailorshirt
	name = "Striped Shirt"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor

/datum/loadout_item/sailorjacket
	name = "Leather Jacket"
	path = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor

/datum/loadout_item/priestrobe
	name = "Undervestments"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest

/datum/loadout_item/exoticsilkbra
	name = "Exotic Silk Bra"
	path = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra

/datum/loadout_item/desertbra
	name = "Desert Bra"
	path = /obj/item/clothing/suit/roguetown/shirt/desertbra

/datum/loadout_item/deserthood
	name = "Desert Hood"
	path = /obj/item/clothing/head/roguetown/deserthood

/datum/loadout_item/desertskirt
	name = "Desert Skirt"
	path = /obj/item/clothing/under/roguetown/skirt/desert

/datum/loadout_item/explorerhat
	name = "Explorer Hat"
	path = /obj/item/clothing/head/roguetown/explorerhat

/datum/loadout_item/explorervest
	name = "Explorer Vest"
	path = /obj/item/clothing/suit/roguetown/shirt/explorer

/datum/loadout_item/fancycoat
	name = "Fancy Coat"
	path = /obj/item/clothing/cloak/poncho/fancycoat

/datum/loadout_item/explorerpants
	name = "Explorer Pants"
	path = /obj/item/clothing/under/roguetown/tights/explorerpants

/datum/loadout_item/bottomtunic
	name = "Low-cut Tunic"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut

/datum/loadout_item/tunic
	name = "Tunic"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic

/datum/loadout_item/stripedtunic
	name = "Striped Tunic"
	path = /obj/item/clothing/suit/roguetown/armor/workervest

/datum/loadout_item/dress
	name = "Dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen

/datum/loadout_item/bardress
	name = "Bar Dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress

/datum/loadout_item/chemise
	name = "Chemise"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress

/datum/loadout_item/sexydress
	name = "Sexy Dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy

/datum/loadout_item/straplessdress
	name = "Strapless Dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless

/datum/loadout_item/straplessdress/alt
	name = "Strapless Dress, alt"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/alt

/datum/loadout_item/gown
	name = "Spring Gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown

/datum/loadout_item/gown/summer
	name = "Summer Gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown

/datum/loadout_item/gown/fall
	name = "Fall Gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown

/datum/loadout_item/gown/winter
	name = "Winter Gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown

/datum/loadout_item/gown/silkydress
	name = "Silky Dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress

/datum/loadout_item/noblecoat
	name = "Fancy Coat"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat

/datum/loadout_item/leathervest
	name = "Leather Vest"
	path = /obj/item/clothing/suit/roguetown/armor/leather/vest

/datum/loadout_item/nun_habit
	name = "Nun Habit"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/nun

/datum/loadout_item/eastshirt1
	name = "Black Foreign Shirt"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1

/datum/loadout_item/eastshirt2
	name = "White Foreign Shirt"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2

//PANTS
/datum/loadout_item/tights
	name = "Cloth Tights"
	path = /obj/item/clothing/under/roguetown/tights/black

/datum/loadout_item/leathertights
	name = "Leather Tights"
	path = /obj/item/clothing/under/roguetown/trou/leathertights

/datum/loadout_item/trou
	name = "Work Trousers"
	path = /obj/item/clothing/under/roguetown/trou

/datum/loadout_item/leathertrou
	name = "Leather Trousers"
	path = /obj/item/clothing/under/roguetown/trou/leather

/datum/loadout_item/leathershorts
	name = "Leather Shorts"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts

/datum/loadout_item/sailorpants
	name = "Seafaring Pants"
	path = /obj/item/clothing/under/roguetown/tights/sailor

/datum/loadout_item/skirt
	name = "Skirt"
	path = /obj/item/clothing/under/roguetown/skirt

//ACCESSORIES
/datum/loadout_item/wrappings
	name = "Handwraps"
	path = /obj/item/clothing/wrists/roguetown/wrappings

/datum/loadout_item/allwrappings
	name = "Cloth Wrappings"
	path = /obj/item/clothing/wrists/roguetown/allwrappings

/datum/loadout_item/loincloth
	name = "Loincloth"
	path = /obj/item/clothing/under/roguetown/loincloth

/datum/loadout_item/spectacles
	name = "Spectacles"
	path = /obj/item/clothing/mask/rogue/spectacles

/datum/loadout_item/fingerless
	name = "Fingerless Gloves"
	path = /obj/item/clothing/gloves/roguetown/fingerless

/datum/loadout_item/bandages
	name = "Bandages, Gloves"
	path = /obj/item/clothing/gloves/roguetown/bandages

/datum/loadout_item/exoticsilkbelt
	name = "Exotic Silk Belt"
	path = /obj/item/storage/belt/rogue/leather/exoticsilkbelt

/datum/loadout_item/ragmask
	name = "Rag Mask"
	path = /obj/item/clothing/mask/rogue/ragmask

/datum/loadout_item/halfmask
	name = "Halfmask"
	path = /obj/item/clothing/mask/rogue/shepherd

/datum/loadout_item/dendormask
	name = "Briar Mask"
	path = /obj/item/clothing/head/roguetown/dendormask

/datum/loadout_item/eorahood
	name = "Opera Mask - Eoran Hood"
	path = /obj/item/clothing/head/roguetown/roguehood/eorahood

/datum/loadout_item/exoticsilkmask
	name = "Exotic Silk Mask"
	path = /obj/item/clothing/mask/rogue/exoticsilkmask

/datum/loadout_item/duelmask
	name = "Duelist's Mask"
	path = /obj/item/clothing/mask/rogue/duelmask

/datum/loadout_item/pipe
	name = "Pipe"
	path = /obj/item/clothing/mask/cigarette/pipe

/datum/loadout_item/pipewestman
	name = "Westman Pipe"
	path = /obj/item/clothing/mask/cigarette/pipe/westman

/datum/loadout_item/feather
	name = "Feather"
	path = /obj/item/natural/feather

/datum/loadout_item/collar
	name = "Collar"
	path = /obj/item/clothing/neck/roguetown/collar

/datum/loadout_item/forlon_collar
	name = "Light Forlorn Collar"
	path = /obj/item/clothing/neck/roguetown/collar/forlorn

/datum/loadout_item/bell_collar
	name = "Bell Collar"
	path = /obj/item/clothing/neck/roguetown/collar/bell_collar

/datum/loadout_item/cursed_collar
	name = "Cursed Collar"
	path = /obj/item/clothing/neck/roguetown/gorget/cursed_collar

/datum/loadout_item/cloth_blindfold
	name = "Cloth Blindfold"
	path = /obj/item/clothing/mask/rogue/blindfold

/datum/loadout_item/fake_blindfold
	name = "Fake Blindfold"
	path = /obj/item/clothing/mask/rogue/blindfold/fake

/datum/loadout_item/bases
	name = "Cloth military skirt"
	path = /obj/item/storage/belt/rogue/leather/battleskirt

/datum/loadout_item/fauldedbelt
	name = "Belt with faulds"
	path = /obj/item/storage/belt/rogue/leather/battleskirt/faulds

/datum/loadout_item/psicross
	name = "Psydonian Cross"
	path = /obj/item/clothing/neck/roguetown/psicross

/datum/loadout_item/psicross/reform
	name = "Reformist Psydonian Cross"
	path = /obj/item/clothing/neck/roguetown/psicross/reform

/datum/loadout_item/psicross/astrata
	name = "Amulet of Astrata"
	path = /obj/item/clothing/neck/roguetown/psicross/astrata

/datum/loadout_item/psicross/noc
	name = "Amulet of Noc"
	path = /obj/item/clothing/neck/roguetown/psicross/noc

/datum/loadout_item/psicross/abyssor
	name = "Amulet of Abyssor"
	path = /obj/item/clothing/neck/roguetown/psicross/abyssor

/datum/loadout_item/psicross/xylix
	name = "Amulet of Xylix"
	path = /obj/item/clothing/neck/roguetown/psicross/xylix

/datum/loadout_item/psicross/dendor
	name = "Amulet of Dendor"
	path = /obj/item/clothing/neck/roguetown/psicross/dendor

/datum/loadout_item/psicross/necra
	name = "Amulet of Necra"
	path = /obj/item/clothing/neck/roguetown/psicross/necra

/datum/loadout_item/psicross/pestra
	name = "Amulet of Pestra"
	path = /obj/item/clothing/neck/roguetown/psicross/pestra

/datum/loadout_item/psicross/ravox
	name = "Amulet of Ravox"
	path = /obj/item/clothing/neck/roguetown/psicross/ravox

/datum/loadout_item/psicross/malum
	name = "Amulet of Malum"
	path = /obj/item/clothing/neck/roguetown/psicross/malum

/datum/loadout_item/psicross/eora
	name = "Amulet of Eora"
	path = /obj/item/clothing/neck/roguetown/psicross/eora

/datum/loadout_item/psicross/undivided
	name = "Amulet of Ten"
	path = /obj/item/clothing/neck/roguetown/psicross/undivided

/datum/loadout_item/psicross/zizo
	name = "Decrepit Zcross"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

/datum/loadout_item/zcross_iron
	name = "Iron Zcross"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/iron

/datum/loadout_item/psicross/matthios
	name = "Amulet of Matthios"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios

/datum/loadout_item/psicross/graggar
	name = "Amulet of Graggar"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar

/datum/loadout_item/psicross/gronnzizo
	name = "Wolf Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn

/datum/loadout_item/psicross/gronnbaotha
	name = "Leopard Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/baothagronn

/datum/loadout_item/psicross/gronnmatthios
	name = "Bear Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn

/datum/loadout_item/psicross/gronngraggar
	name = "Moose Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn

/datum/loadout_item/psicross/gronndendor
	name = "Volfskinned Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn

/datum/loadout_item/psicross/gronnabyssor
	name = "Hadal Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn

/datum/loadout_item/wedding_band
	name = "silver wedding band"
	path = /obj/item/clothing/ring/band

/datum/loadout_item/chaperon
    name = "Chaperon (Normal)"
    path = /obj/item/clothing/head/roguetown/chaperon

/datum/loadout_item/chaperon/alt
    name = "Chaperon (Alt)"
    path = /obj/item/clothing/head/roguetown/chaperon/greyscale

/datum/loadout_item/chaperon/burgher
    name = "Noble's Chaperon"
    path = /obj/item/clothing/head/roguetown/chaperon/noble

/datum/loadout_item/jesterhat
    name = "Jester's Hat"
    path = /obj/item/clothing/head/roguetown/jester

/datum/loadout_item/jestertunick
    name = "Jester's Tunick"
    path = /obj/item/clothing/suit/roguetown/shirt/jester

/datum/loadout_item/jestershoes
    name = "Jester's Shoes"
    path = /obj/item/clothing/shoes/roguetown/jester

/datum/loadout_item/cotehardie
	name = "Fitted Coat"
	path = /obj/item/clothing/cloak/cotehardie

//CAPARISONS

/datum/loadout_item/caparison
	name = "Caparison"
	path = /obj/item/caparison

/datum/loadout_item/caparison/psy
	name = "Psydonite Caparison"
	path = /obj/item/caparison/psy

/datum/loadout_item/caparison/astrata
	name = "Astratan Caparison"
	path = /obj/item/caparison/astrata

/datum/loadout_item/caparison/eora
	name = "Eoran Caparison"
	path = /obj/item/caparison/eora

//Donator Section
//All these items are stored in the donator_fluff.dm in the azure modular folder for simplicity.
//All should be subtypes of existing weapons/clothes/armor/gear, whatever, to avoid balance issues I guess. Idk, I'm not your boss.
// Please make sure to NOT create a subtype of donator_x/item unless there's a parent type, else it will show up as parent loadout datum due to the implicitly defined parent

/datum/loadout_item/donator_plex
	name = "Donator Kit - Rapier di Aliseo"
	path = /obj/item/enchantingkit/plexiant
	ckeywhitelist = list("plexiant")

/datum/loadout_item/donator_sru
	name = "Donator Kit - Emerald Dress"
	path = /obj/item/enchantingkit/srusu
	ckeywhitelist = list("cheekycrenando")

/datum/loadout_item/donator_strudel1
	name = "Donator Kit - Grenzelhoftian Mage Vest"
	path = /obj/item/enchantingkit/strudel1
	ckeywhitelist = list("toasterstrudes")

/datum/loadout_item/donator_strudel2
	name = "Donator Kit - Xylixian Fasching Leotard"
	path = /obj/item/enchantingkit/strudel2
	ckeywhitelist = list("toasterstrudes")

/datum/loadout_item/donator_bat
	name = "Donator Kit - Handcarved Harp"
	path = /obj/item/enchantingkit/bat
	ckeywhitelist = list("kitchifox")

/datum/loadout_item/donator_mansa
	name = "Donator Kit - Wortträger"
	path = /obj/item/enchantingkit/ryebread
	ckeywhitelist = list("pepperoniplayboy")	//Byond maybe doesn't like spaces. If a name has a space, do it as one continious name.

/datum/loadout_item/donator_rebel
	name = "Donator Kit - Gilded Sallet"
	path = /obj/item/enchantingkit/rebel
	ckeywhitelist = list("rebel0")

/datum/loadout_item/donator_bigfoot
	name = "Donator Kit - Gilded Knight Helm"
	path = /obj/item/enchantingkit/bigfoot
	ckeywhitelist = list("bigfoot02")

/datum/loadout_item/donator_bigfoot_axe
	name = "Donator kit - Gilded Greataxe"
	path = /obj/item/enchantingkit/bigfoot_axe
	ckeywhitelist = list("bigfoot02")

/datum/loadout_item/donator_zydrasiconocrown
	name = "Donator Kit - Iconoclast Crown"
	path = /obj/item/enchantingkit/zydrasiconocrown
	ckeywhitelist = list("1ceres")

/datum/loadout_item/donator_zydrasiconopauldrons
	name = "Donator Kit - Iconoclast Pauldrons"
	path = /obj/item/enchantingkit/zydrasiconopauldrons
	ckeywhitelist = list("1ceres")

/datum/loadout_item/donator_zydrasiconosash
	name = "Donator Kit - Iconoclast Sash"
	path = /obj/item/enchantingkit/zydrasiconosash
	ckeywhitelist = list("1ceres")

/datum/loadout_item/donator_eiren
	name = "Donator Kit - Regret"
	path = /obj/item/enchantingkit/eiren
	ckeywhitelist = list("eirenxiv")

/datum/loadout_item/donator_eiren2
	name = "Donator Kit - Lunae"
	path = /obj/item/enchantingkit/eirensabre
	ckeywhitelist = list("eirenxiv")

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

/datum/loadout_item/donator_waff
	name = "Donator Kit - Weeper's Lathe"
	path = /obj/item/enchantingkit/waff
	ckeywhitelist = list("waffai")

/datum/loadout_item/donator_inverserun
	name = "Donator Kit - Votive Thorns"
	path = /obj/item/enchantingkit/inverserun
	ckeywhitelist = list("inverserun")

/datum/loadout_item/donator_zoe
	name = "Donator Kit - Shroud of the Undermaiden"
	path = /obj/item/enchantingkit/zoe
	ckeywhitelist = list("zoetheorc")

/datum/loadout_item/donator_zoe_shovel
	name = "Donator Kit - Silence"
	path = /obj/item/enchantingkit/zoe_shovel
	ckeywhitelist = list("zoetheorc")

/datum/loadout_item/donator_willmbrink
	name = "Donator Item - Royal Gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal
	ckeywhitelist = list("willmbrink")

/datum/loadout_item/donator_willmbrink/sleeves
	name = "Donator Item - Royal Sleeves"
	path = /obj/item/clothing/wrists/roguetown/royalsleeves

/datum/loadout_item/donator_dasfox
	name = "Donator Kit - Archaic Ceremonial Valkyrhelm"
	path = /obj/item/enchantingkit/dasfox_helm
	ckeywhitelist = list("dasfox", "purplepineapple") // on request by dasfox

/datum/loadout_item/donator_dasfox/cuirass
	name = "Donator Kit - Archaic Ceremonial Cuirass"
	path = /obj/item/enchantingkit/dasfox_cuirass

/datum/loadout_item/donator_dasfox/periapt
	name = "Donator Item - Defiled Astratan Periapt"
	path = /obj/item/clothing/neck/roguetown/psicross/astrata/dasfox
	ckeywhitelist = list("dasfox")

/datum/loadout_item/donator_dasfox/lance
	name = "Donator Item - Decorated Lance"
	path = /obj/item/enchantingkit/dasfox_lance
	ckeywhitelist = list("dasfox", "cre77") // on request by dasfox

/datum/loadout_item/donator_ryan
	name = "Donator Item - Western Estates Caparison"
	path = /obj/item/caparison/ryan
	ckeywhitelist = list("ryan180602")

/datum/loadout_item/donator_ryan/psy_helm
	name = "Donator Kit - Unorthodoxist Psydonite Helm"
	path = /obj/item/enchantingkit/ryan_psyhelm

/datum/loadout_item/donator_koruu
	name = "Donator Kit - Well-Worn Bamboo Hat"
	path = /obj/item/clothing/head/roguetown/mentorhat/koruu
	ckeywhitelist = list("koruu", "painfeeler", "poots13")

/datum/loadout_item/donator_dakken
	name = "Donator Kit - Armoured Avantyne Barbute"
	path = /obj/item/enchantingkit/dakken_zizhelm
	ckeywhitelist = list("dakken12")

//////////////////
//  TRIUMPHS !  //
//////////////////

//Everything in this section costs TRI. Very rudimentary, but it should help us gradually realign some sense of value to this otherwise-neglected system.
//When it comes to equipment, avoid adding anything that an Adventurer - or non-combative Noble - couldn't spawn with, or otherwise acquire within the first dae of the week.
//If adding more items, ensure they're a Triumph-exclusive child. If they can be smelted down, reduce the sum to one ingot. If they can be sold, blacklist it from the Stockpile.

// -3 TRI Minisection.
// Nearly all characters can comfortably earn +3-5 TRI per week, assuming they sleep ever-so-often.

/datum/loadout_item/triumph_knife
	name = "Laborer's Knife (-3 TRI)"
	path = /obj/item/rogueweapon/huntingknife/throwingknife/triumph
	triumph_cost = 3

/datum/loadout_item/triumph_heavygloves
	name = "Heavy Leather Gloves (-3 TRI)"
	path = /obj/item/clothing/gloves/roguetown/angle
	triumph_cost = 3

/datum/loadout_item/triumph_heavyboots
	name = "Heavy Leather Boots (-3 TRI)"
	path = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	triumph_cost = 3

/datum/loadout_item/triumph_necklace
	name = "Golden Necklace, Ornate (-3 TRI)"
	path = /obj/item/clothing/neck/roguetown/ornateamulet/noble/triumph
	triumph_cost = 3

/datum/loadout_item/triumph_ring
	name = "Golden Ring, Ornate (-3 TRI)"
	path = /obj/item/clothing/ring/gold/triumph
	triumph_cost = 3

/datum/loadout_item/triumph_circlet
	name = "Golden Circlet, Ornate (-3 TRI)"
	path = /obj/item/clothing/head/roguetown/circlet/triumph
	triumph_cost = 3

/datum/loadout_item/triumph_weaponkitaxe
	name = "Morphing Elixir, 'Valorian Axe' (-3 TRI)"
	path = /obj/item/enchantingkit/triumph_weaponkit_axe
	triumph_cost = 3

// -5 TRI Minisection.

/datum/loadout_item/triumph_shortsatchel
	name = "Short Satchel (-5 TRI)"
	path = /obj/item/storage/backpack/rogue/satchel/short
	triumph_cost = 5

/datum/loadout_item/triumph_bedroll
	name = "Waterskin (-5 TRI)"
	path = /obj/item/reagent_containers/glass/bottle/waterskin
	triumph_cost = 5

/datum/loadout_item/triumph_messkit
	name = "Mess Kit (-5 TRI)"
	path = /obj/item/storage/gadget/messkit
	triumph_cost = 5

/datum/loadout_item/triumph_foldtable
	name = "Folding Table (-5 TRI)"
	path = /obj/structure/table/wood/folding
	triumph_cost = 5

/datum/loadout_item/triumph_bedroll
	name = "Bedroll (-5 TRI)"
	path = /obj/item/bedroll
	triumph_cost = 5

/datum/loadout_item/triumph_scabbardnoble
	name = "Decorated Scabbard, Silver (-5 TRI)"
	path = /obj/item/rogueweapon/scabbard/sword/noble
	triumph_cost = 5

/datum/loadout_item/triumph_sheathnoble
	name = "Decorated Sheath, Silver (-5 TRI)"
	path = /obj/item/rogueweapon/scabbard/sheath/noble
	triumph_cost = 5

/datum/loadout_item/triumph_psycross
	name = "Golden Psycross, Ornate (-5 TRI)"
	path = /obj/item/clothing/neck/roguetown/psicross/g/triumph
	triumph_cost = 5

/datum/loadout_item/triumph_zcross
	name = "Golden Zizote Amulet, Ornate (-5 TRI)"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/g/triumph
	triumph_cost = 5

/datum/loadout_item/triumph_astcross
	name = "Golden Astratan Amulet, Ornate (-5 TRI)"
	path = /obj/item/clothing/neck/roguetown/psicross/astrata/g/triumph
	triumph_cost = 5

/datum/loadout_item/triumph_signet
	name = "Golden Signet Ring, Ornate (-5 TRI)"
	path = /obj/item/clothing/ring/signet/triumph
	triumph_cost = 5

/datum/loadout_item/triumph_gildedshirt
	name = "Gilded Dress Shirt (-5 TRI)"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
	triumph_cost = 5

/datum/loadout_item/triumph_pristinedress
	name = "Pristine Dress (-5 TRI)"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	triumph_cost = 5

/datum/loadout_item/triumph_royalsleeves
	name = "Royal Sleeves (-5 TRI)"
	path = /obj/item/clothing/wrists/roguetown/royalsleeves
	triumph_cost = 5

/datum/loadout_item/triumph_goldhalfmask
	name = "Golden Halfmask, Ornate (-5 TRI)"
	path = /obj/item/clothing/mask/rogue/lordmask/triumph
	triumph_cost = 5

/datum/loadout_item/triumph_goldfullmask
	name = "Golden Mask, Ornate (-5 TRI)"
	path = /obj/item/clothing/mask/rogue/facemask/goldmask/triumph
	triumph_cost = 5

/datum/loadout_item/triumph_goldfullmaskc
	name = "Crestless Golden Mask, Ornate (-5 TRI)"
	path = /obj/item/clothing/mask/rogue/facemask/goldmaskc/triumph
	triumph_cost = 5

//

/datum/loadout_item/triumph_armorkit
	name = "Morphing Elixir, 'Valorian Steel Armor' (-5 TRI)"
	path = /obj/item/enchantingkit/triumph_armorkit
	triumph_cost = 5

/datum/loadout_item/triumph_weaponkittri
	name = "Morphing Elixir, 'Valorian Longsword' (-5 TRI)"
	path = /obj/item/enchantingkit/triumph_weaponkit_tri
	triumph_cost = 5

/datum/loadout_item/triumph_weaponkitwide
	name = "Morphing Elixir, 'Wideguard Longsword' (-5 TRI)"
	path = /obj/item/enchantingkit/triumph_weaponkit_wide
	triumph_cost = 5

/datum/loadout_item/triumph_weaponkitrock
	name = "Morphing Elixir, 'Rockhillian Longsword' (-5 TRI)"
	path = /obj/item/enchantingkit/triumph_weaponkit_rock
	triumph_cost = 5

/datum/loadout_item/triumph_weaponkitsabre
	name = "Morphing Elixir, 'Sabreguard Longsword' (-5 TRI)"
	path = /obj/item/enchantingkit/triumph_weaponkit_sabre
	triumph_cost = 5

/datum/loadout_item/triumph_weaponkitpsy
	name = "Morphing Elixir, 'Psycrucifix Longsword' (-5 TRI)"
	path = /obj/item/enchantingkit/triumph_weaponkit_psy
	triumph_cost = 5

// -7 TRI Minisection.

/datum/loadout_item/triumph_buttpack
	name = "Belted Satchel (-7 TRI)"
	path = /obj/item/storage/backpack/rogue/satchel/beltpack
	triumph_cost = 7

/datum/loadout_item/triumph_lunchpouch
	name = "Pouch of Luncheons (-7 TRI)"
	path = /obj/item/storage/belt/rogue/pouch/triumphlunch
	triumph_cost = 7

/datum/loadout_item/triumph_grenzhat
	name = "Grenzelhoftian Beret (-7 TRI)"
	path = /obj/item/clothing/head/roguetown/grenzelhofthat/triumph
	triumph_cost = 7

/datum/loadout_item/triumph_lordcloak
	name = "Lordly Cloak (-7 TRI)"
	path = /obj/item/clothing/cloak/lordcloak
	triumph_cost = 7

/datum/loadout_item/triumph_ladycloak
	name = "Ladylike Cloak (-7 TRI)"
	path = /obj/item/clothing/cloak/lordcloak/ladycloak
	triumph_cost = 7

/datum/loadout_item/triumph_scabbardroyal
	name = "Decorated Scabbard, Golden (-7 TRI)"
	path = /obj/item/rogueweapon/scabbard/sword/royal
	triumph_cost = 7

/datum/loadout_item/triumph_sheathroyal
	name = "Decorated Sheath, Golden (-7 TRI)"
	path = /obj/item/rogueweapon/scabbard/sheath/royal
	triumph_cost = 7

/datum/loadout_item/triumph_gdorpelring
	name = "Golden Dorpel Ring, Ornate (-7 TRI)"
	path = /obj/item/clothing/ring/diamond/triumph
	triumph_cost = 7

// Beyond.

/datum/loadout_item/triumph_buffpot
	name = "Vial of Distilled Triumphance (-70 TRI)"
	path = /obj/item/reagent_containers/glass/bottle/alchemical/tripot
	triumph_cost = 70
