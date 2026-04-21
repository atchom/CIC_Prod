import pyodbc as pyo
import pandas as pd
conn_str = (
    "Driver={ODBC Driver 17 for SQL Server};"
    "Server=ATCHOM;"
    "Database=CIC_OP;"
    "Trusted_Connection=yes;"
)
conn = pyo.connect(conn_str)
cursor = conn.cursor()

#cursor.execute(open("create_view.sql", "r", encoding="utf-8").read())
df = pd.read_sql("SELECT * FROM SRC_RH_PAIE", conn)
print(df.head())
conn.commit()
cursor.close()
conn.close()
df.to_csv(r"C:\\CIC_Github\\SRC_RH_PAIE.csv", index=False, encoding='utf-8-sig')
