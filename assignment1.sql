-- create elements

insert into productsSch.products values (1,'computer','electronics',100000),(2,'ram','electronics',10000)
,(3,'mousepad','accesories',1000),(4,'controller', 'accesories',3000);


-- Update and Read

update productsSch.products set category='pc' where product_id=1;


-- Delete

delete from productsSch.products where product_id=3;


-- total quantity from product category

select product_id, count(product_id) from ordersSch.orders group by product_id order by product_id asc;


-- Categories where totoal number of order units are greater than 5

select category from productsSch.products where product_id in (select product_id from ordersSch.orders where quantity > 5);


