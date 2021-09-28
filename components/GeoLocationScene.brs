function init()
    m.infoGroup = m.top.findNode("infoGroup")
    m.ipLabel = m.top.findNode("ipLabel")
    m.countryLabel = m.top.findNode("geoCountryLabel")
    m.locLabel = m.top.findNode("geoExtendedLabel")
    m.flagPoster = m.top.findNode("geoFlagPoster")
    m.deviceInfoLabel = m.top.findNode("deviceInfoLabel")
    m.channelStoreLabel = m.top.findNode("channelStoreLabel")
    m.reloadBtn = m.top.findNode("reloadBtn")

    m.top.backgroundColor = "0x002B36FF" 
    m.top.backgroundURI = ""

    m.vertPad = 30
    m.vertPadSmall = 10
    m.horizPad = 50

    m.ipLabel.font.size=48
    m.ipLabel.color="0xCB4B16FF"
    m.ipLabel.translation=[0, 0]

    m.countryLabel.font.size=92
    m.countryLabel.color="0x268BD2FF"
    m.countryLabel.translation=[0, m.ipLabel.translation[1] + m.ipLabel.height + m.vertPad]

    m.locLabel.font.size=32
    m.locLabel.color="0x859900FF"
    m.locLabel.translation=[0, m.countryLabel.translation[1] + m.countryLabel.height + m.vertPad]

    flagBounds = m.flagPoster.boundingRect()
    posterCenterX = (1280 - flagBounds.width) / 2
    m.flagPoster.translation=[posterCenterX, m.locLabel.translation[1] + m.locLabel.height + m.vertPad]

    m.deviceInfoLabel.font.size=24
    m.deviceInfoLabel.color="0xD33682FF"
    m.deviceInfoLabel.translation=[0, m.flagPoster.translation[1] + flagBounds.height + m.vertPad]

    m.deviceInfo = CreateObject("roDeviceInfo")
    m.infoString = "Device Info: [Country: " + m.deviceInfo.GetCountryCode() + " | User: " + m.deviceInfo.GetCountryCode() + " | Locale: " + m.deviceInfo.GetCurrentLocale() + "]"
    print m.infoString
    m.deviceInfoLabel.text = m.infoString

    doLayout()

    buttonBounds = m.reloadBtn.boundingRect()
    m.reloadBtn.translation=[m.horizPad, 720 - (buttonBounds.height + m.vertPad)]
    m.reloadBtn.observeField("buttonSelected", "onReload")

    m.apiKey = "22eda8f7c717412b9150930c0f67b607"

    m.geoTask = CreateObject("roSGNode", "JSONTask")
    m.geoTask.observeField("data", "onLocationChange")
    m.geoTask.url = "https://api.ipgeolocation.io/ipgeo?apiKey=" + m.apiKey
    m.geoTask.control = "RUN"

    m.storeTask = CreateObject("roSGNode", "ChannelStoreTask")
    m.storeTask.observeField("data", "onStoreDataChange")
    m.storeTask.control = "RUN"

    m.reloadBtn.setFocus(true)
end function

sub doLayout()
    groupBounds = m.infoGroup.boundingRect()
    groupCenterY = (720 - groupBounds.height) / 2
    m.infoGroup.translation = [0, groupCenterY]    
end sub

sub onLocationChange()
    if m.geoTask.data = invalid
        m.ipLabel.text = ""
        m.countryLabel.text = ""
        m.locLabel.text = ""
        m.flagPoster.uri = ""
    else
        m.location = m.geoTask.data
        print "ip: " + m.location.ip + ", country: " + m.location.country_name
        m.ipLabel.text = m.location.ip
        m.countryLabel.text = m.location.country_name
        m.locLabel.text = m.location.city + ", " + m.location.district + ", " + m.location.state_prov + ", " + m.location.country_code3
        m.flagPoster.uri = m.location.country_flag
    end if
end sub

sub onStoreDataChange()
    if m.storeTask.data <> invalid and m.storeTask.data.userRegion <> invalid
        m.channelStoreLabel.visible = true

        m.channelStoreLabel.font.size=24
        m.channelStoreLabel.color="0xD33682FF"
        m.channelStoreLabel.translation=[0, m.deviceInfoLabel.translation[1] + m.deviceInfoLabel.height + m.vertPadSmall]

        m.userRegion = m.storeTask.data.userRegion
        m.userRegionString = "User Region: [" + m.userRegion.country + ", " + m.userRegion.state + ", " + m.userRegion.zip + "]"
        print m.userRegionString
        m.channelStoreLabel.text = m.userRegionString

        doLayout()
    end if
end sub

sub onReload()
    m.geoTask.data = invalid
    m.geoTask.control = "RUN"
end sub