pipeline {
    agent none
    tools{
        //jdk "jdk11"
        maven "mymaven"
    }
    environment{
        DEV_SERVER_IP='ec2-user@172.31.18.93'
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
                echo "Test the code in ${params.Env}"
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
                BRANCH_NAME == 'sept'   //this should be added in all branches jenkins file
            }
        }
        agent any //{label 'linux_slave'}
             input{
              message "select the version to deploy"
              ok "OK"
             parameters{
                choice (name: 'APP', choices:['1.1','2.1','3.1'])
             }
        }
            steps {
                script{
                    sshagent([Slave2])
                    echo "Package the code ${params.APPVERSION}"
                    sh "scp -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER_IP}:/home/ec2-user" //for first time connection
                    sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER_IP} 'bash ~/server-script.sh' "
                    
                }
                
            }        
        }
    }   
}
