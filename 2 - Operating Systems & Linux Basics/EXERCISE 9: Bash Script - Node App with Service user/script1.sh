#!/bin/bash

# function install or show already installed NPM, NodeJS
function nodejs_npm () {
        if command -v nodejs >/dev/null 2>&1 && command -v npm >/dev/null 2>&1; then
                echo "NodeJS and NPM is installed (+)"
                echo "NodeJS Version: $(nodejs --version)"
                echo "NPM Version: $(npm --version)"

        else
                echo "NodeJS and NPM isn't installed (X)"
                echo "Installing NodeJS and NPM"
                apt install nodejs npm
        fi
}

# function to create new user
user="myapp1"
function create_user() {
        if id "$user" &>/dev/null; then
                echo "User: $user already exists"
        else
                echo "Creating user $user"
                useradd -m "$user"
        fi
}

function app() {

	create_user
	
	#Take user input and check on existed log directory
        read -p "Enter logs directory path: " log_dir
        if [ -d "$log_dir" ]; then
                echo "Logs directory is existed"
                runuser -l $user -c "export LOG_DIR=$log_dir"
        else
                echo "Logs directory isn't existed"
                runuser -l $user -c "mkdir -p $log_dir"
                runuser -l $user -c "export LOG_DIR=$log_dir"

        fi
	
	#Check of downloaded files from Web
	if [ -d "/home/$user/package" ]; then
                echo "Package directory already exists"
        else
                echo "Downloading an artifact file ..."
                runuser -l $user -c "wget https://node-envvars-artifact.s3.eu-west-2.amazonaws.com/bootcamp-node-envvars-project-1.0.0.tgz"

                echo "Unzip the downloaded file"
                runuser -l $user -c "tar -xvzf bootcamp-node-envvars-project-1.0.0.tgz"
	fi
	
	echo "Set the following needed environment variables: APP_ENV=dev, DB_USER=myuser, DB_PWD=mysecret"
	runuser -l $user -c "export APP_ENV=dev DB_USER=myuser DB_PWD=mysecret"

        echo "Change into the unzipped ./package/ directory"
	echo "Run the NodeJS application"
        runuser -l $user -c "
		cd ./package/ &&
		npm install &&
        	node server.js &"

        app_pid=$!
        sleep 2

        if ps -p "$app_pid" > /dev/null 2>&1; then
		echo "Application started successfully (+)"
		echo "Node App PID: $app_pid"
                echo "Node App Port: $(ss -tulpn | grep $app_pid | awk '{print $5}' | tr -d '*:')"
	else
                echo "Application FAILED to start (X)"
        fi
}

nodejs_npm
app