Citizen.CreateThread(function()
    Citizen.Wait(250)
    local resource_name = GetCurrentResourceName()
    local current_version = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    PerformHttpRequest('https://raw.githubusercontent.com/ZeskDev/ZeskDevelopment_Versions/main/zesk_animations.txt',function(error, result, headers)
        local new_version = result:sub(1, -2)
        SetConvarServerInfo("ZeskAnimations by ZeskDev", current_version)
        if new_version ~= current_version then
            print('^2['..resource_name..'] - New Update Available.^0\nCurrent Version: ^5'..current_version..'^0\nNew Version: ^5'..new_version..'^0')
            print("Download the update in our Discord")
        else
          print("^2[ Zesk Animations ]^0 Up To Date Have a nice Day!")  
        end
    end,'GET')
end)
