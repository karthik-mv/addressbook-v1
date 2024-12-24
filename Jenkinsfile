pipeline {
    agent none
    
    stages {
        stage('Compile') {
        agent any
            steps {
                echo "Compile the code"
                sh "mvn compile"
            }
        }

        stage('Unit test') {
        agent any
            steps {
                echo "Test the code"
                sh "mvn test"
            }       
        }

        stage('Package') {
        agent {label 'linux_slave'}
            steps {
                echo "Package the code"
                sh "mvn package"
            }        
        }
    }   
}
