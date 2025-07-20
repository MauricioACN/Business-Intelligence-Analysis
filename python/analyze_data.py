#!/usr/bin/env python3
"""
Data Analysis Script - Quick overview of generated synthetic data
"""

import pandas as pd
import os


def analyze_generated_data():
    """Analyze the generated CSV files and provide insights"""

    # Check if all files exist
    files = ['customers.csv', 'products.csv',
             'stores.csv', 'orders.csv', 'order_items.csv']
    missing_files = [f for f in files if not os.path.exists(f)]

    if missing_files:
        print(f"❌ Missing files: {missing_files}")
        print("Please run generate_synthetic_data.py first!")
        return

    print("📊 DETAILED DATA ANALYSIS")
    print("=" * 60)

    # Load data
    customers = pd.read_csv('customers.csv')
    products = pd.read_csv('products.csv')
    stores = pd.read_csv('stores.csv')
    orders = pd.read_csv('orders.csv')
    order_items = pd.read_csv('order_items.csv')

    # Customer Analysis
    print("\n👥 CUSTOMER ANALYSIS:")
    print(f"   • Total Customers: {len(customers):,}")
    print(
        f"   • Sample Names: {', '.join(customers['Name'].head(3).tolist())}")
    print(
        f"   • Email Domains: {customers['Email'].str.split('@').str[1].value_counts().head(3).to_dict()}")

    # Product Analysis
    print("\n📦 PRODUCT ANALYSIS:")
    print(f"   • Total Products: {len(products):,}")
    print(
        f"   • Price Range: ${products['Price'].min():.2f} - ${products['Price'].max():.2f}")
    print(f"   • Average Price: ${products['Price'].mean():.2f}")
    print("   • Category Distribution:")
    for category, count in products['Category'].value_counts().head(5).items():
        print(f"     - {category}: {count} products")

    # Store Analysis
    print("\n🏪 STORE ANALYSIS:")
    print(f"   • Total Stores: {len(stores):,}")
    print("   • Regional Distribution:")
    for region, count in stores['Region'].value_counts().items():
        print(f"     - {region}: {count} stores")

    # Order Analysis
    orders['OrderDate'] = pd.to_datetime(orders['OrderDate'])
    print("\n🛒 ORDER ANALYSIS:")
    print(f"   • Total Orders: {len(orders):,}")
    print(f"   • Total Revenue: ${orders['TotalAmount'].sum():,.2f}")
    print(f"   • Average Order Value: ${orders['TotalAmount'].mean():.2f}")
    print(
        f"   • Date Range: {orders['OrderDate'].min().date()} to {orders['OrderDate'].max().date()}")
    print("   • Payment Method Distribution:")
    for method, count in orders['PaymentMethod'].value_counts().items():
        percentage = (count / len(orders)) * 100
        print(f"     - {method}: {count:,} ({percentage:.1f}%)")

    # Order Items Analysis
    print("\n📋 ORDER ITEMS ANALYSIS:")
    print(f"   • Total Order Items: {len(order_items):,}")
    print(
        f"   • Average Items per Order: {len(order_items) / len(orders):.1f}")
    print(
        f"   • Quantity Range: {order_items['Quantity'].min()} - {order_items['Quantity'].max()}")
    print(
        f"   • Average Quantity per Item: {order_items['Quantity'].mean():.1f}")

    # Cross-table Analysis
    print("\n🔗 RELATIONSHIP ANALYSIS:")
    orders_per_customer = orders.groupby('CustomerID').size()
    print(f"   • Max Orders per Customer: {orders_per_customer.max()}")
    print(
        f"   • Average Orders per Customer: {orders_per_customer.mean():.1f}")

    revenue_by_region = orders.merge(stores, on='StoreID').groupby(
        'Region')['TotalAmount'].sum().sort_values(ascending=False)
    print("   • Top 3 Regions by Revenue:")
    for region, revenue in revenue_by_region.head(3).items():
        print(f"     - {region}: ${revenue:,.2f}")

    print("\n" + "=" * 60)
    print("✅ ANALYSIS COMPLETED")
    print("=" * 60)


if __name__ == "__main__":
    analyze_generated_data()
