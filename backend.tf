terraform {
    backend "s3"{
        bucket          = "raghbindra-terraform-state"
        key             = "flask-app/dev/terraform.tfstate"
        region          = "ap-south-1"
        dynamodb_table = "terraform-locks"
    }
}