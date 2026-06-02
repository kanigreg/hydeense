local get_yandex_ai_models = function(self, opts)
  local adapter = require("codecompanion.adapters").resolve(self)

  if not adapter.env_replaced then
    local utils = require("codecompanion.utils.adapters")
    utils.get_env_vars(adapter)
  end

  local models = {
    ["gpt://" .. adapter.env_replaced.ai_project .. "/yandexgpt-lite/latest"] = {
      formatted_name = "YandexGPT Lite",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/yandexgpt-lite/rc"] = {
      formatted_name = "YandexGPT Lite (rc)",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/yandexgpt/latest"] = {
      formatted_name = "YandexGPT 5 Pro",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/yandexgpt/rc"] = {
      formatted_name = "YandexGPT 5.1 Pro",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/yandex-art/latest"] = {
      formatted_name = "YandexART",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/text-embeddings/latest"] = {
      formatted_name = "Yandex Text embeddings 1",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/text-search-query/latest"] = {
      formatted_name = "Yandex Text embeddings (query) 1",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/text-search-doc/latest"] = {
      formatted_name = "Yandex Text embeddings (doc) 1",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/qwen3-235b-a22b-fp8/latest"] = {
      formatted_name = "Qwen3 235B A22B Instruct 2507 FP8",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/qwen2.5-vl-32b-instruct/latest"] = {
      formatted_name = "Qwen2.5 VL 32B Instruct",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/gemma-3-27b-it/latest"] = {
      formatted_name = "Gemma 3 27B IT",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/gpt-oss-20b/latest"] = {
      formatted_name = "GPT OSS 20B",
    },
    ["gpt://" .. adapter.env_replaced.ai_project .. "/gpt-oss-120b/latest"] = {
      formatted_name = "GPT OSS 120B",
    },
  }

  if opts and opts.default then
    -- YandexGPT Lite is default
    return "gpt://" .. adapter.env_replaced.ai_project .. "/yandexgpt-lite/latest"
  else
    return models
  end
end

local yandex_ai_adapter = function()
  return require("codecompanion.adapters").extend("openai_compatible", {
    name = "yandex_ai",
    formatted_name = "Yandex AI Studio",
    env = {
      url = "https://llm.api.cloud.yandex.net",
      chat_url = "/v1/chat/completions",
      api_key = "cmd: dot-bws yandex_ai_api_key",
      ai_project = "cmd: dot-bws yandex_ai_project",
    },
    headers = {
      Authorization = "Api-Key ${api_key}",
      ["OpenAI-Project"] = "${ai_project}",
    },
    schema = {
      model = {
        default = function(self)
          return get_yandex_ai_models(self, { default = true })
        end,
        choices = function(self)
          return get_yandex_ai_models(self)
        end,
      },
    },
  })
end

return yandex_ai_adapter
