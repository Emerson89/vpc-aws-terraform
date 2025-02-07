output "private_ids" {
  description = "Output subnet private"
  value       = module.vpc.*.private_ids
}

output "public_ids" {
  description = "Output subnet public"
  value       = module.vpc.*.public_ids
}