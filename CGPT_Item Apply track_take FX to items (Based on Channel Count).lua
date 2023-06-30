function apply_fx_based_on_channel_count()

    -- Get count of selected items
    local count = reaper.CountSelectedMediaItems(0)
    
    -- Create a table to store the items
    local items = {}

    -- Loop over the selected items and store them in the table
    for i = 0, count - 1 do
        items[i+1] = reaper.GetSelectedMediaItem(0, i)
    end

    -- Now loop over the stored items and apply your actions
    for i = 1, #items do
        -- Get the media item from the table
        local item = items[i]

        -- Unselect all items
        reaper.Main_OnCommand(40289, 0)

        -- Select the current item
        reaper.SetMediaItemSelected(item, true)

        -- Get the take
        local take = reaper.GetActiveTake(item)

        if take ~= nil then
            local is_MIDI = reaper.TakeIsMIDI(take)
            
            local num_channels

            if is_MIDI then
                -- Get the track
                local track = reaper.GetMediaItemTrack(item)
                -- Get the number of channels of the track
                num_channels = reaper.GetMediaTrackInfo_Value(track, "I_NCHAN")
            else
                -- Get the source of the take
                local source = reaper.GetMediaItemTake_Source(take)
                -- Get the number of channels of the source
                num_channels = reaper.GetMediaSourceNumChannels(source)
            end
            
            if num_channels == 1 then
                -- Run your mono action here
                reaper.Main_OnCommand(reaper.NamedCommandLookup(40361), 0)
            elseif num_channels == 2 then
                -- Run your stereo action here
                reaper.Main_OnCommand(reaper.NamedCommandLookup(40209), 0)
            else
                -- Run your multi-channel action here
                reaper.Main_OnCommand(reaper.NamedCommandLookup(41993), 0)
            end
        end
    end
    
    -- At the end, re-select the original items
    for i = 1, #items do
        reaper.SetMediaItemSelected(items[i], true)
    end
end

apply_fx_based_on_channel_count()

