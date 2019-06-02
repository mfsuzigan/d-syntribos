#!/bin/bash

function addPrefixIfNotEmpty() {
	
	if ([ ! -z $2 ])
	then
		echo "$2$1"
	else
		echo $'\0'
	fi
}

function removeEmptyLines() {	
	sed -i "/^$/d" $1
}

function escapeDashes() {
	echo "${1//\//\\/}"
}

for ARGUMENT in "$@"
do

	KEY=$(echo $ARGUMENT | cut -f1 -d=)
	VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

	case "$KEY" in
	    	method)			method="$VALUE" ;;
		baseUrl) 		baseUrl="$VALUE" ;;			     
	    	path)			path="$(escapeDashes $VALUE)" ;;
		accept) 		acceptHeader="$VALUE" ;;	
		contentType)	 	contentTypeHeader="$VALUE" ;;
		authorization)	 	authorizationHeader="$VALUE" ;;
		body) 			body="$VALUE" ;;	
	    	*)   
	esac    


done

contentTypeHeader="$(escapeDashes $contentTypeHeader)"
contentTypeHeader="$(addPrefixIfNotEmpty $contentTypeHeader 'Content-Type: ')"

acceptHeader="$(escapeDashes $acceptHeader)"
acceptHeader="$(addPrefixIfNotEmpty $acceptHeader 'Accept: ')"

authorizationHeader="$(addPrefixIfNotEmpty "$authorizationHeader" 'Authorization: ')"

mkdir -p "execution/template"
cp "models/model.template" "execution/template/d-syntribos.template"
cp "models/model.conf" "execution/d-syntribos.conf"

templatePlaceHolders=(method path acceptHeader contentTypeHeader authorizationHeader body)
templatePlaceHoldersValues=("$method" "$path" "$acceptHeader" "$contentTypeHeader" "$authorizationHeader" "$body")

for i in ${!templatePlaceHolders[@]}
do	echo ${templatePlaceHolders[i]}  ${templatePlaceHoldersValues[i]}
	sed -i -e "s/%${templatePlaceHolders[i]}%/${templatePlaceHoldersValues[i]}/g" "execution/template/d-syntribos.template"
done

removeEmptyLines "execution/template/d-syntribos.template"
sed -i -e "s/%templateSeparator%//g" "execution/template/d-syntribos.template"

baseUrl="$(escapeDashes $baseUrl)"
sed -i -e "s/%baseUrl%/$baseUrl/g" "execution/d-syntribos.conf"

removeEmptyLines "execution/d-syntribos.conf"

PATH=$PATH:/root/.local/bin
syntribos init --no_downloads --force
syntribos --no_colorize --config-file=execution/d-syntribos.conf run
