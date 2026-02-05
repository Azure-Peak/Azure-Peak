GLOBAL_LIST_INIT(command_positions, list(
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer"))


GLOBAL_LIST_INIT(engineering_positions, list(
	"Chief Engineer",
	"Station Engineer",
	"Atmospheric Technician"))


GLOBAL_LIST_INIT(medical_positions, list(
	"Chief Medical Officer",
	"Medical Doctor",
	"Geneticist",
	"Virologist",
	"Chemist"))


GLOBAL_LIST_INIT(science_positions, list(
	"Research Director",
	"Scientist",
	"Roboticist"))


GLOBAL_LIST_INIT(supply_positions, list(
	"Head of Personnel",
	"Quartermaster",
	"Cargo Technician",
	"Shaft Miner"))


GLOBAL_LIST_INIT(civilian_positions, list(
	"Bartender",
	"Kek",
	"Cook",
	"Janitor",
	"Curator",
	"Lawyer",
	"Chaplain",
	"Clown",
	"Mime",
	"Assistant"))


GLOBAL_LIST_INIT(security_positions, list(
	"Head of Security",
	"Warden",
	"Detective",
	"Security Officer"))


GLOBAL_LIST_INIT(nonhuman_positions, list(
	"AI",
	"Cyborg",
	ROLE_PAI))

///////////////
// ROGUETOWN //
///////////////

GLOBAL_LIST_INIT(leadership_positions, list( // Used for boldening text primarily
	"Grand Duke",
	"Hand",
	"Court Magician",
	"Marshal",
	"Sergeant",
	"Bishop",
	"Martyr",
	"Merchant",
	"Guildmaster",
	"Head Physician",
	"Innkeeper",
	"Bathmaster",
	"Inquisitor"
))

GLOBAL_LIST_INIT(regency_positions, list( // Used to determine elligibility for Regency
	"Consort",
	"Prince",
	"Hand",
	"Steward",
	"Councillor",
	"Marshal",
))

GLOBAL_LIST_INIT(noble_positions, list( //Royal family only
	"Grand Duke",
	"Consort",
	"Prince",
))

GLOBAL_LIST_INIT(courtier_positions, list( //Anyone that is officially part of the court
	"Hand",
	"Steward",
	"Councillor",
	"Clerk",
	"Jester",
	"Court Magician",
	"Archivist",
	"Seneschal",
	"Suitor",
))

GLOBAL_LIST_INIT(retinue_positions, list( //Manorites
	"Marshal",
	"Knight",
	"Squire",
))

GLOBAL_LIST_INIT(garrison_positions, list( //Guards
	"Sergeant",
	"Man at Arms",
	"Warden",
	"Watchman",
))

GLOBAL_LIST_INIT(church_positions, list( //Church of the Ten
	"Bishop",
	"Martyr",
	"Templar",
	"Keeper",
	"Druid",
	"Acolyte",
	"Sexton",
))

GLOBAL_LIST_INIT(burgher_positions, list( //Artisans, store owners what have you.
	"Merchant",
	"Guildmaster",
	"Guildsman",
	"Tailor",
	"Head Physician",
	"Apothecary",
	"Innkeeper",
	"Bathmaster",
	"Town Crier",
	"Magicians Associate",
))

GLOBAL_LIST_INIT(peasant_positions, list( //Serfs / peasants / generic towners
	"Bathhouse Attendant",
	"Cook",
	"Tapster",
	"Servant",
	"Shophand",
	"Soilson",
	"Towner",
))

GLOBAL_LIST_INIT(sidefolk_positions, list( //Weerdoes who hang around the town
	"Lunatic",
	"Vagabond",
	"Migrant",
	"Pilgrim",
	"Mercenary",	
	"Veteran",
))

GLOBAL_LIST_INIT(wanderer_positions, list( //Homeless
	"Adventurer",
	"Court Agent",
	"Trader",
))

GLOBAL_LIST_INIT(antagonist_positions, list( //Mostly lesser antagonists
	"Assassin",
	"Bandit",
	"Wretch",
	"Gnoll",
))

GLOBAL_LIST_INIT(inquisition_positions, list( //Self explanatory
	"Inquisitor",
	"Absolver",
	"Orthodoxist",
))

GLOBAL_LIST_INIT(rogueoverthrow_positions, list( //Used for Aspirant / Peasant Rebellion
	"Grand Duke",
	"Consort",
	"Suitor",
	"Prince",
	"Hand",
	"Steward",
	"Councillor",
	"Suitor",
	"Marshal",
	"Knight",
	"Inquisitor",
	"Absolver",
	"Orthodoxist",
	"Assassin",
	"Bandit",
	"Wretch",
	"Gnoll"
))

GLOBAL_LIST_INIT(roguewar_positions, list(
	"Adventurer",
))

GLOBAL_LIST_INIT(roguefight_positions, list(
	"Red Captain",
	"Red Caster",
	"Red Ranger",
	"Red Fighter",
	"Green Captain",
	"Green Caster",
	"Green Ranger",
	"Green Fighter",
))

//This list is used to prevent the duke from stripping nobility from certain jobs that aren't intrinsically a part of the town.
GLOBAL_LIST_INIT(foreign_positions, list(
	"Adventurer", 
	"Mercenary", 
	"Bandit", 
	"Wretch",
	"Inquisitor",
	"Suitor",
	"Orthodoxist",
	"Migrant",
))

GLOBAL_LIST_INIT(test_positions, list(
	"Tester",
))

GLOBAL_LIST_INIT(job_assignment_order, get_job_assignment_order())

/proc/get_job_assignment_order()
	var/list/sorting_order = list()
	sorting_order += GLOB.noble_positions
	sorting_order += GLOB.courtier_positions
	sorting_order += GLOB.retinue_positions
	sorting_order += GLOB.garrison_positions
	sorting_order += GLOB.church_positions
	sorting_order += GLOB.burgher_positions
	sorting_order += GLOB.peasant_positions
	sorting_order += GLOB.sidefolk_positions
	sorting_order += GLOB.antagonist_positions
	sorting_order += GLOB.inquisition_positions
	return sorting_order

GLOBAL_LIST_INIT(exp_jobsmap, list(
	EXP_TYPE_CREW = list("titles" = peasant_positions | command_positions | engineering_positions | medical_positions | science_positions | supply_positions | security_positions | civilian_positions | list("AI","Cyborg")), // crew positions
	EXP_TYPE_COMMAND = list("titles" = command_positions),
	EXP_TYPE_ENGINEERING = list("titles" = engineering_positions),
	EXP_TYPE_MEDICAL = list("titles" = medical_positions),
	EXP_TYPE_SCIENCE = list("titles" = science_positions),
	EXP_TYPE_SUPPLY = list("titles" = supply_positions),
	EXP_TYPE_SECURITY = list("titles" = security_positions),
	EXP_TYPE_SILICON = list("titles" = list("AI","Cyborg")),
	EXP_TYPE_SERVICE = list("titles" = civilian_positions),
))

GLOBAL_LIST_INIT(exp_specialmap, list(
	EXP_TYPE_LIVING = list(), // all living mobs
	EXP_TYPE_ANTAG = list(),
	EXP_TYPE_SPECIAL = list("Lifebringer","Ash Walker","Exile","Servant Golem","Free Golem","Hermit","Translocated Vet","Escaped Prisoner","Hotel Staff","SuperFriend","Space Syndicate","Ancient Crew","Space Doctor","Space Bartender","Beach Bum","Skeleton","Zombie","Space Bar Patron","Lavaland Syndicate","Ghost Role"), // Ghost roles
	EXP_TYPE_GHOST = list() // dead people, observers
))
GLOBAL_PROTECT(exp_jobsmap)
GLOBAL_PROTECT(exp_specialmap)

/proc/guest_jobbans(job)
	return ((job in GLOB.command_positions) || (job in GLOB.nonhuman_positions) || (job in GLOB.security_positions))



//this is necessary because antags happen before job datums are handed out, but NOT before they come into existence
//so I can't simply use job datum.department_head straight from the mind datum, laaaaame.
/proc/get_department_heads(job_title)
	if(!job_title)
		return list()

	for(var/datum/job/J in SSjob.occupations)
		if(J.title == job_title)
			return J.department_head //this is a list

/proc/get_full_job_name(job)
	var/static/regex/cap_expand = new("cap(?!tain)")
	var/static/regex/cmo_expand = new("cmo")
	var/static/regex/hos_expand = new("hos")
	var/static/regex/hop_expand = new("hop")
	var/static/regex/rd_expand = new("rd")
	var/static/regex/ce_expand = new("ce")
	var/static/regex/qm_expand = new("qm")
	var/static/regex/sec_expand = new("(?<!security )officer")
	var/static/regex/engi_expand = new("(?<!station )engineer")
	var/static/regex/atmos_expand = new("atmos tech")
	var/static/regex/doc_expand = new("(?<!medical )doctor|medic(?!al)")
	var/static/regex/mine_expand = new("(?<!shaft )miner")
	var/static/regex/chef_expand = new("chef")
	var/static/regex/borg_expand = new("(?<!cy)borg")

	job = lowertext(job)
	job = cap_expand.Replace(job, "captain")
	job = cmo_expand.Replace(job, "chief medical officer")
	job = hos_expand.Replace(job, "head of security")
	job = hop_expand.Replace(job, "head of personnel")
	job = rd_expand.Replace(job, "research director")
	job = ce_expand.Replace(job, "chief engineer")
	job = qm_expand.Replace(job, "quartermaster")
	job = sec_expand.Replace(job, "security officer")
	job = engi_expand.Replace(job, "station engineer")
	job = atmos_expand.Replace(job, "atmospheric technician")
	job = doc_expand.Replace(job, "medical doctor")
	job = mine_expand.Replace(job, "shaft miner")
	job = chef_expand.Replace(job, "cook")
	job = borg_expand.Replace(job, "cyborg")
	return job


