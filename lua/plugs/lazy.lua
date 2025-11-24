-- 公式ドキュメント: https://lazy.folke.io/spec
-- disabled_plugins の設定は vim_g.lua に
vim.loader.enable()
local opts = {
	defaults = { lazy = true }, -- デフォルトで lazy = treu
	performance = { cache = { enabled = true } }, -- キャッシュ有効化
}
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- plugin configuration (Based on migration from packer.nvim) --
-- https://coralpink.github.io/commentary/outro/lazy-migration-guide.html
local plugins = {
	-- -- -- -- -- -- --
	-- -- 通常起動 -- --
	-- -- -- -- -- -- --
	{
		"mason-org/mason.nvim",
		lazy = false, -- 依存され: "mason-org/mason-lspconfig.nvim"
		build = function()
			vim.cmd(":MasonUpdate")
			vim.cmd(
				":MasonInstall ast-grep black clang-format clangd gofumpt golangci-lint golangci-lint-langserver gopls intelephense prettierd python-lsp-server stylua templ tinymist ts-standard typescript-language-server typstyle xmlformatter"
			)
		end,
	},
	{
		"mhartington/formatter.nvim",
		lazy = false, -- 別ファイルで require() しているので lazy = false
		keys = "<leader>f",
		cmd = { "Format", "FormatWrite" },
		build = function()
			vim.fn.system("mkdir -p\
            ~/.local/share/nvim/lazy/formatter.nvim/lua/formatter/filetypes/;\
            cp ~/.config/nvim/lua/plugs/bkup_formatter/filetypes/*.lua\
            ~/.local/share/nvim/lazy/formatter.nvim/lua/formatter/filetypes/")
		end,
		init = function()
			-- mhartington/formatter.nvim の書き込み時に自動フォーマット
			-- https://github.com/mhartington/formatter.nvim#format-after-save
			augroup("__formatter__", { clear = true })
			autocmd("BufWritePost", {
				group = "__formatter__",
				command = ":FormatWrite",
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false, -- 別で require() しているから
		evnet = { "InsertEnte", "BufReadPre", "BufNewFile" },
	},

	-- -- -- -- -- -- --
	-- -- 遅延起動 -- --
	-- -- -- -- -- -- --
	{ "github/copilot.vim", build = ":Copilot setup", cmd = "Copilot" },
	{
		"dstein64/nvim-scrollview",
		event = "VeryLazy",
		init = function()
			vim.g.scrollview_excluded_filetypes = { "nerdtree" }
			vim.g.scrollview_current_only = true
			vim.g.scrollview_winblend = 100 -- 透過
			vim.g.scrollview_base = "buffer"
			vim.g.scrollview_column = 176
			vim.g.scrollview_signs_on_startup = { "all" }
			vim.g.scrollview_diagnostics_severities = { vim.diagnostic.severity.ERROR }
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		-- 依存先: mason-org/mason.nvim
		dependencies = { "mason-org/mason.nvim", opts = {} },
	},
	{
		"previm/previm",
		ft = "markdown", -- key や cmd だとうまく動作しない
		init = function()
			vim.g.previm_open_cmd = "vivaldi.exe"
			vim.g.previm_wsl_mode = "1"

			--[[
            -- previm/previm ファイル開く度に立ち上がるのが意外と不便だったので廃止
            -- autocmd BufRead,BufNewFile *.{text,txt,md} vim.opt.filetype=markdown
			autocmd({ "BufRead", "BufNewFile" }, {
				once = true,
				pattern = { "*.text", "*.txt", "*.md" },
				command = ":PrevimOpen",
			})
            ]]
		end,
	},
	{
		"tpope/vim-commentary",
		keys = { "gcc", "gc", "gcap" },
		init = function()
			-- tpope/vim-commentary が Typst でも動作するように設定
			autocmd("FileType", {
				once = true,
				pattern = "typst",
				command = "",
				vim.opt_local.commentstring:append("// %s"),
			})
		end,
	},
}

require("lazy").setup(plugins, opts)

local no_used = {
	{
		"cohama/lexima.vim", -- 括弧閉じるやつ、逆効果な場面もあるから無効化してみる
		event = "InsertEnter",
		config = function()
			-- （）の設定
			vim.fn["lexima#add_rule"]({
				char = "（",
				input_after = "）",
			})
			vim.fn["lexima#add_rule"]({
				char = "）",
				at = [[\%#）]],
				leave = 1,
			})

			-- 「」の設定
			vim.fn["lexima#add_rule"]({
				char = "「",
				input_after = "」",
			})
			vim.fn["lexima#add_rule"]({
				char = "」",
				at = [[\%#」]],
				leave = 1,
			})

			-- $ の設定
			-- vim.fn["lexima#add_rule"]({
			-- char = "$",
			-- input_after = "$",
			-- })
			-- vim.fn["lexima#add_rule"]({
			-- char = "$",
			-- at = [[\%#\$]],
			-- leave = 1,
			-- })
		end,
	},
	{
		"Eandrju/cellular-automaton.nvim", -- 完全にネタプラグインだから
		cmd = "CellularAutomaton",
		-- "<leader>r",
	},
	{
		"chomosuke/typst-preview.nvim", -- masonの方で入れてるLSPで十分っぽい
		ft = "typst",
		init = function()
			require("typst-preview").setup({
				open_cmd = '"/mnt/c/Users/yorugo/AppData/Local/Vivaldi/Application/vivaldi.exe" %s',
				-- open_cmd = '"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" %s',
				-- follow_cursor = false,
			})
		end,
	},
	{
		"IogaMaster/neocord", -- 設定複雑だし、重いし、Discordそもそも起動しなくなった
		event = "VeryLazy",
		keys = { "<leader>d" },
		init = function()
			require("neocord").setup({
				-- https://github.com/IogaMaster/neocord?tab=readme-ov-file#lua
				-- 無効化はスペース２つ
				editing_text = "Editing now",
				file_explorer_text = "Browsing now",
				reading_text = "Reading now",
				workspace_text = "🦕💭",
				line_number_text = "Line %s out of %s",
			})
		end,
	},
	{
		"mattn/vim-maketable", -- markdown の表、まじで使わんねんな
		cmd = { "MakeTable", "UnmakeTable" },
	},
	{
		"mfussenegger/nvim-lint", -- 気づいたら使ってなかった
		-- 以下のイベントで自動読み込み
		event = { "BufReadPost", "BufWritePost" },
		config = function()
			local lint = require("lint")

			-- ファイルタイプ別のリンターを定義
			-- LSP と競合するので使わない
			lint.linters_by_ft = {
				-- go = { "golangcilint" }, -- Go: golangci-lint
				-- python = { "flake8" }, -- Python: flake8
				-- javascript = { "eslint_d" }, -- JS: eslint_d
			}

			-- バッファを開いたとき／保存したときに自動で lint を実行
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
	{
		--[[
        対応言語: https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
        導入１: https://zenn.dev/duglaser/articles/c02d6a937a48df
		導入２: https://konnyakmannan.com/archives/neovim_treesitter_setup_on_windows11/
        メモ: プラグインマネージャーは関係ない `:TSInstallInfo`
        ]]
		"nvim-treesitter/nvim-treesitter", -- treesitter なくてもハイライト効くし、重いし
		event = "VeryLazy",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = { enable = true, additional_vim_regex_highlighting = true },
				indent = { enable = true },
				ensure_installed = {
					"bash",
					"bibtex",
					"c",
					"cpp",
					"css",
					"csv",
					"dockerfile",
					"fish",
					"git_config",
					"git_rebase",
					"gitcommit",
					"gitignore",
					"go",
					"gomod",
					"gosum",
					"html",
					"javascript",
					"json",
					"json5",
					"jsonc",
					"lua",
					"markdown",
					"markdown_inline",
					"python",
					"sql",
					"toml",
					"tsx",
					"typescript",
					"typst",
					"yaml",
					"vim",
				},
			})
		end,
	},
	{
		"skanehira/translate.vim", -- 翻訳まじ使ったことない
		cmd = "Translate",
	},
	{
		"tyru/open-browser.vim", -- previm/previm の依存，wsl と相性が悪いので採用なし
	},
	{
		"ray-x/go.nvim", -- mason の方でいれてる LSP で十分っぽい
		dependencies = {
			-- optional packages, dependencies に記述は非推奨
			-- "ray-x/guihua.lua",
			-- "neovim/nvim-lspconfig",
			-- "nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		-- if you need to install/update all binaries
		build = ':lua require("go.install").update_all_sync()',
	},
	{
		"vim-jp/vimdoc-ja", -- ヘルプ使わんし、いいかなって
		keys = { "h", mode = "c" },
		init = function()
			-- 日本語化プラグインの設定
			vim.opt.helplang = ja
		end,
	},
	{ "wakatime/vim-wakatime", event = "VeryLazy" },
}

-- 公式ドキュメント: https://lazy.folke.io/spec

--[[ 説明
init: （neovim の？）起動時に常に実行， vim.g.* の設定に役立つ
    init = function() require("scrollview").setup{
        excluded_filetypes = {"nerdtree"},
    } end,
config: プラグインのロード時に実行
        opts か config = true が設定されていれば，
        自動的に require(MAIN).setup(opts) を実行
build: プラグインがインストールまたは更新されたときに実行
        文字列 は シェルコマンド
        先頭 : は Neovimコマンド
lazy: event, keys, cmd, ft, require() のいずれかで発火する遅延に
]]

--[[ usage
キーマップ
    モード指定すると副作用あり -> 改善？
    特に，コマンドラインでの入力はキーマップと c モードで指定する
	keys = { "h", mode = "c" } },

１つの関数
    build = function() vim.cmd.GlowInstall() end,

複数の関数
    init = function()
        vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")
        vim.keymap.set("n", "ga", "<Plug>(EasyAlign)")
    end,

イベント
    -- * "BufEnter" か "BufEnter *.lua" で指定
    -- "VeryLazy" Neovim の起動後にアイドル状態で発火 lazy.nvim 独自
    -- https://vim-jp.org/vimdoc-ja/autocmd.html
    event = {"FocusLost", "CursorHold"},

vim コマンド
    cmd = {":avim", ":bstart"},

依存（おそらく非推奨）
    dependencies = "repo",

ファイルタイプ
    ft = "go",

キーマップ
    keys = {"v", "<CR>"},
]]
