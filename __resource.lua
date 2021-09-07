resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'qb-dumpster made by PhantomDDK'
version "1.0.4"

client_scripts {
  
  'client/client.lua',
  
  'config.lua'
}

server_scripts {
  'sv_version_check.lua',
  'server/server.lua',
 
  'config.lua'
}


