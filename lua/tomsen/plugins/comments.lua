return {
  "numToStr/Comment.nvim", -- commenting/uncommenting
  config = function()
    require 'Comment'.setup()
  end
}

-- gc toggle inline commenting
-- gb toggle block commenting
-- gcO create commented line above
-- gco create commented line below
-- gcA create comment end of line
