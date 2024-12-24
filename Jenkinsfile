pipeline {
    agent any
    stages {
        stage('Compile') {
            steps {
                echo "Compile the code"
                sh "mvn compile"
            }
        }

        stage('Unit test') {
            steps {
                echo "Test the code"
                sh "mvn test"
            }       
        }

        stage('Package') {
            steps {
                echo "Package the code"
                sh "mvn package"
            }        
        }
    }   
}
