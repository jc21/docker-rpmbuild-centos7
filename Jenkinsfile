pipeline {
  agent any
  stages {
    stage('Prepare') {
      steps {
        sh '''docker pull centos:7
exit 0'''
      }
    }
    stage('Build') {
      steps {
        sh '''DOCKER_REGISTRY=docker-registry.jc21.net.au
IMAGE_NAME="rpmbuild"
TAG_NAME="el7"

TEMP_IMAGE_NAME="${IMAGE_NAME}-${TAG_NAME}_${BUILD_NUMBER}"
FINAL_IMAGE_NAME="${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG_NAME}"

# Build
echo "Building temp image..."
docker build -t ${TEMP_IMAGE_NAME} .
rc=$?; if [ $rc != 0 ]; then exit $rc; fi
'''
      }
    }
    stage('Publish') {
      steps {
        sh '''DOCKER_REGISTRY=docker-registry.jc21.net.au
IMAGE_NAME="rpmbuild"
TAG_NAME="el7"

TEMP_IMAGE_NAME="${IMAGE_NAME}-${TAG_NAME}_${BUILD_NUMBER}"
FINAL_IMAGE_NAME="${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG_NAME}"

# Tag
echo "Tagging new image..."
docker tag ${TEMP_IMAGE_NAME} ${FINAL_IMAGE_NAME}
rc=$?; if [ $rc != 0 ]; then exit $rc; fi

# Remove temp image
echo "Removing temp image..."
docker rmi ${TEMP_IMAGE_NAME}

# Upload entire php image and all tags:
echo "Uploading new image..."
docker push ${FINAL_IMAGE_NAME}
rc=$?; if [ $rc != 0 ]; then exit $rc; fi'''
      }
    }
  }
}