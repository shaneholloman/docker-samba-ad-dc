# Define the GitHub account or organization name
$githubAccount = "shaneholloman"  # Change this to your personal account name if needed

# Initialize a new git repository
git init -b main

# Get the name of the current repository from the top-level directory
$repoName = Split-Path -Leaf (git rev-parse --show-toplevel)

# Create a new repository on GitHub using the gh CLI
gh repo create $repoName --public -y

# Add the remote repository
git remote add origin "https://github.com/$githubAccount/$repoName.git"

# Add all files in the current directory to the git repository
git add .

# Commit the changes
git commit -m "Initial commit"

# Push the changes to GitHub
git push -u origin main

# Define a hashtable where the key is the name of the secret and the value is the secret value
$secrets = @{
    "DOCKERHUB_TOKEN"    = $env:DOCKERHUB_TOKEN
    "DOCKERHUB_USERNAME" = $env:DOCKERHUB_USERNAME
    "GALAXY_API_KEY"     = $env:GALAXY_API_KEY
    # Add more secrets here as needed
}

# Check if environment variables exist
$missingVars = @()
foreach ($key in $secrets.Keys) {
    if ([string]::IsNullOrEmpty($secrets[$key])) {
        $missingVars += $key
    }
}

if ($missingVars.Count -ne 0) {
    Write-Host "`nThe following environment variables are missing:"
    foreach ($var in $missingVars) {
        Write-Host $var
    }
    Write-Host "Please add them to your environment variables."
    return
}

# Loop through each secret to set it for the current repository
foreach ($key in $secrets.Keys) {
    $secretValue = $secrets[$key]
    $secretValue | Out-File -FilePath secretValue.txt -NoNewline -Encoding utf8
    $command = "Get-Content secretValue.txt -Raw | gh secret set $key --repo=$githubAccount/$repoName"
    Invoke-Expression -Command $command
    Remove-Item secretValue.txt
}

# Tag and push after setting the secrets
$commitMessage = "still working on ci"
$tagVersion = "0.0.1"
$tagMessage = "initial tag"

git commit --allow-empty -m "$commitMessage"
git tag -a $tagVersion -m "$tagMessage"

# Ask the user if the current git tag and message are correct
Write-Host "`nThe current git tag is $tagVersion with the message '$tagMessage'. Is this correct? (yes/no)"
$answer = Read-Host

if ($answer -eq "yes") {
    git push origin $tagVersion
}
else {
    Write-Host "Please edit the git tag and message in this script."
}