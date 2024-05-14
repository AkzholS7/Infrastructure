In order to run this code you have to take initial steps, you ought to create those, otherwise you can't go for the further steps:

```
$resourceGroupName = 'rg-tfstate-akzhol'
$storageAccountName = 'satfstatecac-akzhol'
$location = 'West US'

az group create --location $location --name $resourceGroupName
az storage account create --name $storageAccountName --resource-group $resourceGroupName --location $location --sku Standard_LRS
az storage container create --name state --account-name $storageAccountName
az storage account blob-service-properties update --account-name $storageAccountName --enable-change-feed --enable-versioning true

```