# Pay-as-you-go (paug-workload-dashboard) dashboarding framework for workload specific compute usage monitoring using open source technologies 
#
#
# Requirement
1. Compute resource consumption monitoring & metering for pay-as-you-go model.
2. Resource consumption to be measured at workload level and not at operating systems level.
3. Capability to capture excess resource consumption at user defined interval.
4. Capability to show excess workload specific capacity usage for user specified/selected time period
#
#
# Technical Framework
Proposed frame work is primarily comprises of 3 stages,
1. Data Generation: Generated at end points / hosts, using custom created collector script(s).
2. Data Ingestion: Ingesting data generated at end point into centrally hosted time-series database (influxDB).
3. Data Visualization: Visualizing ingested data points using centrally hosted Grafana dashboars.
![Alt text](https://github.com/lokeshbhatt/shana/blob/main/SHANA%20-%20Technical%20Framework.JPG "SHANA - Technical Framework")
#
#
# Demonstrated use case
- Capturing excess memory usage over and above user defined threshold for HANA workload
- Dashboard for monitoring, metering & billing excess memory usage at user defined interval
#
#
# Technology Stack
### At each LPAR hosting HANA DB
- SAP HANA Instance
- /bin/bash
- SUSE Linux Enterprise Server 15 (ppc64le)
- [nmeasure_linux_ppc64le](https://sourceforge.net/projects/nmon/files/nmeasure_linux_v3.zip/download): Thanks to [Nigel Griffiths](https://www.linkedin.com/in/nigelargriffiths/) for creating this helpful utility for pushing data into InfluxDB and it works like a charm !
#
### At central dashboard hosting server
- OS: RHELRed Hat Enterprise Linux 7.7 (Maipo)
- InfluxDB version: 1.7.7
- Grafana: v6.2.5
#
#
# Terminologies
- architecture: systems architecture details (x86, ppc64le etc.)
- mtm: machine type model of physical server
- serial_no: serial no of physical server
- host: hostnam
- os: operating system of host
- oscache: operating system file cache
- osfree: unused memory (MemFree and SwapFree in /proc/meminfo)
- ostotal: total installed memory
- osused: used memory (calculated as total - free - buffers - cache)
- hanacommitted: comitted memory usage for hana workload
- hanaexcesss: excess ram usage by hana workload
- hanaramusage: total ram usage by hana workload
#
#
# Step-1: Setting up centrally hosted influxDB
- Refer [this useful post](https://www.power-devops.com/post/influxdb-on-ibm-power-systems) for installing InfluxDB on IBM Power server systems
OR
- Refer [InfluxDB portal](https://docs.influxdata.com/influxdb/v1.8/introduction/install/) for installing InfluxDB on x86 server systems
- Login to newly installed influxDB  [command: "influx"]
- Create a new database named testdb [command: "create database testdb"]
#
#
# Step-2: Setting up end point "data collection" & "ingestion" to influxDB
- Complete [HANA & OS user setup for compute monitoring](https://github.com/lokeshbhatt/paug-workload-dashboard/blob/main/UserSetup.md) at each LPAR hosting HANA DB
- Download collector script, [collector.sh](https://github.com/lokeshbhatt/paug-workload-dashboard/blob/main/collector.sh)
- Download [nmeasure_linux_ppc64le](https://sourceforge.net/projects/nmon/files/nmeasure_linux_v3.zip/download) to USER1 home directory
- Assign executable permission to both [chmod u+x collector.sh nmeasure_linux_ppc64le]
- Move "nmeasure_linux_ppc64le" as "nmeasure" to bin in your PATH [command: mv measure_linux_ppc64le /home/USER1/bin/nmeasure]
- Make crontab entry with "crontab -e" command [crontab entry: 00 00 * * * /home/USER1/collector.sh 1 60 > /home/USER1/collector.log 2>&1]
#
#
### Post completing step-1 & step-2, it would start populating data into InfluxDB and we are ready setting up data visualization 
#
#
# Step-3: Setting up "data visualization"
- Refer [this useful post](https://www.power-devops.com/post/installing-grafana-on-ibm-power-systems) for installing Grafana on IBM Power server systems
OR
- Refer [Grafana portal](https://grafana.com/docs/grafana/latest/installation/) for installing Grafana on x86 server systems
- Login to Grafana [http://<Grafana_Server_IP>:3000/]
- Import Grafana dashboard for [paug-workload-dashboard-ramstat](https://grafana.com/grafana/dashboards/13366) using [steps listed here](https://grafana.com/docs/grafana/latest/dashboards/export-import/)
#
#
References
- [SAP HANA Memory Usage Explained](https://www.sap.com/documents/2016/08/205c8299-867c-0010-82c7-eda71af511fa.html)
- [M_HOST_RESOURCE_UTILIZATION Table](https://help.sap.com/viewer/4fe29514fd584807ac9f2a04f6754767/2.0.03/en-US/20b12419751910148afa9303eec370a0.html)
- Grafana dashboard for [paug-workload-dashboard-ramstat](https://grafana.com/grafana/dashboards/13366)
