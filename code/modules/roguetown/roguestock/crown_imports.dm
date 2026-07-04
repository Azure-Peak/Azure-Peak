/datum/crown_import/crackers
	name = "Bin of Rations"
	desc = "Low moisture bread that keeps well."
	item_type = /obj/item/roguebin/crackers
	base_cost = 100
	source_region_id = TRADE_REGION_KINGSFIELD

/obj/item/roguebin/crackers/Initialize()
	. = ..()
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)

/obj/structure/closet/crate/chest/steward
	lockid = "steward"
	locked = TRUE
	masterkey = TRUE

/datum/crown_import/redpotion
	name = "Crate of Health Potions"
	desc = "Red that keeps men alive."
	item_type = /obj/structure/closet/crate/chest/steward/redpotion
	base_cost = 100
	source_region_id = TRADE_REGION_ROCKHILL

/obj/structure/closet/crate/chest/steward/redpotion/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/healthpot(src)

/datum/crown_import/rotpotion
	name = "Crate of Rot Cure Potions"
	desc = "A sought-after crate of rare potions of rot-curing."
	item_type = /obj/structure/closet/crate/chest/steward/rotpotion
	base_cost = 400		//Expensive, 200 each roughly. Four uses total, as only 5u needed to reverse rot. Each bottle is 10u.
	source_region_id = TRADE_REGION_ROCKHILL

/obj/structure/closet/crate/chest/steward/rotpotion/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure(src)

/datum/crown_import/saigabuck
	name = "Saigabuck"
	desc = "One Saigabuck tamed with a saddle from a far away land."
	item_type = /obj/structure/closet/crate/chest/steward/saigabuck
	base_cost = 100

/obj/structure/closet/crate/chest/steward/saigabuck/Initialize()
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled(src)
	new /obj/item/caparison/azure(src)

/datum/crown_import/cow
	name = "Cow"
	desc = "Farmer's best friend, reliable provider of milk and meat."
	item_type = /obj/structure/closet/crate/chest/steward/cow
	base_cost = 100
	source_region_id = TRADE_REGION_KINGSFIELD

/obj/structure/closet/crate/chest/steward/cow/Initialize()
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/cow(src)

/datum/crown_import/bull
	name = "Bull"
	desc = "Horned and aggressive, required to start a herd."
	item_type = /obj/structure/closet/crate/chest/steward/bull
	base_cost = 100
	source_region_id = TRADE_REGION_KINGSFIELD

/obj/structure/closet/crate/chest/steward/bull/Initialize()
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/bull(src)

/datum/crown_import/goat
	name = "Doe Goat"
	desc = "An all-purpose source of milk, hide and fat."
	item_type = /obj/structure/closet/crate/chest/steward/goat
	base_cost = 100
	source_region_id = TRADE_REGION_KINGSFIELD

/obj/structure/closet/crate/chest/steward/goat/Initialize()
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/goat(src)

/datum/crown_import/goatmale
	name = "Billy Goat"
	desc = "Bearded, male goat capable of saddling."
	item_type = /obj/structure/closet/crate/chest/steward/goatmale
	base_cost = 100
	source_region_id = TRADE_REGION_KINGSFIELD

/obj/structure/closet/crate/chest/steward/goatmale/Initialize()
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/goatmale(src)

/datum/crown_import/chicken
	name = "Chicken"
	desc = "A reliable source of egg and meat."
	item_type = /obj/structure/closet/crate/chest/steward/chicken
	base_cost = 50
	source_region_id = TRADE_REGION_KINGSFIELD

/obj/structure/closet/crate/chest/steward/chicken/Initialize()
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/rogue/chicken(src)

/datum/crown_import/farmequip
	name = "Farm Equipment Crate"
	desc = "A crate with a pitchfork, sickle, hoe and some seeds."
	item_type = /obj/structure/closet/crate/chest/steward/farmequip
	base_cost = 100
	source_region_id = TRADE_REGION_KINGSFIELD

/obj/structure/closet/crate/chest/steward/farmequip/Initialize()
	. = ..()
	new /obj/item/rogueweapon/hoe(src)
	new /obj/item/rogueweapon/pitchfork(src)
	new /obj/item/rogueweapon/sickle(src)
	new /obj/item/seeds/apple(src)
	new /obj/item/seeds/wheat(src)
	new /obj/item/seeds/berryrogue(src)

/datum/crown_import/blacksmith
	name = "Smith Crate"
	desc = "Stone, coal , iron ingot, wood bin, bucket with hammer and tongs."
	item_type = /obj/structure/closet/crate/chest/steward/blacksmith
	base_cost = 100
	source_region_id = TRADE_REGION_DAFTSMARCH

/obj/structure/closet/crate/chest/steward/blacksmith/Initialize()
	. = ..()
	new /obj/item/rogueweapon/hammer/iron(src)
	new /obj/item/rogueweapon/tongs(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/rogueore/coal(src)
	new /obj/item/rogueore/coal(src)
	new /obj/item/ingot/iron(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/natural/stone(src)
	new /obj/item/roguebin(src)
	new /obj/item/reagent_containers/glass/bucket(src)

/datum/crown_import/craftsman
	name = "Craftsman Crate"
	desc = "Handsaw, chisel, hammer."
	item_type = /obj/structure/closet/crate/chest/steward/craftsman
	base_cost = 60
	source_region_id = TRADE_REGION_ROSAWOOD

/obj/structure/closet/crate/chest/steward/craftsman/Initialize()
	. = ..()
	new /obj/item/rogueweapon/hammer/wood(src)
	new /obj/item/rogueweapon/chisel(src)
	new /obj/item/rogueweapon/handsaw(src)

/datum/crown_import/glasscrate
	name = "Glass Crate"
	desc = "A crate full of glass for windows, repairs, and works of art.."
	item_type = /obj/structure/closet/crate/chest/steward/glasscrate
	base_cost = 150
	source_region_id = TRADE_REGION_DAFTSMARCH

/obj/structure/closet/crate/chest/steward/glasscrate/Initialize()
	. = ..()
	new /obj/item/natural/glass(src)
	new /obj/item/natural/glass(src)
	new /obj/item/natural/glass(src)
	new /obj/item/natural/glass(src)
	new /obj/item/natural/glass(src)

/datum/crown_import/tailor
	name = "Tailor Crate"
	desc = "A crate with basic tailoring tools."
	item_type = /obj/structure/closet/crate/chest/steward/tailor
	base_cost = 150
	source_region_id = TRADE_REGION_ROSAWOOD

/obj/structure/closet/crate/chest/steward/tailor/Initialize()
	. = ..()
	new /obj/item/rogueweapon/huntingknife/scissors/steel(src)
	new /obj/item/needle(src)
	new /obj/item/grown/log/tree/small(src)
	new /obj/item/grown/log/tree/small(src)
	new /obj/item/natural/bundle/fibers(src)
	new /obj/item/grown/log/tree/stick(src)
	new /obj/item/grown/log/tree/stick(src)

/datum/crown_import/alcoholset
	name = "Alcohol Crate"
	desc = "A crate with a selection of beers and liquors, fit for a party."
	item_type = /obj/structure/closet/crate/chest/steward/alcoholset
	base_cost = 800

/obj/structure/closet/crate/chest/steward/alcoholset/Initialize()
	. = ..()
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/nred(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/voddena(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/whitewine(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/redwine(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/elfred(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/kgunplum(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/aurorian(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/butterhairs(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/kgunshochu(src)
	new /obj/item/reagent_containers/glass/bottle/rogue/beer/apfelweinheim(src)

/datum/crown_import/minecarttracks
	name = "Minecart Tracks"
	desc = "A crate with One hundred minecart tracks and four break tracks"
	item_type = /obj/structure/closet/crate/chest/steward/minecarttracks
	base_cost = 310
	source_region_id = TRADE_REGION_DAFTSMARCH

/obj/structure/closet/crate/chest/steward/minecarttracks/Initialize()
	. = ..()
	for(var/i = 1 to 100)
		new /obj/item/rotation_contraption/minecart_rail(src)
	for(var/i = 1 to 4)
		new /obj/item/rotation_contraption/minecart_rail/railbreak(src)

/datum/crown_import/rotationalnetwork
	name = "Rotational Network"
	desc = "A crate of ten large gears, sixteen small gears, three gearboxes, three verticle gearboxes, and twenty shafts"
	item_type = /obj/structure/closet/crate/chest/steward/rotationalnetwork
	base_cost = 362
	source_region_id = TRADE_REGION_DAFTSMARCH

/obj/structure/closet/crate/chest/steward/rotationalnetwork/Initialize()
	. = ..()
	for(var/i = 1 to 10)
		new /obj/item/rotation_contraption/large_cog(src)
	for(var/i = 1 to 16)
		new /obj/item/rotation_contraption/cog(src)
	for(var/i = 1 to 3)
		new /obj/item/rotation_contraption/horizontal(src)
	for(var/i = 1 to 3)
		new /obj/item/rotation_contraption/vertical(src)
	for(var/i = 1 to 20)
		new /obj/item/rotation_contraption/shaft(src)

/datum/crown_import/waterwheels
	name = "Waterwheels"
	desc = "A crate of five waterwheels"
	item_type = /obj/structure/closet/crate/chest/steward/waterwheels
	base_cost = 75
	source_region_id = TRADE_REGION_ROSAWOOD

/obj/structure/closet/crate/chest/steward/waterwheels/Initialize()
	. = ..()
	for(var/i = 1 to 5)
		new /obj/item/rotation_contraption/waterwheel(src)

/datum/crown_import/stoneblocks
	name = "Stoneblocks"
	desc = "A crate of twenty Stoneblocks, useful in building"
	item_type = /obj/structure/closet/crate/chest/steward/stoneblocks
	base_cost = 40
	source_region_id = TRADE_REGION_DAFTSMARCH

/obj/structure/closet/crate/chest/steward/stoneblocks/Initialize()
	. = ..()
	for(var/i = 1 to 20)
		new /obj/item/natural/stoneblock(src)

/datum/crown_import/planks
	name = "Planks"
	desc = "A crate of twenty planks, useful in building"
	item_type = /obj/structure/closet/crate/chest/steward/planks
	base_cost = 60
	source_region_id = TRADE_REGION_ROSAWOOD

/obj/structure/closet/crate/chest/steward/planks/Initialize()
	. = ..()
	for(var/i = 1 to 20)
		new /obj/item/natural/wood/plank(src)

/datum/crown_import/keyringsset
	name = "Man-At-Arms Keyring Set Crate"
	desc = "A set of keys for new hires."
	item_type = /obj/structure/closet/crate/chest/steward/keyringsset
	base_cost = 100

/obj/structure/closet/crate/chest/steward/keyringsset/Initialize()
	. = ..()
	new /obj/item/storage/keyring/manatarms(src)
	new /obj/item/storage/keyring/manatarms(src)
	new /obj/item/storage/keyring/manatarms(src)
	new /obj/item/storage/keyring/manatarms(src)

/datum/crown_import/crossbow
	name = "Crossbows Crate"
	desc = "A crate with 3 crossbows with 3 full quivers."
	item_type = /obj/structure/closet/crate/chest/steward/crossbow
	base_cost = 300

/obj/structure/closet/crate/chest/steward/crossbow/Initialize()
	. = ..()
	new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(src)
	new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(src)
	new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow(src)
	new /obj/item/quiver/bolt/standard(src)
	new /obj/item/quiver/bolt/standard(src)
	new /obj/item/quiver/bolt/standard(src)

/datum/crown_import/warden
	name = "Warden Equipment Crate"
	desc = "Equipment kit for a warden."
	item_type = /obj/structure/closet/crate/chest/steward/warden
	base_cost = 300
	source_region_id = TRADE_REGION_ROSAWOOD

/obj/structure/closet/crate/chest/steward/warden/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/bascinet/antler(src)
	new /obj/item/clothing/cloak/wardencloak(src)
	new /obj/item/clothing/suit/roguetown/armor/leather/studded/warden(src)
	new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy(src)
	new /obj/item/clothing/wrists/roguetown/bracers/leather(src)
	new /obj/item/clothing/gloves/roguetown/fingerless_leather(src)
	new /obj/item/clothing/under/roguetown/trou/leather(src)
	new /obj/item/clothing/shoes/roguetown/boots/leather/reinforced(src)
	new /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick(src)
	new /obj/item/rogueweapon/huntingknife/idagger/warden_machete(src)
	new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden(src)
	new /obj/item/quiver/arrows(src)
	new /obj/item/storage/belt/rogue/leather(src)
	new /obj/item/storage/keyring/warden(src)//Different ring to the rest

/datum/crown_import/manatarms
	name = "Man-at-Arms Equipment Crate"
	desc = "Equipment kit for an armsman."
	item_type = /obj/structure/closet/crate/chest/steward/manatarms
	base_cost = 300

/obj/structure/closet/crate/chest/steward/manatarms/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/sallet/visored(src)
	new /obj/item/clothing/neck/roguetown/bevor(src)
	new /obj/item/clothing/cloak/tabard/stabard/surcoat/guard(src)
	new /obj/item/clothing/suit/roguetown/armor/brigandine/retinue(src)
	new /obj/item/clothing/suit/roguetown/armor/chainmail(src)
	new /obj/item/clothing/wrists/roguetown/bracers(src)
	new /obj/item/clothing/gloves/roguetown/plate(src)
	new /obj/item/clothing/under/roguetown/chainlegs(src)
	new /obj/item/clothing/shoes/roguetown/boots/armor(src)
	new /obj/item/storage/belt/rogue/leather/steel(src)
	new /obj/item/rogueweapon/scabbard/gwstrap(src)
	new /obj/item/rogueweapon/halberd(src)

/datum/crown_import/knight
	name = "Knight Equipment Crate"
	desc = "Equipment kit for a dismounted knight."
	item_type = /obj/structure/closet/crate/chest/steward/knight
	base_cost = 500

/obj/structure/closet/crate/chest/steward/knight/Initialize()
	. = ..()
	new /obj/item/clothing/head/roguetown/helmet/heavy/knight(src)
	new /obj/item/clothing/neck/roguetown/gorget/steel(src)
	new /obj/item/clothing/cloak/tabard/knight/guard(src)
	new /obj/item/clothing/suit/roguetown/armor/plate(src)
	new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk(src)
	new /obj/item/clothing/wrists/roguetown/bracers(src)
	new /obj/item/clothing/gloves/roguetown/plate(src)
	new /obj/item/clothing/under/roguetown/platelegs(src)
	new /obj/item/clothing/shoes/roguetown/boots/armor(src)
	new /obj/item/storage/belt/rogue/leather/steel(src)
	new /obj/item/rogueweapon/scabbard/sword(src)
	new /obj/item/rogueweapon/sword/long(src)
