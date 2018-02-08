pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        withMaven(jdk: '1.8', maven: '3.5.2') {
          sh '''#/bin/bash

mvn package'''
        }

      }
    }
    stage('packer') {
      environment{
        PACKER_HOME = tool name: 'packer-1.1.3', type: 'biz.neustar.jenkins.plugins.packer.PackerInstallation'
      }
      steps {
        wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']) {
          sh "${PACKER_HOME}/packer validate packer/vagrant.json"
          sh "${PACKER_HOME}/packer build packer/vagrant.json"
        }
      }
    }
  }
}
