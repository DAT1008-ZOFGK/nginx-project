pipeline {
    agent any

    environment {
        IMAGE_NAME = "datzofgk/nginx-image"
        IMAGE_TAG = "v${BUILD_NUMBER}"
        NEXUS_REPO = "10.10.3.67:1008/docker-hosted/${IMAGE_NAME}"
        SONARQUBE_SERVER = 'sonarserver'
        SONAR_SCANNER = 'sonarscanner'
    }

    stages {
        stage('SonarQube Scan') {
            environment {
                scannerHome = tool "${SONAR_SCANNER}"
            }
            steps {
                script {
                    echo 'Run SonarQube Scan'
                    try {
                        withSonarQubeEnv("${SONARQUBE_SERVER}") {
                            sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=nginx -Dsonar.sources=. -Dsonar.host.url=http://10.10.3.67:9000"
                        }
                    } catch (e) {
                        echo "SonarQube scan failed: ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        // stage('Test with Snyk') {
        //     steps {
        //         script {
        //             echo 'Testing with Snyk'
        //             // Check current directory and list files
        //             sh 'pwd'
        //             sh 'ls -la'
        //             snykSecurity(
        //                 snykInstallation: 'snyk',
        //                 snykTokenId: 'snyk-token',
        //                 options: [
        //                     'test',
        //                     '--severity-threshold=low',
        //                     '--docker',
        //                 ]
        //             )
        //         }
        //     }
        // }

        stage('Build') {
            steps {
                script {
                    echo 'Building Docker image'
                    try {
                        sh "docker image prune -af && docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    } catch (e) {
                        echo "Docker build failed: ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    echo 'Pushing Docker image to Docker Hub'
                    try {
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
                            sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                        }
                    } catch (e) {
                        echo "Push to Docker Hub failed: ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Tag and Push to Nexus') {
            steps {
                script {
                    echo 'Tagging and Pushing Docker image to Nexus'
                    try {
                        docker.withRegistry('http://10.10.3.67:1008/', 'nexus-credentials-id') {
                            sh """
                                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${NEXUS_REPO}:${IMAGE_TAG}
                                docker push ${NEXUS_REPO}:${IMAGE_TAG}
                            """
                        }
                    } catch (e) {
                        echo "Tag and Push to Nexus failed: ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying Docker container'
                    try {
                        sh "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook deploy.yml --private-key=/var/jenkins_home/id_rsa -i inventory -u vsi -e 'image_tag=${IMAGE_TAG}'"
                    } catch (e) {
                        echo "Deploy failed: ${e}"
                        currentBuild.result = 'FAILURE'
                    }
                }
            }
        }
    }
}
