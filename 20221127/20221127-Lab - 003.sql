
use `order-directory`;

/*3)	Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.*/

select * from `order`
;


/* 4)	Display all the orders along with product name ordered by a customer having Customer_Id=2 */
select 
o.*, p.PRO_Name
-- o.Ord_ID, o.ORD_Date, s.Supp_Name, p.PRO_Name, p.Pro_Desc
from `order` o
INNER JOIN supplier_pricing sp ON sp.PRICING_ID = o.Pricing_ID
INNER JOIN product p ON p.Pro_ID = sp.PRO_ID
-- INNER JOIN supplier s ON s.supp_ID = sp.SUPP_ID
-- INNER JOIN customer c ON c.CUS_ID = o.CUS_ID
where o.CUS_ID = 2;


/* 5)	Display the Supplier details who can supply more than one product. */
select * from Supplier where Supp_ID IN (
select SUPP_ID from (select SUPP_ID, COUNT(SUPP_ID) as Cnt from Supplier_pricing GROUP BY Supp_ID) ss where ss.Cnt > 1);

-- OR 
select supp_id from supplier_pricing group by supp_id having count(supp_id)> 1;
select * from supplier where supp_id in (select supp_id from supplier_pricing group by supp_id having count(supp_id)> 1);

/* 6)	Find the least expensive product from each category 
and print the table with category id, name, product name and price of the product */

select pp.Cat_ID, c.cat_Desc , pp.Pro_name , MIN(SUPP_PRICE) MinPrice 
from supplier_pricing ss 
INNER JOIN PRODUCT pp ON pp.Pro_ID = ss.Pro_ID
INNER JOIN Category c ON c.cat_Id = pp.Cat_ID
 GROUP BY pp.Cat_ID;

/* 7)	Display the Id and Name of the Product ordered after “2021-10-05”. */

select sp.pro_id, p.Pro_Name
from `order` o
inner join SUPPLIER_pricing sp ON sp.Pricing_ID = o.Pricing_ID
inner join product p ON p.Pro_ID = sp.Pro_ID
where ORD_Date > '2021-10-05';

-- OR

select pro_id,pro_name from product as p where pro_id in 
(select pro_id from supplier_pricing as sp where pricing_id in 
(select pricing_id from `order` as o where ord_date > "2021-10-05"));


/* 8)	Display customer name and gender whose names start or end with character 'A'. */

select cus_name, Cus_Gender from customer where LEFT(cus_name, 1) = 'A' or RIGHT(cus_name, 1) = 'A';
-- OR
select cus_name, Cus_Gender from customer where cus_name LIKE  'A%' or cus_name LIKE '%A';


/* 9)	Create a stored procedure to display supplier id, name, rating and Type_of_Service.
 For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, 
 If rating >2 print “Average Service” else print “Poor Service”. */
delimiter $$
ALTER procedure Rating_procedure()
begin
select sp.SUPP_ID, s.Supp_Name, AVG(r.RAT_RATSTARS) As Rating,
CASE
 WHEN AVG(r.RAT_RATSTARS) = 5 THEN 'Excellent Service'
 WHEN AVG(r.RAT_RATSTARS) > 4 THEN 'Good Service'
 WHEN AVG(r.RAT_RATSTARS) > 2 THEN 'Average Service'
 ELSE 'Poor Service'
END As 'Type_of_Service'
from `order` o
INNER JOIN rating r ON r.ORD_ID = o.ORD_ID
INNER JOIN supplier_pricing sp ON sp.Pricing_ID = o.Pricing_ID
INNER JOIN Supplier s ON s.Supp_ID = sp.SUPP_ID
GROUP BY sp.SUPP_ID;
end $$
delimiter ;

CALL Rating_procedure();
 

-- OR

delimiter $$
create procedure Rating_procedure()
begin
select supp_id,supp_name,Avg_rating,
case when Avg_rating =5 then 'Excellent Service'
when Avg_rating > 4 then 'Good Service'
when Avg_rating >2 then 'Average Service'
else 'Poor Service'
end as Type_of_Service from (select sp.supp_id,s.supp_name,avg(r.rat_ratstars) as Avg_rating
from rating as r ,`order` as o,supplier_pricing as sp, supplier as s where r.ord_id = o.ord_id and sp.pricing_id = o.pricing_id and s.supp_id = sp.supp_id group by sp.supp_id ) as T1;
end $$
delimiter ;

call Rating_procedure();
