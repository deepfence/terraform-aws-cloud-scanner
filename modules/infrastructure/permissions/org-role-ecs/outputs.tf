# outputs created role arn

output "ccs_mgmt_acc_role_arn" {
  value       = aws_iam_role.ccs_mgmt_acc_role[0].arn
  description = "organizational role arn"
}

# outputs created role name

output "ccs_mgmt_acc_role_name" {
  value       = aws_iam_role.ccs_mgmt_acc_role[0].name
  description = "organizational role name"
}