/datum/decree/indenture_of_war
	id = DECREE_INDENTURE_OF_WAR
	name = "The Indenture of War"
	category = DECREE_CATEGORY_ANCIENT
	mechanical_text = "Sets minimum daily wages for soldiery: Marshal 60m, Knight/Sergeant 40m, Man-at-Arms/Warden 20m, Squire 10m."
	/// Per-rank mandated daily wage. Steward cannot set below these amounts while the Indenture
	/// stands, and any existing below-floor wage is bumped up at activation. Military ranks only -
	/// courtiers, healers, scholars, and civilian staff are not covered by this charter.
	var/static/list/wage_floors = list(
		"Marshal" = 60,
		"Knight" = 40,
		"Sergeant" = 40,
		"Man at Arms" = 20,
		"Warden" = 20,
		"Squire" = 10,
	)
	flavor_text = {"This Indenture of War, made betwene the Crown of Azuria on the one part, and the armed men of the Realm on the other part, witnesseth that:

The Crown shall paye unto its soldiery their just wages, by the daye, and without lette or delay, according to the ranks herein set forth. The Marshal of the Realm at threescore marks, the Knights at twoscore, a Sergeant at twoscore likewise, a Man at Armes at a score, a Warden at a score, and a Squire at ten. Beneath these sums no wage shall fall whilst this Indenture stands.

In return, the armed men of the Realm shall do their trewe service to the Duke, and shall obey the Duke's lieutenants and officers in all things lawful and reasonable. And if the saide armed men shall break or contravene this Indenture, they shall be at the Duke's wille and mercye. And if the Crown shall break this Indenture - withholding the wages herein pledged, or setting them lower than here set forth - the soldier is released from his oath, and the Crown shall answer for the faith it hath broken.

In witness whereof, the Crown of Azuria hath set his seale to this Indenture, and the said armed men of the Realm have set their seales in like manner.

Yeven under the seal of the Crown."}
	revoke_text = "The %RULER% has broken the Indenture of War. The soldier's oath is dissolved, and the Crown's armed men stand at liberty of service - let the garrison remember whose seal was cut first."
	restore_text = "The %RULER% has renewed the Indenture of War. The soldier's wage is pledged, and the soldier's oath stands - each binds the other."

/datum/decree/indenture_of_war/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(40, 120)

/datum/decree/indenture_of_war/apply_wage_floor(job_title, current_floor)
	var/mandated = wage_floors[job_title] || 0
	return max(current_floor, mandated)

/datum/decree/indenture_of_war/wage_floored_jobs()
	return wage_floors

/datum/decree/indenture_of_war/on_restore()
	. = ..()
	SStreasury.steward_machine?.enforce_wage_floors()
