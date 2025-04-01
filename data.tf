# The data lookup we are using in our maintenance-windows.tf file
data "aws_iam_role" "aws_service_role_for_amazon_ssm" {
  name = "AWSServiceRoleForAmazonSSM"
}

# The lookup for the AmazonSSMManagedInstanceCore Policy
data "aws_iam_policy" "ssm_managed_core" {
  name = "AmazonSSMManagedInstanceCore"
}

# The lookup for the AmazonSSMMaintenanceWindowRole Policy
data "aws_iam_policy" "ssm_managed_window_role" {
  name = "AmazonSSMMaintenanceWindowRole"
}