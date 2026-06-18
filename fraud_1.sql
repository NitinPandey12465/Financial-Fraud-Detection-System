CREATE TABLE fact_transactions (
    transactionid     BIGINT PRIMARY KEY,
    transactiondt     INTEGER,
    transactionamt    NUMERIC(10,2),
    productcd         VARCHAR(5),
    isfraud           SMALLINT,
    card1             VARCHAR(20),
    card2             VARCHAR(20),
    card3             VARCHAR(20),
    card4             VARCHAR(20),
    card5             VARCHAR(20),
    card6             VARCHAR(20),
    addr1             NUMERIC(6,1),
    addr2             NUMERIC(6,1),
    p_emaildomain     VARCHAR(50),
    r_emaildomain     VARCHAR(50),
    dist1             NUMERIC(10,2),
    dist2             NUMERIC(10,2)
);

CREATE TABLE dim_identity (
    transactionid    BIGINT PRIMARY KEY,
    C1  NUMERIC(10,2),
    C2  NUMERIC(10,2),
    C3  NUMERIC(10,2),
    C4  NUMERIC(10,2)
    C5  NUMERIC(10,2)
    C6  NUMERIC(10,2)
    C7  NUMERIC(10,2)
    C8  NUMERIC(10,2)
    C9  NUMERIC(10,2)
    C10  NUMERIC(10,2)
    C11 NUMERIC(10,2)
    C12  NUMERIC(10,2)
    C13  NUMERIC(10,2)
    C14  NUMERIC(10,2)
    D1  NUMERIC(10,2)
    D2  NUMERIC(10,2)
    D3  NUMERIC(10,2)
    D4  NUMERIC(10,2)
    D5  NUMERIC(10,2)
    D6  NUMERIC(10,2)
    D7  NUMERIC(10,2)
    D8  NUMERIC(10,2)
    D9  NUMERIC(10,2)
    D10  NUMERIC(10,2)
    D11  NUMERIC(10,2)
    D12  NUMERIC(10,2)
    D13  NUMERIC(10,2)
    D14  NUMERIC(10,2)
    D15 NUMERIC(10,2)
    FOREIGN KEY (transactionid) REFERENCES fact_transactions(transactionid)
);

CREATE TABLE fact_vesta_features (
    transactionid    BIGINT PRIMARY KEY,
    v1  NUMERIC(10,2), v2  NUMERIC(10,2), v3  NUMERIC(10,2),
    v4  NUMERIC(10,2), v5  NUMERIC(10,2), v6  NUMERIC(10,2),
    v7  NUMERIC(10,2), v8  NUMERIC(10,2), v9  NUMERIC(10,2),
    v10 NUMERIC(10,2), v11 NUMERIC(10,2), v12 NUMERIC(10,2),
    v13 NUMERIC(10,2), v14 NUMERIC(10,2), v15 NUMERIC(10,2),
    v16 NUMERIC(10,2), v17 NUMERIC(10,2), v18 NUMERIC(10,2),
    v19 NUMERIC(10,2), v20 NUMERIC(10,2),
    FOREIGN KEY (transactionid) REFERENCES fact_transactions(transactionid)
);