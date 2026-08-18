/datum/vision_quest/tier_1
	name = "The Void"
	description = "There's nothing."
	required_tier = 1
	possible_rewards = list(
		/obj/item/dream_material/dream_spike = "effervescent spikes",
		/obj/item/dream_material/parchment_raw = "imagined parchment",
		/obj/item/dream_material/dream_ring = "gleaming rings"
	)
	possible_bonus_rewards = list(
		/obj/item/dream_material/dream_spike = "effervescent spikes",
		/obj/item/dream_material/parchment_raw = "imagined parchment",
		/obj/item/dream_material/dream_ring = "gleaming rings",
		/obj/item/dream_material/dream_seed = "dream seeds"
	)
	target_description = "unknown"
	summary = "There are grander things out there."
	vision_text = "The feeling surrounding me is familiar as I awaken. \
	Ammonia in the air, warped walls like dripping paint. \
	The Deepfather's realm. Oddly tranquil this time. No nightmares in sight. \
	Just more of those trusted images. The town of Azure... The distant broiling of a full inn. \
	Yet something is off. The darkened night sky seems to be crawling. \
	Like a maggot burrowed under the skin, a facade for something else. \
	Building shrink and wane at the edges of my sight, as the sky swells, the edges rippling like a puddle of water. \
	Am I one with the town? No. We're smudged at the edge of the puddle. \
	A single drop of swirling, diluted paint besides an infinity of uniform liquid. \
	An ever looming shadow expands within the center of the puddle. \
	Massive sharpened fangs part the surface one by one, whatever creature owns such a jaw... \
	Ripples sent forth, as we drift further apart, further into the endless dark. \
	Yet- a single crescent shape lights up the surface nearby. Noc's gaze. All is obscured at once."
	possible_phrases = list(
		"Ignorance is bliss",
		"We are but a speck",
		"Reality is greater than us",
		"The serpent lurks"
	)

/datum/vision_quest/tier_1/psydon_vision_bad
	name = "Psydonic Vision"
	description = "A psydonite stands in Abyssor's gaze. You are the prophet, you will deliver his missive."
	target_description = "an Orthodoxist"
	summary = "A psydonite's faith in the light of a true vision."
	vision_text = "The mists part to reveal someone clad in Orthodoxist vestments, their silver icons gleaming. \
	You see them preaching to a crowd, but their eyes betray uncertainty. Their faith is a hollow shell, built on sand. \
	Confront them, and watch the cracks form. \
	\n\nSuddenly, you find yourself deep beneath the earth. A chamber hollowed out in rock by Malum, like a cathedral. \
	A large, elderly figure lies quietly in a bed of gigantic, thorny roses. Briars cut the flesh, marring the skin. \
	Wounds ooze crimson. the wine of life decanted into hungry roots, carrying the essence far and wide. \
	The old god stands no more... But you need to know, your calloused hands fighting the thorns to clamber up a gigantic palm. \
	It is arduous, a journey which feels like hours... stretching on into days, hands digging into bits of loose skin like a misshapen ladder. \
	Sides like a mountain, the torso stretching on like a desert. Was He ever this large? Did your eyes deceive you? It has been too long to remember anything clearly. \
	Then the jaws, stretching on like the gate to Necra's domain. With the end in sight, it is as if the very sweat crawls back into your flesh. \
	The howling winds you anticipate, yet the hollow stays silent. Pale curtains cover what should be basking in His glory, His caring gaze. \
	O Psydon, why have you forsaken us so?"
	possible_phrases = list(
		"Psydon is dead",
		"The seas sing a somber dirge for him",
		"Psydon is dead, I saw it in a dream"
	)
	valid_roles = list("Orthodoxist","Inquisitor","Absolver")

/datum/vision_quest/tier_1/wounded_tennite
	name = "Wounded Pilgrim"
	description = "A faithful tennite limps. Abyssor's waters will close their wounds."
	target_description = "a Tennite"
	summary = "A wounded lamb whom may require your aid."
	vision_text = "The mists part to reveal a trail of blood. Crimson droplets staining the stone like a rosary of suffering. \
	You follow it to its source. A Tennite pilgrim, collapsed against a weathered shrine too damaged to identify. Their leg is savaged, \
	the flesh torn by something with claws like fishhooks. They clutch a rusted icon of the Gods, whispering prayers \
	between ragged breaths. Their eyes, clouded with pain, search the fog for salvation or death. \
	\n\nAs you approach, the vision shifts. You stand at the edge of an endless sea, black and restless beneath a moonless sky. \
	The waters churn, parting to reveal a path of jagged coral that leads to a submerged cathedral. Inside, a figure kneels \
	the pilgrim, whole and unbroken, dipping their hands into a pool of shimmering waters. Abyssor's voice rumbles from the depths, \
	not in words, but in the crash of waves against the shore. 'The faithful are not measured by their scars, but by their \
	willingness to rise from them.' The pilgrim rises, and the sea closes \
	behind them. \
	You blink, and you are back in the mist. The pilgrim stirs, their wounds weeping. They will not survive the night \
	without intervention. Will you be the hand that pulls them from the tide, or will you watch them drown?"
	possible_phrases = list(
		"The faithful do not bleed upon corrupt soil",
		"Bury whom wounds or suffer their grief"
	)

/datum/vision_quest/tier_1/wounded_tennite/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(!..())
		return FALSE
	if(target.getBruteLoss() < 50)
		return FALSE
	if(!target.patron)
		return FALSE
	var/list/tennite_gods = ALL_DIVINE_PATRONS
	if(!(target.patron.type in tennite_gods))
		return FALSE
	return TRUE

/datum/vision_quest/tier_1/royal_tick
	name = "A Terrible Disease"
	description = "The royal family, endangered. But they know naught."
	target_description = "a member of the royal family"
	summary = "Leechticks are a danger to the world."
	vision_text = "The mists part to reveal a tiny image of a creeping, crawling tick. \
	It is too small to be observed by the naked eye, but you've seen the truth. \
	Our great Azurean royalty, endangered by the smallest of foes. \
	Between the toes, vile and unending, the tick seeks to suck out their lux. \
	It is not the almighty hordes from the north. But one of the smallest pieces of divinity that threatens the realm. \
	How was this evil left unnoticed for so long? Their grace ails, but all are blinded, all but you. \
	Not the impurity of blood, the imbalancing of humors, but one of Pestra's most humble servants misguided"
	possible_phrases = list(
		"You must wash your left foot",
		"You must wash your right foot",
		"You must take a bath",
		"The realm requires you cleanse yourself",
		"A bath will save your life"
	)
	valid_roles = list("Grand Duke","Grand Duchess","Prince", "Princess")

/datum/vision_quest/tier_1/abyssor_sleeping
	name = "The Deepfather"
	description = "He calls out from depths, you answer."
	target_description = "an abyssorite"
	summary = "A beautiful sleeper."
	vision_text = "Darkness envelops me. \
	The light of the surface seems akin to a distant shimmer. \
	I am in His presence, within his Realm. \
	Roiling sands that undulate with the movements of His divine creatures. \
	Plants that light up with the faces of those I know well, older aquaintances faded. \
	Yet the stangeness pales in comparison to His form, as I float above to behold divinity. \
	An old grizzled man, wrinkles akin to the very waves that dance above. Frozen in time. \
	His body twists and turns, the waves above respond... A grand wave rising far above even castles. \
	Some empty rock in the ocean enveloped, crumbling apart into the depth beneath. \
	Abyssor turns once more, your heart sinks. You know those waters... Azure- \
	All of them will drown. The seas will swallow up every last soul. Lux extinguished. \
	Yet the light of the faithful burns bright like a lighthouse fire. Illuminating the waters. \
	His sleeping grace pauses, a hand adjusting his path. Cautiously lowering Himself down. The seas remain still."
	possible_phrases = list(
		"The deepfather sees you",
		"We are chosen by Abyssor",
		"The waves will not harm us",
		"The waves spare us for now"
	)

/datum/vision_quest/tier_1/abyssor_sleeping/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(!..())
		return FALSE
	if(!target.patron || !istype(target.patron, /datum/patron/divine/abyssor))
		return FALSE
	return TRUE

/datum/vision_quest/tier_1/dance_macabre
	name = "The Dance"
	description = "The fool embraces."
	target_description = "a fool"
	summary = "One's legs must keep moving."
	vision_text = "As the drowsiness overtakes me... \
	Hands intertwined, finding the palms of another. \
	We dance the night away, and the next. \
	Hearts racing, eyes gazing. Everyone sees us, and we see them. \
	The town elder is there to congratulate us. \
	Oh, wait, the court magician is there too. \
	Even the guildmaster, the steward, no, the very duke is here! \
	There's no one like us, no one dances so gracefully. With such... mesmerizing fervor! \
	Even the very history recorded upon the ancient tomes will be just us. \
	Just us dancing. Showing Psydonia, showing everyone how it's done. \
	Abyssor? Does it please thee?"
	possible_phrases = list(
		"Take my hand and dance",
		"We are meant to be",
		"You and I, two peas in a pie",
		"Saigas wish they had our moves"
	)
	valid_roles = list("Jester")

/datum/vision_quest/tier_1/bottomless_maw
	name = "The Bottomless Maw"
	description = "A mortal forgets their place at the table."
	summary = "A reminder of the hunger that waits below."
	vision_text = "The mists part to reveal a table groaning under the weight of rotten meats and gold plates. \
	You see someone stuffing their face, ever bloating as morsels threaten to squeeze their gullet shut. \
	Suddenly, you are staring into an endless abyss. There's only the impending glint of something collosal at the bottom, and you're sinking so swiftly that water occupies every last bit of your lungs. \
	At the bottom, a colossal golden maw opens, catching the debris of the world. Every scrap, every hapless fool, hopes and dreams are no exception. \
	It never fills. Yet it desires more. Crying out with an everlasting hunger that draws others such as yourself. \
	Your flesh rotten, putrid like your lux. The maw cares not."
	possible_phrases = list(
		"you are hunger itself",
		"feast not so greedily",
		"you starve in a palace of plenty"
	)

/datum/vision_quest/tier_1/bottomless_maw/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(!..())
		return FALSE
	if(target.nutrition > 350)
		return FALSE
	return TRUE

/datum/vision_quest/tier_1/wandering_doubter
	name = "Too little faith"
	description = "A soul seeks proof of the Gods."
	target_description = "a doubter"
	summary = "Doubt is the root of evil."
	vision_text = "The mists part to reveal a barren plain, stretching endlessly in all directions. \
	A figure wanders, their feet bare, their clothes torn, their eyes scanning the horizon for a sign that never comes. \
	They carry a tattered book, its pages filled with crumbling, fading hymns. \
	They have walked for days. No. Years, for proof of the divine. \
	You approach, and they stop. 'I have asked the Gods to speak,' they say, their voice cracking. \
	'I have offered my blood, my tears, my lux. And they remain silent. Is there anyone there?' \
	You silence them with a finger. Letting the sands pass through your fingers. \
	'Malum shaped these sands. You seek with open eyes, ears poised for a sign. Yet you are deafened and blinded by your own ignorance.' \
	in the dark. The doubter weeps. 'I have been waiting for a sign' they say. 'But really, I'm just a fool.' \
	Eyes did not close again. Ears ever alert. The wanderer perked up, hearing the song of the gods once more."
	possible_phrases = list(
		"the work of the gods surrounds us",
		"doubt is the root of evil",
		"the ten shaped these lands"
	)

/datum/vision_quest/tier_1/wandering_doubter/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(!..())
		return FALSE
	if(target.get_skill_level(/datum/skill/magic/holy) > 0)
		return FALSE
	return TRUE

/datum/vision_quest/tier_1/dull_blade
	name = "The Dull Blade"
	description = "A warrior has forgotten how to do anything but fight."
	target_description = "a warrior"
	summary = "Even the sharpest blade needs a sheath."
	vision_text = "The mists part to reveal a workshop. \
	Tools hang on the walls. Hammers, saws, chisels, each one well-worn and cared for. \
	A figure stands at the workbench, but it is not a warrior. It is... you. \
	Your hands are covered in sawdust and wood shavings, and you are carving something delicate, something that has nothing to do with battle.\
	A small fish carving... \
	You blink. The workshop is gone, replaced by a battlefield littered with bodies. \
	A warrior stands among them, their sword dripping with blood. \
	They always win, you can tell it from their gait, their gaze. \
	But the weight of their victories lies heavy on them.\
	They look down at their rough, calloused... Deadly hands. \
	They know only the grip of a weapon. They have forgotten the feel of anything else. \
	Your voice, gentle and amused, speaks from the mist. \
	'You have honed your edge so finely that you have become a weapon and nothing more. \
	But even the sharpest sword grows dull if it never rests. Tell me, warrior, when was the last time you made something? \
	When was the last time you planted a seed, baked a loaf, or carved a simple wooden toy?' \
	The battlefield crumbles, and you stand with them in a garden. \
	A single flower blooms at their feet, its petals soft and fragile. \
	They reach down to touch it, fingers shaking in hesitation. 'I don't know how to be gentle anymore'. \
	'That' you say, 'is why you are here. Not to fight. But to remember how to grow.'"
	possible_phrases = list(
		"when have you last baked a loaf",
		"even the sharpest blade needs a sheath",
		"a true warrior creates",
		"flowers will wilt in your rough grip",
		"there is a world beyond battle",
		"when have you last planted a seed"
	)

/datum/vision_quest/tier_1/dull_blade/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(!..())
		return FALSE

	// All non-combat skills that represent hobbies/crafts/labor
	var/static/list/hobby_skills = list(
		/datum/skill/labor/farming,
		/datum/skill/labor/mining,
		/datum/skill/labor/fishing,
		/datum/skill/labor/butchering,
		/datum/skill/labor/lumberjacking,
		/datum/skill/craft/crafting,
		/datum/skill/craft/weaponsmithing,
		/datum/skill/craft/armorsmithing,
		/datum/skill/craft/blacksmithing,
		/datum/skill/craft/smelting,
		/datum/skill/craft/carpentry,
		/datum/skill/craft/masonry,
		/datum/skill/craft/traps,
		/datum/skill/craft/engineering,
		/datum/skill/craft/cooking,
		/datum/skill/craft/sewing,
		/datum/skill/craft/tanning,
		/datum/skill/craft/ceramics,
		/datum/skill/craft/alchemy,
		/datum/skill/misc/music,
		/datum/skill/misc/hunting
	)
	for(var/skill_type in hobby_skills)
		if(target.get_skill_level(skill_type) > SKILL_LEVEL_APPRENTICE)
			return FALSE
	return TRUE

/datum/vision_quest/tier_1/weight_of_chains
	name = "The Weight of Chains"
	description = "A knight bears chains they forged themselves."
	target_description = "a penitent"
	summary = "Penance is a weight you must learn to carry."
	vision_text = "A knight kneels in a circle of stones, chains draped across their shoulders. \
	They forged each link themselves... From the armor of allies they failed to protect. \
	Each clink is a reminder, the weight a sin given form. \
	They have worn them for so long that the rust has liquefied parts of their armor, fusing to skin. \
	They try to rise. The chains hold them down. They try to pray but metal is coiled tightly around the lips. \
	'I cannot bear this weight forever' Words do not leave their mouth, you simply read their gaze. \
	The very winds themselves answer. 'You will not have to. But you must carry it until you are absolved through penance.' \
	The chains do not grow lighter. But the knight's back straightens, just slightly."
	possible_phrases = list(
		"you forged these chains yourself",
		"learn to carry your sins"
	)
	valid_roles = list("Templar", "Knight", "Sergeant", "Men-at-arms", "Squire", "Mercenary", "Warden")

/datum/vision_quest/orthodoxist_echo
	name = "Psydonic Vision"
	description = "A psydonite stands in Abyssor's gaze. You are the prophet, you will deliver his missive."
	target_description = "an Orthodoxist"
	summary = "A psydonite's faith in the light of a true vision."
	vision_text = "The mists part to reveal an Orthodoxist straining their ears against an empty shell, listening for a dead whisper. \
	They seek a voice, no one answers, yet they persist desperately. \
	Confront them, and make them hear them realise they are not listening in vain. \
	\n\nSuddenly, you stand in a hollow abyss. Gradually, the sides illuminate to show a shimmering pearlescent hue. Like the inside of a seashell. \
	In the center rests another. The shell of a hermit crab. Though no crustacean rests within, instead the fingers of a hand extend from the opening. \
	Alongside the lingering chime of a voice spoken millennia ago, still bouncing off the shell walls. \
	The speaker has moved beyond, yet the song stays trapped in the depths forever. \
	When you return, the orthodoxist yet listens. You direct them to clamber into the shell, for His voice does not pierce the armor of ignorance. \
	O Psydon, your voice remains long after the throat quiets."
	possible_phrases = list(
		"The ocean holds His echo",
		"Psydon's song endures",
		"Listen to the shell, Psydon calls"
	)
	valid_roles = list("Orthodoxist","Inquisitor","Absolver")

/datum/vision_quest/tier_1/royal_stag
	name = "A Terrible Omen"
	description = "The nobles of Astrata, endangered. But they know naught."
	target_description = "an influential individual"
	summary = "Dendor's angel lurks in the woods."
	vision_text = "The mists part to reveal the beautiful cadence of cervine limbs. \
	Elegant, yet worrisome. The large creature of alabaster luster, never filling the entiriety of your view. \
	For so it is grand, so it is hard to capture. Not just in a literal sense, evading hunter and observer alike. \
	It's like it can feel you watching its gait from afar. \
	Your mind and body wanders, finding yourself cozy in your bed. A tower suspended far above the soil. \
	The gruff of a beast's nostrils flaring, until the haunting gaze of the beast is before your window. \
	You have sinned, and it will collect. \
	The men posted outside of your chambers are slain, heaved apart in hues of scarlet. \
	A head rolls against the edge of your bed, accusing eyes stare back into your soul. \
	This is your fault, how many more will have to perish due to your hubris?"
	possible_phrases = list(
		"The white stag watches you sleep",
		"The white stag wishes for your demise",
		"The white stag will pursue you",
		"The white stag will end you",
		"The White Stag marks you guilty"
	)
	// Same as royal tick, but with some other influential roles as well.
	valid_roles = list("Grand Duke","Grand Duchess","Prince", "Princess", "Steward", "Councillor", "Merchant")

/datum/vision_quest/tier_1/seven_daes_of_wrath
	name = "The Sevenfold Reckoning"
	description = "A week of strange portents grips Astrata's light, but only one Dae brings true misfortune."
	possible_bonus_rewards = list(
		/obj/item/dream_material/dream_spike = "effervescent spikes",
		/obj/item/dream_material/parchment_raw = "imagined parchment",
		/obj/item/dream_material/dream_ring = "gleaming rings",
		/obj/item/dream_material/dream_seed = "dream seeds",
		/obj/effect/spawner/lootdrop/roguetown/dream_material/geyser = "random geyser seeds"
	)
	target_description = "someone misfortunate"
	summary = "A vision of seven strange days unfolding across the kingdom."
	vision_text = "The grand work of the ten spins out of rhythm, unspooling seven strange dawns. \
	On Moon's Dae, the tides rise backward, flooding dry stone with silver salt water. \
	On Truce's Dae, iron chains turn to soft lead and iron locks slide open unbidden. \
	On Wedding's Dae, every shadow splits in two, mocking the solitary walking above. \
	On Thunder's Dae, lightning strikes in dead silence, reducing watchtowers to dust. \
	On Feast's Dae, fresh bread turns rotten upon touching living lips. \
	On Psydon's Dae, blind fish surface in the palace fountains, gasping for air. \
	On Sun's Dae, the sun stands motionless at noon, burning those who speak lies. \
	Six dawns shall pass as mere curiosities, but one shall bring true sorrow."
	possible_phrases = list(
		"Moon's Dae was and shall be an ill day",
		"Truce's Dae was and shall be an ill day",
		"Wedding's Dae was and shall be an ill day",
		"Thunder's Dae was and shall be an ill day",
		"Feast's Dae was and shall be an ill day",
		"Psydon's Dae was and shall be an ill day",
		"Sun's Dae was and shall be an ill day"
	)

/datum/vision_quest/tier_1/seven_daes_of_wrath/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(!..())
		return FALSE
	if(target.STALUC > 12)
		return FALSE
	return TRUE

/datum/vision_quest/tier_1/day_one_moon
	name = "The False Reflection"
	description = "The mirrors of the land weep silver, refusing the faces of the living."
	target_description = "unknown"
	summary = "Reflections disconnect from reality under the tide of Moon's Dae."
	vision_text = "The pool turns quicksilver and smooth like that of a mirror. \
	You lean close, but the face looking back is not your own, ut is an empty husk with eyes of mercury. \
	When you step away, the reflection remains bound to the frame, pressing its hands against the surface. \
	Faraway the tide swells, drowning the land with abnormally high waves. \
	Ever mirror in the region wails with cries trapped behind the glass. \
	Even the waves turn silver, the faces familiar, embedded in the sea. \
	The slightest puddle of liquid shows fingers trying to break through desperately, warping the otherwise still fluid from underneath. \
	Moon's Dae brings a shadow that steals your likeness."
	possible_phrases = list(
		"Moon's Dae brings a drowned face, avoid the water",
		"On Moon's Dae your reflection rots, avoid that which mirrors",
		"You shant be yourself on Moon's Dae, avoid yourself"
	)

// Can't be past moon's dae
/datum/vision_quest/tier_1/day_one_moon/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	var/current_day = get_current_day_of_week()
	if(current_day > 1)
		return FALSE
	if(!..())
		return FALSE
	return TRUE

/datum/vision_quest/tier_1/day_two_truce
	name = "The Unspooling Binding"
	description = "The strongholds' chains fray into dust, and signed treaties bleed through parchment."
	target_description = "unknown"
	summary = "No bond or lock holds fast when Truce's Dae dawns."
	vision_text = "The heavy iron shackles in the dungeon slide apart like the very chains are melting. \
	Vault doors swing open without a whisper, their bolts disintegrating into fine red rust. \
	In the high council chamber, the wax on the treaties liquefies, smelling of scorched marrow. \
	Knots in the sails unravel into thin, black worms that writhe toward the sea. \
	Mercenaries don't just shed bonds to their employers, what little morals bind their actions are consumed. \
	The widower kneels, his hands crawling with blood that festers, leaving the rest of his skin pale as parchment. \
	Betrayal, negligence, it is as rife within the people as the disease carried by rous. \
	Truce's Dae renders every promise moot."
	possible_phrases = list(
		"Truce's Dae snaps every chain",
		"On Truce's Dae no secret stays bound",
		"Truce's Dae rejects promise",
		"Trust no oath made on Truce's Dae"
	)

/datum/vision_quest/tier_1/day_two_truce/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	var/current_day = get_current_day_of_week()
	if(current_day > 2)
		return FALSE
	if(!..())
		return FALSE
	return TRUE

/datum/vision_quest/tier_1/day_three_wedding
	name = "The Duplicated Shadows"
	description = "Everything touched by ceremony sprouts a twin, mocking the sacred union."
	target_description = "unknown"
	summary = "Surreal multiplication plagues the altars on Wedding's Dae."
	vision_text = "A ringing bell echoes twice, but the second tone vibrates in your teeth like the scraping of bone. \
	The hollowed bride steps forward, but a second shadow walks three paces behind her, unattached to feet. Freed from bindings. \
	The chalice holding high spirits splits in two, spilling wine that congeals like blood. \
	Astrata and noc alike hover low over the chapel spire, dousing the premise in darkness. blind eyes staring down at the congregation. \
	The crowd laugh not in celebration, but at the endless tragedy promised by a raised dagger in shadowy fingers, powerless to prevent tragedy. \
	A priest unwilling to complete a doomed union, yet the hand around his neck will not relent. \
	Wedding's Dae bring false happiness."
	possible_phrases = list(
		"Wedding's Dae spawns a second shadow",
		"On Wedding's Dae two gods will bicker",
		"Wedding's Dae brings false happiness",
		"Wedding's Dae unravels the union between lovers",
		"Wedding's Dae hollows the soul"
	)

// Since this is starting day three, let's start taking a spare day to decrease the chance the day is about to pass.
/datum/vision_quest/tier_1/day_three_wedding/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	var/current_day = get_current_day_of_week()
	if(current_day > 2)
		return FALSE
	if(!..())
		return FALSE
	return TRUE
