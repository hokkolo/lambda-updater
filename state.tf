terraform {
  backend "s3"{
      bucket = "tf-backend-hokkolo"
      key = "lambda-updater/terraform.tfstate"
      region = "us-east-1"
  }

}