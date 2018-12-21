#!/usr/bin/env bash

repository="gcr.io/net2phone-sandbox"
appname="podinfo"
#repository="drweber"
branch="master"
version=""
commit=$(LC_ALL=C tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 8 | head -n 1| awk '{print tolower($0)}')

while getopts :r:b:v: o; do
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
        v)
            version=${OPTARG}
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${version}" ]; then
    image="${repository}/${appname}:${branch}-${commit}"
    version="1.4.2u"
else
    image="${repository}:${version}"
fi

echo ">>>> Building image ${image} <<<<"

echo " Image name is " ${image}

docker build --build-arg GITCOMMIT=${commit} --build-arg VERSION=${version} -t ${image} -f Dockerfile.ci .

echo " Image name is " ${image}

docker push ${image}
