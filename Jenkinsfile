pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        withMaven(jdk: '1.8', maven: '3.5.2') {
          sh '''#!/bin/bash

mvn package'''
        }

        echo 'awesome!!!'
      }
    }
  }
}