-- Get all selected tracks
num_sel_tracks = reaper.CountSelectedTracks(0)

-- Loop through all selected tracks
for i = 0, num_sel_tracks - 1 do
  selected_track = reaper.GetSelectedTrack(0, i)

  -- Loop through all tracks in the project
  for j = 0, reaper.CountTracks(0) - 1 do
    track = reaper.GetTrack(0, j)

    -- Check if the track name starts with "FX1"
    track_name_ok, track_name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
    if track_name_ok and string.sub(track_name, 1, 3) == "FX1" then

      -- Check if the selected track already has a send to the FX1 track
      has_send = false
      for k = 0, reaper.GetTrackNumSends(selected_track, 0) - 1 do
        dest_track = reaper.GetTrackSendInfo_Value(selected_track, 0, k, "P_DESTTRACK")
        if dest_track == track then
          has_send = true
          break
        end
      end

      -- If the selected track doesn't already have a send to the FX1 track, create one
      if not has_send then
        send_idx = reaper.CreateTrackSend(selected_track, track)
      end

      -- Get the send count for the selected track
      send_count = reaper.GetTrackNumSends(selected_track, 0)

      -- Get the number of channels in the selected track
      num_channels = reaper.GetMediaTrackInfo_Value(selected_track, "I_NCHAN")

      -- If there is at least one send and the track has a supported number of channels, change all sends' output to multichannel source
      if send_count > 0 and (num_channels == 4 or num_channels == 6 or num_channels == 8) then
        -- Set the number of channels based on the track's number of channels
        if num_channels == 4 then
          num_channels = 4
        elseif num_channels == 6 then
          num_channels = 6
        elseif num_channels == 8 then
          num_channels = 8
        else -- num_channels == 2
          return
        end

        -- Loop through all sends for the selected track
        for i = 0, send_count - 1 do
          -- Set the send info based on the number of channels
          send_info = (num_channels << 9) | 0

          -- Set the send's output to multichannel source
          reaper.SetTrackSendInfo_Value(selected_track, 0, i, "I_SRCCHAN", send_info)
        end
      end

      break -- Exit the loop after the first "FX1" track is found

    end
  end
end

