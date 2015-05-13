--[[	$Id: dataFeed.lua 3536 2013-08-24 16:19:22Z sdkyron@gmail.com $	]]

local _, caelDataFeed = ...

caelDataFeed.createModule = function(name)

    -- Create module frame.
    local module = CreateFrame("Frame", format("caelDataFeedModule%s", name), caelPanel8)
    
    -- Create module text.
    module.text = caelPanel8:CreateFontString(nil, "OVERLAY")
    module.text:SetFont(caelMedia.fonts.CUSTOM_NUMBERFONT, 10)
    
    -- Setup module.
    module:SetAllPoints(module.text)
    module:EnableMouse(true)
    module:SetScript("OnLeave", function() GameTooltip:Hide() end)

    return module
end