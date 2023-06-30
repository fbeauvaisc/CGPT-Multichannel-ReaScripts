-- Get the selected track
selected_track = reaper.GetSelectedTrack(0, 0)

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

