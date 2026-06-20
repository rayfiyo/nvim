--[[基本noremap、<Plug>時map、Lua関数可
    command_mode      "c"
    insert_mode       "i"
    normal_mode       "n"
    term_mode         "t"
    visual_mode       "v"
    visual_block_mode "x"

    noremap ではない（素のvimのではない）
    {remap = true}            ]]

local map = vim.keymap.set

-- リーダーキーをスペースにする設定
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 通常マッピング
map("n", "<ESC><ESC>", "<cmd>noh<CR>") -- Escキー をタブルクリックで、ハイライト削除
map({ "n", "i" }, "<F2>", "<Esc>:w<CR>:!cat % | iconv -t UTF-16LE | /mnt/c/Windows/System32/clip.exe<CR>")
map({ "n", "i" }, "<F6>", "<Esc>:w<CR>:!go test %<CR>")
map({ "n", "i" }, "<F5>", function()
	-- 現在のファイルタイプ: vim.bo.filetype
	if vim.bo.filetype == "c" then
		vim.cmd("update")
		vim.cmd("!gcc -lm % && echo : && ./a.out")
	elseif vim.bo.filetype == "go" then
		vim.cmd("update")
		vim.cmd("!echo : && go run %")
	elseif vim.bo.filetype == "python" then
		vim.cmd("update")
		vim.cmd("!python %")
	elseif vim.bo.filetype == "typst" then
		vim.cmd("update")
		vim.cmd("!TYPST_FONT_PATHS=/usr/share/fonts/ typst compile %")
	end
end, { silent = true })

map({ "i" }, "<C-b>", function() -- Typst で青字のショートカット
	if vim.bo.filetype == "typst" then
		return "**<b><Left><Left><Left><Left>"
	end
end, { expr = true, silent = true }) -- expr で返り値を入力

-- map("i", "{", "{}<ESC>i") -- 閉じ｛括弧の入力
-- map("i", "{<Enter>", "{}<ESC>i<CR><ESC><S-o>") -- 閉じ（括弧の入力
-- map("i", "()", "()<ESC>i") -- 閉じ（括弧の入力
-- map("i", "()<Enter>", "<ESC>i<CR><ESC><S-o>") -- 閉じ（括弧の入力

-- 全角・半角間違い用
map("n", "：ｑ！", ":q!")
map("n", "：ｗ", ":w")
map("n", "：ｗｑ", ":wq")
map("n", "：ｗｑ！", ":wq!")
map("n", "ｈ", "h")
map("n", "ｊ", "j")
map("n", "ｋ", "k")
map("n", "ｌ", "l")
map("n", "ｄｄ", "dd")
map("n", "ｙｙ", "yy")
map("n", "うう", "uu")
map("n", "い", "i")
map("n", "あ", "a")
map("n", "お", "o")

-- タブのスペース数は vim_opt
