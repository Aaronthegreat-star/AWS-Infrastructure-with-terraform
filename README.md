Terraform which is the leading(IAC) tool was used to build this infrastructure. The project describes installation of an apache webserver on several ec2 instances residing in the private subent of a vpc. a shell script that installs the apache webserver on an ubuntu ami was written as the userdata to install the apache webserver at launch of the instances. a Demo s3 bucket was also attached as a backend which could serve various purpose from static website hoisting, storage of files as well as backup of data from the ec2 instances.
![Alt text](demo-terraform-deployment.png)
🔗  🛠 Skills:
    Terraform, bash scripting...

🔗 Prerequisites:
    If you are interested in replicating this 
    project, there are some important tools
    to get it up and running, a couple of these
    tools are listed below.

i.  AWS account: This is very important as it 
    provides the cloud platform the resources to be 
    deployed would be created.

ii.  CLI: This is a text based interactive 
    environment we use to communicate with the AWS
    resources from the command line instead of 
    using the console. our aws account is accesed 
    here through our access key and secret access 
    key. The AWS CLI must be installed before we
    can carry out any interactive operation.

iii. Terraform: This an open-source Infrastructure
    as a code(IAC) implementaion. It enables the 
    provision of Infrastructure Declaratively. This
    has to be installed prior to creation of this 
    project.


