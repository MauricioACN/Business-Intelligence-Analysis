# Business Intelligence Analysis - Synthetic Data

This repository contains a comprehensive toolkit for generating and analyzing realistic synthetic data for Business Intelligence projects. The repository is structured to support data generation, analysis, and future SQL operations.

## � Repository Structure

```
Business-Intelligence-Analysis/
├── 📁 data/                    # Generated CSV datasets
│   ├── customers.csv           # Customer information and demographics
│   ├── products.csv            # Product catalog with categories and pricing
│   ├── stores.csv              # Store locations and regional data
│   ├── orders.csv              # Order transactions and payment methods
│   └── order_items.csv         # Detailed order line items
├── 📁 python/                  # Python scripts for data operations
│   ├── generate_synthetic_data.py  # Main data generation script
│   └── analyze_data.py         # Data analysis and insights script
├── 📁 sql/                     # SQL scripts (ready for future queries)
├── 📄 requirements.txt         # Python dependencies
└── 📄 README.md               # Project documentation
```

## 📊 Dataset Description

The synthetic dataset simulates an e-commerce system with the following interconnected tables:

- **Customers** (CustomerID, Name, Email, JoinDate)
- **Products** (ProductID, ProductName, Category, Price)
- **Stores** (StoreID, StoreName, Region)
- **Orders** (OrderID, OrderDate, CustomerID, StoreID, TotalAmount, PaymentMethod)
- **OrderItems** (OrderID, ProductID, Quantity, UnitPrice)

## 🚀 Features

- **Realistic synthetic data**: Uses Faker library to generate authentic-looking customer names, emails, dates, and business data
- **Coherent relationships**: Tables maintain logical relationships (e.g., order dates after customer registration dates)
- **Comprehensive coverage**: Includes multiple product categories, US regional data, and various payment methods
- **Scalable generation**: Easily configurable data volumes through simple parameter adjustments
- **Detailed analytics**: Built-in analysis scripts provide immediate insights into generated datasets
- **Organized structure**: Clean folder organization separating data, scripts, and future SQL operations

## 📋 Requirements

```bash
pip install faker pandas
```

Or using the requirements file:

```bash
pip install -r requirements.txt
```

## 🔧 Quick Start

1. **Clone this repository**
   ```bash
   git clone <repository-url>
   cd Business-Intelligence-Analysis
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Generate synthetic data**
   ```bash
   python python/generate_synthetic_data.py
   ```

4. **Analyze the generated data**
   ```bash
   python python/analyze_data.py
   ```

## 📁 Generated Dataset

After running the generation script, you'll find the following CSV files in the `/data` folder:

| File | Records | Description |
|------|---------|-------------|
| `customers.csv` | 1,000 | Customer profiles with demographics |
| `products.csv` | 200 | Product catalog across 10 categories |
| `stores.csv` | 25 | Store locations across US states |
| `orders.csv` | 2,500 | Order transactions with totals |
| `order_items.csv` | ~11,000 | Individual line items per order |

## 📈 Customization

You can modify the following variables in `python/generate_synthetic_data.py` to adjust data quantities:

```python
NUM_CUSTOMERS = 1000      # Number of customers
NUM_PRODUCTS = 200        # Number of products
NUM_STORES = 25          # Number of stores
NUM_ORDERS = 2500        # Number of orders
MAX_ITEMS_PER_ORDER = 8  # Maximum items per order
```

## 🔄 Workflow

1. **Data Generation**: Use `python/generate_synthetic_data.py` to create fresh datasets
2. **Data Analysis**: Run `python/analyze_data.py` for immediate insights
3. **Data Export**: Access clean CSV files in the `/data` folder
4. **SQL Operations**: Future SQL scripts can be added to the `/sql` folder
5. **BI Integration**: Import data directly into your preferred BI tool

## 🛠️ Technologies Used

- **Python 3.x**: Core programming language
- **Faker**: Realistic synthetic data generation
- **Pandas**: Data manipulation and CSV export
- **Structured Organization**: Modular folder structure for scalability

## 🎨 Project Organization Benefits

The organized folder structure provides several advantages:

### 📁 `/data` Folder
- **Clean Separation**: All generated datasets in one location

### 📁 `/python` Folder
- **Code Organization**: All Python scripts in dedicated location

### 📁 `/sql` Folder
- **Future Ready**: Prepared space for SQL queries and scripts

---

*This project provides a solid foundation for Business Intelligence learning and development with realistic, well-structured synthetic data.*