pipeline {
  agent any

  environment {
    PRISMA_API_URL = 'https://api.sg.prismacloud.io'
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'git@github.com:eddie-ecv/prismacloud.git'
        stash includes: '**/*', name: 'source'
      }
    }
    stage('Checkov') {
      steps {
        withCredentials([string(credentialsId: 'PC_USER', variable: 'pc_user'),
        string(credentialsId: 'PC_PASSWORD', variable: 'pc_password')]) {
          script {
            docker.image('bridgecrew/checkov:latest').inside("--entrypoint=''") {
              unstash 'source'
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
