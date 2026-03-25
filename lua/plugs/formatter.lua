--[[
https://github.com/mhartington/formatter.nvim#configure
~/.local/share/nvim/lazy/formatter.nvim/lua/formatter/filetypes/
]]

-- 設定（configurations）生成ユーティリティ
local util = require("formatter.util")

-- php のフォーマッタで、vendor/bin/phpcbf が実行可能ならその設定を利用する
-- なければ formatter.nvim 標準の設定 （グローバルな phpcbf）を利用
local php_formatter
if vim.fn.executable("vendor/bin/phpcbf") == 1 then
	php_formatter = function()
		return {
			exe = "vendor/bin/phpcbf",
			args = { "-q" },
			stdin = true,
			ignore_exitcode = true,
		}
	end
else
	php_formatter = require("formatter.filetypes.php").phpcbf
end

-- Format, FormatWrite, FormatLock, FormatWriteLock のコマンドを提供
require("formatter").setup({
	-- ログの設定
	logging = true,
	log_level = vim.log.levels.WARN,

	-- すべてのフォーマッタ設定はオプトイン（書かないとならない）
	-- Mason で インストールして，こちらでファイルタイプと紐づけ
	-- https://github.com/mhartington/formatter.nvim/tree/master/lua/formatter/filetypes
	filetype = {
		-- prettierd 使う
		css = { require("formatter.filetypes.css").prettierd },
		graphql = { require("formatter.filetypes.graphql").prettierd },
		json = { require("formatter.filetypes.json").prettierd },
		javascript = { require("formatter.filetypes.javascript").prettierd },
		javascriptreact = { require("formatter.filetypes.javascriptreact").prettierd },
		markdown = { require("formatter.filetypes.markdown").prettierd },
		typescript = { require("formatter.filetypes.typescript").prettierd },
		typescriptreact = { require("formatter.filetypes.typescript").prettierd },
		vue = { require("formatter.filetypes.vue").prettierd },

		-- prettierd 以外
		c = { require("formatter.filetypes.c").clangformat },
		go = { require("formatter.filetypes.go").gofumpt },
		html = { require("formatter.filetypes.html").ast_grep },
		lua = { require("formatter.filetypes.lua").stylua },
		python = { require("formatter.filetypes.python").black },
		sql = { require("formatter.filetypes.sql").sqlfluff },
		yaml = { require("formatter.filetypes.yaml").yamlfmt },

		-- 自作
		bib = { -- bibtex-tidy
			function()
				return {
					exe = "bibtex-tidy",
					args = { "-" },
					stdin = true,
				}
			end,
		},
		jsx = { -- prettierd
			function()
				return {
					exe = "prettierd",
					args = { util.escape_path(util.get_current_buffer_file_path()) },
					stdin = true,
				}
			end,
		},
		php = { -- ローカルの phpcbf か、グローバルの phpcbf か
			php_formatter,
		},
		svg = { -- xmlformat
			function()
				return {
					exe = "xmlformat",
					args = { "-" },
					stdin = true,
				}
			end,
		},
		typst = { -- typstyle
			function()
				return {
					exe = "typstyle",
					stdin = true,
				}
			end,
		},

		-- その他
		-- ["*"] = { require("formatter.filetypes.any").remove_trailing_whitespace },
	},
})

-- prettierd but not support formatter.vim
-- https://github.com/mhartington/formatter.nvim/tree/master/lua/formatter/filetypes
-- angular = { require("formatter.filetypes.angular").prettierd },
-- flow = { require("formatter.filetypes.flow").prettierd },
-- less = { require("formatter.filetypes.less").prettierd },
-- scss = { require("formatter.filetypes.scss").prettierd },
