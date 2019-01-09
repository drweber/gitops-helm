#!/usr/bin/env bash

repository="gcr.io/net2phone-sandbox"
appname="hello"
#repository="drweber"
branch="master"
version=""
commit=$(LC_ALL=C tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 8 | head -n 1| awk '{print tolower($0)}')

while getopts :r:a:b:v: o; do
    case "${o}" in
        r)
            repository=${OPTARG}
            ;;
        a)
            appname=${OPTARG}
            ;;
        b)
            branch=${OPTARG}
            ;;
        p)
            port=${OPTARG}
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${port}" ]; then
    image="${repository}/${appname}:${branch}-${commit}"
    port="8000"
else
    image="${repository}:${port}"
fi

echo ">>>> Building image ${image} <<<<"

echo " Image name is " ${image}

docker build --build-arg build_expose_port=${port} -t ${image} -f Dockerfile.ci .

echo " Image name is " ${image}

docker push ${image}
