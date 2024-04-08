local VersionActual = '1.0.0'
local GithubResourceName = 'qb-menu'


PerformHttpRequest('https://raw.githubusercontent.com/nejoinc/Versiones_Scripts/master/' .. GithubResourceName .. '/VERSION', function(Error, NuevaVersion)
    PerformHttpRequest('https://raw.githubusercontent.com/nejoinc/Versiones_Scripts/master/' .. GithubResourceName .. '/CHANGELOG', function(Error, Cambios)
        -- print('^0')
        print('^1[qb-menu]^0 Checking for updates...')
        print('^0')
        print('^1[qb-menu]^0 Current version: ^5' .. VersionActual .. '^0')
        print('^1[qb-menu]^0 Updater version: ^5' .. NuevaVersion .. '^0')
        if VersionActual ~= NuevaVersion then
            print('^1[qb-menu]^0 Your script is ^8outdated^0!')
            print('^1')
            print('^1[qb-menu] ^3CHANGELOG ^5' .. NuevaVersion .. ':')
            print(Cambios)
            print('^1[qb-menu]^0 You ^8are not^0 running the newest stable version of ^5qb-menu^0. Please update: https://github.com/nejoinc/qb-menu ')
        else
            print('^1[qb-menu]^0 Your script is ^2up to update^0')
        end
        print('^0')
    end)
end)