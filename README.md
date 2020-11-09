# Pay-as-you-go (paug-workload-dashboard) dashboarding framework for workload specific compute usage monitoring using open source technologies 
#
#
# Business requirement(s)
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
# Case presented
- Capturing excess memory usage over user defined threshold for HANA workload
- Dashboard for monitoring, metering & billing excess memory usage for user defined interval
#
#
# Technology Stack
### At each LPAR hosting HANA DB
- SAP HANA Instance
- /bin/bash
- SUSE Linux Enterprise Server 15 (ppc64le)
- [nmeasure_linux_ppc64le](https://sourceforge.net/projects/nmon/files/nmeasure_linux_v3.zip/download): Thanks to [Nigel Griffiths](https://www.linkedin.com/in/nigelargriffiths/) for creating this helpful utility for pushing data into InfluxDB and it works like a charm !
#
#
### At central dashboard hosting server
- OS: RHELRed Hat Enterprise Linux 7.7 (Maipo)
- InfluxDB version: 1.7.7
- Grafana: v6.2.5
Grafana dashboard can be downloaded from [paug-workload-dashboard-ramstat](https://grafana.com/grafana/dashboards/13366)
