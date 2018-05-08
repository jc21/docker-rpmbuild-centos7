pipeline {
  agent any
  environment {
    IMAGE_NAME      = "rpmbuild"
    TEMP_IMAGE_NAME = "rpmbuild7_${BUILD_NUMBER}"
    TAG_VERSION     = "el7"
  }
  stages {
    stage('Prepare') {
      steps {
        sh 'docker pull centos:7'
      }
    }
    stage('Build') {
      steps {
        sh 'FINAL_IMAGE_NAME="${DOCKER_PRIVATE_REGISTRY}/${IMAGE_NAME}:${TAG_NAME}"'
        sh 'docker build --squash --compress -t ${TEMP_IMAGE_NAME} .'
      }
    }
    stage('Publish') {
      steps {
        sh 'docker tag ${TEMP_IMAGE_NAME} ${DOCKER_PRIVATE_REGISTRY}/${IMAGE_NAME}:${TAG_NAME}'
        sh 'docker push ${DOCKER_PRIVATE_REGISTRY}/${IMAGE_NAME}:${TAG_NAME}'
      }
    }
  }
  triggers {
    bitbucketPush()
  }
  post {
    success {
      slackSend color: "good", message: "<${BUILD_URL}|${JOB_NAME}> build #${BUILD_NUMBER} completed"
    }
    failure {
      slackSend color: "#d61111", message: "<${BUILD_URL}|${JOB_NAME}> build #${BUILD_NUMBER} failed"
    }
    always {
      sh 'docker rmi  $TEMP_IMAGE_NAME'
    }
  }
}
