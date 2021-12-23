

resource "azurerm_kubernetes_cluster" "aks_web" {
  name                = "${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-${var.shift-salt}"
  location            = azurerm_resource_group.aks-rg.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  dns_prefix          = "${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-${var.shift-salt}"
  node_resource_group = "${var.enterprise}-${var.environment}-${var.region}-AKS-WEB-NODES-RG-${var.shift-salt}"
  

  default_node_pool {
    name            = "default"
    node_count      = var.AKS_WEB_NODE_COUNT
    vm_size         = var.AKS_WEB_VM_SIZE
    vnet_subnet_id  = azurerm_subnet.aks-web-subnet.id
    type            = "VirtualMachineScaleSets"
    max_pods        = 110
    # os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  # Une piste pour acroitre la sécurité, et intégrer l'active directory dans les droits de livraisons des applis
  role_based_access_control {
    enabled = false
  }

  tags = {
    TYPE = "KUBERNETES"
    LOCATION = "${var.environment}-${var.region}"
    PROJECT  = "AKS"
  }
}


resource "azurerm_kubernetes_cluster" "aks_worker" {
  name                = "${var.enterprise}-${var.environment}-${var.region}-AKS-WORKER-${var.shift-salt}"
  location            = azurerm_resource_group.aks-rg.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  dns_prefix          = "${var.enterprise}-${var.environment}-${var.region}-AKS-WORKER-${var.shift-salt}"
  node_resource_group = "${var.enterprise}-${var.environment}-${var.region}-AKS-WORKER-NODES-RG-${var.shift-salt}"
  

  default_node_pool {
    name            = "default"
    node_count      = var.AKS_WORKER_NODE_COUNT
    vm_size         = var.AKS_WORKER_VM_SIZE
    vnet_subnet_id  = azurerm_subnet.aks-worker-subnet.id
    type            = "VirtualMachineScaleSets"
    max_pods        = 110
    # os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  # Une piste pour acroitre la sécurité, et intégrer l'active directory dans les droits de livraisons des applis
  role_based_access_control {
    enabled = false
  }

  tags = {
    TYPE = "KUBERNETES"
    LOCATION = "${var.environment}-${var.region}"
    PROJECT  = "AKS"
  }
}
