local status, colorizer = pcall(require, 'colorizer')
if (not status) then return end

-- colorize css hex colors in css and javascript files
colorizer.setup({
  'css';
  'javascript';

})
