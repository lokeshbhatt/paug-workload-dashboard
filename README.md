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
1. Data Generation: At end point using custom created collector script
2. Data Ingestion: Ingesting end point data into centrally hosted time-series database (influxDB)
3. Data Visualization: Visualizing ingested data points using centrally hosted Grafana dashboars
![Alt text](https://github.com/lokeshbhatt/shana/blob/main/SHANA%20-%20Technical%20Framework.JPG "SHANA - Technical Framework")


Grafana dashboard can be downloaded from [paug-workload-dashboard-ramstat](https://grafana.com/grafana/dashboards/13366)
