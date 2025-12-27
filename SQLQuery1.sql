

CREATE DATABASE CreditRiskDB;
GO

USE CreditRiskDB;
GO

CREATE TABLE Credit_Risk_Predictions (
    PredictionID INT IDENTITY(1,1) PRIMARY KEY,
    

    person_age INT,
    person_income FLOAT,
    person_home_ownership VARCHAR(50),
    person_emp_length FLOAT,
    loan_intent VARCHAR(50),
    loan_grade VARCHAR(50),
    loan_amnt FLOAT,
    loan_int_rate FLOAT,
    loan_status INT,    
    loan_percent_income FLOAT,
    cb_person_default_on_file VARCHAR(10),
    cb_person_cred_hist_length INT,

    Model_Prediction INT,
    Upload_Date DATETIME DEFAULT GETDATE()
);


USE CreditRiskDB;
GO
ALTER TABLE Credit_Risk_Predictions
ADD Risk_Probability FLOAT;


select count(person_age)  from Credit_Risk_Predictions;

select count(Model_prediction) as predicted_risk 
from Credit_Risk_Predictions
where Model_Prediction = 1

select count(Model_prediction) as predicted_no_risk
from Credit_Risk_Predictions
where Model_Prediction = 0

select 
    sum(case when Model_Prediction= 1 then 1 Else 0 end) as predicted_defaults,
    sum(case when loan_status =1 then 1 else 0 end)      as actual_default,

    sum(case when Model_Prediction= 0 then 1 else 0 end) as predicted_no_default,
    sum(case when loan_status =0 then 1 else 0 end)      as actual_no_default
from Credit_Risk_Predictions

SELECT * FROM dbo.Credit_Risk_Predictions;


GO

CREATE VIEW v_Credit_Risk_Display AS
select *,
  case when loan_status = 1 then 'Yes' else 'No' end as is_defaulted,
  case when Model_Prediction =1 then 'Yes' else 'No' end as predicted_default
from dbo.Credit_Risk_Predictions;

Go

SELECT * FROM dbo.v_Credit_Risk_Display;



