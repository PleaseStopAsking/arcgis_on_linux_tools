#!/bin/bash

###########
# Script to pull various pieces of information from an install of ArcGIS Server on Linux
# Created by Michael Hatcher
# 09-30-2016
# Version 1.0
##########
# Will work on 10.5 and older at this time. Can be updated as needed

getMajorMinorVersion()
{
    # given aa.bb.cc, strip .cc, return aa.bb
    echo $1 | sed 's/\([0-9][0-9]*\)\.\([0-9][0-9]*\)\.[0-9][0-9]*$/\1\.\2/'
}

SimpleVersion=10.4.1
ProductVersion="${SimpleVersion}"
BaseVersion=` getMajorMinorVersion $SimpleVersion `
product=ArcGISServer
PreviousVersions="10.5 10.4.1 10.4 10.3.1 10.3 10.2.2 10.2.1 10.2 10.1"
ProductName="ArcGIS $ProductVersion for Server"
shortname="server"
Esri_Hostname=` hostname -f `; export Esri_Hostname
BuildNumber="/.Setup/build_number"
ServerInfo="/tools/serverinfo"
TomcatVersionInfo="/framework/runtime/tomcat/bin/version.sh"
CatalinaVersionInfo="/framework/runtime/tomcat/bin/catalina.sh"

PreviousVersion_Detected=false
for PreviousVersion in ${PreviousVersions}
do
    PreviousVersion_Prop_File="$HOME/.ESRI.properties.` uname -n `.${PreviousVersion}"
    #echo "PreviousVersion_Prop_File="$PreviousVersion_Prop_File
    ProductInstallDir=""
    if [ -f ${PreviousVersion_Prop_File} ]
    then
        ProductInstallDir=` grep Z_${product}_INSTALL_DIR ${PreviousVersion_Prop_File} | cut -f2 -d= `
    fi
	PreviousProductName="ArcGIS ${PreviousVersion} for Server"
	#echo "PreviousProductName="$PreviousProductName
	#echo "ProductInstallDir="$ProductInstallDir
	
    DetectedSPLevel=""
    if [ "x${ProductInstallDir}" != "x" ] && [ -d ${ProductInstallDir} ]
    then
        PreviousVersion_Detected=true
        ProductPatchLog="${ProductInstallDir}/.ESRI_S_PATCH_LOG"
        if [ -f ${ProductPatchLog} ]
        then
            GetSPNumber="False"
            while read line
            do
                if [ "` echo ${line} | grep ^QFE_TYPE | sed 's/^QFE_TYPE: //' `" = "Service Pack" ]
                then
                    GetSPNumber="True"
                    continue
                fi

                if [ "${GetSPNumber}" = "True" ] && [ "` echo ${line} | grep ^QFE_TITLE `x" != "x" ]
                then
                    DetectedSPLevel=` echo ${line} | sed 's/^QFE_TITLE: //' `
                    break
                fi
            done < ${ProductPatchLog}
        fi
        break
    fi
done

if [ "x${DetectedSPLevel}" != "x" ]
then
     DetectedPreviousProductName="${PreviousProductName} SP${DetectedSPLevel}"
    	else
     DetectedPreviousProductName="${PreviousProductName}"
fi

BuildNumberComplete=$(cat "$ProductInstallDir$BuildNumber")

echo
echo "Hostname: "$Esri_Hostname
echo "Previous Version Detected: "$PreviousVersion_Detected
echo "Product Found: "$DetectedPreviousProductName
echo "ProductPatchLog: "$ProductPatchLog
echo "DetectedSPLevel: "$DetectedSPLevel
echo "Build Number: "$BuildNumberComplete
echo "ProductInstallDir: "$ProductInstallDir
echo
echo "Server Info Reports:"
$ProductInstallDir$ServerInfo
echo
echo "Tomcat Version Reports:"
$ProductInstallDir$TomcatVersionInfo
echo
echo "Catalina Version Reports:"
$ProductInstallDir$CatalinaVersionInfo version
echo
