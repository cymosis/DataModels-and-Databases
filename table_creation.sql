CREATE TABLE a1phra.diabetes(
    HeartDiseaseorAttack NUMBER(1),  
    HighBP NUMBER(1),  
    HighChol NUMBER(1),  
    CholCheck NUMBER(1),  
    BMI NUMBER(5,2),  
    Smoker NUMBER(1),  
    Stroke NUMBER(1),  -- Assuming 1 for Yes/No (1/0 or boolean)
    Diabetes NUMBER(1),  -- Assuming 1 for Yes/No (1/0 or boolean)
    PhysActivity NUMBER(1),  -- Assuming 1 for Yes/No (1/0 or boolean)
    Fruits NUMBER(1),  -- Assuming 1 for Yes/No (1/0 or boolean)
    Veggies NUMBER(1),  -- Assuming 1 for Yes/No (1/0 or boolean)
    HvyAlcoholConsump NUMBER(1),  -- Assuming 1 for Yes/No (1/0 or boolean)
    AnyHealthcare NUMBER(1),  -- Assuming 1 for Yes/No (1/0 or boolean)
    NoDocbcCost NUMBER(1),  -- Assuming 1 for Yes/No (1/0 or boolean)
    GenHlth NUMBER(1),  -- Assuming 1 for Poor/Fair/Good/Very good/Excellent
    MentHlth NUMBER(3),  -- Assuming number to store mental health status (e.g., 0-30 scale)
    PhysHlth NUMBER(3),  -- Assuming number to store physical health status (e.g., 0-30 scale)
    DiffWalk NUMBER(1),  -- Assuming 1 for Yes/No (1/0 or boolean)
    Sex VARCHAR2(10),  -- Assuming 'Male' or 'Female'
    Age NUMBER(3),  -- Assuming age is an integer
    Education VARCHAR2(50),  -- Assuming categories like 'High School', 'College', 'Masters'
    Income VARCHAR2(50)  -- Assuming categories like 'Low', 'Middle', 'High'
);
