#!/bin/bash
while getopts ":x:i:I:n:T:N:l:L:" opt; do
  case $opt in
    x)
      xmlfile="$OPTARG"
      ;;
    i)
      agentIdentifierType="$OPTARG" >&2
      ;;
    I)
      agentIdentifierValue="$OPTARG" >&2
      ;;
    n)
      agentName="$OPTARG" >&2
      ;;
    T)
      agentType="$OPTARG" >&2
      ;;
    N)
      agentNote="$OPTARG" >&2
      ;;
    l)
      linkingEventIdentifierType="$OPTARG" >&2
      ;;
    L)
      linkingEventIdentifierValue="$OPTARG" >&2
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
    -a "(/P:premis/P:agent|P:event)[last()]" -t elem -n "agent" -v "" \
    -s "/P:premis/agent[last()]" -t elem -n "agentIdentifier" -v "" \
    -s "/P:premis/agent[last()]/agentIdentifier[last()]" -t elem -n "agentIdentifierType" -v "$agentIdentifierType" \
    -s "/P:premis/agent[last()]/agentIdentifier[last()]" -t elem -n "agentIdentifierValue" -v "$agentIdentifierValue" \
    -s "/P:premis/agent[last()]" -t elem -n "agentName" -v "$agentName" \
    -s "/P:premis/agent[last()]" -t elem -n "agentType" -v "$agentType" \
    -s "/P:premis/agent[last()]" -t elem -n "agentNote" -v "$agentNote" \
    -s "/P:premis/agent[last()]" -t elem -n "linkingEventIdentifier" -v "" \
    -s "/P:premis/agent[last()]/linkingEventIdentifier[last()]" -t elem -n "linkingEventIdentifierType" -v "$linkingEventIdentifierType" \
    -s "/P:premis/agent[last()]/linkingEventIdentifier[last()]" -t elem -n "linkingEventIdentifierValue" -v "$linkingEventIdentifierValue" \
    "$xmlfile"
