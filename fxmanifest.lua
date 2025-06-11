fx_version 'cerulean'
game 'gta5'

name "sp_vehicledeleter"
description "A Useful Vehicle Deleter"
author "Space"
version "1.0.0"

files {
	'version.txt'
}

server_scripts {
	'server/versionchecker.lua',
	'server/vehicledeleter.lua',
	'server/main.lua'
}

shared_script 'shared/main.lua'
