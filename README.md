
# **Supply Chain and Order Management Analysis**

## **Overview**
This repository showcases a comprehensive data analysis project that spans data cleaning, exploration, and visualization. The project leverages SQL, Python, Excel, and Power BI to analyze and generate insights from the **Northwind database**, a sample dataset simulating supply chain and order management processes.

---

## **Project Structure**
The project is organized as follows:

```
supplychain_and_order_management/
├── excel_analysis/         # Contains Excel files and pivot table analysis (to be added)
├── powerbi_dashboard/      # Power BI dashboards and reports (to be added)
├── python_analysis/        # Python scripts for data analysis and cleaning
│   ├── config.py           # File paths configuration
│   ├── data_analysis.py    # Python script for exploratory data analysis
│   ├── data_cleaning.py    # Python script for cleaning CSV data
│   ├── data_check.ipynb    # Jupyter Notebook for quick data checks
│   ├── requirements.txt    # Required Python packages
├── sql_analysis/           # SQL scripts for data exploration and business insights
│   ├── sql_queries.sql     # Foundational SQL queries
│   ├── sql_analysis.sql    # Advanced SQL analysis
│   ├── northwind.sql       # Northwind database schema
│   ├── csv_sql.sql         # SQL queries for exporting data to CSV
└── .gitignore              # Specifies files and folders excluded from GitHub
```

---

## **Key Features**

### **SQL Analysis**
- **Files:** Located in the `sql_analysis/` directory.
- **Skills Demonstrated:**
  - Database schema exploration (`sql_queries.sql`).
  - Advanced business insights and revenue analysis (`sql_analysis.sql`).
  - Use of Common Table Expressions (CTEs), window functions, and joins.
  - Exporting data to CSV for further analysis.

### **Python Analysis**
- **Files:** Located in the `python_analysis/` directory.
- **Scripts:**
  - `data_cleaning.py`: Cleans raw CSV data for analysis.
  - `data_analysis.py`: Performs exploratory data analysis, including order, product, and country-based insights.
  - `data_check.ipynb`: Jupyter Notebook for quick data inspection.
- **Capabilities:**
  - Data cleaning and transformation.
  - Exploratory analysis using Pandas.
  - Generating insights to inform further visualization.

### **Excel and Power BI Analysis** *(Planned)*
- Pivot tables and charts in Excel to explore sales trends and revenue distribution.
- Interactive dashboards in Power BI to present KPIs and actionable insights.

---

## **Next Steps**
- **Excel:** Analyze data using pivot tables and advanced Excel features.
- **Power BI:** Create interactive dashboards and share visual insights.
- **Documentation:** Update README with links to completed dashboards and analyses.

---

## **How to Run**

### **Prerequisites**
- **Database:** Install the Northwind database in your PostgreSQL environment.
- **Python:** Install required packages using the `requirements.txt` file:
  ```bash
  pip install -r requirements.txt
  ```

### **Steps**
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/supplychain_and_order_management.git
   ```
2. Set up the Northwind database.
3. Run SQL queries using a PostgreSQL client.
4. Execute Python scripts for data cleaning and analysis:
   ```bash
   python python_analysis/data_cleaning.py
   python python_analysis/data_analysis.py
   ```
5. Analyze exported data in Excel or Power BI.

---

## **About the Northwind Database**
The Northwind database is a widely used sample dataset designed for educational purposes. It simulates a real-world business environment with tables such as:
- **Customers:** Customer details.
- **Orders:** Order transactions.
- **Products:** Product catalog and inventory.
- **Order_Details:** Line items and order-specific details.

---
