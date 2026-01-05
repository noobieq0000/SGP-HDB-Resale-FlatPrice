# SGP-HDB-Resale-FlatPrice

# Introduction
Diving into public housing market in Singapore. This project explores high-value estates, high demand region, and where the high demands meeting the flat type and builds a simple end to end workflow:

**CSV dataset → Dockerized Postgres → SQL ingestion → Figma UI → PowerBI dashboard insights.**

# Background 
The purpose behind this project was driven to strengthen my SQL fundamentals, database skills, Figma UI design and PowerBI, while also exploring about data engineering and gaining a deeper understanding of Singare public housing resale market. 

The data for this project is from Singapore Government public portal [HDB Resale Price](https://data.gov.sg/datasets?topics=housing&resultId=189)

Questions behind the data analysis through my project were:
1. Price trend (1990-2025):
How the median resale price have changed over time, and which time periods show the biggest jumps and dips when comparing against 12 month moving average?

2. Town price differences:
Which towns having the highest and lowest average resale price consistently, and how does that rank change when filtering by flat type and remaining lease years?

3. Transaction mix by flat model: 
Which flat models make up most of the transactions, and does a shift in flat model mix relate to changes in the overall median resale price or YoY median %?

## Tools I Used
- **Docker:** containerized PostgreSQL + pgadmin
- **PostgreSQL:** data storage + SQL queries 
- **pgAdmin:** DB management + query execution 
- **PowerBI:** dashboard + DAX measures
- **Figma:** UI improvement for dashboard
- **VSCode:** uploading of file and updating README

