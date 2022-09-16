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
  s("require", {
    t("const "),
    i(1, "modulename"),
    t(" = require('"),
    rep(1),
    t("');"),
    t(''),
    i(0)
  }),
  s("test2", {
    t("test2 insert text: "), i(1), t(''),
    t("test insert some more text: "), i(2)

  }),
  s("iife", {
    t({ "(async () => {", "" }),
    t({ "\t" }), i(1),
    t({ "", "})();", "" }),
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
  }), -- logger
  s("mongooseschema", {
    t({ "const " }), i(1, "schemaName"), t({ " = mongoose.Schema({", "" }),
    t({ "\t" }), i(2, "attrName"), t({ ": {type: String, required: true, index: {unique: true}},", "" }),
    t({ "\t// other attributes", "" }),
    t({ "\t" }), i(0),
    t({ "", "" }),
    t({ "}); // " }), rep(1), t("")
  }), -- mongooseschema
  s("mongooseconn", {
    t("const "), i(1, "conn"), t(" = mongoose.createConnection("), i(2, "process.env.MONGO_URL"), t({ ");", "" }),
    rep(1), t([[.model(']]), i(3, "User"), t([[', ]]), i(4, "userSchema"), t({ ");", "" }),
    i(0),
  }), -- mongooseconn
  ls.parser.parse_snippet({ trig = "axios" }, [[
    const axios = require('axios')
    axios.post('$1', {
      ${2:key: value}
    })
    .then(res => {
      console.log(`statusCode: ${res.status}`);
      console.log(res);
    })
    .catch(error => {
      console.error(error);
    });
    $0
    ]])
})

-- Set the keymaps imap
-- :help nvim_set_keymap()
-- :help :map-arguments
-- :help luasnip
vim.keymap.set('i', '<Tab>', "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'",
  { silent = true, expr = true })
vim.keymap.set('i', '<S-Tab>', function() ls.jump(-1) end, { silent = true })

vim.keymap.set('s', '<Tab>', function() ls.jump(1) end, { silent = true })
vim.keymap.set('s', '<S-Tab>', function() ls.jump(-1) end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<C-E>', "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'",
  { silent = true, expr = true })



-- set keybinds for both INSERT and VISUAL. cycle choice node
vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})
