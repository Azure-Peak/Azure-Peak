/datum/materia_aspect // we really don't need to store much data here - this just lets us use less #defines
	var/name = "Prima Materia"
	var/desc = "The aspect of programmers forgetting to exclude base types."

/// MATERIAL ASPECTS

/datum/materia_aspect/metal // iron, scrap
	name = "Metallum"
	desc = "The basal aspect of metal, borne most strongly by iron; reliable, stable, but not overly-strong on its own."

/datum/materia_aspect/defense // steel, armor
	name = "Loricatus"
	desc = "Defense, durability, strength. That which endures and protects."

/datum/materia_aspect/solar // gold, coinage
	name = "Solaris"
	desc = "The solar half of the twinned-aspect of purity; the cleansing heat of sunfyre, the fundament of value. Attracts and conducts arcyne energy."

/datum/materia_aspect/lunar // silver, raw essentia
	name = "Lunae"
	desc = "The lunar half of the twinned-aspect of purity; the soft glow of that which is already pure. Projects and repels arcyne energy."

/datum/materia_aspect/mundane // tin, dirt
	name = "Saecularis"
	desc = "The aspect of the grounded, the mundane, the uninspired. Lacks potential in itself; dampens and stabilizes alchemical procedures, but hampers its own expression too much to be of especial use."

/datum/materia_aspect/change // copper, clay
	name = "Mutatio"
	desc = "The aspect of change unbound. Unpredictable at the best of times, rarely used in any but the most radical of experiments."

/datum/materia_aspect/motion // bronze. union of the previous two
	name = "Impetus"
	desc = "Change, shackled to direction. The driving-force of motion and progress. Used extensively in artifice and alchemy alike."

/datum/materia_aspect/aalloy // gilbranze, specifically the pure stuff
	name = "Vindexio"
	desc = "A lost ideal. Once, this was the most important of materia; now, its uses are for the esoteric and heretical. <i>And it was a beautiful world we lost...</i>"

/datum/materia_aspect/malleability // cinnabar
	name = "Mollis"
	desc = "Yielding, formable, malleability; that which accepts and adapts, yet can catalyze change of its own when directed. Stores and directs arcyne energy when shaped. Less potent than Solaris, but easier to work."

/datum/materia_aspect/animal // animal products, especially hides and leathers
	name = "Belua"
	desc = "Half of the wyld-nature, the aspect of the beast. Might that resists restraint and direction, a savage hunger lies beneath."

/datum/materia_aspect/plant // plants - crops, trees, weeds, moreso than flowers and herbs
	name = "Silva"
	desc = "Half of the wyld-nature, the aspect of rooted growth. Stifles the waning, nourishes the waxing."

/datum/materia_aspect/herb // herbs and flowers. inedible-but-useful crops
	name = "Pervigeo"
	desc = "Oft called 'an alchemist's favorite aspect'. Borne by all manner of herbs and flowers, it marks the diffusing nature which lends itself to infusion. The aspect of flourishing bloom, of spreading influence, of nature begging to be harnessed."

/// 'four mortal elements' contrasting the two 'divine' elements of solaris and lunae
/datum/materia_aspect/fire // fire essentia, coal, ash
	name = "Ignis"
	desc = "One of the four 'mortal elements', the nature of candescent flame. Ardor; inspiration; destruction."

/datum/materia_aspect/water // water essentia, reagent containers like bottles, actual water provided to the alch station if we add piping in mgl3pt2
	name = "Aqua"
	desc = "One of the four 'mortal elements', the nature of calm waters. Coolness; reason; restoration."

/datum/materia_aspect/air // air essentia, cloth, feathers
	name = "Aura"
	desc = "One of the four 'mortal elements', the nature of weightless air. Freedom; impulse; unconstrained."

/datum/materia_aspect/earth // dirt, rocks, etc. you know what earth is
	name = "Terra"
	desc = "One of the four 'mortal elements', the nature of solid earth. Consequential; immovable; grounded."

/datum/materia_aspect/arcyne // outlier fifth (eighth) element; pure essentia, gems you can make staves out of
	name = "Caeleste"
	desc = "The aspect of the arcyne itself, that which goes beyond the bounds of the mundane. Potential; energy; the preternatural."

/// FORM ASPECTS

/datum/materia_aspect/tool // tools - pickaxes, shovels, hammers, etc
	name = "Auxilium"
	desc = "The nature of tools, to be wielded and to shape the world in turn. The aspect of the secondary, of aid, of that which bears purpose."

/datum/materia_aspect/weapon // weapons, ammunition, the like
	name = "Ictus"
	desc = "That which strikes, the aspect which embodies violence. The nature of strife, of struggle, of conflict in all forms."

