pipeline {
    agent none
    tools{
        //jdk "jdk11"
        maven "mymaven"
    }
    parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Env to deploy')
        booleanParam(name: 'Executetests', defaultValue: true, description: 'decide to run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '2.1', '3.1'])
    }
    stages {
        stage('Compile') {
        agent any
            steps {
                echo "Compile the code"
                sh "mvn compile"
            }
        }

        stage('Unit test') {
        when{
            expression{
                Executetests == true
            }
        }
        agent any
            steps {
                echo "Test the code"
                sh "mvn test"
            }     

            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }  
        }

        stage('Package') {
        when{
            expression{
                BRANCH_NAME == 'sept'
            }
        }
        agent {label 'linux_slave'}
             input{
              message "select the version to deploy"
              ok "OK"
             parameters{
                choice (name: 'APP', choices:['1.1','2.1','3.1'])
             }
        }
            steps {
                echo "Package the code"
                sh "mvn package"
            }        
        }
    }   
}
