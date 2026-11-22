GLOBAL_LIST_INIT(default_ruler_styles, list(
	"Lord of Lords of the Azurian",
	"Heir of the Exarchs",
	"Duke of Heartfelt and Lord of the Arwinii of the East",
	"Liege of Rosawood and Eveswood",
	"Protector of the Rossan Elves",
	"Lord of the Two Syons and the Earii",
	"Master of the Azur from Spring to Sea",
	"Shield of the Ten and Guardian of Syon's Hallow",
	"Warden of the Church of Azuria",
))

GLOBAL_LIST_INIT(default_ruler_old_styles, list(
	"King of Kings of the Azurian",
	"Heir of the Exarchs",
	"Duke of Heartfelt and King of the Arwinii of the East",
	"Liege of Rosawood and Eveswood",
	"Protector of the Rossan Elves",
	"King of the Two Syons and the Earii",
	"Master of the Azur from Spring to Sea",
	"Shield of the Ten and Guardian of Syon's Hallow",
	"Warden of the Church of Azuria",
))

#define DEFAULT_RULER_DOMAIN "Azuria"

/proc/ruler_full_title(mob/living/carbon/human/ruler, old_azurian = FALSE)
	return "[ruler.real_name], [ruler_styling(ruler, old_azurian)]."

/proc/ruler_styling(mob/living/carbon/human/ruler, old_azurian = FALSE)
	var/datum/map_adjustment/adjustment = SSmapping.map_adjustment
	var/domain = adjustment?.ruler_domain || DEFAULT_RULER_DOMAIN
	var/list/styles
	if(old_azurian)
		styles = adjustment?.ruler_old_styles || GLOB.default_ruler_old_styles
	else
		styles = adjustment?.ruler_styles || GLOB.default_ruler_styles
	var/possessive = istype(ruler) ? ruler.p_their() : "their"
	if(possessive == "her" || possessive == "their")
		possessive += "s"
	return "by the Grace of the Ten, [SSticker.rulertype] of [domain], [jointext(styles, ", ")], and [old_azurian ? "King" : "Lord"] of all else that is [possessive] by Right"

/mob/living/carbon/human/proc/remember_ruler_title()
	set name = "Remember Title"
	set category = "RoleUnique.Banneret"

	var/mob/living/carbon/human/ruler = SSticker.rulermob
	if(!istype(ruler) || QDELETED(ruler))
		to_chat(src, span_warning("There is no ruler."))
		return
	var/list/dat = list()
	dat += "<p>You remember the title of your ruler so you may properly announce their presence.</p>"
	dat += "<p><b>[ruler_full_title(ruler)]</b></p>"
	dat += "<p><i>Adri</i>, in Old Azurian:<br><b>[ruler_full_title(ruler, TRUE)]</b></p>"
	var/datum/browser/popup = new(src, "ruler_title", "Remember Title", 480, 360)
	popup.set_content(dat.Join())
	popup.open()

#undef DEFAULT_RULER_DOMAIN
