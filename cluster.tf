
resource "google_container_cluster" "cluster_set"{
    name = var.newclusterpet3
    location = var.cluster_zone
    project = var.project

    network = google_compute_network.vpc_net_petproj3.self_link 
    subnetwork = google_compute_subnetwork.vpc_subnet_pet.self_link 

    remove_default_node_pool = "true"
    initial_node_count = 1
    // create_service_account = true

    #Configuration of cluster IP allocation for VPC clusters. 
    #Adding this block enables IP aliasing, making the cluster VPC instead of 
    #routes-based
    
ip_allocation_policy{
    cluster_secondary_range_name = var.cluster_secondary_name
    services_secondary_range_name = var.cluster_service_name
    }

private_cluster_config{
    enable_private_endpoint = true
    enable_private_nodes = true
    master_ipv4_cidr_block = var.master_cidr
    dynamic "master_global_access_config" {
       for_each = var.master_global_access_config
         content {
           enabled   = master_global_access_config.value.enabled
    }
  }
}

master_authorized_networks_config{
    
}

}
/*
resource "google_service_account" "default" {
  account_id   = "service-account-id"
  display_name = "Service Account"
}
*/
### creating node pools #########

resource "google_container_node_pool" "dummynode" {
    cluster = google_container_cluster.cluster_set.name
     #adding cluster name

#add location for nodes
location = var.cluster_zone
project = var.project
name = "dummynodecluster"
node_count = var.node_count

autoscaling {
    min_node_count = var.autoscaling_min_node_count
    max_node_count = var.autoscaling_max_node_count
  }

node_config{
    preemptible = true
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    machine_type = var.machine_type
    service_account = "petproject@thri-petproject.iam.gserviceaccount.com"
    
     // google_service_account.default.email
   
   
    // create_service_account =true
    // service_account = var.service_account_email


    tags = ["allow-google-apis"]
   

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/cloud-platform",
    ]
}

depends_on = [google_container_cluster.cluster_set]
}