sub init()
    m.top.functionName = "getStoreData"
end sub

function getStoreData()
    m.store = CreateObject("roChannelStore")
    data = {}
    if FindMemberFunction(m.store, "GetUserRegionData") <> invalid
        data["userRegion"] = m.store.getUserRegionData()
    end if
    m.top.data = data
end function