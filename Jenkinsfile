pipeline {
  agent any
  tools {
    packer 'packer'
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
