resource "aws_ssm_patch_group" "windows_baseline" {
  baseline_id = aws_ssm_patch_baseline.windows_baseline.id
  patch_group = "windows-patching"
}