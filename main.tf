variable "main_region" {
  type = string
  default = "us-east-1"
}

provider "aws"{
	region = var.main_region
        access_key = "AKIAZQOEGABW372IK5XI"
	
}

module "vpc" {
	source = "./modules/vpc"
}
resource "aws_key_pair" "my-key"{
         key_name = "my-key"
	 public_key ="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCm6ymRlBFVBDEYHYCZqFWg3UVvGzLvAzWKmMNw6oyRam2Tf4Hv4kTSbhhAKruM4U5X4NfBOVOYxd+BtwwmyEj5YDM/h3VlSJEfci1jikrN0+DPYxfDfnBtEWusDhm4u6MBEFjVNYXCigM8aPLxZX0Gy/oYjBXZ+Cqc1GWNCsa9NjM7GZbSCA8Btpp3rvF4Tu+mjo41sc8hVL+T6ZqnyXu0KOMruGHIknci7ByrRmhJZw9ufFu8ek8lNswwGUEe1DyyOnIFcbhYOEVr1ZSK65Mf+V5Dg1kF6n+P3M7NSg74tu+4YN90Nu9SG+t9XEDuEmyl3gO2chHT0CtEaR3v6y48YpHbnhekHYoENIeDPETerxLNshcbq4XDgjoXlvkl4RTHkXCRkyvt1oxCH2uDk5l4u6XEZa3vam9QlCVsldHVArSYEXvWENd3v0FW/uaAwf5opPPEOQtC7kEh/Pb94cxD4+Al9H9ezAH+TzmD74TiYerStCB+FFCurMgDv0EmWTE= epampriyanka_bhardwaj@EPINHYDW00CC"
}

resource "aws_instance" "my-instance" {
	instance_type = "t2.micro"
	key_name      = "my-key"
	ami	      = module.vpc.ami_id
        subnet_id     = module.vpc.subnet_id
tags = {
    Name = "terraform-webserver"
  }

provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl restart httpd"
    ]
} 
connection {
    host        = self.public_ip
    user        = "ec2-user"
    type        = "ssh"
    private_key = file("./my-key")
  }


}

