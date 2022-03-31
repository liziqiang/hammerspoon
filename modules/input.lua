hs.keycodes.inputSourceChanged(function()

    local currentSourceID = hs.keycodes.currentSourceID()
    local currentSourceText = string.sub(currentSourceID, string.find(currentSourceID, '%w+$')):upper()
    
    -- 关闭重复提示
    hs.alert.closeSpecific(showUUID)

    showUUID = hs.alert.show(currentSourceText, {
        textSize = 40,
        padding = 50
    })

end)
