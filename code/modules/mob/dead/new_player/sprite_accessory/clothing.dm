/datum/sprite_accessory/clothing
	abstract_type = /datum/sprite_accessory/clothing
	color_key_name = "Clothing"
	/// Real inventory item represented by this character preference.
	var/item_type

/datum/sprite_accessory/clothing/New()
	var/obj/item/garment = item_type
	icon = initial(garment.icon)
	icon_state = initial(garment.icon_state)
	default_colors = list(initial(garment.color) ? initial(garment.color) : "#FFFFFF")
	return ..()

/datum/sprite_accessory/clothing/underwear_bottom
	name = "Briefs"
	item_type = /obj/item/clothing/underwear/bottom

/datum/sprite_accessory/clothing/underwear_bottom/panties
	name = "Panties"
	item_type = /obj/item/clothing/underwear/bottom/panties

/datum/sprite_accessory/clothing/underwear_bottom/braies
	name = "Braies"
	item_type = /obj/item/clothing/underwear/bottom/braies

/datum/sprite_accessory/clothing/underwear_bottom/briefs_eoran
	name = "Briefs - Eoran"
	item_type = /obj/item/clothing/underwear/bottom/briefs_eoran

/datum/sprite_accessory/clothing/underwear_top
	abstract_type = /datum/sprite_accessory/clothing/underwear_top

/datum/sprite_accessory/clothing/underwear_top/bra
	name = "Bra"
	item_type = /obj/item/clothing/underwear/top/bra

/datum/sprite_accessory/clothing/undershirt
	name = "Sheer Body"
	item_type = /obj/item/clothing/undershirt

/datum/sprite_accessory/clothing/undershirt/leotard
	name = "Leotard"
	item_type = /obj/item/clothing/undershirt/leotard

/datum/sprite_accessory/clothing/undershirt/athletic_leotard
	name = "Athletic Leotard"
	item_type = /obj/item/clothing/undershirt/athletic_leotard

/datum/sprite_accessory/clothing/undershirt/solid_half
	name = "Sheer Half-Body"
	item_type = /obj/item/clothing/undershirt/solid_half

/datum/sprite_accessory/clothing/undershirt/fullbody
	name = "Full-Body Suit"
	item_type = /obj/item/clothing/undershirt/fullbody

/datum/sprite_accessory/clothing/undershirt/silk
	name = "Silk Body"
	item_type = /obj/item/clothing/undershirt/silk

/datum/sprite_accessory/clothing/undershirt/silk_half
	name = "Silk Half-Body"
	item_type = /obj/item/clothing/undershirt/silk_half

/datum/sprite_accessory/clothing/undershirt/mesh
	name = "Mesh Body"
	item_type = /obj/item/clothing/undershirt/mesh

/datum/sprite_accessory/clothing/undershirt/mesh_half
	name = "Mesh Half-Body"
	item_type = /obj/item/clothing/undershirt/mesh_half

/datum/sprite_accessory/clothing/undershirt/net
	name = "Net Body"
	item_type = /obj/item/clothing/undershirt/net

/datum/sprite_accessory/clothing/undershirt/net_half
	name = "Net Half-Body"
	item_type = /obj/item/clothing/undershirt/net_half

/datum/sprite_accessory/clothing/undershirt/bandages
	name = "Body Bandages"
	item_type = /obj/item/clothing/undershirt/bandages

/datum/sprite_accessory/clothing/armsleeves
	name = "Cloth Armsleeve"
	item_type = /obj/item/clothing/armsleeves

/datum/sprite_accessory/clothing/armsleeves/solid_half
	name = "Sheer Half-Armsleeve"
	item_type = /obj/item/clothing/armsleeves/solid_half

/datum/sprite_accessory/clothing/armsleeves/silk
	name = "Silk Armsleeve"
	item_type = /obj/item/clothing/armsleeves/silk

/datum/sprite_accessory/clothing/armsleeves/silk_half
	name = "Silk Half-Armsleeve"
	item_type = /obj/item/clothing/armsleeves/silk_half

/datum/sprite_accessory/clothing/armsleeves/mesh
	name = "Mesh Armsleeve"
	item_type = /obj/item/clothing/armsleeves/mesh

/datum/sprite_accessory/clothing/armsleeves/mesh_half
	name = "Mesh Half-Armsleeve"
	item_type = /obj/item/clothing/armsleeves/mesh_half

/datum/sprite_accessory/clothing/armsleeves/net
	name = "Net Armsleeve"
	item_type = /obj/item/clothing/armsleeves/net

/datum/sprite_accessory/clothing/armsleeves/net_half
	name = "Net Half-Armsleeve"
	item_type = /obj/item/clothing/armsleeves/net_half

/datum/sprite_accessory/clothing/earrings
	name = "Earrings (G)"
	item_type = /obj/item/earrings
	color_disabled = TRUE

/datum/sprite_accessory/clothing/earrings/silver
	name = "Earrings (S)"
	item_type = /obj/item/earrings/silver
	color_disabled = FALSE

/datum/sprite_accessory/clothing/earrings/hoop
	name = "Hoop Earrings (G)"
	item_type = /obj/item/earrings/hoop
	color_disabled = TRUE

/datum/sprite_accessory/clothing/earrings/hoop/silver
	name = "Hoop Earrings (S)"
	item_type = /obj/item/earrings/hoop/silver
	color_disabled = FALSE

/datum/sprite_accessory/clothing/earrings/stud
	name = "Stud Earrings"
	item_type = /obj/item/earrings/stud
	color_disabled = FALSE

/datum/sprite_accessory/clothing/earrings/dangle
	name = "Dangle Earrings"
	item_type = /obj/item/earrings/dangle
	color_disabled = FALSE

/datum/sprite_accessory/clothing/legwear
	abstract_type = /datum/sprite_accessory/clothing/legwear
	color_key_name = "Legwear"

/datum/sprite_accessory/clothing/legwear/stockings
	name = "Stockings"
	item_type = /obj/item/clothing/legwears

/datum/sprite_accessory/clothing/legwear/stockings/silk
	name = "Silk Stockings"
	item_type = /obj/item/clothing/legwears/silk

/datum/sprite_accessory/clothing/legwear/stockings/fishnet
	name = "Fishnet Stockings"
	item_type = /obj/item/clothing/legwears/fishnet

/datum/sprite_accessory/clothing/legwear/stockings/thigh_high
	name = "Thigh-High Stockings"
	item_type = /obj/item/clothing/legwears/thigh_high

/datum/sprite_accessory/clothing/legwear/stockings/thigh_high_silk
	name = "Thigh-High Stockings - Silk"
	item_type = /obj/item/clothing/legwears/thigh_high_silk

/datum/sprite_accessory/clothing/legwear/stockings/knee_high
	name = "Knee-High Stockings"
	item_type = /obj/item/clothing/legwears/knee_high

/datum/sprite_accessory/clothing/legwear/stockings/knee_high_silk
	name = "Knee-High Stockings - Silk"
	item_type = /obj/item/clothing/legwears/knee_high_silk

/datum/sprite_accessory/clothing/legwear/stockings/sleeve_knee_silk
	name = "Knee-High Sleeves - Silk"
	item_type = /obj/item/clothing/legwears/sleeve_knee_silk

/datum/sprite_accessory/clothing/legwear/stockings/sleeve_stir_knee_silk
	name = "Silk Knee-High Stirrup Sleeves"
	item_type = /obj/item/clothing/legwears/sleeve_stir_knee_silk

/datum/sprite_accessory/clothing/legwear/stockings/sleeve_stir_thigh_silk
	name = "Silk Thigh-High Stirrup Sleeves"
	item_type = /obj/item/clothing/legwears/sleeve_stir_thigh_silk

/datum/sprite_accessory/clothing/legwear/stockings/sleeve_stir_ankle_silk
	name = "Silk Ankle Stirrup Sleeves"
	item_type = /obj/item/clothing/legwears/sleeve_stir_ankle_silk

/datum/sprite_accessory/clothing/legwear/stockings/belted
	name = "Belted Stockings"
	item_type = /obj/item/clothing/legwears/belted

/datum/sprite_accessory/clothing/legwear/stockings/silk/belted
	name = "Silk Belted Stockings"
	item_type = /obj/item/clothing/legwears/silk/belted

/datum/sprite_accessory/clothing/legwear/stockings/stirrup
	name = "Stirrup Stockings"
	item_type = /obj/item/clothing/legwears/stirrup

/datum/sprite_accessory/clothing/legwear/stockings/silk/stirrup
	name = "Silk Stirrup Stockings"
	item_type = /obj/item/clothing/legwears/silk/stirrup

/datum/sprite_accessory/clothing/legwear/stockings/fishnet/stirrup
	name = "Fishnet Stirrup Stockings"
	item_type = /obj/item/clothing/legwears/fishnet/stirrup

/datum/sprite_accessory/clothing/legwear/stockings/thigh_high/fishnet
	name = "Fishnet Thigh-High Stockings"
	item_type = /obj/item/clothing/legwears/thigh_high/fishnet

/datum/sprite_accessory/clothing/legwear/stockings/thigh_high/crotchless
	name = "Crotchless Thigh-High Stockings"
	item_type = /obj/item/clothing/legwears/thigh_high/crotchless

/datum/sprite_accessory/clothing/legwear/stockings/thigh_high_silk/crotchless
	name = "Silk Crotchless Thigh-High Stockings"
	item_type = /obj/item/clothing/legwears/thigh_high_silk/crotchless

/datum/sprite_accessory/clothing/legwear/stockings/thigh_high/fishnet/crotchless
	name = "Fishnet Crotchless Thigh-High Stockings"
	item_type = /obj/item/clothing/legwears/thigh_high/fishnet/crotchless

/datum/sprite_accessory/clothing/legwear/stockings/tights
	name = "Tights"
	item_type = /obj/item/clothing/legwears/tights

/datum/sprite_accessory/clothing/legwear/stockings/tights/stirrup
	name = "Stirrup Tights"
	item_type = /obj/item/clothing/legwears/tights/stirrup

/datum/sprite_accessory/clothing/legwear/stockings/tights/crotchless
	name = "Crotchless Tights"
	item_type = /obj/item/clothing/legwears/tights/crotchless

/datum/sprite_accessory/clothing/legwear/stockings/tights/crotchless/stirrup
	name = "Crotchless Stirrup Tights"
	item_type = /obj/item/clothing/legwears/tights/crotchless/stirrup

/datum/sprite_accessory/clothing/legwear/stockings/low
	name = "Low Stockings"
	item_type = /obj/item/clothing/legwears/low

/datum/sprite_accessory/clothing/legwear/stockings/fishnet/low
	name = "Low Fishnet Stockings"
	item_type = /obj/item/clothing/legwears/fishnet/low

/datum/sprite_accessory/clothing/legwear/stockings/fishnet/low/stirrup
	name = "Low Fishnet Stirrup Stockings"
	item_type = /obj/item/clothing/legwears/fishnet/low/stirrup

/datum/sprite_accessory/clothing/legwear/stockings/fishnet/crotchless
	name = "Crotchless Fishnet Tights"
	item_type = /obj/item/clothing/legwears/fishnet/crotchless

/datum/sprite_accessory/clothing/legwear/stockings/fishnet/crotchless/stirrup
	name = "Crotchless Fishnet Stirrup Tights"
	item_type = /obj/item/clothing/legwears/fishnet/crotchless/stirrup
