environment {
    PRISMA_API_URL = 'https://api.sg.prismacloud.io'
    PRISMA_API_ACCESS_KEY = credentials('PC_USER')
    PRISMA_API_SECRET_KEY = credentials('PC_PASSWORD')
}
node(label: 'checkov') {
  stage('Checkov') {
    container('checkov') {
      try {
        sh("""
        checkov -d . --use-enforcement-rules -o cli -o junitxml \
        --output-file-path console,results.xml \
        --bc-api-key $PRISMA_API_ACCESS_KEY::$PRISMA_API_SECRET_KEY \
        --repo-id git@github.com:eddie-ecv/prismacloud \
        --branch master
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
// stage('Terraform') {
//   steps {
//     container('terraform') {
//       sh 'terraform init'
//       sh 'terraform validate'
//       sh 'terraform plan'
//     }
//   }
// }
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
