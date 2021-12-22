output "kubernetes_cluster_web_name" {
  value = azurerm_kubernetes_cluster.aks_web.name
}

output "aks_web_host" {
  value = azurerm_kubernetes_cluster.aks_web.kube_config.0.host
}

output "aks_web_client_key" {
  value = azurerm_kubernetes_cluster.aks_web.kube_config.0.client_key
}

output "aks_web_client_certificate" {
  value = azurerm_kubernetes_cluster.aks_web.kube_config.0.client_certificate
}

output "aks_web_cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks_web.kube_config.0.cluster_ca_certificate
}

output "aks_web_cluster_username" {
  value = azurerm_kubernetes_cluster.aks_web.kube_config.0.username
}

output "aks_web_cluster_password" {
  value = azurerm_kubernetes_cluster.aks_web.kube_config.0.password
}



output "kubernetes_cluster_worker_name" {
  value = azurerm_kubernetes_cluster.aks_worker.name
}

output "aks_worker_host" {
  value = azurerm_kubernetes_cluster.aks_worker.kube_config.0.host
}

output "aks_worker_client_key" {
  value = azurerm_kubernetes_cluster.aks_worker.kube_config.0.client_key
}

output "aks_worker_client_certificate" {
  value = azurerm_kubernetes_cluster.aks_worker.kube_config.0.client_certificate
}

output "aks_worker_cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks_worker.kube_config.0.cluster_ca_certificate
}

output "aks_worker_cluster_username" {
  value = azurerm_kubernetes_cluster.aks_worker.kube_config.0.username
}

output "aks_worker_cluster_password" {
  value = azurerm_kubernetes_cluster.aks_worker.kube_config.0.password
}

output "sp_password" {
  value = "${azuread_service_principal_password.app.value}"
  sensitive = true
}