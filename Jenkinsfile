podTemplate {
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
