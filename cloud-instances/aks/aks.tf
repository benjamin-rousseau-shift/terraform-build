

resource "azurerm_kubernetes_cluster" "aks_web" {
  name                = "aks-${var.SHIFT_CLOUD_INSTANCE}-web"
  location            = azurerm_resource_group.instance_cloud_rg.location
  resource_group_name = azurerm_resource_group.instance_cloud_rg.name
#   dns_prefix          = var.SHIFT_CLOUD_INSTANCE
  

  default_node_pool {
    name            = "default"
    node_count      = var.AKS_WEB_NODE_COUNT
    vm_size         = var.AKS_WEB_VM_SIZE
    vnet_subnet_id  = var.AKS_WEB_SUBNET_ID
    type            = "VirtualMachineScaleSets"
    max_pods        = 110
    # os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.SP_CLIENT_ID
    client_secret = var.SP_CLIENT_SECRET
  }

  # Une piste pour acroitre la sécurité, et intégrer l'active directory dans les droits de livraisons des applis
  role_based_access_control {
    enabled = false
  }

  tags = {
    cloudInstance = var.SHIFT_CLOUD_INSTANCE
  }
}


resource "azurerm_kubernetes_cluster" "aks_worker" {
  name                = "aks-${var.SHIFT_CLOUD_INSTANCE}-worker"
  location            = azurerm_resource_group.instance_cloud_rg.location
  resource_group_name = azurerm_resource_group.instance_cloud_rg.name
#   dns_prefix          = var.SHIFT_CLOUD_INSTANCE
  

  default_node_pool {
    name            = "default"
    node_count      = var.AKS_WORKER_NODE_COUNT
    vm_size         = var.AKS_WORKER_VM_SIZE
    vnet_subnet_id  = var.AKS_WORKER_SUBNET_ID
    type            = "VirtualMachineScaleSets"
    max_pods        = 110
    # os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.SP_CLIENT_ID
    client_secret = var.SP_CLIENT_SECRET
  }

  # Une piste pour acroitre la sécurité, et intégrer l'active directory dans les droits de livraisons des applis
  role_based_access_control {
    enabled = false
  }

  tags = {
    cloudInstance = var.SHIFT_CLOUD_INSTANCE
  }
}
