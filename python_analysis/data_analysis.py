import pandas as pd
import os

# Define relative file paths
base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
input_file = os.path.join(base_dir, 'csv_files', 'python_clean.csv')

# Read the cleaned data
df = pd.read_csv(input_file)

# 1. Order-Based Analysis
print("1. Order-Based Analysis")
order_totals = df.groupby('order_id')['base_total_price'].sum().reset_index()
order_totals = order_totals.sort_values(by='base_total_price', ascending=False)
print(order_totals.head(10))   # Highest orders

# 2. Country-Based Analysis
print("\n2. Country-Based Analysis")
country_analysis = df.groupby('country').agg({
    'base_total_price': 'sum', # Total revenue
    'order_id': 'nunique'       # Number of orders
}).rename(columns={'base_total_price': 'total_revenue', 'order_id': 'total_orders'}).reset_index()
country_analysis['revenue_percentage'] = (country_analysis['total_revenue'] / country_analysis['total_revenue'].sum()) * 100
country_analysis = country_analysis.sort_values(by='total_revenue', ascending=False)
print(country_analysis.head(10))  # Countries with the highest sales

# 3. Time-Based Analysis
print("\n3. Time-Based Analysis")
df['order_date'] = pd.to_datetime(df['order_date'])
df['order_month'] = df['order_date'].dt.to_period('M')  # Group by month

monthly_revenue = df.groupby('order_month')['base_total_price'].sum().reset_index()
print(monthly_revenue.head(10))  # Monthly total sales

# 4. Product-Based Analysis
print("\n4. Product-Based Analysis")
product_sales = df.groupby('product_name')['quantity'].sum().reset_index()
product_sales = product_sales.sort_values(by='quantity', ascending=False)
print(product_sales.head(10))  # Best-selling products

# 5. Statistical Analysis
print("\n5. Basic Statistical Analysis")

# Basic statistics
print("\nOrder Amount Statistics:")
print(df['base_total_price'].describe())

# Shipment duration statistics
if 'shipment_duration' in df.columns:
    print("\nShipment Duration Statistics:")
    print(df['shipment_duration'].describe())

# Customers with the highest orders
print("\nTop Customers by Total Orders:")
top_customers = df.groupby('customer_id')['base_total_price'].sum().reset_index()
top_customers = top_customers.sort_values(by='base_total_price', ascending=False)
print(top_customers.head(10))

# Percentage distribution of total revenue by country
print("\nRevenue Percentage by Country:")
print(country_analysis[['country', 'revenue_percentage']].head(10))
