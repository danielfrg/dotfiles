return {}

-- return {
--     "rmagatti/auto-session",
--     config = function()
--         require("auto-session").setup {
--             log_level = "error",
--             auto_session_suppress_dirs = {
--                 "~/", "~/Downloads", "~/Documents"
--             },
--             auto_session_use_git_branch = true,
--             auto_save_enabled = true,
--
--             session_lens = {
--                 -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
--                 load_on_setup = false,
--             }
--         }
--     end
-- }
