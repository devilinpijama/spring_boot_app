#Added terraform configuration. 
Added two instances - WebServer - Tomcat, and Master Jenkins (Java, Maven)
Tomcat Log-in change in role - spring_boot_app/terraform for launch instances/tomcat_playbook.yml 

For Using Ansible change it .cfg for terraform directory path: Change : 
- Working Directory
- Role Directory
- For terraform launching create IAM user for it and place it at home dir in .aws/cred file (don't forget to change chmod): or change path at main.tf as variables. 


This project can be deployed via Jenkins and some addons like : GIT plugins - connect repo and adding WebHook, Deploy to container Plugin - deployer to tomcat, etc. 
________________________________________________________________________________________________________


Commit: 
EPAM. <Summer> 2019.11.12 6:15PM
