local function load_secret(secret_name)
  local handle = io.popen("pass " .. secret_name)
  if not handle then
    error(
				"Failed to load secret '"
				.. secret_name
				.. "'. Error: handle cannot be created"
		)
  end
	local result = handle:read "*a"
	handle:close()
	return result:gsub("\n", "")
end

-- ozon_openai_compatible_for_model это метод-helper, который помогает
-- избавиться от кучи дублирования в настройке.
local function ozon_openai_compatible_for_model(model)
		return function()
				local ozon_api_key = load_secret "cloud/ozon/o3-llm-token"
				return require("codecompanion.adapters").extend("openai_compatible",
				{
						env = {
								url = "https://llm-gateway-proton.t.o3.ru/api",
								api_key = ozon_api_key,
								chat_url = "/chat/completions",
								models_endpoint = "/models",
						},
						schema = {
								model = {
										default = model,
								},
						},
				})
		end
end

return {
	"olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    -- NOTE: The log_level is in `opts.opts`
    opts = {
      log_level = "DEBUG", -- or "TRACE"
    },
  },
	config = function()
		require("codecompanion").setup {
				adapters = {
				["ozon_DeepSeek-R1-671B-AWQ_llm"] = ozon_openai_compatible_for_model "DeepSeek-R1-671B-AWQ",
				},
		}
	end
}
