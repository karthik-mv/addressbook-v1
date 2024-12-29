pipeline {
    agent none
    tools{
        //jdk "jdk11"
        maven "mymaven"
    }
    environment{
        DEV_SERVER_IP='ec2-user@172.31.16.83'
        DEPLOY_SERVER_IP='ec2-user@172.31.26.244'
        IMAGE_NAME="karthikmv93/docker"
    }
    parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Env to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'decide to run test cases')
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
                executeTests == true
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

        stage('Package & push the image to registy') {
        // when{
        //     expression{
        //         BRANCH_NAME == 'docker'   //this should be added in all branches jenkins file
        //     }
        // }
        agent any //{label 'linux_slave'}
        //      input{
        //       message "select the version to deploy"
        //       ok "OK"
        //      parameters{
        //         choice (name: 'APP', choices:['1.1','2.1','3.1'])
        //      }
        // }
            steps {
                script{
                    sshagent(['slave2']){
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    echo "Package the code ${params.APPVERSION}"
                    //sh "scp -v -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER_IP}:/home/ec2-user" //for first time connection
                    sh "ssh -v -o StrictHostKeyChecking=no ${DEPLOY_SERVER_IP} sudo yum install docker -y"
                    sh "ssh -v -o StrictHostKeyChecking=no ${DEV_SERVER_IP} 'bash ~/server-script.sh' ${IMAGE_NAME} ${BUILD_NUMBER}"
                    sh " ${DEV_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                    sh "ssh ${DEV_SERVER_IP} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                         }
                    }
                }
                
            }        
        }
    }


    

    
        stage('Deploy') {
        // agent any
        //     steps {
        //         echo "Compile the code"
        //         sh "mvn compile"
        //     }
        // }

        // stage('Unit test') {
        // when{
        //     expression{
        //         executeTests == true
        //     }
        // }
        // agent any
        //     steps {
        //         echo "Test the code in ${params.Env}"
        //         sh "mvn test"
        //     }     

        //     post{
        //         always{
        //             junit 'target/surefire-reports/*.xml'
        //         }
        //     }  
        // }

        // stage('Package') {
        // when{
        //     expression{
        //         BRANCH_NAME == 'docker'   //this should be added in all branches jenkins file
        //     }
        // }
        agent any//{label 'linux_slave'}
             input{
              message "select the version to deploy"
              ok "OK"
             parameters{
                choice (name: 'APP', choices:['1.1','2.1','3.1'])
             }
        }
            steps {
                script{
                    sshagent(['slave2']){
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                    echo "Package the code ${params.APPVERSION}"
                    sh "scp -v -o StrictHostKeyChecking=no server-script.sh ${DEPLOY_SERVER_IP}:/home/ec2-user"
                    sh "ssh ${DEPLOY_SERVER_IP} sudo yum install docker -y"
                    sh "ssh ${DEPLOY_SERVER_IP} sudo systemctl start docker"
                    //sh "ssh -v -o StrictHostKeyChecking=no ${DEV_SERVER_IP} 'bash ~/server-script.sh' ${IMAGE_NAME} ${BUILD_NUMBER}"
                    sh "ssh ${DEPLOY_SERVER_IP} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                    sh "ssh ${DEPLOY_SERVER_IP} sudo docker run -itd -P ${IMAGE_NAME}:${BUILD_NUMBER}"
                    }
                    }
                }
                
            }        
        }
      
}
