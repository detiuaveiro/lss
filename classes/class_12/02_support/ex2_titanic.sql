-- Titanic dataset queries

-- survival rate
SELECT AVG(Survived) * 100 as survival_rate FROM passengers;

-- average age of survivors vs non-survivors
SELECT Survived, AVG(Age) FROM passengers GROUP BY Survived;

-- survival by class
SELECT Pclass, SUM(Survived) as survivors FROM passengers GROUP BY Pclass ORDER BY survivors DESC;

-- survival by sex and age category
SELECT Sex, 
       CASE WHEN Age < 18 THEN 'Child' ELSE 'Adult' END as AgeGroup,
       AVG(Survived) as survival_prob
FROM passengers
GROUP BY Sex, AgeGroup;
