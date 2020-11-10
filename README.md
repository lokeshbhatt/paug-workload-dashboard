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
# Terminolgies
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
- To download and install influxDB on IBM POWER servers (ppc64le) you are 
- Here is a [useful post](https://www.power-devops.com/post/influxdb-on-ibm-power-systems) for installing InfluxDB on IBM Power Systems
#
# Step-2: Setting up end point "data collection" & "ingestion" to influxDB
1. Complete [HANA & OS user setup for compute monitoring](https://github.com/lokeshbhatt/shana/blob/main/UserSetup.md) at each LPAR hosting HANA DB
2. Copy "collector.sh" & "nmeasure_linux_ppc64le" to USER1 home directory
3. Assign executable permission to both [chmod u+x collector.sh nmeasure_linux_ppc64le]
4. Move "nmeasure_linux_ppc64le" as "nmeasure" to bin in your PATH [mv measure_linux_ppc64le /home/USER1/bin/nmeasure]
5. Make following crontab entry with "crontab -e" command [00 00 * * * /home/lokesh/collector.sh 1 60 > /home/lokesh/collector.log 2>&1]
#
#
# Step-3: Setting up "data visualization"
#
#
References
1. [SAP HANA Memory Usage Explained](https://www.sap.com/documents/2016/08/205c8299-867c-0010-82c7-eda71af511fa.html)
2. Grafana dashboard for [paug-workload-dashboard-ramstat](https://grafana.com/grafana/dashboards/13366)
