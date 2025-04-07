# RandomString
Small project for Docker and Terraform with basic code written in Python.

# Task Discription

Choose between the below string

    1.  Investment
    2.  Buy-the-dip
    3.  tickettape
    4.  smallcase

And Display the result at the public endpoint of EC2 instance at /api/v1 on port 8081. 

Example --> http://publicIP:8081/api/v1

# App folder

This folder contains the code in Golang and the Dockerfile to build the image. I have already Build the image at my local system and pushed it to the ECR. 



# Terraform

This folder contains the Infrastructure as code for EC2 instance and IAM role to access the ECR. 
