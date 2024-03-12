pipeline {
  agent any
  options {
    parallelsAlwaysFailFast()
  }

  stages {
    stage('Parallel Stage') {
      parallel {
        stage('Checkov') {
          agent {
            kubernetes {
              cloud 'Kubernetes'
              yaml """
            apiVersion: v1
            kind: Pod
            metadata:
              namespace: jenkins
            spec:
              containers:
              - name: checkov
                image: bridgecrew/checkov:latest
                command:
                - '/bin/sh'
                tty: true
                resources:
                  limits:
                    memory: '512Mi'
                    cpu: '500m'
                  requests:
                    memory: '256Mi'
                    cpu: '250m'
            """
            }
          }
          steps {
            container('checkov') {
              sh 'checkov -d .'
            }
          }
        }
      }
    }
  }
}
