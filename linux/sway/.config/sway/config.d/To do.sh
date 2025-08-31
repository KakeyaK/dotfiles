To do:
- touch mapping
- better display management
- workrooms
- workspaces set for monitors
- workspaces set for media/chat
-  




# Move workspace to current output when switching
# If you want your workspace to be moved to the current output when you switch to it using $mod+<number> instead of you being refocused to a different output where the workspace is currently bound, replace your bindsym $mod+<number> lines in your configuration with this (for each <number> of course):

# bindsym $mod+1 [workspace="^1$"] move workspace to output current; workspace number 1

#Touch Display Mapping
# Touch input targets for touch displays used in a multi-display environment must be mapped to that touch display only.

# set $display1       "Dell Inc. DELL P2414H VHVTW542165L"
# set $display2       "Dell Inc. DELL P2418HT MYDM775F152L"
# set $display2-touch "8146:24835:Melfas_LGD_AIT_Touch_Controller"

# input $display2-touch map_to_output $display2