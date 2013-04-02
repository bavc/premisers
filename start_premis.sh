#!/bin/bash
# requires mediainfo, xsltproc
# set variables for package paths

# check for essential dependencies
[ ! `which mediainfo` ] && { echo Missing mediainfo utility ; exit 1 ;};
[ ! `which xml` ] && { echo Missing xmlstarlet utility ; exit 1 ;};

script_dir=`dirname "$0"`
package_path="$1"
package_name=`basename "${package_path}"`

# pre-requisites
[ -s "$package_path/metadata/premis.xml" ] && { echo premis.xml already exists. ; exit 1 ;};

"$script_dir/deathToDS_Store.sh" "$package_path"
"$script_dir/verifySIPCompliance.py" "$package_path"
[ "$?" != 0 ] && { echo "$package_path fails SIP Compliance tests." ; exit 1 ;};

# test to make sure the supplied package path is valid
[ -z "${package_path}" ] && { echo The input directory has not been declared. ; exit 1 ;};
[ ! -d "${package_path}" ] && { echo "$package_path" is not a directory. ; exit 1 ;};

startdir=`pwd`
cd "$package_path"
mediainfo -f --language=raw --output=XML "./objects" > "./metadata/mediainfo.xml"
EC=`echo "$?"`
if [ "$EC" -ne "0" ] ; then
    eventOutcome="failure"
    #quarantine?
else
    eventOutcome="success"
fi
cd "$startdir"
xsltproc --stringparam representation_objectIdentifierValue "${package_name}" "${script_dir}/mediainfo2premis.xsl" "$package_path/metadata/mediainfo.xml" > "$package_path/metadata/premis.xml"

#set premis event variables
eventIdentifierType="UUID"
eventIdentifierValue=`uuid -v 4`
eventType="description-mediainfo-v1"
eventDateTime=`date "+%FT%T"`
eventDetail="Original object is described with mediainfo"
sourceLinkingObjectIdentifierType="Repository Package ID"
sourceLinkingObjectIdentifierValue="$package_name"
outcomeLinkingObjectIdentifierType="URI"
outcomeLinkingObjectIdentifierValue="/metadata/mediainfo.xml"
linkingAgentRole="Executing program"

#set premis agent variables
agentIdentifierType="URI"
agentIdentifierValue="http://mediainfo.sourceforge.net/en"
agentName="mediainfo"
agentType="software"
agentNote=`mediainfo --help | grep MediaInfoLib`
linkingEventIdentifierType="$eventIdentifierType"
linkingEventIdentifierValue="eventIdentifierValue"

# report mediainfo assessment as event
"$script_dir/premis_add_event.sh" -x "$package_path/metadata/premis.xml" -i "$eventIdentifierType" -I "$eventIdentifierValue" -T "$eventType" -d "$eventDateTime" -D "$eventDetail" -E "$eventOutcome" -l "$agentIdentifierType" -L "$agentIdentifierValue" -r "$linkingAgentRole" -s "$sourceLinkingObjectIdentifierType" -S "$sourceLinkingObjectIdentifierValue" -o "URI" -O "./metadata/mediainfo.xml"

# report mediainfo as agent
"$script_dir/premis_add_agent.sh" -x "$package_path/metadata/premis.xml" -i "$agentIdentifierType" -I "$agentIdentifierValue" -n "$agentName" -T "$agentType" -N "$agentNote" -l "$eventIdentifierType" -L "$eventIdentifierValue"