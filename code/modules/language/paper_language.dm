/// List to assign languages to fonts
GLOBAL_LIST_INIT(paper_fonts, list(
	SPAN_ELF = list("elf.ttf", ""),
	SPAN_DELF = list("elf.ttf", "font-style:italic;"),
	SPAN_DWARF = list("dwarf.ttf", ""),
	SPAN_HELL = list("hell.ttf", "font-size:110%;"),
	SPAN_UNDEAD = list("undead.ttf", ""),
	SPAN_ORC = list("orc.ttf", ""),
	SPAN_BEAST = list("orc.ttf", ""),
	SPAN_DRACONIC = list("draconic.ttf", "font-size:120%;"),
	SPAN_GRENZELHOFTIAN = list("grenzelhoftian.ttf", "font-size:120%;"),
	SPAN_KAZENGUNESE = list("kazengunese.ttf", ""),
	SPAN_LINGYUESE = list("lingyuese.ttf", ""),
	SPAN_UNDERCOMMON = list("undercommon.ttf", ""),
	SPAN_OTAVAN = list("otavan.ttf", "font-size:120%;"),
	SPAN_OLDAZURE = list("oldazure.ttf", "font-size:110%;"),
	SPAN_ETRUSCAN = list("etruscan.ttf", ""),
	SPAN_GRONNIC = list("gronnic.ttf", ""),
	SPAN_AAVNIC = list("aavnic.ttf", ""),
))

/proc/write_langs(text, mob/writer)
	var/list/segments = parse_language_segments(text, null)
	if(!segments || !writer)
		return text
	. = ""
	for(var/datum/language_segment/segment as anything in segments)
		var/datum/language/lang = segment.language
		var/datum/language/langdatum = lang && GLOB.language_datum_instances[lang]
		if(!langdatum?.code_switching || !writer.has_language(lang))
			. += segment.text
			continue
		var/list/spans = get_language_spans(writer, lang)
		var/inner = length(spans) ? "<span class='[jointext(spans, " ")]'>[segment.text]</span>" : segment.text
		. += "<!--lang:[lang]-->[inner]<!--/lang-->"

/mob/proc/read_langs(text)
	var/start = findtext(text, "<!--lang:")
	if(!start)
		return text
	while(start)
		var/head = findtext(text, "-->", start)
		var/stop = head && findtext(text, "<!--/lang-->", head)
		if(!stop)
			break
		var/lang = text2path(copytext(text, start + 9, head))
		var/datum/language/langdatum = lang && GLOB.language_datum_instances[lang]
		var/inner = copytext(text, head + 3, stop)
		if(langdatum && !has_language(lang))
			var/scrambled = ""
			var/pos = 1
			while(pos <= length(inner))
				var/tag = findtext(inner, "<", pos)
				var/plain = html_decode(copytext(inner, pos, tag))
				if(trim(plain))
					scrambled += "[copytext(plain, 1, 2) == " " ? " " : ""][html_encode(langdatum.scramble(plain))][copytext(plain, length(plain)) == " " ? " " : ""]"
				else
					scrambled += plain
				if(!tag)
					break
				var/close = findtext(inner, ">", tag)
				if(!close)
					break
				scrambled += copytext(inner, tag, close + 1)
				pos = close + 1
			inner = scrambled
			text = copytext(text, 1, head + 3) + inner + copytext(text, stop)
		start = findtext(text, "<!--lang:", head + 3 + length(inner))
	if(!client || client.prefs?.no_language_fonts)
		return text
	var/datum/asset/fonts = get_asset_datum(/datum/asset/simple/roguefonts)
	fonts.send(client)
	var/list/urls = fonts.get_url_mappings()
	var/css = ""
	for(var/span in GLOB.paper_fonts)
		var/list/font = GLOB.paper_fonts[span]
		css += "@font-face{font-family:'[span]';src:url('[urls[font[1]]]');}.[span]{font-family:'[span]';[font[2]]}"
	return "<style>[css]</style>[text]"
