/datum/asset/simple/webworkers
	keep_local_name = TRUE
#ifdef TGS
	assets = list(
		"renderer_worker.bundle.js" = "tgui/public/renderer_worker.bundle.js",
	)
#else
	assets = list(
		"renderer_worker.bundle.js" = file("tgui/public/renderer_worker.bundle.js"),
	)
#endif
