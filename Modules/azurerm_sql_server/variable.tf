
variable "sql_server_name" {
  type        = string
  description = "The name of the SQL Server." 
  
}
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the SQL Server will be created."  
  
}
variable "location" {
  type        = string
  description = "The Azure region where the SQL Server will be created."  
  
}

variable "administrator_login" {
  type        = string
  description = "The administrator login for the SQL Server."   
  
}
variable "administrator_login_password" {
  type        = string
  description = "The password for the SQL Server administrator login."    
}