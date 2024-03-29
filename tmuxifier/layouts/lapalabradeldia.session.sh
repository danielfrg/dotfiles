# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/code/inmatura/lapalabradeldia.com"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "lapalabradeldia_com"; then
  new_window "editor"
  new_window "server"

  select_window 2
  run_cmd "npm run dev"

  select_window 1
  run_cmd "nvim"
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
