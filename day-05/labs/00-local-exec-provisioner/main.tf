resource "terraform_data" "local_exec_demo" {
  input = {
    message = var.message
  }

  triggers_replace = [
    var.message,
    var.local_exec_command,
    join(" ", var.local_exec_interpreter),
  ]

  provisioner "local-exec" {
    command     = var.local_exec_command
    interpreter = var.local_exec_interpreter
    working_dir = path.module

    environment = {
      DEMO_MESSAGE = var.message
    }

    on_failure = fail
  }
}
