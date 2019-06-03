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
        set -l duration (echo $CMD_DURATION | humanize_duration)

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

function humanize_duration -d "Make a time interval human readable"
    command awk '
        function hmTime(time,   stamp) {
            split("h:m:s:ms", units, ":")
            for (i = 2; i >= -1; i--) {
                if (t = int( i < 0 ? time % 1000 : time / (60 ^ i * 1000) % 60 )) {
                    stamp = stamp t units[sqrt((i - 2) ^ 2) + 1] " "
                }
            }
            if (stamp ~ /^ *$/) {
                return "0ms"
            }
            return substr(stamp, 1, length(stamp) - 1)
        }
        {
            print hmTime($0)
        }
    '
end
