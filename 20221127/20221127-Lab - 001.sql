Create database `order-directory`;
use `order-directory`;

Create Table IF NOT EXISTS Supplier
(
Supp_ID int,
Supp_Name VarChar(50),
Supp_City VarChar(50),
Supp_Phone VarChar(50),
Primary Key (Supp_ID)
);

Create Table IF NOT EXISTS customer
(
CUS_ID	int,
CUS_Name	VarChar(20),
CUS_Phone	VarChar(20),
CUS_City	VarChar(30),
Cus_Gender Char(1),
primary key (CUS_ID)
);
Create Table IF NOT EXISTS category
(
Cat_ID int,
Cat_Desc VarChar(20),
Primary Key (Cat_ID)
);
Create Table IF NOT EXISTS product
(
Pro_ID int,
PRO_Name VarChar(20) NOT NULL DEFAULT 'Dummy',
PRO_Desc VarChar(60),
Cat_ID int,
primary key (Pro_ID),
Foreign Key (Cat_ID) References Category(Cat_ID)
);

CREATE TABLE IF NOT EXISTS supplier_pricing (
    PRICING_ID INT NOT NULL,
    PRO_ID INT NOT NULL,
    SUPP_ID INT NOT NULL,
    SUPP_PRICE INT DEFAULT 0,
    PRIMARY KEY (PRICING_ID),
    FOREIGN KEY (PRO_ID) REFERENCES PRODUCT (Pro_ID),
    FOREIGN KEY (SUPP_ID) REFERENCES SUPPLIER(SUPP_ID),
	UNIQUE (PRO_ID,SUPP_ID)
);


Create Table IF NOT EXISTS `order`
(
Ord_ID int,
Ord_Amount int NOT NULL,
ORD_Date	Date NOT NULL,
CUS_ID	int,
Pricing_ID int,
Primary Key (Ord_ID),
Foreign Key (Cus_ID) References Customer(Cus_ID),
Foreign Key (Pricing_ID) References supplier_pricing(Pricing_ID)
);

create table rating
(
RAT_ID int,
ORD_ID int,
RAT_RATSTARS int NOT NULL,
Primary Key (Rat_ID),
Foreign Key (Ord_ID) references `Order`(ORD_ID)
);

