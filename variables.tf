variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
  profile     =  "dev"
}
   output "vpc_id" {
       value = aws_default_vpc.default.id
       description = "vpc-0543181ec18566743"
   }
