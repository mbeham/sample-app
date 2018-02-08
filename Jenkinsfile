pipeline {
  agent any
  tools {
    Packer 'packer-1.1.3'
  }
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
      steps {
        sh 'packer validate packer/vagrant.json'
      }
    }
  }
}
