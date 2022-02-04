variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group to create"
}

variable "location" {
  type        = string
  description = "Location to deploy resources"
}

variable "image_gallery_name" {
  type        = string
  description = "Name of Image Gallery to deploy"
}

variable "image_gallery_description" {
  type        = string
  description = "Description of the Image Gallery to deploy"
}

variable "image_name" {
  type        = string
  description = "Name of Image to deploy"
}

variable "os_type" {
  type        = string
  default     = "Windows"
  description = "OS type of image"
}

variable "image_description" {
  type        = string
  description = "Description of image"
}

variable "image_publisher" {
  type        = string
  description = "Image publisher"
}

variable "image_offer" {
  type        = string
  description = "Image offer"
}

variable "image_sku" {
  type        = string
  description = "Image sku"
}

variable "identity_name" {
  type        = string
  description = "Name of identity for Image Gallery"
}

variable "config_resource_group_name" {
  type        = string
  description = "Resource Group name of config scripts"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}
