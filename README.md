# 💰 Supply Chain Bottleneck Optimization: Risk-Based Cost Reduction

## Executive Summary
This project analyzed 13K successful delivery records to identify operational factors driving cost overruns. A **Cost-of-Delay metric (OCI)** was engineered to quantify hidden inefficiency costs. The analysis definitively proved that **Route Risk** and **Traffic Congestion** are the primary bottlenecks, not warehouse time. By prioritizing risk mitigation in routing, the business can avoid the most expensive deliveries and realize a potential **\$210K+** in annual savings.

---

## 💡 Business Problem & Objective

The company faced high variability in delivery costs and delays, hindering profitability. Management lacked clarity on whether to invest in warehouse efficiency or route optimization.

* **Problem:** Identify the operational variable (Traffic, Risk, Loading Time, etc.) with the highest correlation to increased delivery costs.
* **Objective:** Create a unified metric ($\text{OCI}$) and use data segmentation (binning) to pinpoint the bottleneck driving the average cost above the benchmark.

## 🛠️ Technical Pipeline & Stack

The analysis involved critical data transformation to convert complex sensor data into actionable business categories.

| Phase | Tool | Key Technique | File Reference |
| :--- | :--- | :--- | :--- |
| **ETL & Metric Creation** | Python (Pandas) | **Data Troubleshooting** (fixing the continuous score filter). Creation of the **Operational Cost Impact (OCI)** metric. | `01_SC_Data_Prep.ipynb` |
| **Data Discretization** | Python (Pandas) | **Quantile Binning** (`pd.qcut`) to transform continuous Risk and Traffic scores into Low, Medium, and High categories for segmentation. | `03_SC_Visualization.ipynb` |
| **Bottleneck Analysis** | SQL (SQLite) / Pandas | Segmentation and **A/B Testing** (comparing Avg OCI per bucket) to isolate the most expensive operational factor. | `02_SC_SQL_Analysis.ipynb` |
| **Visualization** | Python (Seaborn) | Bar chart visualization comparing segmented OCI to the overall average cost. | `03_SC_Visualization.ipynb` |

### **Key Metric Defined: Operational Cost Impact (OCI)**
$\text{OCI} = \text{Shipping Cost} \times (1 + \text{Delivery Time Deviation Factor})$. This metric translates time inefficiency into a measurable dollar cost.

---

## 📊 Key Findings & Strategic Recommendation

The analysis found that the $\text{Avg\_OCI}$ for all successful deliveries is **\$562.64**. This baseline was significantly exceeded by specific operational segments:

### **Key Finding: Risk is the Cost Driver**
The highest $\text{Avg\_OCI}$ was **\$571.22** and occurred on **High Risk** routes, representing a cost overrun of **\$8.58** per delivery compared to the average.

* The least efficient segment is **High Risk** (\$571.22).
* The most efficient segment is **Low Traffic** (\$554.97).
* **Crucial Negative Finding:** Warehouse/Loading Time was **not** correlated with increased OCI, freeing up capital previously intended for warehouse improvements.

### **Strategic Recommendation**
* **Action:** Immediately update the routing software to integrate the **Route Risk Score** as a penalty factor, prioritizing risk minimization over simple distance minimization.
* **Impact:** By mitigating deliveries on the most expensive segments, the company can target a cost reduction of over **\$16** per delivery (the gap between High Risk and Low Traffic), leading to an estimated **\$210,000+** in annual savings.

---

## 📁 Repository Structure

* `01_Raw_Data/`: Original `logistics_transactions_raw.csv`.
* `02_Processed_Data/`: Cleaned data (`logistics_transactions_clean.csv`).
* `03_SQL_Scripts/`: SQL query used for initial segmentation (demonstrating standard practice).
* `04_Python_Notebooks/`: All preparation, binning, and visualization notebooks.
* `05_Insights_Reports/`: Final visualization output (`bottleneck_cost_analysis.png`).
