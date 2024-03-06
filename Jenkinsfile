pipeline {
  agent {
    kubernetes {
      yaml '''
apiVersion: v1
kind: Pod
metadata:
  name: checkov
  namespace: jenkins
spec:
  containers:
  - name: checkov
    image: bridgecrew/checkov:latest
    command: ["/bin/sh"]
    tty: true
  resources:
    limits:
      memory: '2Gi'
      cpu: '1000m'
    requests:
      memory: '500Mi'
      cpu: '500m'
      '''
    }
  }

  environment {
    PRISMA_API_URL = 'https://api.sg.prismacloud.io'
  }
  stages {
    stage('Checkov') {
      steps {
        withCredentials([string(credentialsId: 'PC_USER', variable: 'pc_user'),
        string(credentialsId: 'PC_PASSWORD', variable: 'pc_password')]) {
          script {
            container('checkov') {
              // unstash 'source'
              try {
                sh("""
                checkov -d . --use-enforcement-rules -o cli -o junitxml
                --output-file-path console,results.xml
                --bc-api-key ${pc_user}::${pc_password}
                --repo-id git@github.com:eddie-ecv/prismacloud --branch main
                """)
                junit skipPublishingChecks: true, testResults: 'results.xml'
              } catch (err) {
                junit skipPublishingChecks: true, testResults: 'results.xml'
                throw err
              }
            }
          }
        }
      }
    }
  }
  options {
    preserveStashes()
    timestamps()
  }
}
