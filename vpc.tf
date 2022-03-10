#creating vpc
resource "google_compute_network" "vpc_net_petproj3"{
    name = var.petprojvpc
    project = var.project
    auto_create_subnetworks = false     
    }

#creating subnet
resource "google_compute_subnetwork" "vpc_subnet_pet"{
    name = var.subnetpet
    project = var.project
    region = var.region
    ip_cidr_range = "192.168.0.0/20"
    network = google_compute_network.vpc_net_petproj3.self_link  #this is self linking and getting the name from 
    
     secondary_ip_range = [
        {
        range_name = var.cluster_secondary_name # we are calling clusters secondary name
        ip_cidr_range = var.cluster_secondary_range_vpc
        },
        {
        range_name = var.cluster_service_name
        ip_cidr_range = var.cluster_service_range
        }
    ]

}



resource "google_compute_firewall" "allowbasic" {
    name = "allow-googleapis"
    project = var.project
    network = var.petprojvpc

    allow {
    protocol = "tcp"
    ports    = ["443"]
    }

    target_tags = ["allow-google-apis"]

    direction = "EGRESS"

    priority = "1000"

    destination_ranges = ["199.36.153.8/30","82.38.176.208/28"]
}



###### External NAT IP (to be used by cloud-router for nodes-to-internet communication ###### 


resource "google_compute_address" "nat2" {
  name    = format("%s-nat2-ip", var.newclusterpet3)
  project = var.project
  region  = var.region
}

###### Create a cloud router (to be use by the Cloud NAT) ######
resource "google_compute_router" "router" {
  name    = format("%s-cloud-router", var.newclusterpet3)
  project = var.project
  region  = var.region
  network = google_compute_network.vpc_net_petproj3.self_link
  // network = google_compute_network.vpc_net_petproj3.self_link
}

 ###### Create a cloud NAT (Using cloud-router and NAT IP) ######
resource "google_compute_router_nat" "nat2" {
    name    = format("%s-cloud-nat2", var.newclusterpet3)
    project = var.project
    router  = google_compute_router.router.name
    region  = var.region
    nat_ip_allocate_option = "MANUAL_ONLY"
    nat_ips = [google_compute_address.nat2.self_link]
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"


    subnetwork{
        name = google_compute_subnetwork.vpc_subnet_pet.self_link

        source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"]

        secondary_ip_range_names=[
            google_compute_subnetwork.vpc_subnet_pet.secondary_ip_range.0.range_name,
            google_compute_subnetwork.vpc_subnet_pet.secondary_ip_range.1.range_name
        ]

    }

} 