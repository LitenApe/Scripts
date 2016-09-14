#!/bin/bash
declare -i usage=1
declare -i direction=0

forskningsparken=3010370
majorstuen=3010200
ensjo=3011430

destination=3010370
destName='Forskningsparken'

for arg in $@ ; do
  if [[ $arg == '-f' ]]; then
    destination=3010370
  elif [[ $arg == '-m' ]]; then
    destination=3010200
    destName='Majorstuen'
  elif [[ $arg == '-e' ]]; then
    destination=3011430
    destName='Ensjo'
  elif [[ $arg == '--E' ]]; then
    direction=1
  elif [[ $arg == '--W' ]]; then
    direction=2
  else
    usage=0
    echo 'Error: command not found:'
    printf 'usage:\n  --E : Avganger vestover\n'
    printf '  --W : Avganger ostover\n'
    printf '  -f : Avganger fra forskningsparken\n'
    printf '  -m : Avganger fra majorstuen\n'
    printf '  -e : Avganger fra ensjo\n\n'
    echo 'or run ./subway.sh without any parameters for all departures from forskningsparken'
    break
  fi
done


declare info=$(curl -H "Accept: text/xml" http://reisapi.ruter.no/StopVisit/GetDepartures/$destination?transporttypes=metro)
clear
echo 'Avganger fra' $destName
for(( iterator = 0; iterator < 6 && usage == 1; iterator++)); do
  info=${info#*</MonitoredStopVisit>}

  chunk=${info#*<MonitoredStopVisit>}
  chunk=${chunk%%</MonitoredStopVisit>*}

  destination=${chunk#*<DestinationDisplay>}
  destination=${destination%%</DestinationDisplay>*}

  arrival=${chunk#*<AimedArrivalTime>}
  arrival=${arrival%%</AimedArrivalTime>*}
  arrival=${arrival:11:5}
  #arrival=${arrival#*T} ; arrival=${arrival%%+*}
  #timed=`echo $arrival | cut -d ':' -f 1,2`

  platform=${chunk#*<DeparturePlatformName>}
  platform=${platform#*\(}
  platform=${platform%%\)*}

  linje=${chunk#*<LineRef>}
  linje=${linje%%</LineRef>*}

  if [[ $direction == 0 ]]; then
    printf "%-45s" "$arrival - $linje $destination"
    printf "$platform\n"
  else
    platform=${chunk#*<DeparturePlatformName>}
    platform=${platform%% \(*}
    if [[ $platform == $direction ]]; then
      echo "$arrival - $linje $destination"
    fi
  fi

  if [[ $iterator -ge 5 ]]; then
    sleep 5
    info=$(curl -s -H "Accept: text/xml" http://reisapi.ruter.no/StopVisit/GetDepartures/$forskningsparken?transporttypes=metro)
    clear
    iterator=-1
    echo 'Avganger fra' $destName
  fi
done
