-- Get the selected track
local track = reaper.GetSelectedTrack(0, 0)

-- Check if the track is a folder track (i.e., has child tracks)
local folder_depth = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH")
if folder_depth > 0 then
    -- Get the number of child tracks
    local num_children = reaper.CountTracks(0)
    local max_channels = 0
    
    -- Loop through each child track
    for i = 0, num_children-1 do
        local child_track = reaper.GetTrack(0, i)
        local parent_track = reaper.GetParentTrack(child_track)
        if parent_track == track then
            local num_channels = reaper.GetMediaTrackInfo_Value(child_track, "I_NCHAN")
            
            if num_channels > max_channels then
                max_channels = num_channels
            end
        end
    end
    
    -- Set the folder track's channel count to match the highest child track channel count
    reaper.SetMediaTrackInfo_Value(track, "I_NCHAN", max_channels)
else
    -- Show an error message if the selected track is not a folder track
    reaper.ShowConsoleMsg("Error: Selected track is not a folder track.\n")
end

