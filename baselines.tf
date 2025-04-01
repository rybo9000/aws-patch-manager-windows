resource "aws_ssm_patch_baseline" "windows_baseline" {
  name             = "windows-custom-baseline"
  description      = "Windows Patch Baseline"
  operating_system = "WINDOWS"

  # Approve All Patches Of Any Classification
  approval_rule {
    approve_after_days = 2

    patch_filter {
      key = "CLASSIFICATION"
      values = [
        "CriticalUpdates",
        "SecurityUpdates",
      ]
    }
    patch_filter {
      key = "MSRC_SEVERITY"
      values = [
        "Critical",
        "Important",
        "Moderate",
      ]
    }
    patch_filter {
      key = "PATCH_SET"
      values = [
        "OS",
      ]
    }
  }
}