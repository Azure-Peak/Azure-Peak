/obj/item/clothing/head/roguetown/helmet/heavy/sheriff/gold/king/uniqueOpulence
	name = "Opulence"
	desc = "Fragile as vanity itself, this gaudy piece is prone to breaking under pressure. Fortunately, its exorbitant cost ensures it remains highly prized among those who mistake wealth for worth."

/obj/item/rogueweapon/huntingknife/idagger/silver/uniqueMiscreed
	name = "Miscreed"
	desc = "Blessed silver, now stained by the blood of profane rites, all performed in the name of the Ten. Even the purest teachings may be twisted by those who hear only what they wish. This blade begs to be cleansed."

/obj/item/rogueweapon/hammer/iron/uniqueDriftiron
	name = "Driftiron"
	desc = "A smithing hammer forged from metal quenched in the sea. The scent of salt still clings to its head, worn smooth from years spent shaping blades for raiders and marauders. Countless weapons have passed beneath its strikes, each carrying a little of the ocean's ruthlessness."
	max_integrity = 400

/obj/item/rogueweapon/fishspear/uniqueLyfesaver
	name = "Lyfesaver"
	desc = "A well-worn, two-pronged fishing spear. It reeks of fish and is crusted with rust, brine, and the stubborn residue of countless catches. By all rights, it should have fallen apart years ago, yet it endures through diligent maintenance and sheer luck alone. A true Lyfesaver."
	fishingMods = list(
		"commonFishingMod" = 1,
		"rareFishingMod" = 1.6,
		"treasureFishingMod" = 0.2,
		"trashFishingMod" = 0,
		"dangerFishingMod" = 1.2,
		"ceruleanFishingMod" = 0,
		"cheeseFishingMod" = 0
	)

/obj/item/satchel_bomb/uniqueAssurance
	name = "Assurance"
	desc = "Either I get what I want, or neither of us are walking out of this in one piece."
	fuze = 30
	PVE_damage = 400

/obj/item/clothing/head/roguetown/helmet/sallet/iron/banded/uniqueDoVesKin
	name = "Do Ves Kin"
	desc = "Hammerholdian design, dented by a drakkyn's claws. It's sharpened rim bids you to hold your head to the sky."
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON + 50

/obj/item/rogueweapon/pick/steel/uniqueDeepstrike
	name = "Deepstrike"
	desc = "A sturdy steel pickaxe abandoned to rust in the murk. It shares its name with a tool favored by many a confident suitor."
	force = 25
	force_wielded = 32

/obj/item/rogueweapon/sword/short/messer/onyxa/uniqueNehnemi
	name = "Nehnemi"
	desc = "Nehnemi, the Wanderer. A macuahuitl of flawless Onyxa recovered from a sealed crate adrift upon the sea. No ship claimed it, no markings revealed its origin, and no owner came seeking its return. The wood of the crate rotted, the nails corroded, and the sea erased every clue. Only the weapon endured, as though it had not been lost at all, but merely traveling."
	max_integrity = 200

/obj/item/rogueweapon/woodstaff/implement/grand/riddle/uniqueVestige
	name = "Vestige"
	desc = "A staff of polished wood, carved with the sigils of a long-forgotten order. It hums faintly with residual magic, a whisper of the power it once commanded. One shudders to think what it could do in it's glory-daes."
	max_integrity = 400
	implement_refund = 0.4

/obj/item/rogueweapon/stoneaxe/hurlbat/uniqueDiggaThing
	name = "Digga Thing"
	desc = "A well-made hurlbat recovered from a goblin camp, its edges worn smooth not by battle, but by years of enthusiastic digging. Somewhere along the way, the goblins concluded that a perfectly serviceable throwing axe was also an excellent shovel. You however are not a goblin, and you are not digging. You are throwing."

/obj/item/cooking/pan/bronze/uniqueMealbringer
	name = "Mealbringer the Devastatingly Blunteous"
	desc = "Undented. Unbroken. Its flawless non-stick surface and carefully wrought curves ensure not a single drop of oil can find its wielder. Yet its true purpose is not in the kitchen, but in caving in the skulls of those who would scorn the labor of a master chef. Cook and Serve until it is done."
	force = 30

/obj/item/clothing/neck/roguetown/psicross/pearl/uniqueDreamingPlea
	name = "Dreaming Plea"
	desc = "Cobbled together by a mind muddied with the dreamer's influence. It's a prayer for freedom, for forgiveness, for a way out of the sunless depths. A heresy borne from the desire for change."

/obj/item/rogueweapon/mace/cudgel/shellrungu/uniqueMchanga
	name = "Mchanga"
	desc = "Mchanga is fashioned from a massive sea shell, polished smooth by patient hands and countless tides. With every swing, it emits a low, haunting call, somewhere between a whistle and the cry of a distant seabird. The sound carries farther than one would expect, announcing each strike before it lands. Whether this was an intentional feature or a quirk of the shell's construction is unknown."
	max_integrity = 200
	swingsound = list('sound/combat/wooshes/blunt/shovel_swing.ogg','sound/combat/wooshes/blunt/shovel_swing2.ogg')
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'

/obj/item/fishingrod/blacksteel/uniqueDeepdredger
	name = "Deepdredger"
	desc = "Women fear me, fish fear me, men turn their eyes away from me as I walk. No beast dare makes a sound in my presence, I am alone on this barren land."
	var/active_item = FALSE

/obj/item/fishingrod/blacksteel/uniqueDeepdredger/equipped(mob/living/user)
	. = ..()
	if(active_item)
		return
	active_item = TRUE
	user.change_stat(STATKEY_LCK, 3)
	to_chat(user, span_suppradio("You feel lucky."))

/obj/item/fishingrod/blacksteel/uniqueDeepdredger/dropped(mob/living/user)
	. = ..()
	if(!active_item)
		return
	active_item = FALSE
	user.change_stat(STATKEY_LCK, -3)
	to_chat(user, span_suicide("The luck fades."))


/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/uniqueFortress
	name = "Fortress"
	desc = "Heavy and cumbersome, this enduring suit of bronze plate grants its wearer the resilience of heroes long past. Woe to those who shatter themselves against you, immovable bulwark. Stand firm and valiant. Never yield your back to the enemy, and let the innocent find refuge at your side."
	max_integrity = ARMOR_INT_CHEST_PLATE_BRONZE + 100

/obj/item/rogueweapon/shield/iron/bone/uniqueCongealedScraps
	name = "congealed scraps"
	desc = "Blood, viscera, mud. It holds together, even if just. You can hold it, and it will take blows for you. But why would you?"

/obj/item/clothing/suit/roguetown/shirt/desertbra/uniqueMustyBra
	name = "musty bra"
	desc = "Found next to a Lamia, this answers the age old question: If given the chance, would they cover up? Nay. They let them hang."

/obj/item/clothing/suit/roguetown/armor/plate/bikini/uniqueModesty
	name = "Modesty"
	desc = "A suit of gold-lined half-plate that leaves remarkably little to the imagination. The craftsmanship is masterful, the metal priceless, and the protection... selective. It was recovered from a goblin cave, a fact that raises several uncomfortable questions. The goblins were clearly quite proud of the piece, having displayed it prominently among their treasures. It appears used."
	color = "#FEBD14"
	smeltresult = /obj/item/ingot/gold
	undyeable = 1

/obj/item/rogueweapon/huntingknife/combat/kris/uniqueTrustedCompanion
	name = "Trusted Companion"
	desc = "Worn with use, jagged as a volf's teeth. This dagger has changed hands as frequently as it's taken lyves."
	max_blade_int = 300

/obj/item/rogueweapon/huntingknife/cleaver/uniqueGluttonousBite
	name = "Gluttonous Bite"
	desc = "There is nothing magical about the cleaver, yet holding it makes you crave pork. Long, sinewy pork."
	max_blade_int = 250
	var/active_item = FALSE
	var/legendcooking = FALSE

/obj/item/rogueweapon/huntingknife/cleaver/uniqueGluttonousBite/equipped(mob/living/user)
	. = ..()
	if(active_item)
		return
	var/current_cooking = user.get_skill_level(/datum/skill/craft/cooking)
	if(current_cooking)
		if(current_cooking < 6)
			active_item = TRUE
			legendcooking = FALSE
			user.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
			ADD_TRAIT(user, TRAIT_ORGAN_EATER, TRAIT_GENERIC)
			to_chat(user, span_notice("Culinary secrets open up to you. Not all of them pleasant."))
		else
			active_item = TRUE
			legendcooking = TRUE
			to_chat(user, span_warning("A faint glimmer of knowledge itches at your mind, but you are set in your ways."))
	else
		to_chat(user, span_warning("The cleaver feels unremarkable in your hands."))

/obj/item/rogueweapon/huntingknife/cleaver/uniqueGluttonousBite/dropped(mob/living/user)
	. = ..()
	if(active_item)
		if(user.get_skill_level(/datum/skill/craft/cooking))
			var/mob/living/carbon/human/H = user
			if(!legendcooking)
				H.adjust_skillrank(/datum/skill/craft/cooking, -1, TRUE)
				REMOVE_TRAIT(user, TRAIT_ORGAN_EATER, TRAIT_GENERIC)
			to_chat(H, span_notice("Culinary secrets fade."))
			active_item = FALSE
		else
			return

/obj/item/rogueweapon/mace/warhammer/bronze/decorated/uniqueDaShinyWhacker
	name = "Da Shiny Whacker"
	desc = "Cobbled together in elegance. A good looking hunk of scrap, considering it's maker; The forgefather sometimes blesses the most unlikely of folk with inspiration. Not a bad weapon either."

/obj/item/rogueweapon/whip/blacksteel/uniqueCrimsonTears
	name = "Crimson Tears"
	desc = "Blacksteel shimmers along the coils in finely-crafted scales, each as sharp as a razor's edge. Flesh will weep crimson."

/obj/item/lockpick/goldpin/uniqueAGentleman
	name = "A Gentleman"
	desc = "A gentleman always opens a door for their lady."

/obj/item/rogueweapon/woodstaff/implement/uniqueLostApprenticeStaff
	name = "lost apprentice's staff"
	desc = "A simple staff topped with an ornamental finial, crafted more carefully than skillfully. The wood bears the marks of repeated use, while the toper remains polished by years of anxious hands and restless study. It belonged to an apprentice once. Judging by the quality of the repairs, the staff survived far more mistakes than its owner cared to admit."
	implement_refund = 0.21

/obj/item/clothing/ring/aalloy/uniqueTarnishedKeepsake
	name = "tarnished keepsake"
	desc = "A frayed coil of bronze, worn smooth by years of handling. It must have meant something to someone once. An empty gem setting rests at its center, and a faint melancholy clings to the otherwise mundane trinket."
	var/active_item = FALSE

/obj/item/clothing/ring/aalloy/uniqueTarnishedKeepsake/equipped(mob/living/user)
	. = ..()
	if(active_item)
		return
	active_item = TRUE
	user.change_stat(STATKEY_LCK, 1)
	to_chat(user, span_suppradio("You a sliver of luck."))

/obj/item/clothing/ring/aalloy/uniqueTarnishedKeepsake/dropped(mob/living/user)
	. = ..()
	if(!active_item)
		return
	active_item = FALSE
	user.change_stat(STATKEY_LCK, -1)
	to_chat(user, span_suicide("The luck fades."))

/obj/item/rogueweapon/halberd/bone/uniqueGnawedHalberd
	name = "gnawed halberd"
	desc = "Countless carvings and gnaw marks mar this troll-bone blade, the remnants of a failed attempt to turn a monstrous trophy into a work of art. Harsh criticism gradually reshaped it into something far cruder, yet far more practical. Sharp, unwieldy, and unnervingly durable, it still retains a trace of the troll's regenerative vitality."

/obj/item/rogueweapon/sword/stone/uniqueEkskallibor
	name = "Ekskallibor"
	desc = "A sharp rock tied to a stick with strips of leather and an almost offensive amount of confidence. By all reasonable measures, it should be firewood. The goblins call it Ekskallibor, and speak of it with the reverence usually reserved for legendary artifacts. According to tribal tradition, it was pulled from a mound of mud by a hero of unmatched strength, wisdom, and personal hygiene. Closer inspection suggests it was more likely assembled from whatever happened to be nearby. The goblins reject this assessment entirely. After all, if it has a name, a legend, and can cave in a skull, what more could a weapon possibly need?"
	max_integrity = 100
	force = 19
	force_wielded = 27

/obj/item/rogueweapon/shield/wood/deprived/uniquePropaSheeld
	name = "Propa Sheeld"
	desc = "A collection of wooden planks lashed together and confidently declared a shield. The craftsmanship is unmistakably goblin in origin: crude, improvised, and surprisingly functional. Against arrows, it performs adequately. Against axes, less so. Against goblin standards, it is a masterwork."
	max_integrity = 250

/obj/item/tntstick/uniqueBoomySticka
	name = "Boomy Sticka"
	desc = "A tightly wrapped stick of blastpowder recovered from a goblin camp. The fuse has been shortened repeatedly, suggesting its previous owners valued enthusiasm over caution. Miraculously, it remains unexploded. Equally miraculously, so did the goblins."
	fuze = 5

/obj/item/rogueweapon/mace/woodclub/deprived/uniqueBurntClub
	name = "burnt club"
	desc = "Forged in fire and heat. Unfortunately it's made of wood, so that wasn't the best of ideas."
	resistance_flags = FIRE_PROOF

/obj/item/broom/uniqueFlyingBroom
	name = "flying broom"
	desc = "A witch could fly with this, probably. Or so the myth goes..."

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/paalloy/uniqueSiegebreaker
	name = "Siegebreaker"
	desc = "In its prime, this siege weapon broke stone as readily as flesh. May no wall deny your passage while it remains in hand. Its gears groan with eager intent, and the pulley endures untouched by the rust that claimed the rest."
	reloadtime = 100
	chargingspeed = 50

/obj/item/clothing/cloak/templar/astratan/uniqueEerieRobes
	name = "eerie robes"
	desc = "Robes once worn by a village priest whose devotion was beyond question and whose judgment was not. Their hems are embroidered with passages from the teachings of the Ten Undivided, each thread painstakingly maintained despite the garment's age. The priest claimed to hear a sacred voice within the Litany's words. In time, he came to trust that voice more than the teachings themselves. What followed was not salvation, but ruin. The hamlet fell, its people perished, and every horror was committed in the belief that it served a divine purpose. The robes remain immaculate. The faith within them does not. A grim reminder that the greatest heresies are often preached by those who believe themselves righteous."
	color = "#FF7F7F"
	undyeable = 1

/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/uniqueCarrion
	name = "Carrion"
	desc = "A rugged leather helmet reinforced with bands of iron and crowned by the front half of a weathered skull. Time has stripped away any clue as to the creature it once belonged to, though its hollow gaze remains unsettlingly intact."
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON + 30

/obj/item/rogueweapon/stoneaxe/battle/steppesman/uniqueLodinkinni
	name = "Lodinkinni"
	desc = "A northman's axe, scarred by sea air and long voyages. Its name honors the starving Bear, deity of fortune, greed, and thriving through lean winters. This axe was often employed when the Bear came to collect."

/obj/item/rogueweapon/sword/short/psy/preblessed/uniqueFairFight
	name = "Fair Fight"
	desc = "A messer of blessed silver bearing the name Fair Fight. It was found beside the cage of a living verevolf, amidst a field of old bones. The beast bore countless silver scars yet stubbornly refused to die. Looking back upon the scene, one cannot help but wonder if the fight was ever meant to be won."

/obj/item/clothing/head/roguetown/helmet/sallet/beastskull/uniqueMonstersDemise
	name = "Monster's Demise"
	desc = "Eyeless and malformed, yet still crowned with vicious teeth. This skull belonged to the progenitor of something dreadful, a thing that may yet walk these lands. It is ancient enough to have crumbled to dust, but the bone remains unnaturally thick and unyielding."
	max_integrity = ARMOR_INT_HELMET_STEEL + 50

/obj/item/clothing/head/roguetown/helmet/heavy/astratan/uniqueRadiance
	name = "Radiance"
	desc = "A bucket helm plated in brilliant gold and worn by the templars of Astrata. Its polished surface catches even the faintest light, ensuring its wearer is seen long before they are heard. It bears the name Radiance, a virtue highly prized by Astrata's faithful. They teach that darkness exists only where the light has yet to impose itself. Doubt, dissent, and disobedience are much the same. The helm shines with uncompromising brilliance. To those who kneel, it is inspiring. To those who do not, it is a warning."

/obj/item/rogueweapon/sword/short/messer/blacksteel/uniqueRatHewer
	name = "Rat Hewer"
	desc = "A darksteel messer lost to history resigned to inglorious service. Its maker intended it for worthy foes and great deeds, judging by the quality of its construction. Fate, however, had other plans. The blade is slick with the blood of rats and other vermin. Whatever destiny was once imagined for it has long since been traded for practical necessity. And yet, the edge remains keen, the darksteel as resilient as the day it left the forge. It thirsts to gleam in astrata's glare."

/obj/item/rogueweapon/sword/broken/uniqueGnawedThing
	name = "gnawed thing"
	desc = "Once a consecrated weapon of impeccable balance, its blessings were gnawed from it piece by piece. What remains is little more than a shard, an insult to the faith and purpose it once served."

/obj/item/rogueweapon/mace/cudgel/flanged/psy/preblessed/uniqueHope
	name = "Hope"
	desc = "Remember: not even HE was perfect. That is the beauty of it. Despite every flaw and failing, HE still pressed onward. So can you. Endure, champion. Failure is a lesson well worth learning, but today is not the day to pay its tuition."

/obj/item/rogueweapon/shield/tower/metal/blacksteel/uniquePeace
	name = "Peace"
	desc = "HE dreamt of a peaceful realm, where HIS children might flourish unburdened by strife. To raise this shield is to inherit that dream. Carry it forward. Bring peace to Psydonia. A single step toward HIS vision. A single step toward the world that should have been."

/obj/item/rogueweapon/spear/blacksteel/uniqueConquest
	name = "Conquest"
	desc = "There must be sacrifice. HE understood that better than anyone. HE mourns every life lost, every spark of potential extinguished before its time. Yet HE is no fool. HIS faith in the goodness of others does not blind HIM to the needs of the many. To take up this spear is to swear yourself to its namesake: Conquest. Not for glory. Not for ambition. Not for greed. Conquest in the name of peace."

/obj/item/rogueweapon/woodstaff/implement/grand/blacksteel/uniqueAxiom
	name = "Axiom"
	desc = "A grand staff of polished blacksteel, recovered from the sanctum of a lich. The metal gleams with a dark, flawless sheen, unmarred by rust, age, or the countless years it spent beside its master. The staff bears the name Axiom. Not a boast, nor a threat, but a statement. An axiom is a truth accepted without proof, the foundation upon which all other conclusions are built. One cannot help but wonder what truth the lich considered so self-evident that it deserved to be wrought into blacksteel. The answer may be as simple as this: all things end. Some merely take longer to admit it."
	implement_refund = 0.5

/obj/item/rogueweapon/huntingknife/idagger/steel/stalker/uniqueFang
	name = "Fang"
	desc = "As cruelly curved as a spider's fang, this drow-forged blade exists for a single purpose: to carry poison where it will do the most harm."

/obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed/uniqueCatharsis
	name = "Catharsis"
	desc = "A stake of seasoned wood tipped with blessed silver, fashioned to destroy those who cling unnaturally to life. May it bring relief, release, and an end to the suffering the accursed refuse to acknowledge."

/obj/item/rogueweapon/shield/tower/spidershield/uniqueCarapace
	name = "Carapace"
	desc = "Fashioned from the chitin of a primordial arachnid, this shield remains as resilient as the creature from which it was taken. It serves as a bulwark against those foolish enough to challenge the Many-Legged Ones."
	max_integrity = 350

/obj/item/rogueweapon/spear/improvisedbillhook/uniqueDismounter
	name = "Dismounter"
	desc = "A sturdy billhook named Dismounter, its blade scarred by hard use and more than a few poorly judged impacts. The hook remains keen despite the wear, though the haft bears enough repairs to suggest its wielder was often closer to the action than intended."
	max_blade_int = 250

/obj/item/rogueweapon/stoneaxe/battle/ice/uniqueFrostBite
	name = "Frost's Bite"
	desc = "The cold bites before the blade ever can. This axe carries within it the bitterness of the north, a relentless frost born from the ice that tempered its edge."
	max_integrity = 300

/obj/item/rogueweapon/mace/maul/grand/malum/uniqueFirstForge
	name = "Firstforge"
	desc = "A faint warmth lingers within the hammer, untouched by age. Malumites who wield it find their minds flooded with visions of invention and their hands driven to ceaseless labor in service to the Forgefather. It is said to be a fragment of a fragment of Creation, hammered into the shape of a weapon."

/obj/item/needle/bronze/uniqueHollowNeedle
	name = "hollow needle"
	desc = "This needle's tip has been hollowed out. What was once meant to close wounds was instead used to deliver poison. Time has since bent the implement and clogged its channel, leaving it incapable of such wicked work. It remains serviceable for stitching, though you cannot help but feel uneasy placing it near an open wound."

/obj/item/rogueweapon/huntingknife/idagger/steel/fire/uniqueDrakkynsTooth
	name = "Drakkyn's Tooth"
	desc = "Curved like a drakkyn's tooth, this dagger bears the memory of its creation. When its name is spoken, the blade remembers the drakkynfyre that tempered it, and bursts forth with searing flame."

/obj/item/clothing/suit/roguetown/armor/plate/paalloy/artificer/uniqueInnovation
	name = "Innovation"
	desc = "Sturdy and light, it lacks only the heat of an infernal core to unleash it's true potential."

/obj/item/rogueweapon/woodstaff/quarterstaff/blacksteel/uniqueDiscipline
	name = "Discipline"
	name = "A solid rod of blacksteel capped with heavy, bulbous ends. Nearly unbreakable, this quarterstaff delivers punishment with relentless efficiency. Its name is Discipline, and it is eager to impart the lesson."
	max_integrity = 600

/obj/item/forgeable/gold/scale/uniqueSaclesOfGreed
	name = "Scales of Greed"
	desc = "A set of golden scales bearing the name Scales of Greed. They are beautifully made, perfectly balanced, and utterly honest in all matters save one. The longer they are held, the more precious every coin appears and the more painful every loss becomes. In the hand they are surprisingly light. Upon the heart, they are crushing."
	sellprice = 500

/obj/item/staff/stick/uniqueLostCane
	name = "lost cane"
	desc = "Carved from a single length of polished wood, this cane once belonged to a gentleman of some refinement. The journey that carried it here has long since been forgotten."
	walking_stick = TRUE
	sellprice = 100

/obj/item/storage/backpack/rogue/artibackpack/uniqueLostExpeditionsPack
	name = "lost expedition's pack"
	desc = "Despite its age, the pack's intricate mechanisms continue to function flawlessly. Its interior remains surprisingly spacious and pleasantly cool, as though time itself has overlooked it."

/obj/item/clothing/gloves/roguetown/otavan/psygloves/uniqueStickyfingers
	name = "Stickyfingers"
	desc = "A pair of leather gauntlets draped in old spider silk. The webbing never seems to tear completely, instead clinging stubbornly to the wearer and anything they touch. They are not particularly durable, nor especially impressive to look upon. Yet objects have a curious habit of ending up in the wearer's hands. Coin purses loosen, clasps come undone, and unattended valuables seem just a little easier to acquire. Whether the silk possesses some subtle enchantment or merely encourages bad habits is a matter of debate. Most owners prefer not to discuss where they found them."
	var/active_item = FALSE
	var/expertstealing = FALSE

/obj/item/clothing/gloves/roguetown/otavan/psygloves/uniqueStickyfingers/equipped(mob/living/user, slot)
	. = ..()
	if(active_item || slot != SLOT_GLOVES)
		return
	var/current_stealing = user.get_skill_level(/datum/skill/misc/stealing)
	if(current_stealing)
		if(current_stealing < 4) // Only add up to expert
			active_item = TRUE
			expertstealing = FALSE
			user.adjust_skillrank(/datum/skill/misc/stealing, 1, TRUE)
			to_chat(user, span_notice("You feel as if you can reach out and take what you desire, but only just barely."))
		else
			active_item = TRUE
			expertstealing = TRUE
			to_chat(user, span_warning("There's a faint magic to the gloves, but it seems to have been fully realized. You feel no more capable than you did before."))
	else
		to_chat(user, span_warning("The gloves feel unremarkable in your hands."))

/obj/item/clothing/gloves/roguetown/otavan/psygloves/uniqueStickyfingers/dropped(mob/living/user)
	. = ..()
	if(active_item)
		if(user.get_skill_level(/datum/skill/misc/stealing))
			var/mob/living/carbon/human/H = user
			if(!expertstealing) // Only remove up to expert
				H.adjust_skillrank(/datum/skill/misc/stealing, -1, TRUE)
			if(H.get_item_by_slot(SLOT_GLOVES) == src)
				to_chat(H, span_notice("You feel as if your hands have lost their subtlety, and that you are no longer able to reach out and take what you desire."))
				active_item = FALSE
				return
		else
			return

/obj/item/rogueweapon/shovel/bronze/uniqueUndertaker
	name = "Undertaker"
	desc = "A sturdy bronze shovel bearing the name Undertaker. Though forged for honest labor, it has spent far more time opening graves than digging ditches. Its edge is worn smooth by countless burials, and its handle polished by generations of weary hands. Few tools have carried so many to their final rest. Fewer still have done so with such quiet dignity. In the end, every road leads to the Undertaker."

/obj/item/clothing/ring/shell/uniqueLostVow
	name = "Lost Vow"
	desc = "A simple shell ring bearing the inscription V&D. Countless years of wear have smoothed its edges, but not the devotion etched into its surface. The ring was recovered from a thief's hut, far removed from its rightful owner. One wonders whether the theft broke hearts, or merely confirmed what fate had already decided."

/obj/item/rogueweapon/huntingknife/idagger/warden_machete/uniqueReedfeller
	name = "Reedfeller"
	desc = "It bears within it a burning hatred for reeds. Fell them. Fell them all."
	max_integrity = 250
	max_blade_int = 250

/obj/item/clothing/head/roguetown/helmet/heavy/necrahelm/uniqueBonelinedHelm
	name = "bone-lined helm"
	desc = "Headwear commonly worn by Templars in service to Necra, lined with the bone of those that once drew breath. Ornate and ceremonial, it still serves as a grim reminder of the universal constant: One dae, you will die."

/obj/item/clothing/gloves/roguetown/plate/kote/uniqueBoneLinedGauntlets
	name = "bone-lined gauntlets"
	desc = "Gauntlets commonly worn by Templars in service to Necra, lined with the bone of those that once drew breath. Ornate and ceremonial, they still serve as a grim reminder of the universal constant: One dae, you will die."

/obj/item/clothing/suit/roguetown/armor/plate/full/uniqueBoneLinedArmor
	name = "bone-lined armor"
	desc = "Armor commonly worn be Templars in service to Necra, lined with the boens of those that once drew breath. Ornate and ceremonial, they still serve as a grim reminder of the universal constant: One dae, you will die."
	color = "#808080"
	undyeable = 1

/obj/item/clothing/under/roguetown/platelegs/iron/gronn/uniqueBoneLinedChausses
	name = "bone-lined chausses"
	desc = "Chausses commonly worn be Templars in service to Necra, lined with the boens of those that once drew breath. Ornate and ceremonial, they still serve as a grim reminder of the universal constant: One dae, you will die."

/obj/item/clothing/wrists/roguetown/bracers/hand/uniqueBoneLinedBracers
	name = "bone-lined bracers"
	desc = "Bracers commonly worn be Templars in service to Necra, lined with the boens of those that once drew breath. Ornate and ceremonial, they still serve as a grim reminder of the universal constant: One dae, you will die."

/obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn/uniqueBoneLinedBoots
	name = "bone-lined boots"
	desc = "Boots commonly worn be Templars in service to Necra, lined with the boens of those that once drew breath. Ornate and ceremonial, they still serve as a grim reminder of the universal constant: One dae, you will die."

/obj/item/clothing/neck/roguetown/gorget/aventail/uniqueBoneLinedGorget
	name = "bone-lined gorget"
	desc = "A gorget commonly worn be Templars in service to Necra, lined with the boens of those that once drew breath. Ornate and ceremonial, they still serve as a grim reminder of the universal constant: One dae, you will die."
	color = "#808080"
	undyeable = 1

/obj/item/clothing/head/roguetown/nyle/consortcrown/uniqueBentCirclet
	name = "bent circlet"
	desc = "Inlaid gemstones and opulent craftsmanship cannot change one simple fact: a troll stepped on it."
	sellprice = 50

/obj/item/clothing/mask/rogue/skullmask/uniqueOldChiefsSkull
	name = "old chief's skull"
	desc = "A mask carved from the skull of a deposed goblin chief. Curiously, the skull belongs to an orc. This raises uncomfortable questions about the chief's ancestry, and even more uncomfortable questions about the coup that removed him."

/obj/item/clothing/wrists/roguetown/bracers/psythorns/uniqueWrapOfWeepvine
	name = "wrap of weepvine"
	desc = "Hardened by the bog's magic, this length of living weepvine coils tightly around its wearer's wrist. The embrace is uncomfortable, even painful, but undeniably protective. Few things are as effective at discouraging unwanted grasps."

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/heavy/decorated/uniqueFenwrought
	name = "Fenwrought"
	desc = "Resplendent in gold, this armor lies tarnished beneath layers of mud and peat. The bog has little regard for wealth, glory, or noble blood. Even so, its old brilliance lingers beneath the filth. One need only wipe away the mud to reveal it once more."

/obj/item/rogueweapon/sword/long/hag/uniqueDiscardedBoon
	name = "discarded boon"
	desc = "When a fae speaks, do not listen. When it offers, do not accept. And as for its gifts, they are best discarded. You now gaze upon the remnants of a bargain long forgotten. Yet a troubling thought lingers still: by taking this thing into your possession, have you also inherited its price?"

/obj/item/roguegem/turq/uniqueSicklyCerulite
	name = "sickly cerulite"
	desc = "A malformed shard of cerulite whose swirling reflections never seem to settle into a coherent shape. Colors twist and coil beneath its surface like something alive, drawing the eye despite every instinct to look away. Prolonged observation brings with it a subtle nausea, as though the mind rejects what it is seeing. The sensation rarely grows beyond mild discomfort, yet few can gaze upon the stone for long without feeling unwell. Whether the flaw lies within the cerulite or within the viewer is a matter of some debate."
	sellprice =  45

/obj/item/rogueweapon/stoneaxe/woodcut/steel/decorated/uniqueMoorhauer
	name = "Moorhauer"
	desc = "A ceremonial axe once borne by a bogman marshal. Its ornate head remains sharp and resplendent, a testament to the esteem afforded its bearer. Such weapons were symbols of authority, and their edges rarely tasted common labor. Though the years have worn upon it, the axe remains remarkably well preserved."

/obj/item/clothing/head/roguetown/roguehood/ravoxgorget/uniqueBogcaptainsTabard
	name = "bogcaptain's tabard"
	desc = "The tabard of a bog captain, worn by those tasked with keeping order amid the mire. Though stained by mud and weather alike, its colors remain surprisingly vibrant, a testament to the pride once taken in the office."

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/uniqueMudtrudgers
	name = "Mudtrudgers"
	desc = "Their greatest virtue is a simple one. Even in the oppressive muck and stagnant waters of the bog, these boots keep the wearer's feet perfectly dry."
	max_integrity = ARMOR_INT_HELMET_HARDLEATHER + 50

/obj/item/rogueweapon/pick/paalloy/uniqueDefiant
	name = "defiant pickaxe"
	desc = "A well-worn mining pick bearing the name Defiant. It once belonged to a miner who challenged a giant mole for dominion over a rich vein of ore. Refusing to concede even as the tunnel collapsed around them, he saw the contest through to its bitter end. The mole survived to claim victory."
	max_integrity = 600

/obj/item/clothing/gloves/roguetown/plate/paalloy/uniqueJudgementAndSentence
	name = "Judgement & Sentence"
	desc = "A pair of battered plate gauntlets worn smooth by decades of hard use. Their former owner had little patience for courts or deliberation, preferring to render Judgment with one fist and Sentence with the other. Time has dulled neither."
	unarmed_bonus = 8

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/classic/uniqueLongshot
	name = "Longshot"
	desc = "Crafted with care and marked with the name 'Longshot.' There is little else remarkable about it. Still, someone thought enough of it to give it a name. May it serve you well."

/obj/item/reagent_containers/glass/cup/skull/uniqueEvylleGoblet
	name = "evylle goblet"
	desc = "Entirely mundane in construction, yet undeniably evylle in design. Carving a skull into a goblet is questionable enough; leaving the eye sockets open is another matter entirely. Any liquid poured within spills forth as tears, weeping endlessly for the soul sacrificed to create it."

/obj/item/reagent_containers/glass/cup/skull/uniqueEvylleGoblet/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_MISC)

/obj/item/legwears/silk/white/uniqueSpidersilkStockings
	name = "spidersilk stockings"
	desc = "Did spiders make these? The fabric is remarkably uniform, woven as though from a single impossibly long strand. Whatever their origin, these stockings are sinfully luxurious."
	sellprice = 30

/obj/item/rogueweapon/sword/long/oldpsysword/uniqueAdamant
	name = "Adamant"
	desc = "This longsword has endured wars, neglect, and generations of owners. The steel bears countless scars, yet none severe enough to claim it. Many hands have wielded it, and many finer swords have been buried in their stead. It remains. It endures. A mundane blade by all appearances, yet it carries within it the resolve of countless warriors whose determination held Psydonia together throughout His slumber. May their strength inspire you."
	max_integrity = 250

/obj/item/clothing/head/roguetown/helmet/heavy/guard/bogman/iron/uniqueDraftsmarch
	name = "Draftsmarch"
	desc = "A mundane helmet, yet one cared for well enough to earn a name. It passed from the hands of the bogmen into the service of the duchy's levy, carrying its purpose with it. The dents upon its iron stand as a reminder of a duty long inherited: keep a watchful eye upon the accursed bog, and slay whatever emerges from its depths."

/obj/item/reagent_containers/glass/bottle/waterskin/purifier/uniqueBogSipper
	name = "Bog Sipper"
	desc = "Born from a simple idea: what if we just drank the bog? No water, no swamp. No swamp, no overgrowth. To drink the bog is a duty passed down from the genius who first crafted this thing to every unfortunate soul who inherits it. The duty now falls to you."
	desc_uncorked = "Born from a simple idea: what if we just drank the bog? No water, no swamp. No swamp, no overgrowth. To drink the bog is a duty passed down from the genius who first crafted this thing to every unfortunate soul who inherits it. The duty now falls to you."

/obj/item/reagent_containers/glass/bottle/waterskin/purifier/uniqueBogSipper/pickup(mob/living/M)
	. = ..()
	if(ishuman(M))
		var/message = pick(
					"<span class='danger'>Drink the bog...</span>",
					"<span class='danger'>It is so yummy... Bog fluid. . .</span>",
					"<span class='danger'>The muck flavor...</span>",
					"<span class='danger'>Bogwater...Sipping... All of it. . .</span>",
					"<span class='danger'>Drink... Drink the bog... Drink...</span>")
		to_chat(M, "You feel a thought manifest: \"[message]\"")


/obj/item/rogueweapon/sword/sabre/mulyeog/uniqueKumoonsen
	name = "Kumoonsen"
	desc = "A hwando recovered from the depths of a spider-haunted hot spring. Neither rust nor decay have touched it. Fine mineral deposits and traces of old silk intertwine across the blade in intricate patterns no smith could have deliberately forged. The name Kumoonsen is etched into the tang. Whether it belonged to a traveler, a warrior, or something stranger has long since been forgotten."

/obj/item/rogueweapon/huntingknife/idagger/steel/bone/uniqueSharpenedFemur
	name = "sharpened femur"
	desc = "A makeshift tool darkened by old blood. It remains the sole piece of evidence that heresy, not misfortune, brought ruin to the coastal hamlet. It yearns for blood."

/obj/item/thetoll/uniqueStolenToll
	name = "stolen toll"
	desc = "A tithe for the carriageman, long overdue. Given the coin's age, one wonders whether it would still be accepted. The blood that seeps from its surface has nearly run dry."

/obj/item/rogueweapon/huntingknife/throwingknife/silver/preblessed/uniqueSilverSliver
	name = "Silver Sliver"
	desc = "A lone throwing knife, blessed in ages past. It could not save the one who carried it, but perhaps it may yet save you."

/obj/item/clothing/head/roguetown/helmet/heavy/volfplate/iron/uniqueBlackVolfGuise
	name = "Black Volf's Guise"
	desc = "The skull of a volf, cast over by iron and stained black by soot, blood, or time. Despite its savage appearance, the design is clearly inspired by a Warden's helm. The resemblance is fleeting, like a fond memory left to rot in the mud."
	color = "#363737"
	undyeable = 1

/obj/item/rogueweapon/sword/silver/decorated/uniqueVhes
	name = "Vhes"
	desc = "A decorated khadga of polished silver, its broad blade etched with intricate patterns that seem to writhe at the edge of vision. The weapon bears the name Vhes, though no record of its owner survives. It sits perfectly in the hand, balanced with an ease that feels almost unnatural. A strange familiarity clings to it. Those versed in forbidden lore may find their thoughts drifting toward cycles, recurrence, and the image of a serpent devouring its own tail, though few could say precisely why."
	max_integrity = 250

/obj/item/rogueweapon/sword/silver/decorated/uniqueVhes/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VHESLYN)

/obj/item/rogueweapon/huntingknife/idagger/silver/elvish/uniqueProgress
	name = "Progress"
	desc = "A slender elven dagger wrought from blessed silver. To many, this would be a contradiction: holy metal dedicated to an unholy cause. To the followers of Zizo, it was proof of their creed. Progress demands change, and change cares little for what was once considered sacred."

/obj/item/rogueweapon/spear/spellblade/uniqueIncentive
	name = "Incentive"
	desc = "A sturdy spear named Incentive, invariably employed when Reason failed to make its point. Its edge is well maintained, suggesting it saw frequent use in the settlement of disputes. Most travelers eventually found the wielder's arguments quite persuasive. Those who remained unconvinced rarely remained standing."

/obj/item/rogueweapon/shield/tower/raneshen/uniqueReason
	name = "Reason"
	desc = "A battered shield carried by a bandit who fancied himself a negotiator. Its face is scarred by arrows, axes, and countless failed arguments. Bearing the name Reason, it was presented first in any discussion. The wise accepted its terms and walked away poorer, but alive."

/obj/item/rogueweapon/greataxe/steel/doublehead/minotaur/uniqueGulletgrinder
	name = "Gulletgrinder"
	desc = "A massive double-headed axe favored by minotaur warriors. Its twin blades are broad enough to cleave shield and bearer alike, but its grim name comes from a more deliberate craft. One hook drags prey close; the other finishes the work. Gulletgrinder is not a title earned lightly."
	max_integrity = 300

/obj/item/clothing/mask/rogue/spectacles/sglasses/uniqueLostScholarsSpectacles
	name = "lost scholar's spectacles"
	desc = "A pair of spectacles crafted from smoky Onyxa, their dark lenses catching and twisting the light into strange patterns. Despite their age, they remain remarkably clear, as though their owner cleaned them one final time before setting them down and never returning. Looking through the lenses brings an odd sensation of recognition, as if a forgotten insight lingers just beyond reach. The feeling never lasts. Whatever knowledge these spectacles once helped uncover was lost long before the spectacles themselves."

/obj/item/rogueweapon/huntingknife/idagger/blacksteel/heavy/uniqueSuddenBetreyal
	name = "Sudden Betreyal"
	desc = "A slender misericorde designed to slip through the gaps in armor and finish fights already won. Its blade bears the name 'Sudden Betrayal', though there is little about it that feels sudden at all. The weapon rewards patience, hesitation, and moments of misplaced trust. More than one warrior met their end believing the worst had already passed. It is a cruel truth that the deadliest strike is often the one delivered by a hand thought friendly."


/obj/item/rogueweapon/greatsword/grenz/flamberge/paalloy/uniqueInHerName
	name = "In Her Name"
	desc = "Polished gilbranze ripples like living flame. Its edge is vicious, its crossguard deliberate and evocative. This weapon exists for a singular purpose: to deliver Progress, in Her name."

/obj/item/rogueweapon/sword/rapier/blacksteel/uniqueClaimant
	name = "Claimant"
	desc = "Forged from lustrous blacksteel, this rapier gleams with a dark beauty matched only by its precision. Its name speaks not of possession, but aspiration. A claimant is not yet a ruler, merely one determined to become one."

/obj/item/clothing/cloak/darkcloak/bear/uniqueWornDirebearPelt
	name = "worn direbear pelt"
	desc = "Strange for a bear to hoard a cloak fashioned from the hide of its own kin. A faint scent of the creature still lingers within the fur. Perhaps it was mourning."

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/aalloy/uniqueBogmansRetort
	name = "Bogman's Retort"
	desc = "An old crossbow, darkened by peat, rain, and years of hard service in the mire. Its stock bears the scars of rough repairs, while its mechanism creaks in protest with every draw. It earned the name Bogman's Retort from those unfortunate enough to mistake a bogman for an easy target. In the bog, words travel poorly through the fog, and answers are often given at range. Age has claimed much of the weapon's former strength, but not its attitude. It remains as stubborn and disagreeable as the people who carried it."

/obj/item/clothing/neck/roguetown/psicross/wood/uniqueLovinglyHandcarvedPsycross
	name = "lovingly handcarved psycross"
	desc = "This psycross has been meticulously hand-carved. There is nothing remarkable about it, save for the care that went into its creation. It must have meant something to someone, once. Holding it stirs a faint sense of enduring."

/obj/item/bodypart/r_leg/prosthetic/bronzeright/uniqueGnawedProsthetic
	name = "gnawed prosthetic"
	desc = "It's marred with bite-marks and slightly rusted. With some love and care, it could help someone walk again."

/obj/item/rogueweapon/spear/boar/uniqueGutskewer
	name = "Gutskewer"
	desc = "A broad-bladed spear whose name leaves little room for interpretation. Gutskewer was not crafted for elegant duels or heroic charges, but for the brutal reality of close combat, where a few inches of steel can decide the fate of a warrior."
	force_wielded = 35
	max_blade_int = 250

/obj/item/clothing/head/roguetown/helmet/headcage/uniquePrisonOfTheMind
	name = "prison of the mind"
	desc = "The screams of its previous owner were silenced when their tongue was severed. Their treachery was blinded when their eyes were taken. Deafened by age and robbed of every means to perceive the world, they were left trapped within themselves. A fate worse than death."
	var/active_item = FALSE
	var/legendaryarcane = FALSE

/obj/item/clothing/head/roguetown/helmet/headcage/uniquePrisonOfTheMind/equipped(mob/living/user, slot)
	. = ..()
	if(active_item || slot != SLOT_HEAD)
		return
	var/current_arcane = user.get_skill_level(/datum/skill/magic/arcane)
	if(current_arcane)
		if(current_arcane < 6)
			active_item = TRUE
			legendaryarcane = FALSE
			user.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
			user.change_stat(STATKEY_INT, 2)
			user.change_stat(STATKEY_PER, 1)
			ADD_TRAIT(user, TRAIT_PSYCHOSIS, TRAIT_GENERIC)
			to_chat(user, span_notice("Your mind expands, but something horrible lingers at the edge of your vision."))
		else
			active_item = TRUE
			legendaryarcane = TRUE
			user.change_stat(STATKEY_INT, 2)
			user.change_stat(STATKEY_PER, 1)
			ADD_TRAIT(user, TRAIT_PSYCHOSIS, TRAIT_GENERIC)
			to_chat(user, span_warning("Your mind expands slightly, but something horrible lingers at the edge of your vision."))
	else
		to_chat(user, span_warning("This helmet feels uncomfortable."))

/obj/item/clothing/head/roguetown/helmet/headcage/uniquePrisonOfTheMind/dropped(mob/living/user)
	. = ..()
	if(active_item)
		if(user.get_skill_level(/datum/skill/magic/arcane))
			var/mob/living/carbon/human/H = user
			if(!legendaryarcane)
				H.adjust_skillrank(/datum/skill/magic/arcane, -1, TRUE)
			user.change_stat(STATKEY_INT, -2)
			user.change_stat(STATKEY_PER, -1)
			REMOVE_TRAIT(user, TRAIT_PSYCHOSIS, TRAIT_GENERIC)
			to_chat(H, span_notice("You breathe a sigh of relief. The torment has faded."))
			active_item = FALSE
		else
			return

/obj/item/clothing/head/roguetown/helmet/headcage/uniquePrisonOfTheMind/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_VHESLYN)

/obj/item/rogueweapon/spear/lance/blacksteel/uniqueResplendence
	name = "Resplendence"
	desc = "Despite being forged from blacksteel, Resplendence refuses to drink in the light as its kin do. Instead, the lance shines with a fierce, radiant gleam, scattering brilliance across its polished surface. Whether through enchantment, craftsmanship, or sheer force of purpose, it defies the nature of the metal from which it was made. Its edge sparkles with unsettling clarity, as though eager to see itself reflected in glory. Held in hand, one cannot escape the feeling that the lance yearns for some grand purpose, some noble charge, some worthy tale."

/obj/item/rogueweapon/mace/goden/steel/paalloy/uniqueGrabbedat
	name = "Grabbedat"
	desc = "Once a revered weapon of ancient heroes, now known exclusively as Grabbedat. The name commemorates the exact circumstances under which the goblins acquired it.Historical accounts suggest the transfer of ownership was neither legal nor amicable. Goblin historians maintain that if somebody wanted to keep it, they should have held on tighter."
