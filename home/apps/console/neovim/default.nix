{ inputs, config, lib, ... }:
{
    imports = [
        inputs.nixvim.homeModules.nixvim
    ];

    programs.git = lib.mkIf (config.programs.git.enable) {
        settings = {
	    diff.tool = "nvimdiff";
	    difftool = {
	    	prompt = true;
		trustExitCode = true;
	    	"nvimdiff".cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
	    };
	};
    };

    programs.nixvim = {
        enable = true;
	defaultEditor = true;

	nixpkgs.source = inputs.nixpkgs;

	opts = {
	    number = true;
	    relativenumber = true;
	    statuscolumn = "%=%{v:relnum} %l%s";

	    undofile = true;

	    showcmd = true;
	
	    foldlevelstart = 99;
	};

	globals = {
	    mapleader = " ";
	};

	extraConfigVim = /** vim **/ ''
	  colorscheme slate
	'';

	clipboard.providers.wl-copy.enable = true;

	lsp = {
	    luaConfig.post = /** lua **/ ''
	      vim.diagnostic.config({
                update_in_insert = true,
              })
	    '';

	    servers = {
	        asm_lsp.enable = true;
		autotools_ls.enable = true;
		clangd.enable = true;
		cmake.enable = true;
		docker_language_server.enable = true;
		dts_lsp.enable = true;
		eslint.enable = true;
		fish_lsp.enable = true;
		gopls.enable = true;
		graphql.enable = true;
		helm_ls.enable = true;
		html.enable = true;
		hyprls.enable = true;
		jdtls.enable = true;
		jsonls.enable = true;
		just.enable = true;
		kotlin_language_server.enable = true;
		lua_ls.enable = true;
		luau_lsp.enable = true;
		marksman.enable = true;
		matlab_ls.enable = true;
		nginx_language_server.enable = true;
		nil_ls.enable = true;
		nushell.enable = true;
		openscad_lsp.enable = true;
		phpantom.enable = true;
		postgres_lsp.enable = true;
		pylsp.enable = true;
		rust_analyzer.enable = true;
		svelte.enable = true;
		systemd_lsp.enable = true;
		tailwindcss.enable = true;
		teal_ls.enable = true;
		texlab.enable = true;
		typos_lsp.enable = true;
		vimls.enable = true;
		wasm_language_tools.enable = true;
		yamlls.enable = true;
	    };
        };

	plugins = {
	    cmp = {
	        enable = true;
	        autoEnableSources = true;
		settings = {
		    mapping = {
		        "<Tab>" = "cmp.mapping.select_next_item()";
			"<S-Tab>" = "cmp.mapping.select_prev_item()";
			"<CR>" = "cmp.mapping.confirm({ select = true })";
			"<C-Space>" = "cmp.mapping.complete()";
			"<C-e>" = "cmp.mapping.complete()";
		    };

		    sources = [
		        { name = "buffer"; }
			{ name = "git"; }
			{ name = "latex_symbols"; }
		        { name = "nvim_lsp"; }
		        { name = "path"; }
	            ];
		};

		luaConfig.post = /** lua **/ ''
		  local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
		  vim.lsp.config('*', { capabilities = cmp_capabilities })
		'';
	    };

	    lspconfig.enable = true;
	    
            mini-cursorword.enable = true;
	    mini-icons = {
	    	enable = true;
		mockDevIcons = true;
	    };
	    mini-statusline.enable = true;
	    mini-tabline.enable = true;

            telescope = {
		enable = true;
		
		# TODO: add ghq extension
		extensions = {
		    advanced-git-search.enable = true;
		    file-browser.enable = true;
		    fzf-native.enable = true;
	            manix.enable = true;
		    media-files.enable = true;
		    undo.enable = true;
                };
	
		keymaps = {
	            "<leader>ts" = {
			action = "live_grep";
			options = {
			    desc = "Grep";
			};
		    };
		    "<leader>tf" = { 
			action = "find_files";
			options = {
			    desc = "Files";
			};
		    };
		    "<leader>tb" = {
			action = "file_browser";
			options = {
			    desc = "File Browser";
			};
		    };
		    "<leader>tgg" = {
			action = "advanced_git_search search_log_content";
			options = {
			    desc = "Git Commit History";
			};
		    };
		    "<leader>tgf" = {
			action = "advanced_git_search search_log_content_file";
			options = {
			    desc = "Git Commit History (Current File)";
			};
		    };
		    "<leader>tn" = {
			action = "manix";
			options = {
			    desc = "Nix Documentation";
			};
		    };
		    "<leader>tm" = {
			action = "media_files";
			options = {
			    desc = "Media Files";
			};
		    };
		    "<leader>tu" = {
			action = "undo";
			options = {
			    desc = "Undo History";
			};
		    };
		};
	    };
		    

            todo-comments.enable = true;

	    treesitter = {
	        enable = true;
		highlight.enable = true;
    		folding.enable = true;
	    };
	    treesitter-context.enable = true;
	    treesitter-textobjects.enable = true;
	    ts-context-commentstring.enable = true;
	  
	    which-key.enable = true;
	};
    };
}
