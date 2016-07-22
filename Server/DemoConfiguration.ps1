configuration PullClientDemoConfiguration
{
    node c944ce11-0ffe-467b-bb22-fd1cd2fd76bc
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