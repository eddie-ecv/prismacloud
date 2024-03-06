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
    PRISMA_API_ACCESS_KEY = credentials('PC_USER')
    PRISMA_API_SECRET_KEY = credentials('PC_PASSWORD')
  }
  stages {
    stage('Checkov') {
      steps {
        script {
          container('checkov') {
            try {
              sh("""
              checkov -d . --use-enforcement-rules -o cli -o junitxml \
              --output-file-path console,results.xml \
              --bc-api-key $PRISMA_API_ACCESS_KEY::$PRISMA_API_SECRET_KEY \
              --repo-id git@github.com:eddie-ecv/prismacloud \
              --branch master || true
              """)
              junit skipPublishingChecks: true, testResults: 'results.xml'
              currentBuild.result = 'SUCCESS'
            } catch (err) {
              junit skipPublishingChecks: true, testResults: 'results.xml'
              currentBuild.result = 'FAILURE'
              throw err
            }
          }
        }
      }
    }
  }
  post {
      success {
        echo 'Checkov scan completed successfully'
      }
      failure {
        echo 'Checkov scan failed'
      }
  }
  options {
    preserveStashes()
    timestamps()
  }
}
