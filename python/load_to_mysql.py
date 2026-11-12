import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

user = os.getenv("DB_USER")
password = os.getenv("DB_PASSWORD")
host = os.getenv("DB_HOST")
port = os.getenv("DB_PORT")
database = os.getenv("DB_NAME")

# Validate database configuration
if not all([user, password, host, port, database]):
    raise ValueError("Missing database configuration in the .env file")

# Create MySQL connection
engine = create_engine(
    f"mysql+pymysql://{user}:{password}@{host}:{port}/{database}"
)

# Define project directory
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Define CSV file paths
customers_path = os.path.join(BASE_DIR, "data", "olist_customers_dataset.csv")
orders_path = os.path.join(BASE_DIR, "data", "olist_orders_dataset.csv")
payments_path = os.path.join(BASE_DIR, "data", "olist_order_payments_dataset.csv")

# Check that all input files exist
for path in [customers_path, orders_path, payments_path]:
    if not os.path.exists(path):
        raise FileNotFoundError(f"File not found: {path}")

# Load CSV files
customers = pd.read_csv(customers_path)
orders = pd.read_csv(orders_path)
payments = pd.read_csv(payments_path)

# Convert date columns to datetime
date_columns = [
    'order_purchase_timestamp',
    'order_approved_at',
    'order_delivered_carrier_date',
    'order_delivered_customer_date',
    'order_estimated_delivery_date'
]

for col in date_columns:
    orders[col] = pd.to_datetime(orders[col])

# Load data into MySQL
customers.to_sql("customers", con=engine, if_exists="replace", index=False)
orders.to_sql("orders", con=engine, if_exists="replace", index=False)
payments.to_sql("order_payments", con=engine, if_exists="replace", index=False)

# Display loading summary
print("Data loading completed successfully")
print(f"Customers loaded: {len(customers):,}")
print(f"Orders loaded: {len(orders):,}")
print(f"Payments loaded: {len(payments):,}")
