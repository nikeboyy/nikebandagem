-----------------------------------------------------------------------------------------------------------------------------------------
--[ vRP ]--------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
-----------------------------------------------------------------------------------------------------------------------------------------
--[ CODE ]-----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
local webhookbandagem = ""

local bandagens = {}
local delay_bandagem = {}

RegisterCommand('bandagem', function(source,args)
	local user_id = vRP.getUserId(source)
	local nplayer = tonumber(args[1])
	local nsource = vRP.getUserSource(parseInt(args[1]))
	local quantidade = parseInt(args[2])
	local valor = 5000*quantidade

	if delay_bandagem[user_id] == nil then
		delay_bandagem[user_id] = 0;
	end
	if delay_bandagem[user_id] > 0 then
		TriggerClientEvent('Notify',source,'negado','Negado','Aguarde '..delay_bandagem[user_id]..' segundos para vender outra bandagem.')
		return;
	end

	if bandagens[nplayer] == nil then
		bandagens[nplayer] = 0;
	end

	if vRP.hasGroup(user_id,'Paramedico') or vRP.hasGroup(user_id,'admin') then
		if bandagens[nplayer] + quantidade > 10 then
			TriggerClientEvent('Notify',source,'negado','Negado','Este jogador comprou mais de 10 bandagens.')
			return;
		else
			delay_bandagem[user_id] = 15
			if vRP.request(nsource,"Você deseja comprar "..quantidade.."x bandagens por $ "..valor.." ?",15) then
				if vRP.tryFullPayment(nplayer,valor) then
					vRP.giveBankMoney(user_id,valor)
					vRP.giveInventoryItem(nplayer,"bandagem",parseInt(args[2]))
					SendWebhookMessage(webhookbandagem,"```prolog\n[ID]: "..user_id.." \n[VENDEU BANDAGEM]: "..quantidade.." \n[PARA O ID]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					TriggerClientEvent("Notify",source,"sucesso","Sucesso","Vendido "..quantidade.."x bandagens por $"..valor)
					bandagens[nplayer] = bandagens[nplayer] + quantidade
				else
					TriggerClientEvent("Notify",nsource,"negado","Negado","Dinheiro insuficiente")
				end
			end
		end
	end
end)
