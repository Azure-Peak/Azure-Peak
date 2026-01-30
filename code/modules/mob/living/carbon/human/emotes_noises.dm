/datum/emote/living/flap
	key = "flap"
	key_third_person = "flaps"
	message = "flaps their wings."
	restraint_check = TRUE
	var/wing_time = 20

/datum/emote/living/carbon/human/flap/can_run_emote(mob/user, status_check = TRUE , intentional)
	return FALSE

/datum/emote/living/flap/aflap
	key = "aflap"
	key_third_person = "aflaps"
	message = "flaps their wings ANGRILY!"
	restraint_check = TRUE
	wing_time = 10

/datum/emote/living/carbon/human/aflap/can_run_emote(mob/user, status_check = TRUE , intentional)
	return FALSE

/datum/emote/living/meow
	key = "meow"
	key_third_person = "meows!"
	message = "meows!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_meow()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Meow"
		set category = "Wildtongue"
		emote("meow", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/mrrp
	key = "mrrp"
	key_third_person = "mrrps!"
	message = "mrrps!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_mrrp()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Mrrp"
		set category = "Wildtongue"
		emote("mrrp", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/caw
	key = "caw"
	key_third_person = "caws!"
	message = "caws!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_caw()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Caw"
		set category = "Wildtongue"
		emote("caw", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/peep
	key = "peep"
	key_third_person = "peeps!"
	message = "peeps!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_peep()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Peep"
		set category = "Wildtongue"
		emote("peep", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/hoot
	key = "hoot"
	key_third_person = "hoots!"
	message = "hoots!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_hoot()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Hoot"
		set category = "Wildtongue"
		emote("hoot", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/squeak
	key = "squeak"
	key_third_person = "squeaks!"
	message = "squeaks!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_squeak()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Squeak"
		set category = "Wildtongue"
		emote("squeak", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/hiss
	key = "hiss"
	key_third_person = "hisses!"
	message = "hisses!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_hiss()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Hiss"
		set category = "Wildtongue"
		emote("hiss", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/phiss
	key = "phiss"
	key_third_person = "hisses!"
	message = "hisses!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_phiss()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "PHiss"
		set category = "Wildtongue"
		emote("phiss", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/roar
	key = "roar"
	key_third_person = "roars!"
	message = "roars!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_roar()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Roar"
		set category = "Wildtongue"
		emote("roar", intentional = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/howl
	key = "howl"
	key_third_person = "howls!"
	message = "howls!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_howl()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Howl"
		set category = "Wildtongue"
		emote("howl", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/cackle
	key = "cackle"
	key_third_person = "cackles!"
	message = "cackles!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_cackle()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Cackle"
		set category = "Wildtongue"
		emote("cackle", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/whine
	key = "whine"
	key_third_person = "whines."
	message = "whines."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_whine()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Whine"
		set category = "Wildtongue"
		emote("whine", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/fwhine
	key = "fwhine"
	key_third_person = "whines like a Venard."
	message = "whines like a Venard."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_fwhine()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Whine (Venard)"
		set category = "Wildtongue"
		emote("fwhine", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/psnort
	key = "psnort"
	key_third_person = "psnorts"
	message = "lets out an elongated snort."
	emote_type = EMOTE_AUDIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_snort()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Snort (Animal)"
		set category = "Wildtongue"
		emote("psnort", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/oink
	key = "oink"
	key_third_person = "oinks."
	message = "oinks."
	emote_type = EMOTE_AUDIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_oink()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Oink"
		set category = "Wildtongue"
		emote("oink", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/trill
	key = "trill"
	key_third_person = "trills!"
	message = "trills!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_trill()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Trill"
		set category = "Wildtongue"
		emote("trill", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/purr
	key = "purr"
	key_third_person = "purrs!"
	message = "purrs!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_purr()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Purr"
		set category = "Wildtongue"
		emote("purr", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/moo
	key = "moo"
	key_third_person = "moos!"
	message = "moos!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_moo()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Moo"
		set category = "Wildtongue"
		emote("moo", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/bark
	key = "bark"
	key_third_person = "barks!"
	message = "barks!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_bark()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Bark"
		set category = "Wildtongue"
		emote("bark", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/growl
	key = "growl"
	key_third_person = "growls!"
	message = "growls!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_growl()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Growl"
		set category = "Wildtongue"
		emote("growl", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/prbt
	key = "prbt"
	key_third_person = "prbts!"
	message = "prbts!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_prbt()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Prbt"
		set category = "Wildtongue"
		emote("prbt", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/bleat
	key = "bleat"
	key_third_person = "bleats!"
	message = "bleats!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_bleat()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Bleat"
		set category = "Wildtongue"
		emote("bleat", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/chitter
	key = "chitter"
	key_third_person = "chitters!"
	message = "chitters!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled chitter!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_chitter()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/moth))
		set name = "Chitter"
		set category = "Wildtongue"
		emote("chitter", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/flutter
	key = "flutter"
	key_third_person = "flutters!"
	message = "flutters!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_flutter()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/moth))
		set name = "Flutter"
		set category = "Wildtongue"
		emote("flutter", intentional = TRUE)
	else
		to_chat(usr, span_warning("Your back doesn't do that"))
		return

/datum/emote/living/yip
	key = "yip"
	key_third_person = "yips"
	message = "yips!"
	emote_type = EMOTE_AUDIBLE
	message_muffled = "makes a muffled yip!"
	is_animal = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_yip()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/lizard))
		set name = "Yip"
		set category = "Wildtongue"
		emote("yip", intentional = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/lizard_bellow
	key = "bellow"
	key_third_person = "bellows"
	message = "bellows!"
	emote_type = EMOTE_AUDIBLE
	message_muffled = "makes a muffled bellow!"
	is_animal = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_lizard_bellow()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/lizard))
		set name = "LizBellow"
		set category = "Wildtongue"
		emote("bellow", intentional = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/lizard_hiss
	key = "hiss"
	key_third_person = "hisses"
	message = "hisses!"
	emote_type = EMOTE_AUDIBLE
	message_muffled = "makes a muffled hiss!"
	is_animal = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_lizard_hiss()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/lizard))
		set name = "LizHiss"
		set category = "Wildtongue"
		emote("hiss", intentional = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/lizard_squeal
	key = "squeal"
	key_third_person = "squeals"
	message = "squeals!"
	emote_type = EMOTE_AUDIBLE
	message_muffled = "makes a muffled squeal!"
	is_animal = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_lizard_squeal()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/lizard))
		set name = "LizSqueal"
		set category = "Wildtongue"
		emote("squeal", intentional = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/emote_lizard_thump
	key = "thump"
	key_third_person = "squeals"
	message = "thumps!"
	emote_type = EMOTE_VISIBLE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_lizard_thump()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/lizard))
		set name = "LizThump"
		set category = "Wildtongue"
		emote("thump", intentional = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

