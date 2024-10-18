USE stroke_prediction_schema;


CREATE VIEW stroke_distribution_by_gender AS
SELECT 
    gender,
    COUNT(*) as total_patients,
    SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) as stroke_count,
    ROUND(SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) as stroke_percentage
FROM stroke_prediction_dataset
WHERE gender != 'other'
GROUP BY gender;

   
   
   
CREATE VIEW average_stroke_bmi AS
SELECT 
    CASE 
        WHEN stroke = 1 THEN 'Stroke'
        ELSE 'No Stroke'
    END as stroke_status,
    AVG(bmi) as average_bmi
FROM stroke_prediction_dataset
GROUP BY stroke;





CREATE VIEW stroke_distribution_by_hypertension AS
SELECT 
    hypertension,
    COUNT(*) as total_patients,
    SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) as stroke_count,
    ROUND(SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) * 100, 2) as stroke_percentage
FROM stroke_prediction_dataset
GROUP BY hypertension;




CREATE VIEW stroke_distribution_by_heart_disease AS
SELECT 
    heart_disease,
    COUNT(*) as total_patients,
    SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) as stroke_count,
    ROUND(SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) * 100, 2) as stroke_percentage
FROM stroke_prediction_dataset
GROUP BY heart_disease;





CREATE VIEW average_age_by_stroke AS
SELECT 
    stroke,
    AVG(age) AS average_age
FROM stroke_prediction_dataset
GROUP BY stroke;	







CREATE VIEW correlation_summary AS
SELECT 
    age,
    avg_glucose_level,
    bmi,
    hypertension,
    heart_disease,
    stroke,
    CASE -- Gender data to numeric
		WHEN gender = 'Male' THEN 1
        WHEN gender = 'Female' THEN 2
        ELSE NULL
	END AS gender_numeric,
    CASE -- Smoking status to numeric
		WHEN smoking_status = 'smokes' THEN 1
        WHEN smoking_status = 'formerly smoked' THEN 2
        WHEN smoking_status = 'never smoked' THEN 3
        WHEN smoking_status = 'Unknown' THEN 4
	END AS smoking_status_numeric,
    CASE -- Residence type numeric
		WHEN Residence_type = 'Urban' THEN 1
        WHEN Residence_type = 'Rural' THEN 2
	END AS Residence_type_numeric    
FROM stroke_prediction_dataset;



    
    
    
CREATE VIEW stroke_distribution_by_age_and_gender AS
SELECT 
    CASE
        WHEN age BETWEEN 0 AND 9 THEN '0-9'
        WHEN age BETWEEN 10 AND 19 THEN '10-19'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        WHEN age BETWEEN 60 AND 69 THEN '60-69'
        ELSE '70 and above'
    END AS age_group,
    gender,  -- Include gender in the select and group by
    COUNT(*) AS total_patients,
    COUNT(CASE WHEN gender = 'Male' THEN 1 END) AS male_count,
    COUNT(CASE WHEN gender = 'Female' THEN 1 END) AS female_count,
    SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) AS stroke_count,
    SUM(CASE WHEN gender = 'Male' AND stroke = 1 THEN 1 ELSE 0 END) AS male_stroke_count,
    SUM(CASE WHEN gender = 'Female' AND stroke = 1 THEN 1 ELSE 0 END) AS female_stroke_count,
    ROUND(SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS stroke_percentage,
    ROUND(SUM(CASE WHEN gender = 'Male' AND stroke = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(CASE WHEN gender = 'Male' THEN 1 END), 0) * 100, 2) AS male_stroke_percentage,
    ROUND(SUM(CASE WHEN gender = 'Female' AND stroke = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(CASE WHEN gender = 'Female' THEN 1 END), 0) * 100, 2) AS female_stroke_percentage
FROM 
    stroke_prediction_dataset
WHERE 
    age IS NOT NULL
GROUP BY 
    age_group, gender  -- Group by both age_group and gender
ORDER BY 
    age_group, gender;

SELECT 
    gender,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) AS stroke_count,
    ROUND(SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS stroke_percentage
FROM 
    stroke_prediction_dataset
WHERE 
    gender IS NOT NULL
GROUP BY 
    gender;
    
    
    


CREATE VIEW stroke_distribution_by_glucose_level_age_gender AS
WITH TotalCounts AS (
    SELECT 
        CASE
            WHEN age BETWEEN 0 AND 9 THEN '0-9'
            WHEN age BETWEEN 10 AND 19 THEN '10-19'
            WHEN age BETWEEN 20 AND 29 THEN '20-29'
            WHEN age BETWEEN 30 AND 39 THEN '30-39'
            WHEN age BETWEEN 40 AND 49 THEN '40-49'
            WHEN age BETWEEN 50 AND 59 THEN '50-59'
            WHEN age BETWEEN 60 AND 69 THEN '60-69'
            ELSE '70 and above'
        END AS total_age_group,
        COUNT(*) AS total_patients_age_group,
        SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) AS total_stroke_count_age_group
    FROM stroke_prediction_dataset
    WHERE age IS NOT NULL
    GROUP BY total_age_group
)

SELECT 
    CASE
        WHEN avg_glucose_level < 70 THEN 'Hypoglycemia'
        WHEN avg_glucose_level BETWEEN 70 AND 99 THEN 'Normal'
        WHEN avg_glucose_level BETWEEN 100 AND 125 THEN 'Prediabetes'
        WHEN avg_glucose_level BETWEEN 126 AND 199 THEN 'Diabetes'
        ELSE 'Severe Hyperglycemia'
    END AS glucose_category,
    CASE
        WHEN avg_glucose_level < 70 THEN '< 70 mg/dL'
        WHEN avg_glucose_level BETWEEN 70 AND 99 THEN '70 - 99 mg/dL'
        WHEN avg_glucose_level BETWEEN 100 AND 125 THEN '100 - 125 mg/dL'
        WHEN avg_glucose_level BETWEEN 126 AND 199 THEN '126 - 199 mg/dL'
        ELSE '≥ 200 mg/dL'
    END AS glucose_range,
    CASE
        WHEN age BETWEEN 0 AND 9 THEN '0-9'
        WHEN age BETWEEN 10 AND 19 THEN '10-19'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        WHEN age BETWEEN 60 AND 69 THEN '60-69'
        ELSE '70 and above'
    END AS age_group,
    COUNT(*) AS total_patients,
    SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) AS stroke_count,
    ROUND(SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) * 100, 2) AS stroke_percentage,
    ROUND(SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) / NULLIF(tc.total_patients_age_group, 0) * 100, 2) AS total_age_group_stroke_percentage
FROM stroke_prediction_dataset AS spd
JOIN TotalCounts AS tc ON
    (CASE
        WHEN spd.age BETWEEN 0 AND 9 THEN '0-9'
        WHEN spd.age BETWEEN 10 AND 19 THEN '10-19'
        WHEN spd.age BETWEEN 20 AND 29 THEN '20-29'
        WHEN spd.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN spd.age BETWEEN 40 AND 49 THEN '40-49'
        WHEN spd.age BETWEEN 50 AND 59 THEN '50-59'
        WHEN spd.age BETWEEN 60 AND 69 THEN '60-69'
        ELSE '70 and above'
    END = tc.total_age_group)
WHERE spd.age IS NOT NULL
GROUP BY glucose_category, glucose_range, age_group, tc.total_patients_age_group
ORDER BY glucose_category, glucose_range, age_group;






CREATE VIEW stroke_distribution_by_smoking_age_and_gender AS
WITH StrokeCounts AS (
    SELECT 
        smoking_status,
        COUNT(*) AS total_patients,
        SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) AS stroke_count
    FROM 
        stroke_prediction_dataset
    GROUP BY 
        smoking_status
),
AgeGenderGroupCounts AS (
    SELECT 
        smoking_status,
        CASE
            WHEN age BETWEEN 0 AND 9 THEN '0-9'
            WHEN age BETWEEN 10 AND 19 THEN '10-19'
            WHEN age BETWEEN 20 AND 29 THEN '20-29'
            WHEN age BETWEEN 30 AND 39 THEN '30-39'
            WHEN age BETWEEN 40 AND 49 THEN '40-49'
            WHEN age BETWEEN 50 AND 59 THEN '50-59'
            WHEN age BETWEEN 60 AND 69 THEN '60-69'
            ELSE '70 and above'
        END AS age_group,
        gender,  -- Include gender column here
        COUNT(*) AS total_patients_age_gender_group,
        SUM(CASE WHEN stroke = 1 THEN 1 ELSE 0 END) AS stroke_count_age_gender_group
    FROM 
        stroke_prediction_dataset
    WHERE 
        age IS NOT NULL AND gender IS NOT NULL
    GROUP BY 
        smoking_status, age_group, gender
)
SELECT 
    aggc.smoking_status,
    aggc.age_group,
    aggc.gender,  -- Gender column to be used in slicer
    aggc.total_patients_age_gender_group,
    aggc.stroke_count_age_gender_group,
    ROUND(aggc.stroke_count_age_gender_group * 100.0 / NULLIF(aggc.total_patients_age_gender_group, 0), 2) AS stroke_percentage,
    ROUND(sc.stroke_count * 100.0 / NULLIF(sc.total_patients, 0), 2) AS total_stroke_percentage
FROM 
    AgeGenderGroupCounts aggc
JOIN 
    StrokeCounts sc ON aggc.smoking_status = sc.smoking_status
ORDER BY 
    aggc.smoking_status, aggc.age_group, aggc.gender;






DROP TABLE IF EXISTS AgeGroups;  -- Drop the existing table
CREATE TABLE AgeGroups (
    age_group VARCHAR(20) PRIMARY KEY  -- Define a longer VARCHAR size
);

INSERT INTO AgeGroups (age_group)
VALUES ('0-9'), ('10-19'), ('20-29'), ('30-39'), 
       ('40-49'), ('50-59'), ('60-69'), ('70 and above');
