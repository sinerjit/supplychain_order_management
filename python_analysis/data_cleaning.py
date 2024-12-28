import pandas as pd
import re 
import os
import sys


# Create paths to access the csv_files directory from the project root directory
base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))  # Move up one directory
input_file = os.path.join(base_dir, 'csv_files', 'order_analysis.csv')
output_file = os.path.join(base_dir, 'csv_files', 'python_clean.csv')

# If the output file already exists, stop the program
if os.path.exists(output_file):
    print(f"'{output_file}' already exists. 'data_cleaning.py' will not work.")
    sys.exit() # Terminates the program

print("File does not exist, starting data cleanup...")

# Read the CSV file
df = pd.read_csv(input_file)


# Function to clean phone numbers
def clean_phone_number(phone):
    if pd.isnull(phone):  # If the number is missing
        return None
    # Convert the phone number to a string and retain only digits
    cleaned = re.sub(r'\D', '', str(phone))
    return cleaned

# Function to add country codes based on the country
def add_country_code(row):
    country_code_map = {
    'Germany': '+49',
    'Brazil': '+55',
    'Austria': '+43',
    'Denmark': '+45',
    'USA': '+1',
    'Canada': '+1',
    'Ireland': '+353',
    'Sweden': '+46',
    'Switzerland': '+41',
    'UK': '+44',
    'Mexico': '+52',
    'France': '+33',
    'Belgium': '+32',
    'Venezuela': '+58',
    'Spain': '+34',
    'Norway': '+47',
    'Italy': '+39',
    'Finland': '+358',
    'Portugal': '+351',
    'Argentina': '+54',
    'Poland': '+48'
}
    country_code = country_code_map.get(row['country'], '')   # Get the country code
    if row['phone']:  # If there is a phone number, add the country code
        return f"{country_code} {row['phone']}"
    return None

# Clean phone numbers
df['phone'] = df['phone'].apply(clean_phone_number)

# Add country codes
df['phone_with_country_code'] = df.apply(add_country_code, axis=1)

# Print results
print(df[['phone', 'phone_with_country_code']])


# Missing date calculation
df['order_date'] = pd.to_datetime(df['order_date'], errors= 'coerce')
df['shipped_date'] = pd.to_datetime(df['shipped_date'], errors= 'coerce')

df['shipment_duration'] = (df['shipped_date']  - df['order_date']).dt.days

avg_shipment_duration = df.groupby('country')['shipment_duration'].mean().round().astype('Int64')

print("Average shipping times by country: ")
print(avg_shipment_duration)

def fill_shipped_date(row):
    if pd.isnull(row['shipped_date']): 
        avg_duration = avg_shipment_duration.get(row['country'], 0)
        if pd.notnull(row['order_date']) and avg_duration > 0:
            return row['order_date'] + pd.to_timedelta(avg_duration, unit='days')
    return row['shipped_date']
    
df['shipped_date'] = df.apply(fill_shipped_date, axis= 1)

print("Remaining missing shipped_date values:", df['shipped_date'].isnull().sum())

# print(df['shipped_date'])

print(df[['order_date', 'shipped_date', 'country']].head(27))

df.to_csv(output_file, index=False)
print(f"Cleaned Data Saved as '{output_file}'")
