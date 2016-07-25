function Get-DSCReport
{
    param
    (
        $agentId = "E4971363-5018-11E6-A2CA-08002771CAD3", 
        $serviceURL = "http://52.174.151.121//PSDSCPullServer.svc"
    )

    $requestUri = "$serviceURL/Nodes(AgentId= '$agentId')/Reports"

    $request = Invoke-WebRequest -Uri $requestUri  -ContentType "application/json;odata=minimalmetadata;streaming=true;charset=utf-8" `
               -UseBasicParsing -Headers @{Accept = "application/json";ProtocolVersion = "2.0"} `
               -ErrorAction SilentlyContinue -ErrorVariable ev

    $object = ConvertFrom-Json $request.content
    return $object.value
}


Get-DSCReport