ESX = nil
--ESX:GETSHAREDOBJECT
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

--Variables Ped
--local ped = PlayerPedId()
--Variables Animaciones
local handsup = false
local holsteranim = false
local ragdoll = false


--HandsUP
function HandsUp()
   handsup = not handsup
end

Citizen.CreateThread(function()
   local ped = PlayerPedId()
   local dict = "missminuteman_1ig_2"
   RequestAnimDict(dict)
   while not HasAnimDictLoaded(dict) then
      Citizen.Wait(100)
   end
   while true do
      Citizen.Wait(0)
      if handsup then
         handsup = false
         ClearPedTasks(ped)
      else
         TaskPlayAnim(ped, dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
         handsup = true
      end
   end
end)

--Radio Animation
function RadioAnim()
   local ped = PlayerPedId()
   if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
      if IsEntityPlayingAnim(ped, "random@arrests", "generic_radio_chatter", 3) then
         ClearPedSecondaryTask(ped)
      else
         RequestAnimDict("random@arrests")
         while not HasAnimDictLoaded("random@arrests")
            Citizen.Wait(500)
         end
         while true do
            Citizen.Wait(0)
            TaskPlayAnim(ped, "random@arrests", "generic_radio_chatter", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
			   RemoveAnimDict("random@arrests")
         end
      end
   end
end

--Animacion Pistolera
function HolsterAnim()
   local ped = PlayerPedId()
   if(DoesEntityExist(ped) and not IsEntityDead(ped)) then
      holsteranim = not holsteranim
   end
end
Citizen.CreateThread(function()
   local dict = "move_m@intimidation@cop@unarmed" 
   local ped = PlayerPedId()
   while true do
      Citizen.Wait(0)
      if IsEntityPlayingAnim(ped, "move_m@intimidation@cop@unarmed", "idle", 3) then
			ClearPedSecondaryTask(ped)
		else
		     RequestAnimDict(dict)
           while not HasAnimDictLoaded(dict) then
               Citizen.Wait(500)
           end
	        TaskPlayAnim(ped, "move_m@intimidation@cop@unarmed", "idle", 2.0, 2.5, -1, 49, 0, 0, 0, 0 )
			  RemoveAnimDict("move_m@intimidation@cop@unarmed")
		end
   end
end)
--Animacion Ragdoll

function RagdollAnim()
   ragdoll = not ragdoll
end
Citizen.CreateThread(function()
    local ped = PlayerPedId()
    while true do
        Citizen.Wait(0)
        if ragdoll then
            SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
        end
    end
end)
Citizen.CreateThread(function()
   local ped = PlayerPedId()
   while true do
      Citizen.Wait(0)
      if Config.RagdollStunned and IsPedBeingStunned(ped) then
         ragdoll = true
      end
      if IsPlayerDead(PlayerId()) and ragdoll == true then
            ragdoll = false
      end
      if IsPedInAnyVehicle(ped, false) then
         ragdoll = not ragdoll
         if not ragdoll then
            ESX.ShowNotification(Locales[Config.Locale]['ragdoll_animation_error_car'])
         end
      end
   end
end)

function RequestWalking(ad)
	RequestAnimSet( ad )
	while ( not HasAnimSetLoaded( ad ) ) do 
		Citizen.Wait( 500 )
	end 
end

function vehiclecheck()
	local player = PlayerPedId()
	if IsPedInAnyVehicle(player, false) then
		return false
	end
	return true
end


--MENU

function OpenMENU()
         local elements = {}                     

      table.insert(elements, { label = Locales[Config.Locale]['handsup_animation'], value = "handsup"})
      table.insert(elements, { label = Locales[Config.Locale]['radio_anim'], value = "radio"})
      table.insert(elements, { label = Locales[Config.Locale]['holster_anim'], value = "holster"})
      table.insert(elements, { label = Locales[Config.Locale]['ragdoll_animation'], value = "ragdoll"})
     --[[ table.insert(elements, { label = "Hands Up"})
      table.insert(elements, { label = "Hands Up"})
      table.insert(elements, { label = "Hands Up"})
      table.insert(elements, { label = "Hands Up"})
      table.insert(elements, { label = "Hands Up"}) ]]

        ESX.UI.Menu.CloseAll()

            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'animations_menu',
                {
                    title    = Locales[Config.Locale]['animation_menu_name'],
                    align    = 'bottom-right',
                    elements = elements

                },        function(data, menu)						--on data selection
                    if data.current.value == "handsup" then
                        HandsUp()
                    elseif data.current.value == "radio" then
                        RadioAnim()
                    elseif data.current.value == "holster" then
                        HolsterAnim()
                    elseif data.current.value == "ragdoll" then
                        RagdollAnim()
                    end
                    menu.close()							--close menu after selection
                  end,
                  function(data, menu)
                    menu.close()
                  end
                )
end
