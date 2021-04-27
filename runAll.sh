#!/usr/bin/env bash


    read -p "Run on local java environment or run on K8S?, Y=Local java, N=K8S" yn
    case $yn in
        [Yy]* )
            nohup java -jar discovery-service/target/discovery-service-0.0.1-SNAPSHOT.jar  &
            sleep 5s # Waits 5 seconds.
            nohup java -jar notebook-service/target/notebook-service-0.0.1-SNAPSHOT.jar  &
            sleep 5s # Waits 5 seconds.
            nohup java -jar zuul-service/target/zuul-service-0.0.1-SNAPSHOT.jar  &
         break;;
        [Nn]* )
            read -p "Run on K8S prod namespace?, Y=prod, N=dev" yn
            case $yn in
                [Yy]* )
                    kubectl delete -f k8s-deploy/discovery.yaml -n prod
                    kubectl delete -f k8s-deploy/gateway.yaml -n prod
                    kubectl delete -f k8s-deploy/notebook.yaml -n prod

                    kubectl create -f k8s-deploy/discovery.yaml -n prod
                    kubectl create -f k8s-deploy/notebook.yaml -n prod
                    kubectl create -f k8s-deploy/gateway.yaml -n prod
                 break;;
                [Nn]* )
                    kubectl delete -f k8s-deploy/discovery.yaml -n dev
                    kubectl delete -f k8s-deploy/gateway.yaml -n dev
                    kubectl delete -f k8s-deploy/notebook.yaml -n dev

                    kubectl create -f k8s-deploy/discovery.yaml -n dev
                    kubectl create -f k8s-deploy/notebook.yaml -n dev
                    kubectl create -f k8s-deploy/gateway.yaml -n dev
                exit;;
                * ) echo "Please answer yes or no.";;
            esac
            kubectl delete -f k8s-deploy/discovery.yaml
            kubectl delete -f k8s-deploy/gateway.yaml
            kubectl delete -f k8s-deploy/notebook.yaml

            kubectl create -f k8s-deploy/discovery.yaml
            kubectl create -f k8s-deploy/notebook.yaml
            kubectl create -f k8s-deploy/gateway.yaml
        exit;;
        * ) echo "Please answer yes or no.";;
    esac



