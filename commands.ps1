$username = Read-Host "Please enter the username:"

$devRgName = "rg-$username-dev"
$qaRgName = "rg-$username-qa"

# Create development resource group
az group create -l eastus -n $devRgName

# Create development app service plan and web app
az appservice plan create -g $devRgName -n asp-dev-01
az webapp create -g $devRgName -p asp-dev-01 -n "$username-spacegame-dev"

# Create QA resource group
az group create -l eastus -n $qaRgName

# Create QA app service plan and web app
az appservice plan create -g $qaRgName -n asp-qa-01
az webapp create -g $qaRgName -p asp-qa-01 -n "$username-spacegame-qa"

# Create a service principal for a resource group using a preferred name and role
$servicePrincipalName = "$username-spa-01"
$role = "contributor"
$subscriptionId = $(az account show --query id -o tsv)
$subscriptionName = $(az account show --query name -o tsv)

az ad sp create-for-rbac --name $servicePrincipalName --role $role --scopes /subscriptions/$subscriptionId/resourceGroups/$devRgName /subscriptions/$subscriptionId/resourceGroups/$qaRgName

Write-Host "Subscription ID - $subscriptionId"
Write-Host "Subscription Name - $subscriptionName"