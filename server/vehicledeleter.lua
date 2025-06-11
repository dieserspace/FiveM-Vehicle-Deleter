---@class VehicleDeleter
---@field vehicles { [number]: number }
---@field deleteableVehicles table
VehicleDeleter = { }
VehicleDeleter.__index = VehicleDeleter

function VehicleDeleter:new()
    local self = setmetatable({ }, VehicleDeleter)
    self.vehicles = { }
    self.deleteableVehicles = { }
    return self
end

function VehicleDeleter:Init()
    
    CreateThread(function()
        
        while true do
            
            local freeVehicles = self:GetFreeVehicles()
            local occupiedVehicles = self:GetOccupiedVehicles()

            for _, vehicle in pairs(freeVehicles) do
                if (not self.vehicles[vehicle]) then
                    self.vehicles[vehicle] = 1
                else
                    if (not self:IsVehicleAlreadyInDeleteList(vehicle)) then
                        self.vehicles[vehicle] = self.vehicles[vehicle] + 1
                        if (self.vehicles[vehicle] >= Config.DeleteTime) then
                            table.insert(self.deleteableVehicles, vehicle)
                        end
                    end
                end
            end

            for _, vehicle in pairs(occupiedVehicles) do
                self.vehicles[vehicle] = 0
            end

            if(#self.deleteableVehicles > Config.DeleteAfter) then
                TriggerClientEvent('ox_lib:notify', -1, {
                    title = 'Vehicle Deleter',
                    description = string.format('Es wurden %s Fahrzeuge entfernt', #self.deleteableVehicles),
                    position = 'top',
                    type = 'warning'
                })
                for _, vehicle in pairs(self.deleteableVehicles) do
                    DeleteEntity(vehicle)
                end
                self.deleteableVehicles = { }
            end

            Wait(1000)
        end

    end)

end

---@param vehicle number
---@return boolean
function VehicleDeleter:IsAPlayerInCar(vehicle)
    for seat=-1, 6 do
        local ped = GetPedInVehicleSeat(vehicle, seat)
        if (ped ~= 0) then
            return true
        end
    end
    return false
end

function VehicleDeleter:IsVehicleAlreadyInDeleteList(vehicle)
    for _, v in pairs(self.deleteableVehicles) do
        if (v == vehicle) then return true end
    end
    return false
end

---@return table
function VehicleDeleter:GetFreeVehicles()
    local freeVehicles = { }
    for _, vehicle in pairs(GetAllVehicles()) do
        if (not self:IsAPlayerInCar(vehicle)) then
            table.insert(freeVehicles, vehicle)
        end
    end
    return freeVehicles
end

---@return table
function VehicleDeleter:GetOccupiedVehicles()
    local occupiedVehicles = { }
    for _, vehicle in pairs(GetAllVehicles()) do
        if (self:IsAPlayerInCar(vehicle)) then
            table.insert(occupiedVehicles, vehicle)
        end
    end
    return occupiedVehicles
end