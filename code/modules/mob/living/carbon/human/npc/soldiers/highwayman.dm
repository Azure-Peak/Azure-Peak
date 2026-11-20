/mob/living/carbon/human/species/human/northern/highwayman
	npc_archetype = /datum/npc_archetype/highwayman
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_BANDITS, FACTION_STATION)
	ambushable = FALSE
	dodgetime = 30
	d_intent = INTENT_PARRY
	blood_toll_bucket = STATS_KILLED_HIGHWAYMEN

/mob/living/carbon/human/species/human/northern/highwayman/ambush
	threat_point = THREAT_HIGH
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/mount_reaver
	npc_archetype = /datum/npc_archetype/highwayman/mount_reaver
	name = "mount reaver"
	threat_point = THREAT_TOUGH
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/archer
	npc_archetype = /datum/npc_archetype/highwayman/archer
	threat_point = THREAT_HIGH
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/crossbowman
	npc_archetype = /datum/npc_archetype/highwayman/crossbowman
	threat_point = THREAT_HIGH
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/road_knight
	npc_archetype = /datum/npc_archetype/highwayman/road_knight
	threat_point = THREAT_DEADLY
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/sharpshooter
	npc_archetype = /datum/npc_archetype/highwayman/sharpshooter
	threat_point = THREAT_DEADLY
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/caster
	npc_archetype = /datum/npc_archetype/highwayman/caster/mixed
	threat_point = THREAT_DANGEROUS
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/caster/pyromancer
	npc_archetype = /datum/npc_archetype/highwayman/caster/pyromancer

/mob/living/carbon/human/species/human/northern/highwayman/caster/fulgurmancer
	npc_archetype = /datum/npc_archetype/highwayman/caster/fulgurmancer

/mob/living/carbon/human/species/human/northern/highwayman/caster/geomancer
	npc_archetype = /datum/npc_archetype/highwayman/caster/geomancer

/mob/living/carbon/human/species/human/northern/highwayman/caster/telomancer
	npc_archetype = /datum/npc_archetype/highwayman/caster/telomancer

/mob/living/carbon/human/species/human/northern/highwayman/caster/cryomancer
	npc_archetype = /datum/npc_archetype/highwayman/caster/cryomancer

/mob/living/carbon/human/species/human/northern/highwayman/caster/ferramancer
	npc_archetype = /datum/npc_archetype/highwayman/caster/ferramancer

/mob/living/carbon/human/species/human/northern/highwayman/caster/magister
	npc_archetype = /datum/npc_archetype/highwayman/caster/magister
	threat_point = THREAT_DEADLY

/mob/living/carbon/human/species/human/northern/highwayman/caster/boss
	npc_archetype = /datum/npc_archetype/highwayman/caster/boss/mixed
	threat_point = THREAT_ELITE + THREAT_CASTER_PREMIUM

/mob/living/carbon/human/species/human/northern/highwayman/caster/boss/pyromancer
	npc_archetype = /datum/npc_archetype/highwayman/caster/boss/pyromancer
	boss_class = BOSS_CLASS_PYROMANCER

/mob/living/carbon/human/species/human/northern/highwayman/caster/boss/fulgurmancer
	npc_archetype = /datum/npc_archetype/highwayman/caster/boss/fulgurmancer
	boss_class = BOSS_CLASS_FULGURMANCER

/mob/living/carbon/human/species/human/northern/highwayman/caster/boss/geomancer
	npc_archetype = /datum/npc_archetype/highwayman/caster/boss/geomancer
	boss_class = BOSS_CLASS_GEOMANCER

/mob/living/carbon/human/species/human/northern/highwayman/caster/boss/telomancer
	npc_archetype = /datum/npc_archetype/highwayman/caster/boss/telomancer
	boss_class = BOSS_CLASS_TELOMANCER

/mob/living/carbon/human/species/human/northern/highwayman/caster/boss/cryomancer
	npc_archetype = /datum/npc_archetype/highwayman/caster/boss/cryomancer
	boss_class = BOSS_CLASS_CRYOMANCER

/mob/living/carbon/human/species/human/northern/highwayman/spellblade
	npc_archetype = /datum/npc_archetype/highwayman/spellblade/mixed
	threat_point = THREAT_DANGEROUS + THREAT_SPELLBLADE_PREMIUM
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/spellblade/blade
	npc_archetype = /datum/npc_archetype/highwayman/spellblade/blade

/mob/living/carbon/human/species/human/northern/highwayman/spellblade/phalangite
	npc_archetype = /datum/npc_archetype/highwayman/spellblade/phalangite

/mob/living/carbon/human/species/human/northern/highwayman/spellblade/macebearer
	npc_archetype = /datum/npc_archetype/highwayman/spellblade/macebearer

/mob/living/carbon/human/species/human/northern/highwayman/spellblade/spellfist
	npc_archetype = /datum/npc_archetype/highwayman/spellblade/spellfist

/mob/living/carbon/human/species/human/northern/highwayman/spellblade/champion
	npc_archetype = /datum/npc_archetype/highwayman/spellblade/champion
	threat_point = THREAT_DEADLY + THREAT_SPELLBLADE_PREMIUM

/mob/living/carbon/human/species/human/northern/highwayman/spellblade/boss
	npc_archetype = /datum/npc_archetype/highwayman/spellblade/boss/mixed
	threat_point = THREAT_ELITE + THREAT_CASTER_PREMIUM + THREAT_SPELLBLADE_PREMIUM

/mob/living/carbon/human/species/human/northern/highwayman/spellblade/boss/blade
	npc_archetype = /datum/npc_archetype/highwayman/spellblade/boss/blade
	boss_class = BOSS_CLASS_SPELLBLADE

/mob/living/carbon/human/species/human/northern/highwayman/spellblade/boss/phalangite
	npc_archetype = /datum/npc_archetype/highwayman/spellblade/boss/phalangite
	boss_class = BOSS_CLASS_PHALANGITE

/mob/living/carbon/human/species/human/northern/highwayman/spellblade/boss/macebearer
	npc_archetype = /datum/npc_archetype/highwayman/spellblade/boss/macebearer
	boss_class = BOSS_CLASS_MACEBEARER

/mob/living/carbon/human/species/human/northern/highwayman/spellblade/boss/spellfist
	npc_archetype = /datum/npc_archetype/highwayman/spellblade/boss/spellfist
	boss_class = BOSS_CLASS_SPELLFIST

/mob/living/carbon/human/species/human/northern/highwayman/light
	npc_archetype = /datum/npc_archetype/highwayman/light
	threat_point = THREAT_HIGH
	ambush_faction = "bandits"

/mob/living/carbon/human/species/human/northern/highwayman/bulwark
	npc_archetype = /datum/npc_archetype/highwayman/bulwark
	threat_point = THREAT_TOUGH
	ambush_faction = "bandits"
