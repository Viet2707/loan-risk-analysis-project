CREATE DATABASE LoanDB;
GO
USE LoanDB;


CREATE TABLE LoanData (
    ApplicationDate DATE,
    Age INT,
    AnnualIncome FLOAT,
    CreditScore INT,
    EmploymentStatus NVARCHAR(50),
    EducationLevel NVARCHAR(50),
    Experience INT,
    LoanAmount FLOAT,
    LoanDuration INT,
    MaritalStatus NVARCHAR(50),
    NumberOfDependents INT,
    HomeOwnershipStatus NVARCHAR(50),
    MonthlyDebtPayments FLOAT,
    CreditCardUtilizationRate FLOAT,
    NumberOfOpenCreditLines INT,
    NumberOfCreditInquiries INT,
    DebtToIncomeRatio FLOAT,
    BankruptcyHistory INT,
    LoanPurpose NVARCHAR(100),
    PreviousLoanDefaults INT,
    PaymentHistory NVARCHAR(50),
    LengthOfCreditHistory INT,
    SavingsAccountBalance FLOAT,
    CheckingAccountBalance FLOAT,
    TotalAssets FLOAT,
    TotalLiabilities FLOAT,
    MonthlyIncome FLOAT,
    UtilityBillsPaymentHistory FLOAT,
    JobTenure INT,
    NetWorth FLOAT,
    BaseInterestRate FLOAT,
    InterestRate FLOAT,
    MonthlyLoanPayment FLOAT,
    TotalDebtToIncomeRatio FLOAT,
    LoanApproved INT,
    RiskScore FLOAT,
    CreditScoreGroup NVARCHAR(50),
    IncomeGroup NVARCHAR(50),
    AgeGroup NVARCHAR(50)
);

SELECT * FROM sys.tables WHERE name = 'LoanData';

SELECT COUNT(*) AS TotalRows
FROM LoanData;

SELECT TOP 10 * FROM LoanData;


-- Nhóm truy vấn 1: Truy vấn tổng quan dữ liệu

-- Query 1: Tổng số hồ sơ vay
SELECT COUNT(*) AS TotalApplications
FROM LoanData;

--Query 2: Phân bố trạng thá phê duyệt khoản vay

SELECT 
    LoanApproved,
    COUNT(*) AS NumberOfApplications,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM LoanData
GROUP BY LoanApproved;

--Nhóm truy vấn 2: So sánh hai nhóm duyệt và không duyệt

--Query 3: Trung bình các biến quan trọng theo LoanApproved
SELECT 
    LoanApproved,
    ROUND(AVG(AnnualIncome), 2) AS AvgAnnualIncome,
    ROUND(AVG(MonthlyIncome), 2) AS AvgMonthlyIncome,
    ROUND(AVG(CreditScore), 2) AS AvgCreditScore,
    ROUND(AVG(LoanAmount), 2) AS AvgLoanAmount,
    ROUND(AVG(InterestRate), 4) AS AvgInterestRate,
    ROUND(AVG(RiskScore), 2) AS AvgRiskScore,
    ROUND(AVG(DebtToIncomeRatio), 4) AS AvgDebtToIncomeRatio,
    ROUND(AVG(TotalDebtToIncomeRatio), 4) AS AvgTotalDebtToIncomeRatio
FROM LoanData
GROUP BY LoanApproved;

--Nhóm truy vấn 3: Phân tích theo từng nhóm khách hàng
--Query 4: Tỷ lệ duyệt theo tình trạng việc làm
SELECT 
    EmploymentStatus,
    COUNT(*) AS TotalApplications,
    SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) AS ApprovedApplications,
    ROUND(SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ApprovalRate
FROM LoanData
GROUP BY EmploymentStatus
ORDER BY ApprovalRate DESC;

--Query 5: Tỷ lệ duyệt theo trình độ học vấn
SELECT 
    EducationLevel,
    COUNT(*) AS TotalApplications,
    SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) AS ApprovedApplications,
    ROUND(SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ApprovalRate
FROM LoanData
GROUP BY EducationLevel
ORDER BY ApprovalRate DESC;

--Query 6: Tỷ lệ duyệt theo mục đích vay
SELECT 
    LoanPurpose,
    COUNT(*) AS TotalApplications,
    SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) AS ApprovedApplications,
    ROUND(SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ApprovalRate
FROM LoanData
GROUP BY LoanPurpose
ORDER BY ApprovalRate DESC;

--Query 7: Tỷ lệ duyệt theo tình trạng sở hữu nhà ở
SELECT 
    HomeOwnershipStatus,
    COUNT(*) AS TotalApplications,
    SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) AS ApprovedApplications,
    ROUND(SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ApprovalRate
FROM LoanData
GROUP BY HomeOwnershipStatus
ORDER BY ApprovalRate DESC;


--Nhóm truy vấn 4: Truy vấn theo các biến nhóm đã tạo ở Chương 2
--Query 8: Theo nhóm tuổi
SELECT 
    AgeGroup,
    COUNT(*) AS TotalApplications,
    ROUND(AVG(RiskScore), 2) AS AvgRiskScore,
    ROUND(SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ApprovalRate
FROM LoanData
GROUP BY AgeGroup
ORDER BY AgeGroup;

--Query 9: Theo nhóm thu nhập
SELECT 
    IncomeGroup,
    COUNT(*) AS TotalApplications,
    ROUND(AVG(RiskScore), 2) AS AvgRiskScore,
    ROUND(SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ApprovalRate
FROM LoanData
GROUP BY IncomeGroup
ORDER BY ApprovalRate DESC;

--query 10: Theo nhóm điểm tín dụng
SELECT 
    CreditScoreGroup,
    COUNT(*) AS TotalApplications,
    ROUND(AVG(RiskScore), 2) AS AvgRiskScore,
    ROUND(SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ApprovalRate
FROM LoanData
GROUP BY CreditScoreGroup
ORDER BY ApprovalRate DESC;

--Nhóm truy vấn 5: Truy vấn chi tiết để đưa sang Power BI
--Query 11: Bảng dữ liệu chi tiết cho dashboard
SELECT 
    ApplicationDate,
    Age,
    AgeGroup,
    AnnualIncome,
    MonthlyIncome,
    IncomeGroup,
    CreditScore,
    CreditScoreGroup,
    EmploymentStatus,
    EducationLevel,
    LoanPurpose,
    HomeOwnershipStatus,
    LoanAmount,
    InterestRate,
    DebtToIncomeRatio,
    TotalDebtToIncomeRatio,
    RiskScore,
    LoanApproved
FROM LoanData;