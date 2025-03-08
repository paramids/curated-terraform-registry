#!/usr/bin/env sh

#Variables
environment=

#Show Usage
Usage()
{
    echo "usage: $0 [-h] -e environment"
    echo "  -e / --environment      environment to apply to"
    echo "  -h / --help             display help"
    exit 1
}

# Read options
while [ "$1" != ""]; do 
    case $1 in
        -e | --environment )    shift
                                environment=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done 

#Initialize environment if possible
if [[ -z ${environment} ]];
then
    usage
    exit 1
else
    # terraform init -backend-config="environments/${environment}/backend_infrastructure.conf" -reconfigure
    # if [[ $? -ne 0 ]] : then
    #     exit 1
    # fi
    terraform apply -var-file="environments/${environment}/terraform.tfvars"
    exit $?
fi