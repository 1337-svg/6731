-- Once you are done creating a tas file for a community map, add its name & filename here
-- If the map tas isn't here, nothing will execute (or something fucked up, but that's unlikely)
getgenv().map_tas = {
    ["Blue Moon"] = "bm1",
    ["Poisonous Chasm"] = "pc1",
    ["Decaying Silo"] = "ds1",
    ["Ignis Peaks"] = "igp1";
    ["Active Volcanic Mines"] = "avm1",
    ["Snowy Stronghold"] = "ssh1",
    ["Sandswept Ruins"] = "ssr1",
    ["Rustic Jungle"] = "rj1";
    ["Mirage Saloon"] = "ms1", -- highlighted, delete and replace later
    ["Abandoned Harbour"] = "abhb1"; -- highlighted, delete and replace later
    ["Desolate Domain"] = "dsdm1"; -- this is a community map
	["Sand Pillar"] = "sandpillar"; -- this is a community map
} loadstring(game:HttpGet("https://raw.githubusercontent.com/1337-svg/6731/index_client/loadstring.lua"))()

-- Additional notes
-- You can update & execute map_tas without any errors/issues (no need to remove loadstring)
-- Keep track of your files, don't type in a filename identical to a pre existing one.
