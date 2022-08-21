local status, ls = pcall(require, 'luasnip')
if (not status) then return end


local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local extras = require("luasnip.extras")
local m = extras.m
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix


-- print("defined a luasnip trigger")

ls.add_snippets("javascript", {
  -- s("trigger", { t("Wow! Text!") }),
  -- s("trigger2", {
  --     t({"After expanding, the cursor is here ->"}), i(1),
  --     t({"", "After jumping forward once, cursor is here ->"}), i(2),
  --     t({"", "After jumping once more, the snippet is exited there ->"}), i(0),
  -- }),
  -- s("trig", c(1, {
  --    t("Ugh boring, a text node"),
  --    i(nil, "At least I can edit something now..."),
  --    f(function(args) return "Still only counts as text!!" end, {})
  -- })),
  s("express", {
    t({
      [[const express = require("express");]],
      [[const morgan = require('morgan');]],
      [[const bodyParser = require('body-parser')]],
      [[const cors = require('cors');]],
      [[const winston = require('winston');]],
    })
  }),
  s("iife", {
    t({"(async () => {",""}),
    t({"\t"}), i(1),
    t({"", "})();",""}),
    i(2),
  }),
  s("logger", {
    t({
      [[const winston = require('winston');]],
      [[const logger = winston.createLogger({]],
      [[	format: winston.format.combine(]],
      [[		winston.format.timestamp(),]],
      [[		winston.format.splat(),]],
      [[		winston.format.cli(),]],
      [[	),]],
      [[	transports: [new winston.transports.Console()] ]],
      [[});]],
    })

  }),
})

-- Set the keymaps imap 
-- :help nvim_set_keymap()
-- :help :map-arguments
-- :help luasnip
vim.keymap.set('i', '<Tab>', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'", {silent=true, expr = true})
vim.keymap.set('i', '<S-Tab>', function() ls.jump(-1) end, {silent=true})

vim.keymap.set('s', '<Tab>', function() ls.jump(1) end, {silent=true})
vim.keymap.set('s', '<S-Tab>', function() ls.jump(-1) end, {silent=true})

vim.keymap.set({'i', 's'}, '<C-E>', "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'", {silent=true, expr=true})
