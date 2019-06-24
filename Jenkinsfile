#!groovy
import groovy.json.JsonSlurperClassic
node {

    def BUILD_NUMBER=env.BUILD_NUMBER
    def RUN_ARTIFACT_DIR="tests/${BUILD_NUMBER}"
    def SFDC_USERNAME

    def HUB_ORG=env.HUB_ORG_DH
    def SFDC_HOST = env.SFDC_HOST_DH
    def JWT_KEY_CRED_ID = env.JWT_CRED_ID_DH
    def CONNECTED_APP_CONSUMER_KEY=env.CONNECTED_APP_CONSUMER_KEY_DH
    def DEPLOYDIR='force-app'

    println '===================================1' 
    println 'KEY IS' 
    println 'JWT_KEY_CRED_ID: ' 	   + JWT_KEY_CRED_ID
    println 'HUB_ORG: '         	   + HUB_ORG
    println 'SFDC_HOST: '       	   + SFDC_HOST
    println 'CONNECTED_APP_CONSUMER_KEY: ' + CONNECTED_APP_CONSUMER_KEY
    println '===================================2' 
    def toolbelt = tool 'toolbelt'
    println '===================================3' 
	
    stage('checkout source') {
        // when running in multi-branch job, one must issue this command
        checkout scm
    }
    println '===================================4' 

    withCredentials([file(credentialsId: JWT_KEY_CRED_ID, variable: 'jwt_key_file')]) {
        stage('Deploye Code') {
            if (isUnix()) {
                rc = sh returnStatus: true, script: "${toolbelt} force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile ${jwt_key_file} --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            }else{
                 rc = bat returnStatus: true, script: "\"${toolbelt}\\sfdx\" force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
            	 //rc = command "${toolbelt}/sfdx force:auth:jwt:grant --clientid ${CONNECTED_APP_CONSUMER_KEY} --username ${HUB_ORG} --jwtkeyfile \"${jwt_key_file}\" --setdefaultdevhubusername --instanceurl ${SFDC_HOST}"
	    }
    	    println 'rc: ' + rc
            if (rc != 0) { error 'hub org authorization failed' }

            println rc

            // need to pull out assigned username
	    if (isUnix()) {
	    	rmsg = sh returnStdout: true, script: "${toolbelt} force:mdapi:deploy -d manifest/. -u ${HUB_ORG}"
	    }else{ 
	    // v1.1 - when package.xml in force-app/main/default
	        rmsg = bat returnStdout: true, script: "\"${toolbelt}\\sfdx\" force:mdapi:deploy --wait 10 -d force-app/main/default/. -u ${HUB_ORG}"
	    // v1.2 -
		// rmsg = bat returnStdout: true, script: "\"${toolbelt}\\sfdx\" force:mdapi:deploy --wait 5 -d force-app/main/default/ -u ${HUB_ORG}"
	    // v2.1 - when package.xml in manifest & deploy to catalog
		// rmsg = bat returnStdout: true, script: "\"${toolbelt}\\sfdx\" force:source:convert -d mdapiout"
		// rmsg = bat returnStdout: true, script: "\"${toolbelt}\\sfdx\" force:mdapi:deploy --wait 10 -d mdapiout -u ${HUB_ORG}"
	    // v2.2 - when package.xml in manifest
		// rmsg = bat returnStdout: true, script: "\"${toolbelt}\\sfdx\" force:mdapi:deploy --wait 10 -d manifest/. -u ${HUB_ORG}"
	    }
			  
            printf rmsg
            println('Hello from a Job DSL script!')
            println(rmsg)
        }
    }
}
