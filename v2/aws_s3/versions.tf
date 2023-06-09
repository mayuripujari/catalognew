terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.7.2"
    }
  }
  required_version = ">= 1.3.0"
}

# © 2022 Persistent Systems, <cloud-automation-stack@persistent.com>