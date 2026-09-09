#!/bin/bash

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

user="myapp"
function create_user() {
        if id "$user" &>/dev/null; then
                echo "User: $user already exists"
        else
                echo "Creating user $user"
                sudo useradd -r -m -s /usr/sbin/nologin "$user"
        fi
}

function app() {
        if [ -d "./package" ]; then
                echo "Set the following needed environment variables: APP_ENV=dev, DB_USER=myuser, DB_PWD=mysecret"
                export APP_ENV=dev DB_USER=myuser DB_PWD=mysecret

                read -p "Enter logs directory path: " log_dir
                if [ -d "$log_dir" ]; then
                        echo "Logs directory is existed"
                        export LOG_DIR=$log_dir
                else
                        echo "Logs directory isn't existed"
                        mkdir $log_dir
                        export LOG_DIR=$log_dir
                fi

                echo "Change into the unzipped ./package/ directory"
                cd ./package/

		echo "Setting ownership of application ($user)"
                sudo chown -R "$user":"$user" "$(pwd)"
                sudo chown -R "$user":"$user" "$LOG_DIR"

                echo "Run the NodeJS application"
                sudo -u "$user" npm install
                sudo -u "$user" env APP_ENV="$APP_ENV" DB_USER="$DB_USER" DB_PWD="$DB_PWD" LOG_DIR="$LOG_DIR" node server.js &

                app_pid=$!
                sleep 2

                if ps -p "$app_pid" > /dev/null 2>&1; then
                        echo "Application started successfully (+)"
                        echo "Node App PID: $app_pid"
                        echo "Node App Port: $(ss -tulpn | grep $app_pid | awk '{print $5}' | tr -d '*:')"
                else
                        echo "Application FAILED to start (X)"
                fi
        else
                echo "Downloading an artifact file ..."
                wget https://node-envvars-artifact.s3.eu-west-2.amazonaws.com/bootcamp-node-envvars-project-1.0.0.tgz

                echo "Unzip the downloaded file"
                tar -xvzf bootcamp-node-envvars-project-1.0.0.tgz

                echo "Set the following needed environment variables: APP_ENV=dev, DB_USER=myuser, DB_PWD=mysecret"
                export APP_ENV=dev DB_USER=myuser DB_PWD=mysecret

                read -p "Enter logs directory path: " log_dir
                if [ -d "$log_dir" ]; then
                        echo "Logs directory is existed"
                        export LOG_DIR=$log_dir
                else
                        echo "Logs directory isn't existed"
                        mkdir $log_dir
                        export LOG_DIR=$log_dir

                fi

                echo "Change into the unzipped ./package/ directory"
                cd ./package/

		echo "Setting ownership of application ($user)"
                sudo chown -R "$user":"$user" "$(pwd)"
                sudo chown -R "$user":"$user" "$LOG_DIR"

                echo "Run the NodeJS application"
                sudo -u "$user" npm install
                sudo -u "$user" env APP_ENV="$APP_ENV" DB_USER="$DB_USER" DB_PWD="$DB_PWD" LOG_DIR="$LOG_DIR" node server.js &

                app_pid=$!
                sleep 2

                if ps -p "$app_pid" > /dev/null 2>&1; then
                        echo "Application started successfully (+)"
                        echo "Node App PID: $app_pid"
                        echo "Node App Port: $(ss -tulpn | grep $app_pid | awk '{print $5}' | tr -d '*:')"
                else
                        echo "Application FAILED to start (X)"
                fi
        fi
}

nodejs_npm
app
