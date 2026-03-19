-- https://zenn.dev/hisasann/articles/neovim-settings-to-lua

local opt = {
	-- UI
	cursorline = true, -- カーソルが存在する行にハイライト
	number = true, -- 行番号
	ruler = true, -- カーソル位置
	showcmd = true, -- 入力中のコマンド表示
	termguicolors = false, -- 背景色をターミナルの背景色と同期

	-- エンコーディング，ファイル設定
	encoding = "utf-8", -- neovim 内部の文字エンコーディング
	fileencoding = "utf-8", -- 保存時のエンコーディング
	fileencodings = "utf-8,utf-16,cp932", -- 読み込み時に試行するエンコーディング
	fileformats = "unix,dos,mac", -- 試行する改行コード
	swapfile = false, -- スワップファイル

	-- インデント，タブ
	expandtab = true, -- タブ文字を tabstop 個の半角スペースに置換
	shiftwidth = 4, -- 挿入するインデントの幅
	smartindent = true, -- 改行時にインデント
	tabstop = 4, -- タブ文字の表示幅

	-- 検索
	hlsearch = true, -- 検索結果のハイライト
	incsearch = true, -- 文字を入力する度に検索

	-- その他
	-- clipboard = "unnamedplus", -- "+ と "* レジスタをクリップボードと同期
	mouse = "a", -- すべてのモードでマウス操作を有効化
	shell = "fish", -- デフォルトシェル
	splitbelow = true, -- 水平分割の新規ウィンドウを現在の下にする (true)
	splitright = false, -- 垂直分割の新規ウィンドウを現在の左にする (false)

	shell = "/bin/bash",
}

for i, v in pairs(opt) do
	vim.opt[i] = v
end

-- 一部のファイルで、タブ押下時のスペースを 2 つにする設定
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "c", "typst", "markdown" },
	callback = function()
		vim.opt.shiftwidth = 2
	end,
})

-- 一部のファイルで、タブ押下時はタブにする設定
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go", "php" },
	callback = function()
		vim.opt.expandtab = false
	end,
})
