// GENERAL VARIABLES ---------------------------------------

variable "prefix" { type = string }
variable "location" { type = string }
variable "rg_name" { type = string }
variable "env" { type = string }

// AKS VARIABLES -------------------------------------------

variable "vm_size" { type = string }
variable "syspool_node_count" { type = string }
variable "syspool_min_count" { type = string }
variable "syspool_max_count" { type = string }

// USER POOL ------------------------------------------------

variable "userpool_node_count" { type = string }
variable "userpool_min_count" { type = string }
variable "userpool_max_count" { type = string }

// NETWORK -------------------------------------------------
variable "vnet_id" { type = string }
variable "aks_subnet_id" { type = string }

// APPLICATION GATEWAY --------------------------------------
variable "appgw_id" { type = string }