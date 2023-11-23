//This creates our ec2 instances in our asg
resource "aws_launch_template" "instance_for_my_archi"{
  name_prefix = "instance_type_for_my_archi"
  image_id =  "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  user_data = filebase64("${path.module}/userdata.sh")
  iam_instance_profile{
    name= aws_iam_instance_profile.my_instance_profile.name
  }
}
//This scales our application and make them available in two AZs
resource "aws_autoscaling_group" "scaling_group_for_my_instance" {
  name                 = "my-own-instance-asg-a"
  min_size             = 2
  max_size             = 5
  desired_capacity     = 3
  vpc_zone_identifier  = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id] 
   target_group_arns = [aws_lb_target_group.my_target_group.arn]
  launch_template {
    id      = "${aws_launch_template.instance_for_my_archi.id}"
    version = "$Latest"
  }
}

  #This creates an IAM instance profile
 resource "aws_iam_instance_profile" "my_instance_profile" {
   name = "my-first-instance-profile"
   role = aws_iam_role.my_instance_role.name  # Reference the IAM role you create in the next step
 }
 #This creates an IAM role and attach an S3 policy
 resource "aws_iam_role" "my_instance_role" {
   name = "my-first-instance-role"

   assume_role_policy = <<EOF
  {
   "Version": "2012-10-17",
   "Statement": [
     {
       "Effect": "Allow",
       "Principal": {
         "Service": "ec2.amazonaws.com"
       },
       "Action": "sts:AssumeRole"
     }
   ]
 }
 EOF
 }
 #This attachs a policy with S3 permissions to the IAM role
 resource "aws_iam_policy_attachment" "my_instance_policy" {
   name       = "my_first_instance_policy"
   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"  # Replace with the desired S3 policy ARN
   roles      = [aws_iam_role.my_instance_role.name]
 }
 #This gives the output of the instance profile ARN for reference
 output "instance_profile_arn" {
   value = aws_iam_instance_profile.my_instance_profile.arn
 }
resource "aws_s3_bucket" "my_s3_backend_bucket_for_mydata" {
  bucket = "the-s3-bucket-for-my-data"
}

