ibmcloud_api_key=""
TF_VERSION="1.0"
prefix="gcat-multizone"
region="us-south"
resource_group="asset-development"
classic_access=false
subnet_tiers=[ 
  { 
    name = "web-tier" 
    acl_name = "web-tier-acl" 
    subnets = { 
      zone-1 = [ 
        { 
          name = "subnet-a" 
          cidr = "10.10.10.0/24" 
          public_gateway = true 
        } 
      ], 
      zone-2 = [
        { 
          name = "subnet-b"
          cidr = "10.20.10.0/24" 
          public_gateway = true 
        } 
      ], 
      zone-3 = [ 
        { 
          name = "subnet-c" 
          cidr = "10.30.10.0/24" 
          public_gateway = true 
        } 
      ] 
    } 
  }, 
  { 
    name = "app-tier" 
    acl_name = "app-tier-acl" 
    subnets = { 
      zone-1 = [ 
        { 
          name = "subnet-a" 
          cidr = "10.40.10.0/24" 
          public_gateway = false 
        } 
      ], 
      zone-2 = [
        { 
          name = "subnet-b" 
          cidr = "10.50.10.0/24" 
          public_gateway = false 
        } 
      ], 
      zone-3 = [ 
        { 
          name = "subnet-c" 
          cidr = "10.60.10.0/24" 
          public_gateway = false 
        } 
      ] 
    } 
  },
  { 
    name = "db-tier" 
    acl_name = "db-tier-acl" 
    subnets = { 
      zone-1 = [ 
        { 
          name = "subnet-a" 
          cidr = "10.70.10.0/24" 
          public_gateway = false 
        } 
      ], 
      zone-2 = [ 
        { 
          name = "subnet-b" 
          cidr = "10.80.10.0/24"
           public_gateway = false 
        } 
      ], 
      zone-3 = [ 
        { 
          name = "subnet-c" 
          cidr = "10.90.10.0/24" 
          public_gateway = false 
        } 
      ] 
    } 
  } 
]

use_public_gateways={ 
  zone-1 = true 
  zone-2 = true 
  zone-3 = true 
}
network_acls=[
  { 
    name                = "web-tier-acl"
    network_connections = ["app-tier"] 
    rules               = [
      {
        name        = "allow-all-inbound"
        action      = "allow"
        direction   = "inbound"
        destination = "0.0.0.0/0"
        source      = "0.0.0.0/0"
      },
      {
        name        = "allow-all-outbound"
        action      = "allow"
        direction   = "outbound"
        destination = "0.0.0.0/0"
        source      = "0.0.0.0/0"
      }
    ]
  },
  { 
    name                = "app-tier-acl"
    network_connections = ["web-tier", "db-tier"] 
    rules               = [
      {
        name        = "deny-all-inbound"
        action      = "deny"
        direction   = "inbound"
        destination = "0.0.0.0/0"
        source      = "0.0.0.0/0"
      }
    ]
  },
  { 
    name                = "db-tier-acl"
    network_connections = ["app-tier"] 
    rules               = [
      {
        name        = "deny-all-inbound"
        action      = "deny"
        direction   = "inbound"
        destination = "0.0.0.0/0"
        source      = "0.0.0.0/0"
      }
    ]
  }
]

security_group_rules=[
  {
    name      = "allow-inbound-ping"
    direction = "inbound"
    remote    = "0.0.0.0/0"
    icmp      = {
      type = 8
    }
  },
  {
    name      = "allow-inbound-ssh"
    direction = "inbound"
    remote    = "0.0.0.0/0"
    tcp       = {
      port_min = 22
      port_max = 22
    }
  },
]
