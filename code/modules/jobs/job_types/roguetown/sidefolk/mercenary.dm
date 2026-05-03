/datum/job/roguetown/mercenary
	title = "Mercenary"
	flag = MERCENARY
	department_flag = SIDEFOLK
	faction = "Station"
	total_positions = 8
	spawn_positions = 8
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	tutorial = "Blood stains your hands and the coins you hold. You are a sell-sword, a mercenary, a contractor of war. Where you come from, what you are, who you serve.. none of it matters. What matters is that the mammon flows to your pocket."
	display_order = JDO_MERCENARY
	selection_color = JCOLOR_WANDERER
	min_pq = 2		//Will be handled by classes if PQ limiting is needed. --But Until then, learn escalation, mercs.
	max_pq = null
	round_contrib_points = 1
	townie_contract_gate_exempt = TRUE
	outfit = null	//Handled by classes
	outfit_female = null
	advclass_cat_rolls = list(CTAG_MERCENARY = 20)
	job_traits = list(TRAIT_STEELHEARTED)
	always_show_on_latechoices = TRUE
	class_categories = TRUE
	job_subclasses = list(
		/datum/advclass/mercenary/anthrax,
		/datum/advclass/mercenary/anthrax_assassin,
		/datum/advclass/mercenary/atgervi,
		/datum/advclass/mercenary/atgervi_shaman,
		/datum/advclass/mercenary/etrusca_condottiero,
		/datum/advclass/mercenary/etrusca_balestrieri,
		/datum/advclass/mercenary/desert_rider,
		/datum/advclass/mercenary/desert_rider_zeybek,
		/datum/advclass/mercenary/desert_rider_sahir,
		/datum/advclass/mercenary/desert_rider_almah,
		/datum/advclass/mercenary/forlorn,
		/datum/advclass/mercenary/vaquero,
		/datum/advclass/mercenary/freelancer,
		/datum/advclass/mercenary/freelancer_lancer,
		/datum/advclass/mercenary/freelancer_sabrist,
		/datum/advclass/mercenary/grenzelhoft,
		/datum/advclass/mercenary/grenzelhoft_halberdier,
		/datum/advclass/mercenary/grenzelhoft_crossbowman,
		/datum/advclass/mercenary/grenzelhoft_mage,
		/datum/advclass/mercenary/gronn,
		/datum/advclass/mercenary/gronn_heavy,
		/datum/advclass/mercenary/routier,
		/datum/advclass/mercenary/rumaclan,
		/datum/advclass/mercenary/rumaclan_sasu,
		/datum/advclass/mercenary/hangyaku,
		/datum/advclass/mercenary/chonin,
		/datum/advclass/mercenary/seonjang,
		/datum/advclass/mercenary/steppesman,
		/datum/advclass/mercenary/warscholar,
		/datum/advclass/mercenary/warscholar_pontifex,
		/datum/advclass/mercenary/warscholar_vizier,
		/datum/advclass/mercenary/blackoak,
		/datum/advclass/mercenary/blackoak_ranger,
		/datum/advclass/mercenary/blackoak_adept,
		/datum/advclass/mercenary/underdweller,
		/datum/advclass/mercenary/grudgebearer,
		/datum/advclass/mercenary/grudgebearer_soldier,
		/datum/advclass/mercenary/trollslayer,
		/datum/advclass/mercenary/lirvanmerc
	)

/datum/job/roguetown/mercenary/after_spawn(mob/living/L, mob/M, latejoin = FALSE)
	..()
	if(L && ishuman(L))
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return

		// Get the mercenary statue from SSroguemachine
		var/obj/structure/roguemachine/talkstatue/mercenary/statue = SSroguemachine.mercenary_statue
		if(!statue && SSroguemachine.mercenary_statues.len)
			statue = SSroguemachine.mercenary_statues[1]
		if(statue)
			// Send a message with a clickable link to register remotely
			to_chat(M, span_boldnotice("I sense a mercenary statue calling out to me..."))
			to_chat(M, span_notice("<a href='?src=[REF(statue)];register=[REF(H)]'>Touch the statue from afar</a> to register myself as available for contract."))

			// Store the registration request
			statue.pending_registrations[H.key] = H
