terraform {
 backend "s3" {
   bucket         = "upb-devops2024-terraform-brendavivs"
   key            = "global/s3/terraform.tfstate"
   region         = "us-east-1"
   dynamodb_table = "upb-devops2-24-tfstate-locking"
   encrypt        = true
 }
}
