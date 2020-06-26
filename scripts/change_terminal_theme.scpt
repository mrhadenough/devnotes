tell application "Terminal"
    repeat with w from 1 to count windows
        repeat with t from 1 to count tabs of window w
            if name of current settings of window w contains "Basic" then
                set current settings of tab t of window w to (first settings set whose name is "my")
            else
                set current settings of tab t of window w to (first settings set whose name is "Basic")
            end if
        end repeat
    end repeat
end tell
-- alias theme='osascript ~/Applications/Other/bin/change_terminal_theme.scpt'
