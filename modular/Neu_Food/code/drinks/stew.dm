/*	........   Reagents   ................ */// These are for the pot, if more vegetables are added and need to be integrated into the pot brewing you need to add them here
/datum/reagent/consumable/soup // so you get hydrated without the flavor system messing it up. Works like water with less hydration
	var/hydration = 6
/datum/reagent/consumable/soup/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
			H.adjust_hydration(hydration)
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+10, BLOOD_VOLUME_NORMAL)
	..()

/datum/reagent/consumable/soup/porridge
	name = "porridge"
	description = "Softened grain boiled in water. Suitable for peasants."
	reagent_state = LIQUID
	color = "#F8F0E3"
	nutriment_factor = 15
	metabolization_rate = 0.5 // half as fast as normal, last twice as long
	taste_description = "porridge"
	taste_mult = 3
	hydration = 2

/datum/reagent/consumable/soup/porridge/oatmeal
	name = "oatmeal"
	description = "Fitting for a peasant."
	taste_description = "oatmeal"
	color = "#c38553"

/datum/reagent/consumable/soup/porridge/thick
	name = "thick porridge"
	description = "Fitting for a yeoman."
	taste_description = "thickened porridge"
	color = "#9E6B43"
	nutriment_factor = 25
	alpha = 200

/datum/reagent/consumable/soup/porridge/pudding
	name = "berried porridge-pudding"
	description = "Fitting for a nobleman."
	taste_description = "spongey-sweet doughiness with caramelized berries"
	color = "#8E4074"
	nutriment_factor = 30
	metabolization_rate = 0.8
	alpha = 222
	quality = DRINK_GOOD

/datum/reagent/consumable/soup/porridge/thickpudding
	name = "thick berried porridge-pudding"
	description = "Fitting for a king."
	taste_description = "spongey-sweet doughiness, caramelized berries, and a hint of fragrance"
	color = "#8C1564"
	nutriment_factor = 35
	metabolization_rate = 0.6
	alpha = 222
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/soup/porridge/frostedpudding
	name = "frosted porridge-pudding"
	description = "Fitting for a nobleman."
	taste_description = "spongey-sweet doughiness and velvety frosting"
	color = "#8C88C6"
	nutriment_factor = 35
	metabolization_rate = 0.8
	alpha = 222
	quality = DRINK_GOOD

/datum/reagent/consumable/soup/porridge/thickfrostedpudding
	name = "thick frosted porridge-pudding"
	description = "Fitting for a king."
	taste_description = "spongey-sweet doughiness, velvety frosting, and a hint of fruitiness"
	color = "#604E8E"
	nutriment_factor = 40
	metabolization_rate = 0.6
	alpha = 222
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/soup/porridge/poisonfrostedpudding //Evil variant for poisoned jackberry treats.
	name = "frosted porridge-pudding"
	description = "Fitting for a nobleman."
	taste_description = "spongey-sweet doughiness and bitter-tasting frosting"
	color = "#8C88C6"
	nutriment_factor = 35
	metabolization_rate = 0.8
	alpha = 222
	quality = DRINK_GOOD

/datum/reagent/consumable/soup/porridge/thickpoisonfrostedpudding //Ditto.
	name = "thick frosted porridge-pudding"
	description = "Fitting for a king."
	taste_description = "spongey-sweet doughiness, bitter-tasting frosting, and a hint of burning"
	color = "#604E8E"
	nutriment_factor = 40
	metabolization_rate = 0.6
	alpha = 222
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/soup/porridge/fudgepudding
	name = "chocolate porridge-pudding"
	description = "Fitting for a nobleman."
	taste_description = "spongey-sweet doughiness and creamy fudge"
	color = "#6B4A51"
	nutriment_factor = 35
	metabolization_rate = 0.8
	alpha = 222
	quality = DRINK_GOOD

/datum/reagent/consumable/soup/porridge/thickfudgepudding
	name = "thick chocolate porridge-pudding"
	description = "Fitting for a king."
	taste_description = "spongey-sweet doughiness, creamy fudge, and a hint of herbiness"
	color = "#44242A"
	nutriment_factor = 40
	metabolization_rate = 0.6
	alpha = 222
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/soup/porridge/congee
	name = "congee"
	description = "Rice boiled in water until it is softened. Eaten by the poor and sick in the east. Here, it is considered a medicinal food."
	color = "#F8F0E3"

/datum/reagent/consumable/soup/porridge/frycongee
	name = "fried congee"
	description = "Boiled rice that's been lightly fried inside of a pot. Perplexingly soft for a fried foodstuff, but a little more filling."
	color = "#F7E2C0"
	nutriment_factor = 20
	alpha = 200

/datum/reagent/consumable/soup/veggie
	name = "vegetable soup"
	description = "Boiled, mashed, and stuck in a stew."
	reagent_state = LIQUID
	nutriment_factor = 10
	taste_mult = 4
	hydration = 8

/datum/reagent/consumable/soup/veggie/potato
	name = "potato soup"
	color = "#869256"
	taste_description = "potato broth"

/datum/reagent/consumable/soup/veggie/thickpotato
	name = "thick potato soup"
	color = "#AE9256"
	taste_description = "creamy potato broth"
	nutriment_factor = 15
	metabolization_rate = 0.8
	alpha = 200

/datum/reagent/consumable/soup/veggie/thickfrypotato
	name = "roasted potato soup"
	color = "#968563"
	taste_description = "deliciously creamy potatoes within a thick, buttery broth"
	nutriment_factor = 20
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/veggie/onion
	name = "onion soup"
	color = "#a6b457"
	taste_description = "boiled onions"

/datum/reagent/consumable/soup/veggie/thickonion
	name = "thick onion soup"
	color = "#96924F"
	taste_description = "savory onions"
	nutriment_factor = 15
	metabolization_rate = 0.8
	alpha = 200

/datum/reagent/consumable/soup/veggie/thickfryonion
	name = "roasted onion soup"
	color = "#B29252"
	taste_description = "deliciously soft onions within a rich, light broth"
	nutriment_factor = 20
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/veggie/cabbage
	name = "cabbage soup"
	color = "#859e56"
	taste_description = "boiled cabbage"

/datum/reagent/consumable/soup/veggie/thickcabbage
	name = "thick cabbage soup"
	color = "#687A43"
	taste_description = "savory cabbage"
	nutriment_factor = 15
	metabolization_rate = 0.8
	alpha = 200

/datum/reagent/consumable/soup/veggie/thickfrycabbage
	name = "roasted cabbage soup"
	color = "#685D34"
	taste_description = "deliciously rich cabbage within a savory broth"
	nutriment_factor = 15
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/veggie/turnip
	name = "turnip soup"
	color = "#becf9d"
	taste_description = "boiled turnips"

/datum/reagent/consumable/soup/veggie/thickturnip
	name = "thick turnip soup"
	color = "#AFCE71"
	taste_description = "savory turnips"
	nutriment_factor = 15
	metabolization_rate = 0.8
	alpha = 200

/datum/reagent/consumable/soup/purebutter
	name = "pure butter"
	color = "#FFE88F"
	taste_description = "disgustingly rich butter and a violent rumbling of the humors"
	hydration = 1
	nutriment_factor = 40
	metabolization_rate = 4
	alpha = 222

/datum/reagent/consumable/soup/lemon
	name = "juice of lemon"
	color = "#FFE88F"
	taste_description = "puckeringly bright lemoniness"
	hydration = 8
	nutriment_factor = 8
	metabolization_rate = 1.2
	quality = DRINK_NICE

/datum/reagent/consumable/soup/lime
	name = "juice of lime"
	color = "#BAE88F"
	taste_description = "puckeringly bright limeyness"
	hydration = 8
	nutriment_factor = 8
	metabolization_rate = 1.2
	quality = DRINK_NICE

/datum/reagent/consumable/soup/pear
	name = "juice of pear"
	color = "#BAAE8F"
	taste_description = "pleasantly crisp peariness"
	hydration = 8
	nutriment_factor = 8
	metabolization_rate = 1.2
	quality = DRINK_NICE

/datum/reagent/consumable/soup/apple
	name = "juice of apple"
	color = "#E0BE6D"
	taste_description = "pleasantly crisp appleness"
	hydration = 8
	nutriment_factor = 8
	metabolization_rate = 1.2
	quality = DRINK_NICE

/datum/reagent/consumable/soup/tangerine_marmalade
	name = "juice of tangerine"
	color = "#f0935d"
	taste_description = "extremely sweet tangerines"
	hydration = 8
	nutriment_factor = 8
	metabolization_rate = 1.2
	quality = DRINK_NICE

/datum/reagent/consumable/soup/bone_broth
	name = "bone broth"
	color = "#7F6556"
	taste_description = "nurturing warmth"
	nutriment_factor = 10
	hydration = 10
	metabolization_rate = 0.6

//

/datum/reagent/consumable/soup/stew
	name = "thick stew"
	description = "All manners of edible bits went into this."
	reagent_state = LIQUID
	nutriment_factor = 20
	taste_mult = 4

/datum/reagent/consumable/soup/stew/hardtack
	name = "hardtack stew"
	description = "Fitting for a soldier."
	taste_description = "salted porridge with softened flakes of crispiness"
	color = "#9E6B43"
	nutriment_factor = 15
	alpha = 200

/datum/reagent/consumable/soup/stew/hardtacksalo
	name = "balefire stew"
	description = "Fitting for an adventurer."
	taste_description = "salted porridge, crispy meat, and a remarkably fatty broth"
	color = "#9E4643"
	nutriment_factor = 15
	metabolization_rate = 0.4 //Lowest nutriment factor for stew, but sticks to your guts like proper comfort food.
	alpha = 220

/datum/reagent/consumable/soup/stew/thickhardtacksalo
	name = "thick balefire stew"
	description = "Fitting for a legend."
	taste_description = "thickly salted porridge, crispy meat, a fatty broth, and a lingering warmth in the gullet"
	color = "#7A3534"
	nutriment_factor = 20
	metabolization_rate = 0.4 //Lowest nutriment factor for stew, but sticks to your guts like proper comfort food.
	alpha = 220

/datum/reagent/consumable/soup/stew/egg
	name = "egg drop soup"
	color = "#dedbaf"
	taste_description = "egg soup"

/datum/reagent/consumable/soup/stew/fryegg
	name = "custardy egg drop soup"
	color = "#DDC689"
	taste_description = "creamy egg soup"
	nutriment_factor = 30
	metabolization_rate = 1.2 //A little quicker, for breakfast!

/datum/reagent/consumable/soup/stew/thickfryegg
	name = "scrambled cacklehash stew"
	color = "#B78F71"
	taste_description = "creamy eggs with chunks of crispy meat"
	nutriment_factor = 35
	metabolization_rate = 1.2 //A little quicker, for breakfast!
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/lavishfryegg
	name = "lavish cacklehash stew"
	color = "#B5934A"
	taste_description = "sumptuously creamy eggs, chunks of crispy meat, and cheesy goodness"
	nutriment_factor = 40
	metabolization_rate = 1.2 //A little quicker, for breakfast!
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/cheese
	name = "cheese soup"
	description = "A thick cheese soup. Creamy and comforting."
	color = "#c4be70"
	taste_description = "creamy cheese"

/datum/reagent/consumable/soup/stew/thickcheese
	name = "fondue"
	description = "A ridiculously thick cheese soup. Creamy, comforting, and decadant."
	color = "#c4be70"
	taste_description = "velvety cheese"
	nutriment_factor = 30 //You're throwing an entire wheel of cheese into this thing. It'd be criminal if you didn't get something in return!
	metabolization_rate = 0.6
	quality = DRINK_GOOD
	alpha = 222

/datum/reagent/consumable/soup/stew/parmesan
	name = "aged cheese soup"
	description = "A thick aged cheese soup. Creamy and comforting."
	color = "#A8AA70"
	taste_description = "creamy aged cheese"
	metabolization_rate = 0.8

/datum/reagent/consumable/soup/stew/thickparmesan
	name = "aged fondue"
	description = "A ridiculously thick aged cheese soup. Creamy, comforting, and decadant."
	color = "#A8AA70"
	taste_description = "velvety aged cheese"
	metabolization_rate = 0.6
	nutriment_factor = 40
	quality = DRINK_VERYGOOD
	alpha = 222

/datum/reagent/consumable/soup/stew/chicken
	name = "chicken stew"
	color = "#baa21c"
	taste_description = "chicken"

/datum/reagent/consumable/soup/stew/thickchicken
	name = "thick chicken stew"
	color = "#BA841C"
	taste_description = "savory chicken"
	nutriment_factor = 30

/datum/reagent/consumable/soup/stew/bakedchicken
	name = "frybird stew"
	color = "#A0781C"
	taste_description = "savory chicken with flakes of crispy skin"
	metabolization_rate = 0.8
	quality = DRINK_NICE

/datum/reagent/consumable/soup/stew/bakedthickchicken
	name = "thick frybird stew"
	color = "#8F6119"
	taste_description = "tender chicken with flakes of crispy skin"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/veggiethickchicken
	name = "frybird stew with vegetables"
	color = "#8F6916"
	taste_description = "savory chicken with slow-roasted vegetables, flakes of crispy skin, and a sense of lingering warmth"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/pepperchicken
	name = "pepper-spiced frybird stew"
	color = "#A0421C"
	taste_description = "deliciously tender chicken with flakes of crispy skin, and a hint of tongue-tickling spice"
	nutriment_factor = 35
	metabolization_rate = 0.8
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/lavishchicken
	name = "lavish frybird stew"
	color = "#A0421C"
	taste_description = "sumptuously tender chicken with flakes of crispy skin, buttery richness, and a hint of tongue-tickling spice"
	nutriment_factor = 40
	metabolization_rate = 0.6
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/meat
	name = "meat stew"
	color = "#80432a"
	taste_description = "meat"

/datum/reagent/consumable/soup/stew/frymeat
	name = "brisket stew"
	color = "#7F3518"
	taste_description = "slow-roasted meat"
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/veggiefrymeat
	name = "brisket stew with vegetables"
	color = "#633012"
	taste_description = "savory meat with slow-roasted vegetables, with a refreshingly rich aftertaste"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/pepperfrymeat
	name = "pepper-spiced brisket stew"
	color = "#892214"
	taste_description = "deliciously tender meat, and a hint of tongue-tickling spice"
	nutriment_factor = 35
	metabolization_rate = 0.8
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/lavishfrymeat
	name = "lavish brisket stew"
	color = "#722616"
	taste_description = "sumptuously tender meat, a rich and savory broth, and a hint of tongue-tickling spice"
	nutriment_factor = 40
	metabolization_rate = 0.6
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/pork
	name = "fatty meat stew"
	color = "#80432a"
	taste_description = "soft and savory pork"

/datum/reagent/consumable/soup/stew/thickpork
	name = "fatty brisket stew"
	color = "#7F3518"
	taste_description = "slow-roasted pork"
	metabolization_rate = 0.8

/datum/reagent/consumable/soup/stew/frypork
	name = "crispy and fatty meaty stew"
	color = "#633012"
	taste_description = "savory pork with flakes of crispiness"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/thickfrypork
	name = "crispy and fatty brisket stew"
	color = "#892214"
	taste_description = "tongue-meltingly soft pork with flakes of crispiness"
	nutriment_factor = 35
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/viscera_broth
	name = "offal stew"
	color = "#B65571"
	taste_description = "overpoweringly strange-tasting, with a mildly savory aftertaste"
	nutriment_factor = 15

/datum/reagent/consumable/soup/stew/slop
	name = "slop"
	color = "#18130E"
	taste_description = "charred giblets with a gravely aftertaste, and just a pinch of regret"
	nutriment_factor = 10

/datum/reagent/consumable/soup/stew/fish
	name = "fish stew"
	color = "#c7816e"
	taste_description = "fish"

/datum/reagent/consumable/soup/stew/fryfish
	name = "roasted fish stew"
	color = "#C6725D"
	taste_description = "flaky fish in a gently creamy broth"
	nutriment_factor = 25
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/veggiefryfish
	name = "roasted fish stew with vegetables"
	color = "#C67C78"
	taste_description = "flaky fish and slow-roasted vegetables in a gently creamy broth"
	nutriment_factor = 30
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/pepperfryfish
	name = "pepper-spiced fish stew"
	color = "#C65D5D"
	taste_description = "flaky fish in a sharp, creamy broth with tongue-tingling spices"
	nutriment_factor = 35
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/lavishfryfish
	name = "lavish fish stew"
	color = "#C17070"
	taste_description = "sumptuously flaky fish in a rich, creamy broth with subtle notes of sweetness"
	nutriment_factor = 40
	metabolization_rate = 0.8
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/evilfryfish
	name = "evil fish stew"
	color = "#FF3200"
	taste_description = "an overwhelming sense of dread, whispers of progress, and a surprisingly rich aftertaste"
	nutriment_factor = 66
	metabolization_rate = 6

/datum/reagent/consumable/soup/stew/rabbit
	name = "cabbit stew"
	color = "#c59182"
	taste_description = "cabbit"

/datum/reagent/consumable/soup/stew/fryrabbit
	name = "roasted cabbit stew"
	color = "#BC7A6F"
	taste_description = "slow-roasted cabbit with a surprisingly pleasant aftertaste"
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/veggiefryrabbit
	name = "roasted cabbit stew with vegetables"
	color = "#A35D46"
	taste_description = "savory cabbit with caramelized vegetables, with a robust yet subdued aftertaste"
	metabolization_rate = 0.8
	nutriment_factor = 30
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/volf
	name = "volf stew"
	color = "#80432a"
	taste_description = "gamey meat"

/datum/reagent/consumable/soup/stew/fryvolf
	name = "vriskette stew"
	color = "#7F3518"
	taste_description = "slow-roasted and gamey meat"
	metabolization_rate = 0.8
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/veggiefryvolf
	name = "vriskette stew with vegetables"
	color = "#633012"
	taste_description = "savory and gamey meat with slow-roasted vegetables, and a pleasantly warm aftertaste"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/kingvolf
	name = "king's stew"
	color = "#892214"
	taste_description = "deliciously soft and gamey meat, contrasted with crunchy vegetables and a hint of tongue-tickling spice"
	nutriment_factor = 35
	metabolization_rate = 0.8
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/bisque
	name = "bisque"
	color = "#FFA74F" // Bisque like color I know bisque's more complicated than that 
	taste_description = "shellfish"

/datum/reagent/consumable/soup/stew/frybisque
	name = "roasted bisque"
	color = "#ffb74f"
	taste_description = "roasted shellfish, cradled in a sea of savory-yet-smooth broth"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/lavishfrybisque
	name = "lavish bisque"
	color = "#FFC688"
	taste_description = "sumptuously roasted shellfish, savory-yet-smooth broth, and a hint of spiced butteriness"
	nutriment_factor = 35
	metabolization_rate = 0.6
	quality = DRINK_VERYGOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/seafoodbroil
	name = "seabroil chowder"
	color = "#FFA74F"
	taste_description = "creamy shellfish with the occassional crunch"
	nutriment_factor = 25
	alpha = 200

/datum/reagent/consumable/soup/stew/fryseafoodbroil
	name = "roasted seabroil chowder"
	color = "#ffb74f"
	taste_description = "roasted shellfish within a creamy, delicate broth"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 222

/datum/reagent/consumable/soup/stew/lavishfryseafoodbroil
	name = "lavish seabroil chowder"
	color = "#FFE3D9"
	taste_description = "sumptuously creamy broth with a hint of moist clammage"
	nutriment_factor = 35
	metabolization_rate = 0.6
	quality = DRINK_VERYGOOD
	alpha = 222

/datum/reagent/consumable/soup/stew/meatrice
	name = "fried congee with roasted meat"
	color = "#E5C099"
	taste_description = "mushy, savory-brothed rice with chunks of tender meat"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 250

/datum/reagent/consumable/soup/stew/eggrice
	name = "fried congee with cackleberries"
	color = "#F7C997"
	taste_description = "mushy, savory-brothed rice with creamy yolkage and crispy eggs"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 250

/datum/reagent/consumable/soup/stew/shrimprice
	name = "fried congee with roasted shrimp"
	color = "#F7D5BE"
	taste_description = "mushy, savory-brothed rice with salty yet subdued shellfish"
	nutriment_factor = 30
	metabolization_rate = 0.8
	quality = DRINK_GOOD
	alpha = 250

/datum/reagent/consumable/soup/stew/cheeserice
	name = "fried congee with melted cheese"
	color = "#F7E297"
	taste_description = "mushy, savory-brothed rice that's been smothered in cheesy goodness"
	nutriment_factor = 25
	metabolization_rate = 0.6
	quality = DRINK_NICE
	alpha = 250

/datum/reagent/consumable/soup/stew/lavishfryrice
	name = "lavish brisket-congee"
	color = "#E0AF97"
	taste_description = "sumptuous, pillowy rice with slow-braised meats with hints of butteriness and cheese"
	nutriment_factor = 35
	metabolization_rate = 0.6
	quality = DRINK_VERYGOOD
	alpha = 250

/datum/reagent/consumable/soup/stew/yucky
	name = "strange stew"
	color = "#9e559c"
	taste_description = "overpoweringly strange-tasting, with a mildly tangy aftertaste"

/datum/reagent/consumable/soup/stew/fryyucky
	name = "strange brisket stew"
	color = "#9E6D84"
	taste_description = "a pleasantly implacable meat, somewhere between volf and chicken"
	nutriment_factor = 30
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/berry
	name = "berry stew"
	color = "#863333"
	taste_description = "sweet berries"

/datum/reagent/consumable/soup/stew/berry_poisoned
	name = "berry stew"
	color = "#863333"
	taste_description = "suspiciously bitter berries"

/datum/reagent/consumable/soup/stew/garlick_soup
	name = "garlick soup"
	color = "#FAF9F6"
	taste_description = "clear sinuses"

/datum/reagent/consumable/soup/stew/cucumber_soup
	name = "cucumber soup"
	color = "#98fb98"
	taste_description = "rich cucumbers"

/datum/reagent/consumable/soup/stew/thickcucumber_soup
	name = "thick cucumber soup"
	color = "#98fb98"
	taste_description = "rich and chunky cucumbers"
	nutriment_factor = 25

/datum/reagent/consumable/soup/stew/eggplant_soup
	name = "eggplant soup"
	color = "#fff8e3"
	taste_description = "tasty eggplant"

/datum/reagent/consumable/soup/stew/aubergine_soup
	name = "aubergine stew"
	color = "#D9E4E3"
	taste_description = "tender eggplant with nibblings of roasted mince"
	nutriment_factor = 25
	metabolization_rate = 0.8
	quality = DRINK_NICE

/datum/reagent/consumable/soup/stew/lavishaubergine_soup
	name = "lavish aubergine stew"
	color = "#D9C6E3"
	taste_description = "sumptuously tender eggplant, nibblings of roasted mince, and a creamy broth"
	nutriment_factor = 35
	metabolization_rate = 0.6
	quality = DRINK_GOOD
	alpha = 200

/datum/reagent/consumable/soup/stew/carrot_stew
	name = "carrot stew"
	color = "#f26818"
	taste_description = "savory carrots"

/datum/reagent/consumable/soup/stew/thickcarrot_stew
	name = "roasted carrot stew"
	color = "#f26818"
	taste_description = "savory and caramelized carrots"
	quality = DRINK_NICE
	alpha = 200

/datum/reagent/consumable/soup/stew/nutty_stew
	name = "nutty stew"
	color = "#807b78"
	taste_description = "nutty"

/datum/reagent/consumable/soup/stew/tomato_soup
	name = "tomato soup"
	color = "#db5230"
	taste_description = "home"
	metabolization_rate = 0.5 // half as fast as normal, last twice as long - it is the best soup after all

/datum/reagent/consumable/soup/stew/plum_soup
	name = "plum soup"
	color = "#9c305b"
	taste_description = "sweet plums"

/datum/reagent/consumable/soup/stew/squash_soup
	name = "squash soup"
	color = "#C98C42"
	taste_description = "autumn's loving embrace"
	metabolization_rate = 0.8
	nutriment_factor = 15

/datum/reagent/consumable/soup/stew/frysquash_soup
	name = "roasted squash soup"
	color = "#D3702E"
	taste_description = "a hearth kindled within your chest, and a pleasantly savory aftertaste"
	metabolization_rate = 0.8
	nutriment_factor = 20
	quality = DRINK_NICE

/datum/reagent/consumable/soup/stew/survival_broth
	name = "briquebroth"
	color = "#693346"
	taste_description = "heartwarmingly thick and salty, with little bursts of sweetness and pepperiness"
	nutriment_factor = 30
	alpha = 222

/datum/reagent/consumable/soup/stew/thicksurvival_broth
	name = "thick briquebroth"
	color = "#681936"
	taste_description = "heartwarmingly thick and savory, with bursts of sweetness and pepperiness"
	nutriment_factor = 45
	alpha = 250

/datum/reagent/consumable/soup/stew/saltmeat_stew
	name = "salted meat stew"
	color = "#693346"
	taste_description = "overwhelmingly salty, with hints of savoriness and meatiness"
	nutriment_factor = 20
	alpha = 250

// Copy pasted from berry poison, but stew metabolizes much faster so it is less deadly. You CAN use it as a source of hydration / nutrition if you are desperate enough???
/datum/reagent/consumable/soup/stew/berry_poisoned/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3) // so one berry or one dose (one clunk of extracted poison, 5u) will make you really sick and a hair away from crit.
			M.adjustToxLoss(2)
	return ..()

/datum/reagent/consumable/soup/porridge/poisonfrostedpudding/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3)
			M.adjustToxLoss(2)
	return ..()

/datum/reagent/consumable/soup/porridge/thickpoisonfrostedpudding/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3)
			M.adjustToxLoss(2)
	return ..()

/datum/reagent/consumable/soup/stew/slop/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3) // Slightly less lethal than eating actual poison.
			M.adjustToxLoss(1)
	return ..()

/datum/reagent/consumable/soup/purebutter/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(isdwarf(M))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3) // Slightly less lethal than eating actual poison.
			M.adjustToxLoss(0.5)
	return ..()

// Chicken stew functions like a lesser health potion. Why? Well, because what's a better way to nurse away a cold - or life-threatening wound - with some delicious chicken soup?
/datum/reagent/consumable/soup/stew/chicken/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(1)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+1, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.1, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/soup/stew/bakedchicken/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(1)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+2, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.15  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.15 * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.15, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.15  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.15  * REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/soup/stew/thickchicken/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(1)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+2, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.15  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.15 * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.15, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.15  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.15  * REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/soup/stew/bakedthickchicken/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(1)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+3, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.2 * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.15, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.2  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/soup/stew/veggiethickchicken/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(1)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+3, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.15, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.2  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.2  * REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/soup/stew/pepperchicken/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(1)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+4, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.25  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.25  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.15, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.25  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.25  * REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/soup/stew/lavishchicken/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(1)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+5, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(2)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.15, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.3  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.3  * REAGENTS_EFFECT_MULTIPLIER, 0)
	..()
