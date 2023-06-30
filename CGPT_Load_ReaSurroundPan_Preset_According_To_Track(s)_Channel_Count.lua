-- Set the preset names
local quadPreset = "Quad"
local sevenOnePreset = "7.1"
local fiveOnePreset = "5.1"

-- Get the number of selected tracks
local numSelectedTracks = reaper.CountSelectedTracks(0)

-- Loop through each selected track
for i = 0, numSelectedTracks-1 do
  local track = reaper.GetSelectedTrack(0, i)
  
  -- Get the number of channels on the track
  local channelsIn = reaper.GetMediaTrackInfo_Value(track, "I_NCHAN")
  
  -- Set the preset name based on the number of channels
  local presetName = nil
  if channelsIn == 4 then
    presetName = quadPreset
  elseif channelsIn == 6 then
    presetName = fiveOnePreset   
  elseif channelsIn == 8 then
    presetName = sevenOnePreset
  end
  
  -- Load the preset if it exists and the track has 4 or 8 channels
  if presetName then
    -- Loop through each FX on the track
    local numFX = reaper.TrackFX_GetCount(track)
    for j = 0, numFX-1 do
      local retval, fxName = reaper.TrackFX_GetFXName(track, j, "")
      if fxName:match("ReaSurroundPan") then -- Load the preset
        reaper.TrackFX_SetPreset(track, j, presetName)
      end
    end
  end
end

