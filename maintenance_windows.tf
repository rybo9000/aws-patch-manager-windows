# Create a Maintenance Window for our monthly install job
resource "aws_ssm_maintenance_window" "windows_install" {
  name        = "windows-patch-install-third-saturday"
  description = "Maintenance Window to install patches on the third Saturday of the month"
  schedule    = "cron(0 0 ? * SAT#3 *)"
  duration    = 8
  cutoff      = 6
}

# Associate an AWS tag as a target for the above Maintenance Window
resource "aws_ssm_maintenance_window_target" "windows_tags_install" {
  description   = "Maintenance Window target for the Windows Patch Install"
  window_id     = aws_ssm_maintenance_window.windows_install.id
  resource_type = "INSTANCE"

  targets {
    key = "tag:Patch Group"
    values = [
      "windows-patching",
    ]
  }
}

# The task we will run inside the above Maintenance Window
resource "aws_ssm_maintenance_window_task" "windows_install" {
  window_id        = aws_ssm_maintenance_window.windows_install.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"
  priority         = 1
  service_role_arn = data.aws_iam_role.aws_service_role_for_amazon_ssm.arn
  max_concurrency  = "100%"
  max_errors       = "100%"

  targets {
    key = "WindowTargetIds"
    values = [
      aws_ssm_maintenance_window_target.windows_tags_install.id
    ]
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Install"]
      }

      parameter {
        name   = "RebootOption"
        values = ["RebootIfNeeded"]
      }
    }
  }
}

# Create a Maintenance Window for our daily scanning job
resource "aws_ssm_maintenance_window" "windows_scan" {
  name        = "windows-patch-daily-scan"
  description = "Maintenance Window to scan for patches daily"
  schedule    = "cron(0 18 * * ? *)"
  duration    = 2
  cutoff      = 1
}

# Associate an AWS tag as a target for the above Maintenance Window
resource "aws_ssm_maintenance_window_target" "windows_tags_scan" {
  description   = "Maintenance Window target for the Windows Patch Daily scan"
  window_id     = aws_ssm_maintenance_window.windows_scan.id
  resource_type = "INSTANCE"

  targets {
    key = "tag:Patch Group"
    values = [
      "windows-patching",
    ]
  }

}

# The task we will run inside the above Maintenance Window
resource "aws_ssm_maintenance_window_task" "windows_scan" {
  window_id        = aws_ssm_maintenance_window.windows_scan.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"
  priority         = 1
  service_role_arn = data.aws_iam_role.aws_service_role_for_amazon_ssm.arn
  max_concurrency  = "100%"
  max_errors       = "100%"

  targets {
    key = "WindowTargetIds"
    values = [
      aws_ssm_maintenance_window_target.windows_tags_scan.id
    ]
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Scan"]
      }

      parameter {
        name   = "RebootOption"
        values = ["NoReboot"]
      }
    }
  }
}