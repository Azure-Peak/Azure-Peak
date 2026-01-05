/obj/item/merctoken
	name = "writ of commendation"
	desc = "A small, palm-fitting bound scroll - a writ of commendation for a mercenary in the Duchy of Azure Peak."
	icon_state = "merctoken"
	icon = 'icons/clothing/mercmedals.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.5
	firefuel = 30 SECONDS
	sellprice = 2
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	var/signee = null
	var/signeejob = null
	var/signed = 0

/obj/item/merctoken/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!user.can_read(src))
			to_chat(user, "<span class='warning'>Even a reader would find these verba incomprehensible.</span>")
			return
		if(signed == 1)
			to_chat(user, "<span class='warning'>This writ has already been signed.</span>")
			return
		if(user.can_read(src))
			if(user.mind.assigned_role == "Mercenary")
				to_chat(user, "<span class='warning'>...have I really stooped so low as to sign my own commendation?</span>")
				return
			if(user.mind.assigned_role != "Mercenary") // AZURE: anyone can hire a mercenary
				signee = user.real_name
				signeejob = user.mind.assigned_role
				visible_message("<span class='warning'>[user] writes their name down on the token.</span>")
				playsound(src, 'sound/items/write.ogg', 100, FALSE)
				desc = "A small, palm-fitting bound scroll that can be sent by mail to the Guild. Most of the fine print is unintelligible, save for one bold SIGNEE: [signee], [signeejob] of Azure Peak."
				signed = 1
				return
		else
			if(signed == 0)
				to_chat(user, "<span class='warning'>This could be signed with a quill... or a thorn, if one was desperate.</span>")
				return
			return


/obj/item/clothing/neck/roguetown/luckcharm/mercmedal
	name = "mercenary medal"
	desc = "A medal commemorating a job \"well\" done."
	icon = 'icons/clothing/mercmedals.dmi'
	mob_overlay_icon = 'icons/clothing/onmob/mercmedals.dmi'
	icon_state = "gryphon"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	sellprice = 15

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/grenzelhoft
	name = "imperial gryphon"
	desc = "A parody of the brass medal issued to Grenzelhoftian soldiers of great honor and renown. Frequently adopted as medals by other, younger guilds among the mercenaries of PSYDONIA, with slight adjustment."

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/blackoak
	name = "guardian's seedpouch"
	desc = "A pouch, sealed tight, bearing the acorn of an oak native to the Azure Basin. May your end be a new beginning for Azurea."
	icon_state = "blackoak_pouch"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/condottiero
	name = "condottiero's hilt"
	desc = "A beautiful silver necklace with pea-sized rontz inlays. Each is a work of art in itself; handcrafted by a master jeweler of Etrusca. This is the blade to which the \
	condottiero has sworn their lyfe."
	icon_state = "condo_blade"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/desertrider
	name = "desert rider's sash"
	desc = "A luxuriant golden chain worn about the shoulders or neck, a sign of high honor in distant Raneshan. Some claim these are a testament to the origins of the Desert Riders in distant slave-fighting pits, but \
	others think them marks of favor from the highest echelons of the Empire. The desert riders confirm neither rumour."
	icon_state = "rider_sash"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/forlorn
	name = "laughing volf medal"
	desc ="A trinket bearing the snarling visage of a volf and bolt, a mark of distinction among the Forlorn Hope. Often taken from the dead and issued anew to the living, each bearing \
	lyfetymes of nicks and scratches."
	icon_state = "forlorn_dogmedal"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/freifechter
	name = "freifechter's obol"
	desc = "A descendant of the oft-forgotten psilen, with a hole through one end for hanging on a string. With the advent of mammon as the Western Continent's currency of choice, \
	they find new lyfe worn as marks of skill by freifechters."
	icon_state = "freif_obol"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/atgervi
	name = "northmanne's idol"
	desc = "A humble token of tightly-wound canvas, fur, and wood. A piece of home, clutched tight against the chest. Feel its heart beat in tyme with your own. Even here, in distant Azure Peak, \
	the gods walk, and they walk with you."
	icon_state = "atgervi_idol"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/grudgebearer
	name = "grudgebearer's keepsake"
	desc = "\"Fergive? FERGET? PFAH! GO T'HEL!\""
	icon_state = "grudge_keepsake"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/underdweller
	name = "underdweller's broken compass"
	desc = "The underdwellers claim this will always point you exactly where you need to go. If it doesn't work, that's just an issue of skill and mindset."
	icon_state = "under_compass"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/kazengun
	// NOT CURRENTLY IMPLEMENTED

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/routier
	name = "otavan silvered halo"
	desc = "A fragment of blessed Otavan steel, carefully wrought into an unusual halo-pattern. While it won't do any good against verevolfs or demons, it will remind a distant routier of what they're fighting for: \
	home, blessed Otava, and their Weeping God, PSYDON."
	icon_state = "routier_halo"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/steppesman
	name = "steppesman's ungent"
	desc = "A tightly sealed vial of dirt. These are taken from the town of a steppesman's birth and given to them as they leave. When they return- if they return- they can be dumped out, and the vial crushed; the end, it says."
	icon_state = "steppe_ungent"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/vaquero
	name = "vaquero's ring"
	desc = "A beautiful gold-and-rontz ring, a masterwork of Etruscan jeweling. This does more than prove you a true vaquero; it shows you are as beautiful as you are dangerous, a crimson stone set against gold. Lyve dangerously, \
	but lyve all the same."
	icon_state = "vaquero_ring"

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/warscholar
// NOT CURRENTLY IMPLEMENTED

/obj/item/clothing/neck/roguetown/luckcharm/mercmedal/anthrax
	name = "petrified larvae charm"
	desc = "The husk of a desiccated beespider larva, passed down within the ranks of those whose names have been struck from dark elven history. The old tyranny's uprooting would be their last act of true valor."
	icon_state = "spider"
