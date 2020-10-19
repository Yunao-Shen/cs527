insert into abc_retail.employees(employee_lastname, employee_firstname, employee_title)
select distinct employee_lastname, employee_firstname, employee_title
from abc_retail.raws;

insert into abc_retail.products(product_name)
select distinct product_name
from abc_retail.raws;

insert into abc_retail.companys(company_name)
select distinct company_name
from abc_retail.raws;
select * from abc_retail.companys;

insert into abc_retail.customers(customer_contactname, customer_city, customer_country, customer_phone, company_id)
select distinct r.customer_contactname, r.customer_city, r.customer_country, r.customer_phone, c.company_id
from abc_retail.raws as r
join abc_retail.companys as c
on r.company_name = c.company_name;
select * from abc_retail.customers;

insert into abc_retail.orders(order_id, order_date, order_shippeddate, order_freight, order_shipcity, order_shipcountry, employee_id, customer_id)
select distinct r.order_id, r.order_date, r.order_shippeddate, r.order_freight, r.order_shipcity, r.order_shipcountry, e.employee_id, c.customer_id
from abc_retail.raws as r
join abc_retail.employees as e
on r.employee_lastname= e.employee_lastname and r.employee_firstname= e.employee_firstname
join abc_retail.customers as c
on r.customer_contactname = c.customer_contactname and r.customer_phone = c.customer_phone;
select * from abc_retail.orders limit 100;

insert into abc_retail.order_products(order_quantity, order_unitprice, order_amount, order_id, product_id)
select distinct r.order_quantity, r.order_unitprice, r.order_amount, r.order_id, p.product_id
from abc_retail.raws as r
join abc_retail.products as p
on p.product_name = r.product_name;
select * from abc_retail.order_products limit 100;

select count(*) from abc_retail.companys;
select count(*) from abc_retail.employees;
select count(*) from abc_retail.customers;
select count(*) from abc_retail.products;
select count(*) from abc_retail.orders;
select count(*) from abc_retail.order_products;
