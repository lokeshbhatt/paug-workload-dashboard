# Steps for enabling operating system level user's read only access to M_HOST_RESOURCE_UTILIZATION System View
#
### Special thanks to [Sanjeev Kumar](https://www.linkedin.com/in/sanjeev-kumar-5328a723/) for HANA DB expertise contribution.
#
### 1. Create an OS user "USER1" [via Suse yast]
### 2. Assign saspsys GID to USER1 [via Suse yast]
### 3. Create a HANA DB level user "USER2" [via HANA Studio]
### 4. Give USER2 read only access to "M_HOST_RESOURCE_UTILIZATION" [via HANA Studio]
### 5. Login via OS user "USER1"
### 6. Create HDBUSERSTORE key for HANA DB user (USER2)
      Example: /usr/sap/D29/HDB00/exe/hdbuserstore -i set ASDj4567cvbn localhost:30015 USER2 USER2_PASSWD
      Whereas,
              D29: Instance Name
              HDB00: Instance Number
              ASDj4567cvbn: Any complex key combination of your choice
              30015: Port Number
              USER2: HANA DB user name
              USER2_PASSWD: HANA DB user password
      Expected output: You should see a new directory named ".hdb" in home directory
            > ls -lRt .hdb
            .hdb:
           total 0
            drwx------ 1 lokesh users 68 Oct 30 03:09 p52n33

            .hdb/p52n33:
            total 192
            -rw-r----- 1 lokesh users   871 Oct 16 13:04 SSFS_HDB.DAT
            -rw-r----- 1 lokesh users    92 Oct 16 13:04 SSFS_HDB.KEY
            -rw------- 1 lokesh users 26656 Oct 16 12:50 SQLDBC.shm
 
### 7. Testing
      /usr/sap/D29/HDB00/exe/hdbsql -n localhost -i 00 -U ASDj4567cvbn 'select HOST,INSTANCE_TOTAL_MEMORY_USED_SIZE as "Used Memory" from M_HOST_RESOURCE_UTILIZATION;'|head -2
      Expected output:
            HOST,Used Memory
            "hostname",61953674311


References
1. [Creating the SAP HANA HDBUSERSTORE Key](https://documentation.commvault.com/commvault/v11/article?p=22335.htm)
2. [M_HOST_RESOURCE_UTILIZATION Table](https://help.sap.com/viewer/4fe29514fd584807ac9f2a04f6754767/2.0.03/en-US/20b12419751910148afa9303eec370a0.html)
