variable "cluster_zone"{
    default = "europe-west1"
}

variable "project"{
      
  default = "thri-petproject"
   
}

variable "cluster_secondary_name"{
    default = "subnetpetpod"
}

variable "cluster_service_name"{
    default = "public-services-petproject"
}

variable "master_cidr"{
    // default = "199.36.153.8/30"
    default = "172.16.0.32/28"
}

variable "node_count" {
  default = 2
}

variable "autoscaling_min_node_count" {
  default = 1
}

variable "autoscaling_max_node_count" {
  default = 3
}

variable "disk_size_gb" {
  default = 50
}

variable "disk_type" {
  default = "pd-standard"
}

variable "machine_type" {
  default = "n1-standard-2"
}

variable "region"{
    default = "europe-west1"
}

variable "cluster_secondary_range_vpc"{
    default = "10.4.0.0/14"
}


variable "cluster_service_range"{
    default = "10.0.32.0/20"
}


variable "petprojvpc" {
    default = "pet-vpc"
}

variable "subnetpet" {
    default = "sub-pet-vpc"
}

variable "newclusterpet3" {
    default = "clusterpetproj-artifact"
}

variable "service_account_email" {
  default = ""
}

variable "master_global_access_config" {
type = list(object({ enabled = bool }))
description = "enabled - Enable the cluster master globally or not."

default = [{
"enabled" = true
}]
}