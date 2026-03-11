-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- ~/.local/share/nvim/lazy/nvim-lspconfig/lua/lspconfig/configs
-- フォーマッタは mhartington/formatter.nvim を使用（LSP不使用）

vim.lsp.enable({
	"ast_grep", -- プロジェクトルートに sgconfig.yml 必須
	"clangd",
	"golangci_lint_ls",
	"gopls",
	"intelephense",
	"pylsp",
	"templ",
    "tombi",
	"ts_ls",
	"tinymist",
})

local config = vim.lsp.config

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

config("intelephense", {
	init_options = {
		storagePath = vim.loop.os_homedir() .. "/.cache/intelephense",
		globalStoragePath = vim.loop.os_homedir() .. "/.cache/intelephense",
	},
	settings = {
		intelephense = {
			environment = {
				stubs = { "wordpress" },
				includePaths = {
					vim.loop.os_homedir() -- 改行
						.. "/.config/composer/vendor/php-stubs/wordpress-stubs",
				},
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

--[[
lsp.typst_lsp.config({
	settings = {
		exportPdf = "onType", -- Choose onType, onSave or never.
		-- serverPath = "" -- Normally, there is no need to uncomment it.
	},
})
]]
