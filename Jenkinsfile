#!/usr/bin/env groovy

void dockerRun(image, command, extra='', returnStatus=false) {
  sh 'docker run --rm ' + "${extra} " + "${image} " + "sh -c '${command}'"
}

pipeline {
  agent any

  environment {
    BUILD_IMAGE = env.BUILD_TAG.toLowerCase().replaceAll(/[^a-z0-9]/, '-');
    // Credentials to use for reading and writing to PyPI
    CREDENTIALS_ID = 'artifactory_credentials'
    // The GDLME/Core Services PyPI repository to publish to
    REPOSITORY_URL = 'https://artifactory.secureserver.net/artifactory/api/pypi/pypi-core-services-gdml-local'
  }

  stages {
    stage('Prepare workspace') {
      steps {
        sh "rm -rf coverage && mkdir coverage"
      }
    }

    stage('Build image') {
      steps {
        withCredentials([usernamePassword(credentialsId: env.CREDENTIALS_ID,
                                          usernameVariable: 'POETRY_HTTP_BASIC_ARTIFACTORY_USERNAME',
                                          passwordVariable: 'POETRY_HTTP_BASIC_ARTIFACTORY_PASSWORD')]) {
          sh "docker build --build-arg POETRY_HTTP_BASIC_ARTIFACTORY_USERNAME --build-arg POETRY_HTTP_BASIC_ARTIFACTORY_PASSWORD -t ${env.BUILD_IMAGE} ."
        }
      }
    }

    stage('Format check') {
      steps {
        dockerRun(env.BUILD_IMAGE, 'poetry run format_check')
      }
    }

    stage('Lint') {
      steps {
        dockerRun(env.BUILD_IMAGE, 'poetry run lint')
      }
    }

    stage('Type check') {
      steps {
        dockerRun(env.BUILD_IMAGE, 'poetry run type_check')
      }
    }

    stage('Unit test') {
      steps {
        dockerRun(env.BUILD_IMAGE, 'poetry run test', '-v $(pwd)/coverage:/python-project-example/coverage')
        cobertura coberturaReportFile: 'coverage/coverage.xml'
      }
    }

    stage('Publish') {
      when {
        branch 'master'
      }
      steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
          withCredentials([usernamePassword(credentialsId: env.CREDENTIALS_ID,
                                            usernameVariable: 'TWINE_USERNAME',
                                            passwordVariable: 'TWINE_PASSWORD')]) {
            dockerRun(
              env.BUILD_IMAGE,
              'poetry build && ' +
                'twine upload dist/*',
                "--repository-url ${env.REPOSITORY_URL} " +
                "-u ${env.TWINE_USERNAME} " +
                "-p ${env.TWINE_PASSWORD}"
            )
          }
        }
      }
    }
  }
}