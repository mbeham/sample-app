pipeline {
  agent any
  environment {
    TERRAFORM_HOME = tool name: 'terraform-0.11.3'
    ARM_SUBSCRIPTION_ID = "fcc1ad01-b8a5-471c-812d-4a42ff3d6074"
    ARM_CLIENT_ID = "262d2df5-a043-458a-9d0d-27a734962cd9"
    ARM_CLIENT_SECRET = credentials('283cce48-9ad2-42b5-80b7-61975c1bfdc5')
    ARM_TENANT_ID = "787717a7-1bf4-4466-8e52-8ef7780c6c42"
    ARM_ENVIRONMENT = "public"
  }
  stages {
    stage('build') {
      when { not { branch 'feature/terraform' } }
      steps {
        withMaven(jdk: '1.8', maven: '3.5.2') {
          sh '''#/bin/bash

mvn package'''
        }

      }
    }
    stage('packer') {
      when { not { branch 'feature/terraform' } }
      environment{
        PACKER_HOME = tool name: 'packer-1.1.3', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation'
        PACKER_SUBSCRIPTION_ID = "fcc1ad01-b8a5-471c-812d-4a42ff3d6074"
        PACKER_CLIENT_ID = "262d2df5-a043-458a-9d0d-27a734962cd9"
        PACKER_CLIENT_SECRET = credentials('283cce48-9ad2-42b5-80b7-61975c1bfdc5')
        PACKER_LOCATION = "westeurope"
        PACKER_TENANT_ID = "787717a7-1bf4-4466-8e52-8ef7780c6c42"
        PACKER_OBJECT_ID = "56e89fa0-e748-49f4-9ff0-0d8b9e3d4057"
      }
      steps {
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
          sh "${PACKER_HOME}/packer validate packer/azure.json"
          sh "${PACKER_HOME}/packer build packer/azure.json"
        }
      }
    }
    stage('terraform') {
      steps {
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
          dir('terraform') {
            script {
              sh "${TERRAFORM_HOME}/terraform init -input=false"
              def TF_APPLY_STATUS = sh (script: "${TERRAFORM_HOME}/terraform plan -out=tfplan -detailed-exitcode -input=false", returnStatus: true)
              sh "echo ${TF_APPLY_STATUS}"
              if ( TF_APPLY_STATUS == 2 ) {
                sh "${TERRAFORM_HOME}/terraform apply -input=false -auto-approve tfplan"
              }
          }
          }
        }
      }
    }
  }
}
