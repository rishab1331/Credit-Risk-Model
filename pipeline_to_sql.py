import pandas as pd
import joblib
from sqlalchemy import create_engine
import urllib

CSV_FILE = 'credit_risk_cleaned_.csv'
MODEL_FILE = 'credit_risk_model_final.pkl'
SQL_TABLE = 'Credit_Risk_Predictions'
SERVER_NAME = r'.\SQLEXPRESS'
DATABASE_NAME = 'CreditRiskDB'

def run_pipeline():
    df = pd.read_csv(CSV_FILE)
    model = joblib.load(MODEL_FILE)

    X_clean = df.copy()

    if 'loan_status' in X_clean.columns:
        X_clean = X_clean.drop(columns=['loan_status'])

    X_encoded = pd.get_dummies(X_clean)

    model_cols = model.feature_names_in_
    X_final = X_encoded.reindex(columns=model_cols, fill_value=0)

    df['Model_Prediction'] = model.predict(X_final)
    df['Risk_Probability'] = model.predict_proba(X_final)[:, 1]

    params = urllib.parse.quote_plus(
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER={SERVER_NAME};"
        f"DATABASE={DATABASE_NAME};"
        f"Trusted_Connection=yes;"
    )

    engine = create_engine(f"mssql+pyodbc:///?odbc_connect={params}")

    df.to_sql(SQL_TABLE, con=engine, if_exists='append', index=False)

    print("Uploaded to SQL Server successfully")

if __name__ == "__main__":
    run_pipeline()
