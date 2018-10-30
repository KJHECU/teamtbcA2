----------------------------------------------------------------------------------------
--
-- database.lua
--
-----------------------------------------------------------------------------------------

-- Load database for access by other sections
sqlite3 = require("sqlite3")
path = system.pathForFile("data.db", system.ResourceDirectory)
db = sqlite3.open( path )