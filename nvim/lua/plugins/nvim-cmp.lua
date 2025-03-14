return {
  {
    "hrsh7th/nvim-cmp",
    opts = {
      mapping = {
        ["<C-j>"] = function(fallback)
          if require("cmp").visible() then
            require("cmp").select_next_item()
          else
            fallback()
          end
        end,
        ["<C-k>"] = function(fallback)
          if require("cmp").visible() then
            require("cmp").select_prev_item()
          else
            fallback()
          end
        end,
      },
    },
  },
}
