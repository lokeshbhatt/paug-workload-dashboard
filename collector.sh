#!/bin/bash
#set -x
#
#   collector.sh
#   Developer: Lokesh Bhatt
#   (C) Copyright 2020 Lokesh Bhatt
#
#	- Collects memory utilization statistics for specified HANA database.
#	- Calcualtes memory utilization in excess to user defined limit.
#	- Pushes data points into remotely hosted influxDB
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
HANACommittedPercentage=40

days=$1
duration=$2
if [ "X$duration" = X ]
then
        duration=10
fi

if [ X$days = X ]
then
        echo "Usage: $0 <no_of_days_output_to_be_captured> <duration_in_seconds>"
        exit 1
fi

export days
tot_tim=`expr 60 \* 24`
export tot_time
(
days_iterator=0
hostname=`uname -n`
while [ $days_iterator -lt $days ]
do
        current_time=`date +%H%M`
        current_date=`date +%y%m%d`
        hr=`date +%H`
        min=`date +%M`
        hr=`expr $hr \* 60`
        tim_passed=`expr $hr \+ $min`
        time_left=`expr $tot_tim \- $tim_passed`
        time_left_sec=`expr $time_left \* 60`
        total_itr=`expr $time_left_sec \/ $duration`
        seconds_iterator=0
        while [ $seconds_iterator -lt $total_itr ]
        do
                /usr/sbin/lparstat -i > lparstat.i
		Installed=`cat lparstat.i|grep "Desired Memory                               : " | awk -F ":" '{print $2}' | tr -d " "`
				
		FreeCMD=`free --mebi | head -2 | tail -1 | awk -F " " 'BEGIN{OFS=","} {print $2,$3,$4,$6}'`
		OSTotal=`echo $FreeCMD | awk -F"," '{print $1}'`
		OSUsed=`echo $FreeCMD | awk -F"," '{print $2}'`
		OSFree=`echo $FreeCMD | awk -F"," '{print $3}'`
		OSCache=`echo $FreeCMD | awk -F"," '{print $4}'`

        ######### START: HANA RAM USAGE ###############
        HANARamUsage=`/usr/sap/D29/HDB00/exe/hdbsql -n localhost -i 00 -U ASDghj4567cvbn 'select HOST, round(INSTANCE_TOTAL_MEMORY_USED_SIZE/(1024*1024), 2) as "Used Memory MB" from M_HOST_RESOURCE_UTILIZATION;'|head -2 | tail -1 | awk -F"," '{print $2}'`
		HANARamUsage=`echo "$HANARamUsage/1" | bc`
		HANACommitted=`echo "($Installed*$HANACommittedPercentage)/110" | bc`
		if [ $HANARamUsage -gt $HANACommitted ]; then
			let HANAExcess=$HANARamUsage-$HANACommitted;
		else
			HANAExcess=0;
		fi
		########## END: HANA RAM USAGE ################
								
		TS=`date '+%s%N'`
				
		echo `date`": {installed=$Installed,ostotal=$OSTotal,osused=$OSUsed,osfree=$OSFree,oscache=$OSCache,hanacommitted=$HANACommitted,hanaramusage=$HANARamUsage,hanaexcess=$HANAExcess,ts=$TS}" >> /home/lokesh/shana/$hostname"_"$current_date"_"$current_time".ramstat"
				
		/home/lokesh/bin/nmeasure -g ramusage -G installed=$Installed,ostotal=$OSTotal,osused=$OSUsed,osfree=$OSFree,oscache=$OSCache,hanacommitted=$HANACommitted,hanaramusage=$HANARamUsage,hanaexcess=$HANAExcess,ts=$TS -i influx -p 8086 -x testdb

                seconds_iterator=`expr $seconds_iterator \+ 1`
                sleep $duration
        done
        days_iterator=`expr $days_iterator \+ 1`
        sleep 10
done
)&
