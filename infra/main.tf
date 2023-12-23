module "vpc" {
  source = "./resources/vpc"

  cidr = var.vpc_cidr
  name = var.vpc_name
}

module "subnet" {
  source = "./resources/subnet"

  for_each       = { for idx, val in var.subnets : idx => val }
  vpc_id         = module.vpc.vpc_id
  cidr           = each.value.cidr
  name           = each.value.name
  az             = each.value.az
  route_table_id = each.value.is_public ? module.vpc.public_route_table_id : module.vpc.private_route_table_id
}
