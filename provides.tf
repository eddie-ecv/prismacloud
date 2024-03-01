terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  cloud {
    organization = "Eddie_Cheung"

    workspaces {
      name = "prismacloud"
    }
  }
}

provider "aws" {
  region = "us-west-2" # Replace with your desired AWS region
}
