-- Set the preset name
local presetName = "Quad" -- Change this to the name of the preset you want to load
-- Get the number of selected tracks
local numSelectedTracks = reaper.CountSelectedTracks(0)
-- Loop through each selected track
for i = 0, numSelectedTracks-1 do
  local track = reaper.GetSelectedTrack(0, i)
  -- Get the number of FX on the track
  local numFX = reaper.TrackFX_GetCount(track)
  -- Loop through each FX on the track
  for j = 0, numFX-1 do
    local retval, fxName = reaper.TrackFX_GetFXName(track, j, "")
    if fxName:match("ReaSurroundPan") then -- Load the preset
      reaper.TrackFX_SetPreset(track, j, presetName)
    end
  end
end
