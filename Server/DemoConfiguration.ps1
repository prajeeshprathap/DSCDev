configuration PullClientDemoConfiguration
{
    node 1cd8a349-ff19-4ca4-94ae-3e3e1367a514
    {
        File TestFile
        {
            Ensure          = 'Present'
            Type            = 'File'
            DestinationPath = "$env:windir\Temp\DSCPullTest.txt"
            Contents        = "Hello world DSC pull demo"
        }
    }
}

PullClientDemoConfiguration