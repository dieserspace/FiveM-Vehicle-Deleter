---@class VersionChecker
---@field url string
VersionChecker = { }
VersionChecker.__index = VersionChecker

function VersionChecker:Init()
    local self = setmetatable({ }, VersionChecker)
    self.url = 'https://raw.githubusercontent.com/dieserspace/FiveM-Vehicle-Deleter/refs/heads/main/version.txt'
    return self
end

function VersionChecker:GetCurrentVersion()
    local currentVersion = LoadResourceFile(GetCurrentResourceName(), 'version.txt')
    return currentVersion
end

function VersionChecker:FetchLatestVersion()
    local task = promise.new()
    PerformHttpRequest('https://raw.githubusercontent.com/dieserspace/FiveM-Vehicle-Deleter/refs/heads/main/version.txt', function(errorCode, result, header, error)
        if (not error) then
            task:resolve(result)
        end
    end)
    return task
end

function VersionChecker:Print(...)
    local data = { ... }
    for _, output in pairs(data) do
        print(
            string.format('[%s]', GetCurrentResourceName()),
            output
        )
    end
end

function VersionChecker:CheckVersion()

    local versionPromise = self:FetchLatestVersion()
    local version = Citizen.Await(latestVersion)

    if (self:GetCurrentVersion() ~= version) then
        self:Print(
            string.format('^1Resource currently outdated. ^2%s ^0→ ^1%s', self:GetCurrentVersion(), version)
        )
    end

end