create table raw(
order_id int,
order_date date default null,
order_shippeddate date default null,
order_freight numeric(20,2),
order_shipcity varchar(255),
order_shipcountry varchar(255),
order_unitprice numeric(20,2),
order_quantity numeric(20,2),
order_amount numeric(20,2),
product_name varchar(255),
employee_lastname varchar(255),
employee_firstname varchar(255),
employee_title varchar(255),
company_name varchar(255),
customer_contactname varchar(255),
customer_city varchar(255),
customer_country varchar(255),
customer_phone varchar(255)
);

# load data infile 'E:\\inRutgers\\CS\\527Database\\project1\\ABC_Retail_headless2.txt' into table raw fields ENCLOSED BY '"';

CREATE TABLE Employees
(
  Employee_Id INT NOT NULL AUTO_INCREMENT,
  Employee_LastName VARCHAR(255) NOT NULL,
  Employee_FirstName VARCHAR(255) NOT NULL,
  Employee_Title VARCHAR(255),
  PRIMARY KEY (Employee_Id)
);

CREATE TABLE Products
(
  Product_Id INT NOT NULL AUTO_INCREMENT,
  Product_Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (Product_Id),
  UNIQUE (Product_Name)
);

CREATE TABLE Companys
(
  Company_Id INT NOT NULL AUTO_INCREMENT,
  Company_Name VARCHAR(255) NOT NULL,
  PRIMARY KEY (Company_Id),
  UNIQUE (Company_Name)
);

CREATE TABLE Customers
(
  Customer_Id INT NOT NULL AUTO_INCREMENT,
  Customer_ContactName VARCHAR(255) NOT NULL,
  Customer_City VARCHAR(255),
  Customer_Country VARCHAR(255),
  Customer_Phone VARCHAR(255),
  Company_Id INT NOT NULL,
  PRIMARY KEY (Customer_Id),
  FOREIGN KEY (Company_Id) REFERENCES Companys(Company_Id)
);

CREATE TABLE Orders
(
  Order_Id INT NOT NULL,
  Order_Date DATE,
  Order_ShippedDate DATE,
  Order_Freight NUMERIC(20,2),
  Order_ShipCity VARCHAR(255),
  Order_ShipCountry VARCHAR(255),
  Employee_Id INT NOT NULL,
  Customer_Id INT NOT NULL,
  PRIMARY KEY (Order_Id),
  FOREIGN KEY (Employee_Id) REFERENCES Employees(Employee_Id),
  FOREIGN KEY (Customer_Id) REFERENCES Customers(Customer_Id)
);

CREATE TABLE Order_Products
(
  Order_Id INT NOT NULL,
  Product_Id INT NOT NULL,
  Order_Quantity NUMERIC(20,2) NOT NULL,
  Order_Amount NUMERIC(20,2) NOT NULL,
  Order_UnitPrice NUMERIC(20,2) NOT NULL,
  FOREIGN KEY (Order_Id) REFERENCES Orders(Order_Id),
  FOREIGN KEY (Product_Id) REFERENCES Products(Product_Id)
);