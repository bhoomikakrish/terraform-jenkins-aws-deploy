# In this Day-3 folder we are creating vpc,subnet,IGW,RT,Route table association and ec2 instance.
then installing jenkins using jenkins.sh file
# after installation completed try to access instance, To access instance go to C:\Users\bhoomika.rishnappa\.sshh > CMD > [Because the terraform pem key we generated on this location only]
ssh -i "terraform_key.pem" ubuntu@13.233.89.242

#after login switch to jenkins user
sudo su - jenkins
cat  cat /var/lib/jenkins/secrets/initialAdminPassword 
