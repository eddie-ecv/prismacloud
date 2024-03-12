pipeline {
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
            - name: terraform
                image: hashicorp/terraform:latest
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
  environment {
        PRISMA_API_URL = 'https://api.sg.prismacloud.io'
        PRISMA_API_ACCESS_KEY = credentials('PRISMA_API_ACCESS_KEY')
        PRISMA_API_SECRET_KEY = credentials('PRISMA_API_SECRET_KEY')
  }
  stages {
    stage('Checkov scan') {
        container(name: 'checkov')
          sh(script: """
          checkov -d . --use-enforcement-rules -o cli -o junitxml \
        --output-file-path console,results.xml \
        --bc-api-key $PRISMA_API_ACCESS_KEY::$PRISMA_API_SECRET_KEY \
        --repo-id git@github.com:eddie-ecv/prismacloud \
        --branch master
        """)
    }
    post {
        always { junit skipPublishingChecks: true, testResults: 'results.xml' }
    }
    stage('Terraform validate') {
      container(name: 'terraform') {
        environment {
          AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
          AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        }
        steps {
          sh 'terraform init'
          sh 'terraform validate'
        }
      }
    }
  }
  post {
    success {
      echo 'All stages completed successfully'
    }
    failure {
      echo 'Some stages failed'
      script {
        if (currentBuild.previousBuild != null) {
          def previousResult = currentBuild.previousBuild.result
          echo "Previous build number: ${currentBuild.previousBuild.number}; Result: ${previousResult}"
        }
      }
    }
  }
  options {
    preserveStashes()
    timestamps()
  }
}
