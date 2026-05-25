terraform {
  required_version = ">= 1.5.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

resource "local_file" "mock_server" {
  filename = "${path.module}/mock_aws_instance.txt"
  content  = "ID: i-0abc123def456\nStatus: Running\nPublic_IP: 127.0.0.1\nType: t2.micro\n"
}
