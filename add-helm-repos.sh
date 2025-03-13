#!/bin/bash

in_file="${HELM_REPOS_FILE:-cdk8s.yaml}"
key="${HELM_REPOS_KEY:-helmRepos}"

if [ ! -f $in_file ]; then
  echo "Input file $in_file does not exist"
  exit 0
fi

array_length=$(yq ".$key | length" $in_file)

if [ $array_length -lt 0 ] ; then
  echo "No charts in $key list, exiting"
  exit 0
fi

for element_index in `seq 0 $(($array_length - 1))`;do
    name=`yq -r ".$key[$element_index].name" $in_file`
    url=`yq -r ".$key[$element_index].url" $in_file`

    helm repo add $name $url
done