#!/usr/bin/env python3
"""
Script to generate realistic synthetic data for Business Intelligence analysis
Generates data for tables: Customers, Products, Stores, Orders, OrderItems
"""

from faker import Faker
import pandas as pd
import random
from datetime import datetime, timedelta
import uuid

# Configure Faker with English localization
fake = Faker(['en_US'])
Faker.seed(42)  # For reproducibility
random.seed(42)

# Data generation configuration
NUM_CUSTOMERS = 1000
NUM_PRODUCTS = 200
NUM_STORES = 25
NUM_ORDERS = 2500
MAX_ITEMS_PER_ORDER = 8


def generate_customers():
    """Generate synthetic data for Customers table"""
    print("Generating customer data...")

    customers = []
    for i in range(1, NUM_CUSTOMERS + 1):
        customer = {
            'CustomerID': i,
            'Name': fake.name(),
            'Email': fake.email(),
            'JoinDate': fake.date_between(start_date='-3y', end_date='today')
        }
        customers.append(customer)

    df = pd.DataFrame(customers)
    df.to_csv('customers.csv', index=False, encoding='utf-8')
    print(f"✓ File 'customers.csv' created with {len(customers)} records")
    return df


def generate_products():
    """Generate synthetic data for Products table"""
    print("Generating product data...")

    # Realistic product categories
    categories = [
        'Electronics', 'Clothing & Fashion', 'Home & Garden', 'Sports & Fitness',
        'Books & Media', 'Toys & Games', 'Beauty & Personal Care',
        'Automotive & Tools', 'Food & Beverages', 'Health & Wellness'
    ]

    # Base products by category for more realism
    product_templates = {
        'Electronics': ['Smartphone', 'Laptop', 'Tablet', 'Headphones', 'Smartwatch', 'Camera', 'TV', 'Gaming Console'],
        'Clothing & Fashion': ['T-Shirt', 'Jeans', 'Dress', 'Jacket', 'Shoes', 'Handbag', 'Watch', 'Sunglasses'],
        'Home & Garden': ['Sofa', 'Table', 'Lamp', 'Rug', 'Curtains', 'Plant Pot', 'Tools', 'Decoration'],
        'Sports & Fitness': ['Sneakers', 'Bicycle', 'Ball', 'Weights', 'Racket', 'Helmet', 'Sportswear'],
        'Books & Media': ['Novel', 'Manual', 'Magazine', 'DVD', 'Video Game', 'Audiobook', 'Comic'],
        'Toys & Games': ['Doll', 'Puzzle', 'Board Game', 'Stuffed Animal', 'LEGO', 'Kids Video Game'],
        'Beauty & Personal Care': ['Cream', 'Shampoo', 'Makeup', 'Perfume', 'Brush', 'Treatment'],
        'Automotive & Tools': ['Motor Oil', 'Tire', 'Screwdriver', 'Drill', 'Battery'],
        'Food & Beverages': ['Coffee', 'Tea', 'Snacks', 'Canned Food', 'Energy Drink', 'Supplement'],
        'Health & Wellness': ['Vitamins', 'Thermometer', 'Medicine', 'Supplement', 'Medical Equipment']
    }

    products = []
    for i in range(1, NUM_PRODUCTS + 1):
        category = random.choice(categories)
        base_product = random.choice(product_templates[category])
        brand = fake.company()
        model = fake.word().capitalize()

        product = {
            'ProductID': i,
            'ProductName': f"{brand} {base_product} {model}",
            'Category': category,
            'Price': round(random.uniform(9.99, 999.99), 2)
        }
        products.append(product)

    df = pd.DataFrame(products)
    df.to_csv('products.csv', index=False, encoding='utf-8')
    print(f"✓ File 'products.csv' created with {len(products)} records")
    return df


def generate_stores():
    """Generate synthetic data for Stores table"""
    print("Generating store data...")

    # Realistic US regions/states
    regions = [
        'California', 'Texas', 'Florida', 'New York', 'Illinois',
        'Pennsylvania', 'Ohio', 'Georgia', 'North Carolina', 'Michigan'
    ]

    # Store types for more realistic names
    store_types = ['Mall', 'Store', 'Outlet', 'Megastore', 'Plaza', 'Center']

    stores = []
    for i in range(1, NUM_STORES + 1):
        region = random.choice(regions)
        store_type = random.choice(store_types)
        name_part = fake.company_suffix()

        store = {
            'StoreID': i,
            'StoreName': f"{store_type} {name_part} {region}",
            'Region': region
        }
        stores.append(store)

    df = pd.DataFrame(stores)
    df.to_csv('stores.csv', index=False, encoding='utf-8')
    print(f"✓ File 'stores.csv' created with {len(stores)} records")
    return df


def generate_orders(customers_df, stores_df):
    """Generate synthetic data for Orders table"""
    print("Generating order data...")

    payment_methods = ['Credit Card', 'Debit Card',
                       'PayPal', 'Bank Transfer', 'Cash']

    orders = []
    for i in range(1, NUM_ORDERS + 1):
        # Order date after customer registration date
        customer_id = random.choice(customers_df['CustomerID'].tolist())
        customer_join_date = customers_df[customers_df['CustomerID']
                                          == customer_id]['JoinDate'].iloc[0]

        # Convert to datetime if string
        if isinstance(customer_join_date, str):
            customer_join_date = datetime.strptime(
                customer_join_date, '%Y-%m-%d').date()

        order_date = fake.date_between(
            start_date=customer_join_date, end_date='today')

        order = {
            'OrderID': i,
            'OrderDate': order_date,
            'CustomerID': customer_id,
            'StoreID': random.choice(stores_df['StoreID'].tolist()),
            'TotalAmount': 0,  # Will be calculated after generating OrderItems
            'PaymentMethod': random.choice(payment_methods)
        }
        orders.append(order)

    df = pd.DataFrame(orders)
    df.to_csv('orders.csv', index=False, encoding='utf-8')
    print(f"✓ File 'orders.csv' created with {len(orders)} records")
    return df


def generate_order_items(orders_df, products_df):
    """Generate synthetic data for OrderItems table and update TotalAmount in Orders"""
    print("Generating order items data...")

    order_items = []
    order_totals = {}

    for order_id in orders_df['OrderID']:
        # Random number of items per order (1 to MAX_ITEMS_PER_ORDER)
        num_items = random.randint(1, MAX_ITEMS_PER_ORDER)

        # Select unique products for this order
        selected_products = random.sample(products_df['ProductID'].tolist(),
                                          min(num_items, len(products_df)))

        order_total = 0

        for product_id in selected_products:
            # Get base price of the product
            base_price = products_df[products_df['ProductID']
                                     == product_id]['Price'].iloc[0]

            # Apply price variation (discounts/promotions)
            price_variation = random.uniform(0.8, 1.1)  # ±20% variation
            unit_price = round(base_price * price_variation, 2)

            quantity = random.randint(1, 5)

            order_item = {
                'OrderID': order_id,
                'ProductID': product_id,
                'Quantity': quantity,
                'UnitPrice': unit_price
            }
            order_items.append(order_item)

            order_total += unit_price * quantity

        order_totals[order_id] = round(order_total, 2)

    # Update totals in orders DataFrame
    orders_df['TotalAmount'] = orders_df['OrderID'].map(order_totals)

    # Save both updated files
    order_items_df = pd.DataFrame(order_items)
    order_items_df.to_csv('order_items.csv', index=False, encoding='utf-8')
    # Update with totals
    orders_df.to_csv('orders.csv', index=False, encoding='utf-8')

    print(
        f"✓ File 'order_items.csv' created with {len(order_items)} records")
    print("✓ File 'orders.csv' updated with calculated totals")

    return order_items_df


def generate_summary_report(customers_df, products_df, stores_df, orders_df, order_items_df):
    """Generate summary report of generated data"""
    print("\n" + "="*60)
    print("GENERATED DATA SUMMARY REPORT")
    print("="*60)

    print(f"📊 GENERAL STATISTICS:")
    print(f"   • Customers: {len(customers_df):,}")
    print(f"   • Products: {len(products_df):,}")
    print(f"   • Stores: {len(stores_df):,}")
    print(f"   • Orders: {len(orders_df):,}")
    print(f"   • Order Items: {len(order_items_df):,}")

    print(f"\n💰 FINANCIAL ANALYSIS:")
    print(f"   • Total Sales: ${orders_df['TotalAmount'].sum():,.2f}")
    print(f"   • Average Order: ${orders_df['TotalAmount'].mean():.2f}")
    print(f"   • Minimum Order: ${orders_df['TotalAmount'].min():.2f}")
    print(f"   • Maximum Order: ${orders_df['TotalAmount'].max():.2f}")

    print(f"\n📅 DATA PERIOD:")
    print(f"   • First Order: {orders_df['OrderDate'].min()}")
    print(f"   • Last Order: {orders_df['OrderDate'].max()}")

    print(f"\n🏪 DISTRIBUTION BY REGION:")
    region_stats = stores_df['Region'].value_counts()
    for region, count in region_stats.head().items():
        print(f"   • {region}: {count} stores")

    print(f"\n📦 TOP 5 PRODUCT CATEGORIES:")
    category_stats = products_df['Category'].value_counts()
    for category, count in category_stats.head().items():
        print(f"   • {category}: {count} products")

    print(f"\n💳 PAYMENT METHODS:")
    payment_stats = orders_df['PaymentMethod'].value_counts()
    for method, count in payment_stats.items():
        percentage = (count / len(orders_df)) * 100
        print(f"   • {method}: {count} ({percentage:.1f}%)")

    print("\n" + "="*60)
    print("✅ GENERATION COMPLETED SUCCESSFULLY")
    print("="*60)


def main():
    """Main function that executes the entire data generation process"""
    print("🚀 STARTING SYNTHETIC DATA GENERATION")
    print("="*60)

    try:
        # Generate data for each table
        customers_df = generate_customers()
        products_df = generate_products()
        stores_df = generate_stores()
        orders_df = generate_orders(customers_df, stores_df)
        order_items_df = generate_order_items(orders_df, products_df)

        # Generate summary report
        generate_summary_report(customers_df, products_df,
                                stores_df, orders_df, order_items_df)

        print(
            f"\n📁 Files generated in: {'/'.join(__file__.split('/')[:-1])}")
        print("   • customers.csv")
        print("   • products.csv")
        print("   • stores.csv")
        print("   • orders.csv")
        print("   • order_items.csv")

    except Exception as e:
        print(f"❌ Error during generation: {str(e)}")
        raise


if __name__ == "__main__":
    main()
