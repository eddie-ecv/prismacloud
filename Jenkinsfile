def checkovVersion = '2.0.139'
def terraformVersion = '1.0.4'
def limits = [memory: '2Gi', cpu: '1000m']
def requests = [memory: '500Mi', cpu: '500m']

pipeline {
  agent none
  stages {
    stage('Checkov scan') {
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
              image: bridgecrew/checkov:${checkovVersion}
              command:
              - '/bin/sh'
              tty: true
              resources:
                limits: ${limits}
                requests: ${requests}
          """
        }
      }
      environment {
        PRISMA_API_URL = 'https://api.sg.prismacloud.io'
        PRISMA_API_ACCESS_KEY = credentials('PRISMA_API_ACCESS_KEY')
        PRISMA_API_SECRET_KEY = credentials('PRISMA_API_SECRET_KEY')
      }
      steps {
        script {
          sh(script: """
          checkov -d . --use-enforcement-rules -o cli -o junitxml \
        --output-file-path console,results.xml \
        --bc-api-key $PRISMA_API_ACCESS_KEY::$PRISMA_API_SECRET_KEY \
        --repo-id git@github.com:eddie-ecv/prismacloud \
        --branch master
        """)
        }
      }
      post {
        always { junit 'results.xml' }
      }
    }

    stage('Terraform validate') {
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
              - name: terraform
                image: hashicorp/terraform:${terraformVersion}
                command:
                - '/bin/sh'
                tty: true
                resources:
                  limits: ${limits}
                  requests: ${requests}
          """
        }
      }
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
