/datum/anvil_recipe/valuables
	abstract_type = /datum/anvil_recipe/valuables
	appro_skill = /datum/skill/craft/blacksmithing
	craftdiff = SKILL_LEVEL_JOURNEYMAN // These are VALUABLES
	i_type = "Valuables"

/datum/anvil_recipe/valuables/gold
	name = "Statue, Gold"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/roguestatue/gold
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/silver
	name = "Statue, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/roguestatue/silver
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/iron
	name = "Statue, Iron"
	category = "Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/roguestatue/iron
	display_category = ITEM_CAT_DECORATION

/datum/anvil_recipe/valuables/aalloy
	name = "Statue, Decrepit" // decrepit
	category = "Decrepit Alloy"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/roguestatue/aalloy
	display_category = ITEM_CAT_DECORATION

//

/datum/anvil_recipe/valuables/silver_psycross
	name = "Silver Psycross (+1 Psycross)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/silver
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/silver_amulet_ten
	name = "Silver Amulet of Ten (+1 Any Tennite Amulet)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross) // bandaid until someone makes proper silver amulet sprites for the other Ten
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/silver/undivided
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/silver_amulet_noc
	name = "Silver Amulet of Noc (+1 Amulet of Noc)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/noc)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/silver/noc
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/silver_amulet_astrata
	name = "Silver Amulet of Astrata (+1 Amulet of Astrata)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/silver/astrata
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/silver_amulet_necra
	name = "Silver Amulet of Necra (+1 Amulet of Necra)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/necra)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/silver/necra
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_reformcross
	name = "Golden Reformist Psycross (+1 Reformist Cross)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/reform)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/reform/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_psycross
	name = "Golden Psycross (+1 Psycross)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_zcross
	name = "Golden Inverted Psycross (+1 Inverted Psycross)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/inhumen)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_cross_astrata
	name = "Golden Amulet of Astrata (+1 Astratan Amulet)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/astrata)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/astrata/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_cross_noc
	name = "Golden Amulet of Noc (+1 Noccian Amulet)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/noc)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/noc/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_cross_abyssor
	name = "Golden Amulet of Abyssor (+1 Abyssorian Amulet)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/abyssor)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/abyssor/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_cross_dendor
	name = "Golden Amulet of Dendor (+1 Dendorian Amulet)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/dendor)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/dendor/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_cross_necra
	name = "Golden Amulet of Necra (+1 Necrian Amulet)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/necra)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/necra/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_cross_pestra
	name = "Golden Amulet of Pestra (+1 Pestran Amulet)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/pestra)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/pestra/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_cross_ravox
	name = "Golden Amulet of Ravox (+1 Ravoxian Amulet)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/ravox)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/ravox/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_cross_malum
	name = "Golden Amulet of Malum (+1 Malumite Amulet)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/malum)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/malum/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_cross_eora
	name = "Golden Amulet of Eora (+1 Eoran Amulet)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/eora)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/eora/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_cross_xylix
	name = "Golden Amulet of Xylix (+1 Xylixian Amulet)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/xylix)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/xylix/g
	display_category = ITEM_CAT_VALUABLES_HOLY

/datum/anvil_recipe/valuables/gold_cross_graggar
	name = "Golden Amulet of Graggar (+1 Graggarite Amulet)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/g
	display_category = ITEM_CAT_VALUABLES_HOLY

//

/datum/anvil_recipe/valuables/noccrossaalloy
	name = "Amulet of Knowledge, Decrepit"
	category = "Decrepit Alloy"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/neck/roguetown/psicross/noc/aalloy
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 3

/datum/anvil_recipe/valuables/noccrosspaalloy
	name = "Amulet of Knowledge, Ancient"
	category = "Ancient Alloy"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/neck/roguetown/psicross/noc/paalloy
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 3

/datum/anvil_recipe/valuables/psycrossaalloy
	name = "Amulet of Psydonia, Decrepit"
	category = "Decrepit Alloy"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/neck/roguetown/psicross/aalloy
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 3

/datum/anvil_recipe/valuables/psycrosspaalloy
	name = "Amulet of Psydonia, Ancient"
	category = "Ancient Alloy"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/neck/roguetown/psicross/paalloy
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 3

/datum/anvil_recipe/valuables/zcrossaalloy
	name = "Amulet of Ascension, Decrepit"
	category = "Decrepit Alloy"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 3

/datum/anvil_recipe/valuables/zcrosspaalloy
	name = "Amulet of Ascension, Ancient"
	category = "Ancient Alloy"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/paalloy
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 3

/datum/anvil_recipe/valuables/noccrossbronze
	name = "Amulet of Knowledge, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/neck/roguetown/psicross/noc/bronze
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 2

/datum/anvil_recipe/valuables/steel
	name = "Statue, Steel"
	category = "Steel"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/roguestatue/steel
	display_category = ITEM_CAT_DECORATION

/datum/anvil_recipe/valuables/blacksteel
	name = "Statue, Blacksteel"
	category = "Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/roguestatue/blacksteel
	display_category = ITEM_CAT_DECORATION

/datum/anvil_recipe/valuables/zcross_iron
	name = "Inverted Psycross"
	category = "Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/iron
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 1

/datum/anvil_recipe/valuables/matthios
	name = "Amulets of Matthios (x2)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 3
	createditem_num = 2

/datum/anvil_recipe/valuables/gold_cross_matthios
	name = "Golden Amulet of Matthios"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/g
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 4

/datum/anvil_recipe/valuables/baotha
	name = "Amulets of Baotha (x2)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 3
	createditem_num = 2

/datum/anvil_recipe/valuables/gold_cross_baotha
	name = "Golden Amulet of Baotha"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/g
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 4

/datum/anvil_recipe/valuables/graggar
	name = "Amulet of Graggar"
	category = "Iron"
	req_bar = /obj/item/ingot/iron
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 1

/datum/anvil_recipe/valuables/undivided_cross
	name = "Amulets of Ten (x2)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/neck/roguetown/psicross/undivided
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 3
	createditem_num = 2

/datum/anvil_recipe/valuables/gold_undivided_cross
	name = "Golden Amulet of Ten"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/neck/roguetown/psicross/undivided/g
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 4

/datum/anvil_recipe/valuables/ringb
	name = "Rings, Bronze (x2)"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/ring/bronze
	display_category = ITEM_CAT_VALUABLES_RINGS
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/psicrossbronze
	name = "Amulet of Psydonia, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/neck/roguetown/psicross/bronze
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 2

/datum/anvil_recipe/valuables/zcrossbronze
	name = "Amulet of Ascension, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/bronze
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 2

/datum/anvil_recipe/valuables/astcrossbronze
	name = "Amulet of Order, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/neck/roguetown/psicross/astrata/bronze
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 2

/datum/anvil_recipe/valuables/ravoxbronze
	name = "Amulet of Justice, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/neck/roguetown/psicross/ravox/bronze
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 2

/datum/anvil_recipe/valuables/graggarbronze
	name = "Amulet of Violence, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 2

/datum/anvil_recipe/valuables/malumcrossbronze
	name = "Amulet of Creation, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/neck/roguetown/psicross/malum/bronze
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 2

/datum/anvil_recipe/valuables/noccrossbronze
	name = "Amulet of Knowledge, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/neck/roguetown/psicross/noc/bronze
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = 2

/datum/anvil_recipe/valuables/statuebronze
	name = "Statue, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/roguestatue/bronze
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/ringg
	name = "Rings, Gold (x3)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/ring/gold
	display_category = ITEM_CAT_VALUABLES_RINGS
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 3

/datum/anvil_recipe/valuables/ringa
	name = "Rings, Decrepit (x3)"
	category = "Decrepit Alloy"
	req_bar = /obj/item/ingot/aalloy
	created_item = /obj/item/clothing/ring/aalloy
	display_category = ITEM_CAT_VALUABLES_RINGS
	createditem_num = 3

/datum/anvil_recipe/valuables/rings
	name = "Rings, Silver (x3)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/clothing/ring/silver
	display_category = ITEM_CAT_VALUABLES_RINGS
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 3

/datum/anvil_recipe/valuables/ringbs
	name = "Rings, Blacksteel (x3)"
	category = "Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	created_item = /obj/item/clothing/ring/blacksteel
	display_category = ITEM_CAT_VALUABLES_RINGS
	createditem_num = 3

/datum/anvil_recipe/valuables/weddingrings
	name = "Weddingbands, Silver (x2)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/clothing/ring/band
	display_category = ITEM_CAT_VALUABLES_RINGS
	createditem_num = 2

/datum/anvil_recipe/valuables/weddingringg
	name = "Weddingbands, Gold (x2)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/ring/band/gold
	display_category = ITEM_CAT_VALUABLES_RINGS
	createditem_num = 2

/datum/anvil_recipe/valuables/weddingringb
	name = "Weddingbands, Bronze (x2)"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/clothing/ring/band/bronze
	display_category = ITEM_CAT_VALUABLES_RINGS
	createditem_num = 2

/datum/anvil_recipe/valuables/weddingringp
	name = "Weddingbands, Ancient (x2)"
	category = "Ancient Alloy"
	req_bar = /obj/item/ingot/purifiedaalloy
	created_item = /obj/item/clothing/ring/band/paalloy
	display_category = ITEM_CAT_VALUABLES_RINGS
	createditem_num = 2

/datum/anvil_recipe/valuables/ornateamulet
	name = "Ornate Amulet"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/neck/roguetown/ornateamulet
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/skullamulet
	name = "Skull Amulet"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/neck/roguetown/skullamulet
	display_category = ITEM_CAT_VALUABLES_HOLY
	craftdiff = SKILL_LEVEL_EXPERT

//Gold Rings
/datum/anvil_recipe/valuables/emeringg
	name = "Gemerald Ring, Gold (+1 Gemerald)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/green)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/ring/emerald
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/rubyg
	name = "Rontz Ring, Gold (+1 Rontz)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	additional_items = list(/obj/item/roguegem/ruby)
	created_item = /obj/item/clothing/ring/ruby
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/topazg
	name = "Toper Ring, Gold (+1 Toper)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	additional_items = list(/obj/item/roguegem/yellow)
	created_item = /obj/item/clothing/ring/topaz
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/quartzg
	name = "Blortz Ring, Gold (+1 Blortz)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	additional_items = list(/obj/item/roguegem/blue)
	created_item = /obj/item/clothing/ring/quartz
	display_category = ITEM_CAT_VALUABLES_RINGS
	i_type = "Valuables"

/datum/anvil_recipe/valuables/sapphireg
	name = "Saffira Ring, Gold (+1 Saffira)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	additional_items = list(/obj/item/roguegem/violet)
	created_item = /obj/item/clothing/ring/sapphire
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/diamondg
	name = "Dorpel Ring, Gold (+1 Dorpel)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	additional_items = list(/obj/item/roguegem/diamond)
	created_item = /obj/item/clothing/ring/diamond
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/signet
	name = "Signet Ring, Gold"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/ring/signet
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/signet/silver
	name = "Signet Ring, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_EXPERT
	display_category = ITEM_CAT_VALUABLES_RINGS
	created_item = /obj/item/clothing/ring/signet/silver

/datum/anvil_recipe/valuables/signet/psy
	name = "Psydonian Signet Ring, Blessed Silver"
	category = "Blessed Silver"
	craftdiff = SKILL_LEVEL_MASTER
	req_bar = /obj/item/ingot/silverblessed
	display_category = ITEM_CAT_VALUABLES_RINGS
	created_item = /obj/item/clothing/ring/signet/psy

/datum/anvil_recipe/valuables/signet/psy/inq
	name = "Psydonian Signet Ring, Blessed Silver"
	category = "Blessed Silver"
	craftdiff = SKILL_LEVEL_MASTER
	req_bar = /obj/item/ingot/silverblessed/bullion
	display_category = ITEM_CAT_VALUABLES_RINGS
	created_item = /obj/item/clothing/ring/signet/psy

/datum/anvil_recipe/valuables/signet/psy/gold
	name = "Psydonian Signet Ring, Gold"
	category = "Gold"
	craftdiff = SKILL_LEVEL_EXPERT
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/clothing/ring/signet/psy/g

/datum/anvil_recipe/valuables/duelring
	name = "Duelist's Rings (x2) (+1 Rosestone Ring)"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/clothing/ring/rose)
	craftdiff = SKILL_LEVEL_MASTER
	created_item = /obj/item/clothing/ring/duelist
	display_category = ITEM_CAT_VALUABLES_RINGS
	createditem_num = 2

// Silver ingots are now in play, and as such, the steel rings have been converted to silver with their value adjusted accordingly. -Kyogon

/datum/anvil_recipe/valuables/emerings
	name = "Gemerald Ring, Silver (+1 Gemerald)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/green)
	created_item = /obj/item/clothing/ring/emeralds
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/rubys
	name = "Rontz Ring, Silver (+1 Rontz)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/ruby)
	created_item = /obj/item/clothing/ring/rubys
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/topazs
	name = "Toper Ring, Silver (+1 Toper)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/yellow)
	created_item = /obj/item/clothing/ring/topazs
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/quartzs
	name = "Blortz Ring, Silver (+1 Blortz)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/blue)
	created_item = /obj/item/clothing/ring/quartzs
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/sapphires
	name = "Saffira Ring, Silver (+1 Saffira)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/violet)
	created_item = /obj/item/clothing/ring/sapphires
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/diamonds
	name = "Dorpel Ring, Silver (+1 Dorpel)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	craftdiff = SKILL_LEVEL_MASTER
	additional_items = list(/obj/item/roguegem/diamond)
	created_item = /obj/item/clothing/ring/diamonds
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/terminus
	name = "Terminus Est (+1 Gold Bar, +1 Steel, +1 Rontz)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold, /obj/item/ingot/steel, /obj/item/roguegem/ruby)
	created_item = /obj/item/rogueweapon/sword/long/exe/cloth
	display_category = ITEM_CAT_WEAPONS_SWORDS
	craftdiff = SKILL_LEVEL_MASTER
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"

/datum/anvil_recipe/valuables/dragon
	name = "Dragonstone Ring (Secret!)"
	category = "Blacksteel"
	req_bar = /obj/item/ingot/blacksteel
	hides_from_books = TRUE //New variable, which should make the full recipe unviewable through the Blacksmith's crafting books. Should only be placed on crafting recipes with 'Secret!' in the name.
	additional_items = list(/obj/item/ingot/gold, /obj/item/roguegem/blue, /obj/item/roguegem/violet, /obj/item/clothing/neck/roguetown/psicross/silver)
	created_item = /obj/item/clothing/ring/dragon_ring
	display_category = ITEM_CAT_VALUABLES_RINGS
	craftdiff = SKILL_LEVEL_LEGENDARY
	bypass_dupe_test = TRUE // Transmutation into draconic ingot is fine.

/datum/anvil_recipe/valuables/hope
	name = "Ring Of Omnipotence (Secret!)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	hides_from_books = TRUE //'Secret!' items should be stronger but harder to make. Likewise, it should be inherently difficult to figure out how to craft them, unless you've found special info-giving items.
	additional_items = list(/obj/item/clothing/ring/statgemerald, /obj/item/clothing/ring/statonyx, /obj/item/clothing/ring/statamythortz, /obj/item/clothing/ring/statrontz)
	created_item = /obj/item/clothing/ring/statdorpel
	display_category = ITEM_CAT_VALUABLES_RINGS
	craftdiff = SKILL_LEVEL_LEGENDARY
	bypass_dupe_test = TRUE // Transmutation into riddle of steel is fine if you smelt this.

//

/datum/anvil_recipe/valuables/anointedberserksword
	name = "Anointed Berserkers Sword (Secret!)"
	category = "Glutcrystal"
	req_bar = /obj/item/ingot/component/glutcrystal
	hides_from_books = TRUE
	additional_items = list(/obj/item/rogueweapon/sword/long/exe/berserk)
	created_item = /obj/item/rogueweapon/sword/long/exe/berserk/gnoll
	display_category = ITEM_CAT_WEAPONS_SWORDS
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	craftdiff = SKILL_LEVEL_LEGENDARY
	bypass_dupe_test = TRUE // Smelting into a greatsword is fine.

/obj/item/rogueweapon/sword/long/exe/berserk/gnoll
	name = "anointed berserkers sword"
	desc = "A raw heap of iron, hewn into an intimidatingly massive cleaver. Most could never aspire to effectively swing such a laborsome blade about; those few that have the strength, however, can force even the strongest opponents to stagger back. </br>The thrummage of your heart matches the otherworldly aura that has overtaken this blade. Someone's smiling down upon you, but it certainly isn't who you think it is."
	max_blade_int = 666

/obj/item/rogueweapon/sword/long/exe/berserk/gnoll/Initialize(mapload)
	..()
	add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_VAMPIRIC, "alpha" = 188, "size" = 1))

//

/datum/anvil_recipe/valuables/daemonslayer
	name = "Daemonslayer (Secret!)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	hides_from_books = TRUE //Note to self - adding more than five additional items to a crafting recipe might result in unintended consequences.
	additional_items = list(/obj/item/rogueweapon/sword/long/exe/berserk/gnoll, /obj/item/rogueweapon/greatsword/paalloy, /obj/item/ingot/draconic, /obj/item/ingot/weeping, /obj/item/riddleofsteel)
	created_item = /obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer
	display_category = ITEM_CAT_WEAPONS_SWORDS
	appro_skill = /datum/skill/craft/weaponsmithing
	i_type = "Weapons"
	craftdiff = SKILL_LEVEL_LEGENDARY
	bypass_dupe_test = TRUE


// FORGEABLES BABEY!!!


// GOLD

/datum/anvil_recipe/valuables/gold/ashtray
	name = "Zigtray, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/ashtray
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 2

/datum/anvil_recipe/valuables/gold/urn
	name = "Urn, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/urn
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/gold/canister
	name =	"Canister, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/canister
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/gold/bust
	name = "Bust, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/bust
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/gold/obelisk
	name = "Obelisk, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/obelisk
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/gold/figurine
	name = "Figurine, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/figurine
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 2

/datum/anvil_recipe/valuables/gold/saiga
	name = "Saiga Figurine, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/saiga
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 2

/datum/anvil_recipe/valuables/gold/insect
	name = "Insect Charm, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/bug
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 2

/datum/anvil_recipe/valuables/gold/cameo
	name = "Cameo, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/cameo
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 2

/datum/anvil_recipe/valuables/gold/duck
	name = "Duck, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/duck
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 2

/datum/anvil_recipe/valuables/gold/fish
	name = "Fish Figurine, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/fish
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 2

/datum/anvil_recipe/valuables/gold/comb
	name = "Comb, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/comb
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 2

/datum/anvil_recipe/valuables/gold/talisman
	name = "Talisman, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/talisman
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT
	createditem_num = 2

/datum/anvil_recipe/valuables/gold/caryatid
	name = "Caryatid, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/caryatid
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/gold/vase
	name = "Vase, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/vase
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/gold/scale
	name = "Scale, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/scale
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/gold/bigurns
	name = "Large Urn, Golden (+1 Gold)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/ingot/gold)
	created_item = /obj/item/forgeable/gold/bigurn
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/gold/tablet
	name = "Tablet, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/tablet
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

/datum/anvil_recipe/valuables/gold/totem
	name = "Totem, Golden"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	created_item = /obj/item/forgeable/gold/totem
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_EXPERT

//SILVER

/datum/anvil_recipe/valuables/silver/ashtray
	name = "Zigtray, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/ashtray
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/silver/urn
	name = "Urn, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/urn
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/silver/canister
	name =	"Canister, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/canister
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/silver/bust
	name = "Bust, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/bust
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/silver/obelisk
	name = "Obelisk, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/obelisk
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/silver/figurine
	name = "Figurine, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/figurine
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/silver/saiga
	name = "Saiga Figurine, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/saiga
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/silver/insect
	name = "Insect Charm, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/bug
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/silver/cameo
	name = "Cameo, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/cameo
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/silver/duck
	name = "Duck, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/duck
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/silver/fish
	name = "Fish Figurine, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/fish
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/silver/comb
	name = "Comb, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/comb
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/silver/talisman
	name = "Talisman, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/talisman
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/silver/caryatid
	name = "Caryatid, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/caryatid
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/silver/vase
	name = "Vase, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/vase
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/silver/scale
	name = "Scale, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/scale
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/silver/bigurns
	name = "Large Urn, Silver (+1 Silver)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver)
	created_item = /obj/item/forgeable/silver/bigurn
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/silver/tablet
	name = "Tablet, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/tablet
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/silver/totem
	name = "Totem, Silver"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/forgeable/silver/totem
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

// BRONZE

/datum/anvil_recipe/valuables/bronze/ashtray
	name = "Zigtray, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/ashtray
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/bronze/urn
	name = "Urn, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/urn
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/bronze/canister
	name =	"Canister, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/canister
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/bronze/bust
	name = "Bust, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/bust
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/bronze/obelisk
	name = "Obelisk, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/obelisk
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/bronze/figurine
	name = "Figurine, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/figurine
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/bronze/saiga
	name = "Saiga Figurine, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/saiga
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/bronze/insect
	name = "Insect Charm, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/bug
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/bronze/cameo
	name = "Cameo, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/cameo
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/bronze/duck
	name = "Duck, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/duck
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/bronze/fish
	name = "Fish Figurine, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/fish
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/bronze/comb
	name = "Comb, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/comb
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/bronze/talisman
	name = "Talisman, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/talisman
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	createditem_num = 2

/datum/anvil_recipe/valuables/bronze/caryatid
	name = "Caryatid, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/caryatid
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/bronze/vase
	name = "Vase, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/vase
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/bronze/scale
	name = "Scale, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/scale
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/bronze/bigurns
	name = "Large Urn, Bronze (+1 Bronze)"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	additional_items = list(/obj/item/ingot/bronze)
	created_item = /obj/item/forgeable/bronze/bigurn
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/bronze/tablet
	name = "Tablet, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/tablet
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

/datum/anvil_recipe/valuables/bronze/totem
	name = "Totem, Bronze"
	category = "Bronze"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/forgeable/bronze/totem
	display_category = ITEM_CAT_DECORATION
	craftdiff = SKILL_LEVEL_JOURNEYMAN

// Golden amulets

/datum/anvil_recipe/valuables/goldamber
	name = "Amber Amulet, Gold (+1 Amber)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/amber)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/goldamber
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/goldonyxa
	name = "Onyxa Amulet, Gold (+1 Onyxa)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/onyxa)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/goldonyxa
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/goldjade
	name = "Jade Amulet, Gold (+1 Jade)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/jade)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/goldjade
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/goldrose
	name = "Rosestone Amulet, Gold (+1 Rosestone)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/carvedgem/rose/rawrose)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/goldrose
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/goldshell
	name = "Shell Amulet, Gold (+1 Clam Shell)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/carvedgem/shell/rawshell)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/goldshell
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/goldcoral
	name = "Heartstone Amulet, Gold (+1 Heartstone)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/coral)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/goldcoral
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/goldopal
	name = "Opal Amulet, Gold (+1 Opal)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/opal)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/goldopal
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/goldturq
	name = "Cerulite Amulet, Gold (+1 Cerulite)"
	category = "Gold"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/roguegem/turq)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/goldturq
	display_category = ITEM_CAT_VALUABLES_RINGS

// Silver Amulets

/datum/anvil_recipe/valuables/silveramber
	name = "Amber Amulet, Silver (+1 Amber)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/roguegem/amber)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/silveramber
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/silveronyxa
	name = "Onyxa Amulet, Silver (+1 Onyxa)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/roguegem/onyxa)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/silveronyxa
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/silverjade
	name = "Jade Amulet, Silver (+1 Jade)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/roguegem/jade)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/silverjade
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/silverrose
	name = "Rosestone Amulet, Silver (+1 Rosestone)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/carvedgem/rose/rawrose)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/silverrose
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/silvershell
	name = "Shell Amulet, Silver (+1 Clam Shell)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/carvedgem/shell/rawshell)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/silvershell
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/silvercoral
	name = "Heartstone Amulet, Silver (+1 Heartstone)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/roguegem/coral)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/silvercoral
	display_category = ITEM_CAT_VALUABLES_RINGS
a
/datum/anvil_recipe/valuables/silveropal
	name = "Opal Amulet, Silver (+1 Opal)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/roguegem/opal)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/silveropal
	display_category = ITEM_CAT_VALUABLES_RINGS

/datum/anvil_recipe/valuables/silverturq
	name = "Cerulite Amulet, Silver (+1 Cerulite)"
	category = "Silver"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/roguegem/turq)
	craftdiff = SKILL_LEVEL_EXPERT
	created_item = /obj/item/clothing/neck/roguetown/carved/silverturq
	display_category = ITEM_CAT_VALUABLES_RINGS
