function init()
    m.infoGroup = m.top.findNode("infoGroup")
    m.ipLabel = m.top.findNode("ipLabel")
    m.countryLabel = m.top.findNode("geoCountryLabel")
    m.locLabel = m.top.findNode("geoExtendedLabel")
    m.flagPoster = m.top.findNode("geoFlagPoster")
    m.localeLabel = m.top.findNode("localeLabel")
    m.reloadBtn = m.top.findNode("reloadBtn")

    m.top.backgroundColor = "0x002B36FF" 
    m.top.backgroundURI = ""

    vertPad = 30
    horizPad = 50

    m.ipLabel.font.size=48
    m.ipLabel.color="0xCB4B16FF"
    m.ipLabel.translation=[0, 0]

    m.countryLabel.font.size=92
    m.countryLabel.color="0x268BD2FF"
    m.countryLabel.translation=[0, m.ipLabel.translation[1] + m.ipLabel.height + vertPad]

    m.locLabel.font.size=32
    m.locLabel.color="0x859900FF"
    m.locLabel.translation=[0, m.countryLabel.translation[1] + m.countryLabel.height + vertPad]

    flagBounds = m.flagPoster.boundingRect()
    posterCenterX = (1280 - flagBounds.width) / 2
    m.flagPoster.translation=[posterCenterX, m.locLabel.translation[1] + m.locLabel.height + vertPad]

    m.localeLabel.font.size=32
    m.localeLabel.color="0xD33682FF"
    m.localeLabel.translation=[0, m.flagPoster.translation[1] + flagBounds.height + vertPad]
    
    groupBounds = m.infoGroup.boundingRect()
    groupCenterY = (720 - groupBounds.height) / 2
    m.infoGroup.translation = [0, groupCenterY]

    buttonBounds = m.reloadBtn.boundingRect()
    m.reloadBtn.translation=[horizPad, 720 - (buttonBounds.height + vertPad)]
    m.reloadBtn.observeField("buttonSelected", "onReload")

    di = CreateObject("roDeviceInfo")
    infoString = "User: " + di.GetUserCountryCode() + " | Device: " + di.GetCountryCode() + " | Locale: " + di.GetCurrentLocale()
    print infoString
    m.localeLabel.text = infoString

    m.apiKey = "22eda8f7c717412b9150930c0f67b607"

    m.geoTask = CreateObject("roSGNode", "JSONTask")
    m.geoTask.observeField("data", "onLocationChange")
    m.geoTask.url = "https://api.ipgeolocation.io/ipgeo?apiKey=" + m.apiKey
    m.geoTask.control = "RUN"

    m.reloadBtn.setFocus(true)
end function

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

sub onReload()
    m.ipTask.wan_ip = ""
    m.geoTask.location = invalid
    m.ipTask.control = "RUN"
end sub