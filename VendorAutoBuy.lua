
local name = "VendorAutoBuy"
local version = "1.0.0"

local print = function(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg, 1, 0.5, 1)
end

local buy = function()
	for i = 1, GetMerchantNumItems() do
		local name, tex, price, quantity, numAvailable, isUsable = GetMerchantItemInfo(i)
		if name and numAvailable > 0 then
			if price <= GetMoney() then
				print(string.format("Buying %s for %dc.", GetMerchantItemLink(i), price))
				BuyMerchantItem(i)
			else
				print(string.format("%s is too expensive. %dc required.", GetMerchantItemLink(i), price))
			end
		end
	end
end

local gui_create_checkbox = function()
	local c = CreateFrame("CheckButton", "VAB_Button", MerchantFrame, "UICheckButtonTemplate")
	c:SetHeight(20)
	c:SetWidth(20)
	c:SetPoint("TOPLEFT", MerchantFrame, "TOPLEFT", 80, -45)
	c:SetChecked(VAB_Global.Enabled)
	c:SetScript("OnClick", function()
		VAB_Global.Enabled = c:GetChecked()
		if VAB_Global.Enabled then
			buy()
		end
	end)

	local ct = MerchantFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	ct:SetPoint("LEFT", c, "RIGHT", 0, 0)
	ct:SetFont("Fonts\\FRIZQT__.TTF", 11)
	ct:SetText("Auto buy limited items")
end

local frame = CreateFrame("frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("MERCHANT_SHOW")
frame:RegisterEvent("MERCHANT_UPDATE")
frame:SetScript("OnEvent", function()
	if event == "ADDON_LOADED" then
		if string.lower(arg1) == string.lower(name) then

			if not VAB_Global then
				VAB_Global = {
					Enabled = false,
				}
			end

			gui_create_checkbox()

			print(string.format("%s %s loaded.", name, version))
		end
	elseif event == "MERCHANT_SHOW" or event == "MERCHANT_UPDATE" then
		if VAB_Global.Enabled then
			buy()
		end
	end
end)
