# Singapore HDB Resale Flat Price

# Introduction
Diving into public housing market in Singapore. This project explores high-value estates, high demand region, and where the high demands meeting the flat type and builds a simple end to end workflow:

**CSV dataset → Dockerized Postgres → SQL ingestion → Figma UI → PowerBI dashboard insights.**

# Background 
The purpose behind this project was driven to strengthen my SQL fundamentals, database skills, Figma UI design and PowerBI, while also exploring about data engineering and gaining a deeper understanding of Singare public housing resale market. 

The data for this project is from Singapore Government public portal [HDB Resale Price](https://data.gov.sg/collections/189/view)

Questions behind the data analysis through my project were:
1. Price trend (1990-2025):
How the median resale price have changed over time, and which time periods show the biggest jumps and dips when comparing against 12 month moving average?

2. Town price differences:
Which towns having the highest and lowest average resale price consistently, and how does that rank change when filtering by flat type and remaining lease years?

3. Transaction mix by flat model: 
Which flat models make up most of the transactions, and does a shift in flat model mix relate to changes in the overall median resale price or YoY median %?

# Tools I Used
- **Docker:** Containerized PostgreSQL + pgadmin
- **PostgreSQL:** Data storage + SQL queries 
- **pgAdmin:** DB management + query execution 
- **PowerBI:** Dashboard + DAX measures
- **Figma:** UI/UX refinement for dashboard layout
- **VSCode:** version control and README maintenance 

# Process
## 1. Create Docker + PostgresSQL
Running a local PostgreSQL database using Docker, together with pgAdmin so that when the container is up, I will be able to do SQL ingestion of the CSV into Postgres 

**1. Docker Configuration**
From the project roots (C:\Users\bings\sg-resaleflatprice\SGP-HDB-Resale-FlatPrice), run:

![alt text](docker.png)
*Fig 1. Docker interface*

![alt text](docker1-1.png)
*Fig 1.1 Docker CLI status*

![alt text](docker10.png)
*Fig 1.2 Docker Version*

**2. Postgres Database**
Connecting docker container to pgAdmin on local desktop. 
![alt text](pgdb1.png)
*Fig 2. pgAdmin Connection Interface 

Checking the version that Postgres DB is connected to the container properly. 
![alt text](postgres15.png)
*Fig 2.1. Database Version 

## 2. SQL Data Ingestion

