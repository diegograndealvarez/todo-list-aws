pipeline {
    agent any

    stages {
        stage('Get Code') {
            steps {
                echo "Descàrrega del codi"
                checkout scm
            }
        }

        stage('Static Test') {
            steps {
                echo "Execució de Flake8 i Bandit"
                sh 'pip3 install flake8 bandit --break-system-packages'
                sh 'python3 -m flake8 src --output-file=flake8-report.txt || true'
                sh 'python3 -m bandit -r src -f txt -o bandit-report.txt || true'
            }
        }

stage('Unit Test') {
    environment {
        DYNAMODB_TABLE = "todoTable"
    }
    steps {
        echo "Execució de tests unitaris"

        sh 'pip3 install pytest moto boto3 --break-system-packages'

        sh 'python3 -m pytest test/unit/'
    }
}



stage('Build & Deploy') {
    steps {
        script {

            if (env.BRANCH_NAME == "develop") {
                echo "Desplegando entorno: STAGING"
                sh 'sam build'
                sh 'sam deploy --config-env staging || true'
            }

            else if (env.BRANCH_NAME == "master") {
                echo "Desplegando entorno: PRODUCTION"
                sh 'sam build'
                sh 'sam deploy --config-env production || true'
            }

            else {
                echo "Branca ${env.BRANCH_NAME} no requiere despliegue"
            }
        }
    }
}



stage('Rest Test') {
    steps {
        script {
            def stackName = ''

            if (env.BRANCH_NAME == 'develop') {
                stackName = 'staging-todo-list-aws'
            } else if (env.BRANCH_NAME == 'master') {
                stackName = 'todo-list-aws-production'
            } else {
                error("Branch no soportada: ${env.BRANCH_NAME}")
            }

            env.BASE_URL = sh(
                script: """
                    aws cloudformation describe-stacks \
                    --stack-name ${stackName} \
                    --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' \
                    --region us-east-1 \
                    --output text
                """,
                returnStdout: true
            ).trim()
        }

        echo "Base URL: ${env.BASE_URL}"

        sh 'pip3 install pytest --break-system-packages'
        sh 'python3 -m pytest test/integration/todoApiTest.py'
    }
}


stage('Promote') {
    when {
        branch 'develop'
    }
    steps {

                echo "Promoció de develop a master"

                withCredentials([usernamePassword(credentialsId: 'github-credentials', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh '''
                        git config --global user.email "jenkins@ci.local"
                        git config --global user.name "Jenkins CI"

                        git fetch origin

                        git checkout master
                        git reset --hard origin/master

                        git merge origin/develop

                        git push https://${GIT_USER}:${GIT_PASS}@github.com/diegograndealvarez/todo-list-aws.git master
                    '''
                }
            }
        }









    }
}

