local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local status_ok, trouble_telescope = pcall(require, "trouble.providers.telescope")
if not status_ok then
    return
end

local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local U = require("danielfrg.utils")

telescope.setup {
    defaults = {
        prompt_prefix = " ",
        -- selection_caret = " ",
        path_display = { "smart" },
        mappings = {
            i = {
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-c>"] = actions.close,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["<CR>"] = actions.select_default,
                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                -- ["<C-t>"] = actions.select_tab,
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<PageUp>"] = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<C-l>"] = actions.complete_tag,
                ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                -- Trouble
                ["<c-t>"] = trouble_telescope.open_with_trouble,
            },
            n = {
                ["<esc>"] = actions.close,
                ["<CR>"] = actions.select_default,
                ["<C-x>"] = actions.select_horizontal,
                ["<C-v>"] = actions.select_vertical,
                -- ["<C-t>"] = actions.select_tab,
                ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                ["j"] = actions.move_selection_next,
                ["k"] = actions.move_selection_previous,
                ["H"] = actions.move_to_top,
                ["M"] = actions.move_to_middle,
                ["L"] = actions.move_to_bottom,
                ["<Down>"] = actions.move_selection_next,
                ["<Up>"] = actions.move_selection_previous,
                ["gg"] = actions.move_to_top,
                ["G"] = actions.move_to_bottom,
                ["<C-u>"] = actions.preview_scrolling_up,
                ["<C-d>"] = actions.preview_scrolling_down,
                ["<PageUp>"] = actions.results_scrolling_up,
                ["<PageDown>"] = actions.results_scrolling_down,
                ["?"] = actions.which_key,
                -- Trouble
                ["<C-t>"] = trouble_telescope.open_with_trouble,
            },
        },
    },
    pickers = {
        find_files = {
            hidden = true
        }
    }
}

-- Mostly from LazyVim and LunarVim
U.keymap('n', '<leader>fb', builtin.buffers, { desc = '[F]ind existing [B]uffers' })
U.keymap('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })

U.keymap('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })


U.keymap('n', '<leader>ff', function()
    builtin.find_files(require('telescope.themes').get_dropdown {
      previewer = false,
    })
  end, { desc = '[F]ind File (all)' })

  U.keymap('n', '<C-p>', function()
    builtin.git_files(require('telescope.themes').get_dropdown {
      previewer = false,
    })
end, { desc = '[F]ind [F]ile (uses gitignore)' })


U.keymap("n", "<leader>sf", builtin.live_grep, { desc = 'Live Grep [S]earch [F]ile' })
U.keymap("n", "<leader>sg", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = '[S]earch [G]rep (no live)' })

U.keymap('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
U.keymap('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })

-- U.keymap('n', '<leader>vh', builtin.help_tags, opts)

-- -- Extensions
telescope.load_extension("yaml_schema")
