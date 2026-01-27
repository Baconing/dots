{ config, pkgs, lib, ... }:
let
  lspServers = with pkgs; [
    { package = nil; name = "nil_ls"; }
    { package = lua-language-server; name = "lua_ls"; }
    { package = typescript-language-server; name = "ts_ls"; }
    { package = pyright; name = "pyright"; }
    { package = gopls; name = "gopls"; }
    { package = clang-tools; name = "clangd"; }
    { package = rust-analyzer; name = "rust-analyzer"; }
    { package = bash-language-server; name = "bashls"; }
    { package = yaml-language-server; name = "yamlls"; }
    { package = nodePackages.vscode-json-languageserver; name = "jsonls"; }
    { package = java-language-server; name = "java_language_server";}
    { package = kotlin-language-server; name = "kotlin_language_server"; }
  ];
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      wl-clipboard
    ] ++ map (s: s.package) lspServers;
    extraConfig = ''
      set number
      set relativenumber
      let statuscolumn = "%r %l "
      
      set undofile
      
      set clipboard+=unnamedplus
      
      set showcmd
      let mapleader = "<Space>"
      
      colorscheme retrobox
    '';
    extraLuaConfig = ''
    '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = mini-icons;
        type = "lua";
        config = /* lua */ ''
            require("mini.icons").setup()
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

      {
        plugin = which-key-nvim;
        type = "lua";
        config = /* lua */ ''
        require("which-key").register({
            {prefix = "<leader>" }
        })
        '';
      }


      nvim-treesitter.withAllGrammars
      nvim-ts-context-commentstring
      nvim-treesitter-textobjects
      
      {
        plugin = cmp-nvim-lsp;
        type = "lua";
        config = /* lua */ ''
        require("cmp_nvim_lsp").setup()
        '';
      }
      cmp-buffer

      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = /* lua */ ''
        local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local servers = ${lib.generators.toLua {} (map (s: s.name) lspServers)}

            for _, lsp in ipairs(servers) do
                lspconfig[lsp].setup({ capabilities = capabilities })
            end
        '';
      }
      
      {
        plugin = nvim-cmp;
        type = "lua";
        config = /* lua */ ''
        local cmp = require("cmp")
            cmp.setup({
            snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
            },
            mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            }),
        })
        '';
      }

      {
        plugin = mason-nvim;
        type = "lua";
        config = /* lua */ ''
        require("mason").setup()
        '';
      }
      mason-lspconfig-nvim

      /*
      {
        plugin = copilot-lua;
	type = "lua";
        config = /* lua * / ''
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
      */
    ];
  };
}
