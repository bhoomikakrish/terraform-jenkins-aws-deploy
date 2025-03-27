pipeline {
    agent any
    environment {
        AWS_CREDENTIALS = credentials('aws-credential') // Replace with your credentials ID
    }
    stages {
        stage('Setup') {
            steps {
                script {
                    // Ensure Terraform is installed
                    bat 'terraform --version'
                }
            }
        }
        stage('Initialize Terraform') {
            steps {
                dir('D:/Old-D-Drive/Devops-tools/Terraform/Day-3') { // Replace with the directory path of your Terraform scripts
                    bat 'terraform init'
                }
            }
        }
        stage('Plan') {
            steps {
                dir('D:/Old-D-Drive/Devops-tools/Terraform/Day-3') {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }
        stage('Manual Approval - Apply Changes') {
            steps {
                script {
                    // Adding a manual input step
                    input message: "Do you want to apply these changes?", ok: "Apply"
                }
            }
        }
        stage('Apply') {
            steps {
                dir('D:/Old-D-Drive/Devops-tools/Terraform/Day-3') { // Ensure this path matches the one used in previous stages
                    bat 'terraform apply tfplan'
                }
            }
        }
        stage('Manual Approval - Destroy Changes') {
            steps {
                script {
                    // Adding a manual input step
                    input message: "Do you want to destroy these changes?", ok: "Destroy"
                }
            }
        }
        stage('Destroy') {
            steps {
                dir('D:/Old-D-Drive/Devops-tools/Terraform/Day-3') {
                    bat 'terraform destroy'
                }
            }
        }
    }
}
