Write-Host "Fazendo login no Azure..."
az login

Write-Host "Obtendo Subscription ID atual..."
$subscriptionId = az account show --query id -o tsv
Write-Host "Subscription ID: $subscriptionId"

# Atualiza o main.tf com o subscription_id correto
Write-Host "Atualizando main.tf com subscription_id..."
(Get-Content "./main.tf") -replace 'subscription_id\s*=\s*".*?"', "subscription_id = `"$subscriptionId`"" | Set-Content "./main.tf"

Write-Host "Inicializando Terraform..."
terraform init

# Verifica se o recurso já está no estado do Terraform
Write-Host "Verificando se o recurso já foi importado..."
$resourceName = "module.databricks_workspace.azurerm_databricks_workspace.dbw"
$resourceExists = terraform state list | Select-String $resourceName

if (-not $resourceExists) {
    Write-Host "Importando recurso existente do Databricks..."
    $resourceId = "/subscriptions/$subscriptionId/resourceGroups/proj-dados-rg/providers/Microsoft.Databricks/workspaces/proj-dados-dbw"
    terraform import $resourceName $resourceId
} else {
    Write-Host "Recurso já importado. Ignorando import."
}

Write-Host "Executando terraform plan..."
terraform plan -var "subscription_id=$subscriptionId"

Write-Host "Aplicando terraform apply..."
terraform apply -auto-approve -var "subscription_id=$subscriptionId"
