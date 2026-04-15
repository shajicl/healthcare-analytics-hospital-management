USE HospitalDatabase

DROP TABLE IF EXISTS dbo.Detail_data;
GO


SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Detail_data';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'department';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'staffDetails';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'bedDetails';

select * from dbo.staffDetails
select * from dbo.Detail_data
select * from dbo.bedDetails
select * from dbo.department

-- 1. Average Length of Stay per Department
SELECT 
    d.Department_Name,
    AVG(CAST(dd.LOS AS FLOAT)) AS Avg_Length_of_Stay
FROM dbo.Detail_data dd
JOIN dbo.department d
    ON dd.Dpt_ID = d.Dpt_ID
WHERE dd.LOS IS NOT NULL
GROUP BY d.Department_Name
ORDER BY Avg_Length_of_Stay DESC;


-- 2. Peak Admission Days
SELECT 
    DATENAME(WEEKDAY, [Date]) AS Day,
    COUNT(*) AS Admissions
FROM dbo.Detail_data
WHERE [Date] IS NOT NULL
GROUP BY DATENAME(WEEKDAY, [Date])
ORDER BY Admissions DESC;

-- Readmission Rate: patients who visited more than once

SELECT 
    ID,
    COUNT(*) AS Visit_Count
FROM dbo.Detail_data
GROUP BY ID
HAVING COUNT(*) > 1
ORDER BY Visit_Count DESC;

--department
SELECT 
    d.Department_Name,
    COUNT(*) AS Readmission_Count
FROM (
    SELECT ID, Dpt_ID
    FROM dbo.Detail_data
    GROUP BY ID, Dpt_ID
    HAVING COUNT(*) > 1
) r
JOIN dbo.department d
    ON r.Dpt_ID = d.Dpt_ID
GROUP BY d.Department_Name
ORDER BY Readmission_Count DESC;

--patient
SELECT 
    Patient_type,
    COUNT(*) AS Readmission_Count
FROM (
    SELECT ID, Patient_type
    FROM dbo.Detail_data
    GROUP BY ID, Patient_type
    HAVING COUNT(*) > 1
) t
GROUP BY Patient_type
ORDER BY Readmission_Count DESC;

--age
SELECT 
    Age_Bucket,
    COUNT(*) AS Readmission_Count
FROM (
    SELECT ID, Age_Bucket
    FROM dbo.Detail_data
    GROUP BY ID, Age_Bucket
    HAVING COUNT(*) > 1
) t
GROUP BY Age_Bucket
ORDER BY Readmission_Count DESC;


-- Overall Staff-to-Patient Ratio
SELECT 
    COUNT(DISTINCT ID) AS Total_Patients,
    (SELECT COUNT(*) FROM dbo.staffDetails) AS Total_Staff,
    ROUND(
        COUNT(DISTINCT ID) * 1.0 / (SELECT COUNT(*) FROM dbo.staffDetails),
        2
    ) AS Patient_to_Staff_Ratio,
    AVG(CAST(ER_Time AS FLOAT)) AS Avg_ER_Time,
    AVG(CAST(Rating AS DECIMAL(3,1))) AS Avg_Rating,
    AVG(CAST(LOS AS FLOAT)) AS Avg_Length_of_Stay
FROM dbo.Detail_data;


-- 3. Bed Occupancy Rate Across Departments
SELECT 
    d.Department_Name,
    COUNT(*) AS Total_Records,
    SUM(CASE WHEN dd.Bed = 'Occupied' THEN 1 ELSE 0 END) AS Occupied_Beds,
    ROUND(
        SUM(CASE WHEN dd.Bed = 'Occupied' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Occupancy_Rate_Percentage
FROM dbo.Detail_data dd
JOIN dbo.department d
    ON dd.Dpt_ID = d.Dpt_ID
GROUP BY d.Department_Name
ORDER BY Occupancy_Rate_Percentage DESC;


-- 4. Average Treatment Cost by Department
SELECT 
    d.Department_Name,
    AVG(CAST(dd.treatemencost AS DECIMAL(10,2))) AS Avg_Treatment_Cost
FROM dbo.Detail_data dd
JOIN dbo.department d
    ON dd.Dpt_ID = d.Dpt_ID
GROUP BY d.Department_Name
ORDER BY Avg_Treatment_Cost DESC;


-- 5. Departments with average ER time greater than 40 minutes
SELECT 
    d.Department_Name,
    AVG(CAST(dd.ER_Time AS FLOAT)) AS Avg_ER_Time
FROM dbo.Detail_data dd
JOIN dbo.department d
    ON dd.Dpt_ID = d.Dpt_ID
GROUP BY d.Department_Name
HAVING AVG(CAST(dd.ER_Time AS FLOAT)) > 40
ORDER BY Avg_ER_Time DESC;


-- 6. Rank departments by total treatment cost
SELECT 
    d.Department_Name,
    SUM(CAST(dd.treatemencost AS DECIMAL(10,2))) AS Total_Treatment_Cost,
    RANK() OVER (
        ORDER BY SUM(CAST(dd.treatemencost AS DECIMAL(10,2))) DESC
    ) AS Dept_Rank
FROM dbo.Detail_data dd
JOIN dbo.department d
    ON dd.Dpt_ID = d.Dpt_ID
GROUP BY d.Department_Name;


-- 7. Top 3 departments by patient count
SELECT TOP 3
    d.Department_Name,
    COUNT(DISTINCT dd.ID) AS Patient_Count
FROM dbo.Detail_data dd
JOIN dbo.department d
    ON dd.Dpt_ID = d.Dpt_ID
GROUP BY d.Department_Name
ORDER BY Patient_Count DESC;


-- 8. Running total of treatment cost by date
SELECT
    [Date],
    SUM(CAST(treatemencost AS DECIMAL(10,2))) AS Daily_Treatment_Cost,
    SUM(SUM(CAST(treatemencost AS DECIMAL(10,2)))) OVER (ORDER BY [Date]) AS Running_Total_Cost
FROM dbo.Detail_data
WHERE [Date] IS NOT NULL
GROUP BY [Date]
ORDER BY [Date];


-- 9. Patients whose ER time is above overall average
SELECT
    ID,
    Dpt_ID,
    ER_Time
FROM dbo.Detail_data
WHERE CAST(ER_Time AS FLOAT) > (
    SELECT AVG(CAST(ER_Time AS FLOAT))
    FROM dbo.Detail_data
);


-- 10. Patients who visited the hospital more than once
SELECT
    ID,
    COUNT(*) AS Visit_Count
FROM dbo.Detail_data
GROUP BY ID
HAVING COUNT(*) > 1
ORDER BY Visit_Count DESC;

