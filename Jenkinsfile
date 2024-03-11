podTemplate {
  environment {
    PRISMA_API_URL = 'https://api.sg.prismacloud.io'
    PRISMA_API_ACCESS_KEY = credentials('PRISMA_API_ACCESS_KEY')
    PRISMA_API_SECRET_KEY = credentials('PRISMA_API_SECRET_KEY')
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
  }
  node(POD_LABEL) {
    stage('Checkov') {
      container('checkov') {
        sh("""
        checkov -d . --use-enforcement-rules -o cli -o junitxml \
        --output-file-path console,results.xml \
        --bc-api-key $PRISMA_API_ACCESS_KEY::$PRISMA_API_SECRET_KEY \
        --repo-id git@github.com:eddie-ecv/prismacloud \
        --branch master
        """)
        junit skipPublishingChecks: true, testResults: 'results.xml'
        currentBuild.result = 'SUCCESS'
      }
    }
  }
}
