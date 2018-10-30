sqlite3 = require("sqlite3")
path = system.pathForFile("data.db", system.ResourceDirectory)
db = sqlite3.open( path )