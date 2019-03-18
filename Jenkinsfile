pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    disableConcurrentBuilds()
  }
  agent {
    label 'rpm'
  }
  environment {
    IMAGE = "rpmbuild-centos7"
    TEMP  = "rpmbuild7_${BUILD_NUMBER}"
    TAG   = "latest"
  }
  stages {
    stage('Build') {
      steps {
        ansiColor('xterm') {
          sh 'docker build --pull --no-cache --squash --compress -t ${TEMP_IMAGE} .'
        }
      }
    }
    stage('Publish') {
      steps {
        ansiColor('xterm') {

          // Dockerhub
          sh 'docker tag ${TEMP_IMAGE} docker.io/jc21/${IMAGE}:${TAG}'
          withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
            sh "docker login -u '${duser}' -p '${dpass}'"
            sh 'docker push docker.io/jc21/${IMAGE}:${TAG}'
            sh 'docker rmi docker.io/jc21/${IMAGE}:${TAG}'
          }
        }
      }
    }
  }
  triggers {
    bitbucketPush()
  }
  post {
    success {
      build job: 'Docker/docker-rpmbuild-centos7/golang', wait: false
      build job: 'Docker/docker-rpmbuild-centos7/devtools7', wait: false
      build job: 'Docker/docker-rpmbuild-centos7/rust', wait: false
      build job: 'Docker/docker-rpmbuild-centos7/fpm', wait: false

      juxtapose event: 'success'
      sh 'figlet "SUCCESS"'
    }
    failure {
      juxtapose event: 'failure'
      sh 'figlet "FAILURE"'
    }
    always {
      sh 'docker rmi  ${TEMP_IMAGE}'
    }
  }
}
