# name: clearance
# ---------------
# Based on idan. Display the following bits on the left:
# - Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# - Current directory name
# - Git branch and dirty state (if inside a git repo)

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _remote_hostname
  echo (whoami)@(hostname -s)
end

function fish_prompt
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l normal (set_color normal)
  set -l mywhite (set_color -o white)
  set -l mygreen (set_color -o green)

  # User@server time
  echo -n -s $green (hostname -s) $normal

  # Print pwd or full path
  # echo -n -s  " " $blue (pwd | sed "s:^$HOME:~:") $normal
  echo -n -s " " $blue (prompt_pwd) $normal

  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info '(' $yellow $git_branch "*" $normal ')'
    else
      set git_info '(' $green $git_branch $normal ')'
    end
    echo -n -s ' ' $git_info $normal
  end

  # Terminate with a nice prompt char
  echo -e -n -s ' » ' $normal
end

