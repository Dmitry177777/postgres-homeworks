-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)

select  Customers.company_name,  CONCAT(Employees.first_name, ' ', Employees.last_name) as ФИО,  Shippers.company_name
from orders Join customers USING (customer_id)
Join employees USING (employee_id)
Join shippers on  Orders.ship_via = Shippers.shipper_id
where Customers.city ='London' and Employees.city ='London' and Shippers.company_name  = 'United Package'


-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.

select  Products.product_name, Products.units_in_stock, Suppliers.contact_name, Suppliers.phone,  Products.discontinued, Categories.category_name
from products Join suppliers USING (supplier_id)
Join categories USING (category_id)
-- Join shippers on  Orders.ship_via = Shippers.shipper_id
where Products.discontinued = 0
and Products.units_in_stock < 25
and (Categories.category_name  = 'Dairy Products' or Categories.category_name  = 'Condiments')
order by Products.units_in_stock

-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
select Customers.company_name
from customers FULL OUTER Join orders USING (customer_id)
where order_id IS NULL

-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.

select DISTINCT Products.product_name
from products
where product_id in (
	select product_id
	from order_details
	where Order_details.quantity = 10)

-- 4. Вариант с использованием Join

select DISTINCT Products.product_name, Order_details.quantity
from products Join order_details USING (product_id)
where Order_details.quantity = 10