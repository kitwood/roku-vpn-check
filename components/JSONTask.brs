sub init()
    m.top.functionName = "getJSONRequest"
end sub

function getJSONRequest()
    request = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    request.SetMessagePort(port)
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.SetUrl(m.top.url)
    timer = CreateObject("roTimeSpan")
    timer.mark()
    if (request.AsyncGetToString())
        while true
            msg = wait(1000, port)
            if (type(msg) = "roUrlEvent")
                code = msg.GetResponseCode()
                if (code = 200)
                    m.top.data = ParseJSON(msg.GetString())
                    exit while
                endif
            else if (msg = invalid)
                request.AsyncCancel()
            end if
            if timer.totalmilliseconds() > 3000 then
                exit while
            end if
        end while
    end if
end function