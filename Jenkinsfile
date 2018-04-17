pipeline {
  agent any
  stages {
    stage('Pull dependant images') {
      steps {
        sh 'docker pull centos:7'
      }
    }
    stage('Build and Deploy') {
      steps {
        sh '''DOCKER_REGISTRY=docker-registry.jc21.net.au
IMAGE_NAME="rpmbuild"
TAG_NAME="el7"

TEMP_IMAGE_NAME="${IMAGE_NAME}-${TAG_NAME}_${bamboo_buildNumber}"
FINAL_IMAGE_NAME="${DOCKER_REGISTRY}/${IMAGE_NAME}:${TAG_NAME}"

# Remove any local images
echo "Removing previously built image..."
docker rmi $FINAL_IMAGE_NAME

# Build
echo "Building temp image..."
docker build -t ${TEMP_IMAGE_NAME} .
rc=$?; if [ $rc != 0 ]; then exit $rc; fi

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
#rc=$?; if [ $rc != 0 ]; then exit $rc; fi
exit 0'''
      }
    }
  }
}