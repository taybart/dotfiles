function fish_right_prompt
  for color in $fish_color_error
    # If any of the colour variables aren't defined they're set to 'normal' colour
    if set -q color
      set color normal
    end
  end

  set -l status_copy $status
  set -l status_color 0fc

  if test "$status_copy" -ne 0
    set status_color $fish_color_error
  end


  if test -n "$CMD_DURATION" -a "$CMD_DURATION" -gt 100
    set -l duration_copy $CMD_DURATION
    set -l duration (echo $CMD_DURATION | __fmt_cmd_duration)
    echo -sn (set_color $status_color) "$duration" (set_color normal)
  else if set -l last_job_id (last_job_id -l)
    echo -sn (set_color $status_color) "%$last_job_id" (set_color normal)
  else
    echo -sn (set_color 555) (date "+%H:%M") (set_color normal)
  end
end

function last_job_id
  jobs $argv | command awk '/^[0-9]+\t/ { print status = $1 } END { exit !status }'
end

function __fmt_cmd_duration -d 'Displays the elapsed time of last command'
  set -l seconds ''
  set -l minutes ''
  set -l hours ''
  set -l days ''
  set -l cmd_duration (expr $CMD_DURATION / 1000)
  if [ $cmd_duration -gt 0 ]
    set seconds (expr $cmd_duration \% 68400 \% 3600 \% 60)'s'
    if [ $cmd_duration -ge 60 ]
      set minutes (expr $cmd_duration \% 68400 \% 3600 / 60)'m'
      if [ $cmd_duration -ge 3600 ]
        set hours (expr $cmd_duration \% 68400 / 3600)'h'
        if [ $cmd_duration -ge 68400 ]
          set days (expr $cmd_duration / 68400)'d'
            end
        end
    end

    if test $last_status -ne 0
      set_color red; echo -n ' '$days$hours$minutes$seconds' '
    else
      echo -n ' '$days$hours$minutes$seconds' '
    end
  end
end
