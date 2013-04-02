#!/bin/bash
while getopts ":x:i:I:T:d:D:E:N:l:L:r:s:S:o:O:" opt; do
  case $opt in
    x)
      xmlfile="$OPTARG"
      ;;
    i)
      eventIdentifierType="$OPTARG" >&2
      ;;
    I)
      eventIdentifierValue="$OPTARG" >&2
      ;;
    T)
      eventType="$OPTARG" >&2
      ;;
    d)
      eventDateTime="$OPTARG" >&2
      if [ "$eventDateTime" = "now" ] ; then
        eventDateTime=`date "+%Y-%m-%dT%H:%M:%S"`
      fi
      ;;
    D)
      eventDetail="$OPTARG" >&2
      ;;
    E)
      eventOutcome="$OPTARG" >&2
      ;;
    N)
      eventOutcomeDetailNote="$OPTARG" >&2
      ;;
    l)
      linkingAgentIdentifierType="$OPTARG" >&2
      ;;
    L)
      linkingAgentIdentifierValue="$OPTARG" >&2
      ;;
    r)
      linkingAgentRole="$OPTARG" >&2
      ;;
    s)
      sourceLinkingObjectIdentifierType="$OPTARG" >&2
      ;;
    S)
      sourceLinkingObjectIdentifierValue="$OPTARG" >&2
      ;;
    o)
      outcomeLinkingObjectIdentifierType="$OPTARG" >&2
      ;;
    O)
      outcomeLinkingObjectIdentifierValue="$OPTARG" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

xml ed -L -N P="info:lc/xmlns/premis-v2" \
    -a "(/P:premis/P:event|P:object)[last()]" -t elem -n "event" -v "" \
    -s "/P:premis/event[last()]" -t elem -n "eventIdentifier" -v "" \
    -s "/P:premis/event[last()]/eventIdentifier[last()]" -t elem -n "eventIdentifierType" -v "$eventIdentifierType" \
    -s "/P:premis/event[last()]/eventIdentifier[last()]" -t elem -n "eventIdentifierValue" -v "$eventIdentifierValue" \
    -s "/P:premis/event[last()]" -t elem -n "eventType" -v "$eventType" \
    -s "/P:premis/event[last()]" -t elem -n "eventDateTime" -v "$eventDateTime" \
    -s "/P:premis/event[last()]" -t elem -n "eventDetail" -v "$eventDetail" \
    -s "/P:premis/event[last()]" -t elem -n "eventOutcomeInformation" -v "" \
    -s "/P:premis/event[last()]/eventOutcomeInformation[last()]" -t elem -n "eventOutcome" -v "$eventOutcome" \
    -s "/P:premis/event[last()]/eventOutcomeInformation[last()]" -t elem -n "eventOutcomeDetail" -v "" \
    -s "/P:premis/event[last()]/eventOutcomeInformation[last()]/eventOutcomeDetail[last()]" -t elem -n "eventOutcomeDetailNote" -v "$eventOutcomeDetailNote" \
    -s "/P:premis/event[last()]" -t elem -n "linkingAgentIdentifier" -v "" \
    -s "/P:premis/event[last()]/linkingAgentIdentifier[last()]" -t elem -n "linkingAgentIdentifierType" -v "$linkingAgentIdentifierType" \
    -s "/P:premis/event[last()]/linkingAgentIdentifier[last()]" -t elem -n "linkingAgentIdentifierValue" -v "$linkingAgentIdentifierValue" \
    -s "/P:premis/event[last()]/linkingAgentIdentifier[last()]" -t elem -n "linkingAgentRole" -v "$linkingAgentRole" \
    -s "/P:premis/event[last()]" -t elem -n "linkingObjectIdentifier" -v "" \
    -s "/P:premis/event[last()]/linkingObjectIdentifier[last()]" -t elem -n "linkingObjectIdentifierType" -v "$sourceLinkingObjectIdentifierType" \
    -s "/P:premis/event[last()]/linkingObjectIdentifier[last()]" -t elem -n "linkingObjectIdentifierValue" -v "$sourceLinkingObjectIdentifierValue" \
    -s "/P:premis/event[last()]/linkingObjectIdentifier[last()]" -t elem -n "linkingObjectRole" -v "source" \
    -s "/P:premis/event[last()]" -t elem -n "linkingObjectIdentifier" -v "" \
    -s "/P:premis/event[last()]/linkingObjectIdentifier[last()]" -t elem -n "linkingObjectIdentifierType" -v "$outcomeLinkingObjectIdentifierType" \
    -s "/P:premis/event[last()]/linkingObjectIdentifier[last()]" -t elem -n "linkingObjectIdentifierValue" -v "$outcomeLinkingObjectIdentifierValue" \
    -s "/P:premis/event[last()]/linkingObjectIdentifier[last()]" -t elem -n "linkingObjectRole" -v "outcome" \
    "$xmlfile"
