{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraConfig = ''
    '';
    plugins = with pkgs.vimPlugins; [
      #{
      #  plugin = mini-icons;
      #  type = "lua";
      # config = /* lua */ ''
      #   require("mini.icons").setup()
      # '';
      #}
      {
        plugin = mini-tabline;
	type = "lua";
	config = /* lua */ ''
	  require("mini.tabline").setup()
	'';
      }
      {
        plugin = mini-statusline;
	type = "lua";
	config = /* lua */ ''
	  require("mini.statusline").setup()
	'';
      }
      {
        plugin = mini-tabline;
	type = "lua";
	config = /* lua */ ''
	  require("mini.tabline").setup()
	'';
      }
      {
        plugin = mini-cursorword;
	type = "lua";
	config = /* lua */ ''
	  require("mini.cursorword").setup()
	'';
      }

      {
        plugin = chadtree;
	config = ''
	  autocmd VimEnter * CHADopen --nofocus
	'';
      }

      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      {
        plugin = copilot-lua;
	type = "lua";
        config = /* lua */ ''
          require("copilot").setup({
            panel = {
              enabled = true,
              auto_refresh = false,
              keymap = {
                accept = "<Enter>",
                refresh = "gr",
                open = "<M-CR>",
                jump_next = "]]",
                jump_prev = "[["
              },
            layout = {
              position = "right",
              ratio = 0.3
            },
          },
          suggestion = {
            enabled = true,
            auto_trigger = false,
            hide_during_completion = false,
            debounce = 75,
            trigger_on_accept = true,
            keymap = {
              accept = "<C-Tab>",
              accept_word = "<Shift-Tab>",
              accept_line = false,
              next = "]]",
              prev = "[[",
              dismiss = "<C-]>",
            },
          },
          filetypes = {
            gitcommit = false,
            gitrebase = false,
          },
          auth_provider_url = nil,
          logger = {
            file = vim.fn.stdpath("log") .. "/copilot-lua.log",
            file_log_level = vim.log.levels.OFF,
            print_log_level = vim.log.levels.WARN,
            trace_lsp = "off", -- "off" | "messages" | "verbose"
            trace_lsp_progress = false,
            log_lsp_messages = false,
          },
          copilot_node_command = '${pkgs.nodejs}/bin/node', -- Node.js version must be > 20
          workspace_folders = {},
          copilot_model = "",  -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
          root_dir = function()
            return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
          end,
          
          should_attach = function(_, _)
            if not vim.bo.buflisted then
              logger.debug("not attaching, buffer is not 'buflisted'")
              return false
            end

            if vim.bo.buftype ~= "" then
              logger.debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
              return false
            end

            return true
          end,
          
          server = {
            type = "binary", -- "nodejs" | "binary"
            custom_server_filepath = nil,
          },
          server_opts_overrides = {},
          })
	'';
      }
    ];
  };
}
