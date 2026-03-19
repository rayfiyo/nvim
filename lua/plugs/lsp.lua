--[[
    https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
    ~/.local/share/nvim/lazy/nvim-lspconfig/lua/lspconfig/configs
    フォーマッタは mhartington/formatter.nvim を使用（LSP不使用）
]]

vim.lsp.enable({
	"ast_grep", -- プロジェクトルートに sgconfig.yml 必須
	"clangd",
	"golangci_lint_ls",
	"gopls",
	"intelephense",
	"lemminx",
	"pylsp",
	"templ",
	"tombi",
	"ts_ls",
	"tinymist",
})

local config = vim.lsp.config
-- local intelephense_stubs は後述

config("gopls", {
	settings = {
		gopls = {
			-- Linter は golangci_lint_ls を用いるため重複を防止
			staticcheck = false, -- gopls 経由の Staticcheck を止める
			analyses = {
				printf = false, -- go vet の printf 系を止める
				shadow = true, -- 影変数
				unusedparams = true, -- 未使用パラメータ
			},
		},
	},
})

config("lemminx", {
	settings = {
		xml = {
			validation = {
				-- no grammar の診断を無視するが、LSP の診断自体は有効化のまま
				enabled = true,
				noGrammar = "ignore",
			},
		},
	},
})

config("pylsp", {
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = { enabled = false },
				flake8 = { enabled = true },
			},
		},
	},
})

config("tinymist", {
	settings = {
		exportPdf = "onType",
		formatterMode = "typstyle",
		semanticTokens = "disable",
		fontPaths = "/usr/share/fonts/",
	},
})

-- https://github.com/bmewburn/vscode-intelephense/blob/0464c210540a3a2143b606e9ed04f2e06004c0cf/package.json#L163
local intelephense_stubs = {
	-- デフォルト
	"apache",
	"bcmath",
	"bz2",
	"calendar",
	"com_dotnet",
	"Core",
	"ctype",
	"curl",
	"date",
	"dba",
	"dom",
	"enchant",
	"exif",
	"FFI",
	"fileinfo",
	"filter",
	"fpm",
	"ftp",
	"gd",
	"gettext",
	"gmp",
	"hash",
	"iconv",
	"imap",
	"intl",
	"json",
	"ldap",
	"libxml",
	"mbstring",
	"meta",
	"mysqli",
	"oci8",
	"odbc",
	"openssl",
	"pcntl",
	"pcre",
	"PDO",
	"pgsql",
	"Phar",
	"posix",
	"pspell",
	"random",
	"readline",
	"Reflection",
	"session",
	"shmop",
	"SimpleXML",
	"snmp",
	"soap",
	"sockets",
	"sodium",
	"SPL",
	"sqlite3",
	"standard",
	"superglobals",
	"sysvmsg",
	"sysvsem",
	"sysvshm",
	"tidy",
	"tokenizer",
	"uri",
	"xml",
	"xmlreader",
	"xmlrpc",
	"xmlwriter",
	"xsl",
	"Zend OPcache",
	"zip",
	"zlib",
	-- 追加
	"wordpress",
}

config("intelephense", {
	init_options = {
		storagePath = vim.loop.os_homedir() .. "/.cache/intelephense",
		globalStoragePath = vim.loop.os_homedir() .. "/.cache/intelephense",
	},
	settings = {
		intelephense = {
			phpVersion = "8.3.27",
			-- local intelephense_stubs は後述
			stubs = intelephense_stubs,
		},
	},
})

--[[
lsp.typst_lsp.config({
	settings = {
		exportPdf = "onType", -- Choose onType, onSave or never.
		-- serverPath = "" -- Normally, there is no need to uncomment it.
	},
})
]]
