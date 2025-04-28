local avante_ok, avante = pcall(require, "avante")
if not avante_ok then
	return
end

local avante_api = require("avante.api")
local diff = require("avante.diff")

local M = {}

M.setup = function(opts)
	require("avante_lib").load() -- this doesn't seem to do anything and I should probably remove it
	avante.setup(opts)
end

M.wk_mappings = {
	name = lvim.icons.misc.Robot .. " Avante",
	a = {
		function()
			avante_api.ask()
		end,
		"Ask",
	},
	e = {
		function()
			avante_api.edit()
		end,
		"Edit",
	},
	r = {
		function()
			avante_api.refresh()
		end,
		"Refresh",
	},
	-- a = {
	--   name = 'avante: ask',
	-- },
	c = {
		name = "avante: diff (NOT TESTED)",
		o = {
			function()
				diff.choose("ours")
			end,
			"Ours",
		},
		t = {
			function()
				diff.choose("theirs")
			end,
			"Theirs",
		},
		a = {
			function()
				diff.choose("all_theirs")
			end,
			"All Theirs",
		},
		b = {
			function()
				diff.choose("both")
			end,
			"Both",
		},
		-- c = { function() diff.cursor() end, "Cursor" },
		-- n = { function() diff.next() end, "Next" },
		-- p = { function() diff.prev() end, "Previous" },
	},
	s = {
		name = "avante: suggestion (NOT TESTED)",
		["l"] = {
			function()
				M.suggestion.accept()
			end,
			"Accept",
		},
		["n"] = {
			function()
				M.suggestion.next()
			end,
			"Next",
		},
		["p"] = {
			function()
				M.suggestion.prev()
			end,
			"Previous",
		},
		["d"] = {
			function()
				M.suggestion.dismiss()
			end,
			"Dismiss",
		},
	},
	t = {
		name = "avante: toggle (NOT TESTED)",
		t = {
			function()
				avante_api.toggle()
			end,
			"Default",
		},
		d = {
			function()
				avante_api.toggle.debug()
			end,
			"Debug",
		},
		h = {
			function()
				avante_api.toggle.hint()
			end,
			"Hint",
		},
		s = {
			function()
				avante_api.toggle.suggestion()
			end,
			"Suggestion",
		},
	},
}

return M
