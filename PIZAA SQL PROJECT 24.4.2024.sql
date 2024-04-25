SELECT * FROM pizzahut.orders;

create table orders (
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id) );

create table order_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null ,
quantity int  not null,
primary key(order_details_id) );


-- basic level question

-- Retrieve the total number of orders placed.
 
 select * from orders;
 select count(order_id) as total_orders from orders;
 
 -- Calculate the total revenue generated from pizza sales.
 
 SELECT ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_sales
FROM order_details
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.

SELECT pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC limit 1;

-- Identify the most common pizza size ordered.

select quantity,count(order_details_id)
from order_details group by quantity; 

select pizzas.size,count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas. size order by order_count desc;

-- List the top 5 most ordered pizza types along with their quantities.

  SELECT pizza_types.name AS pizza_type, SUM(order_details.quantity) AS total_quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY total_quantity DESC
LIMIT 5;

-- Intermediate level question

-- Join the necessary tables to find the 
-- total quantity of each pizza category ordered

SELECT pizza_types.category,
       SUM(order_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;

-- Determine the distribution of orders by hour of the day.

SELECT EXTRACT(HOUR FROM order_time) AS order_hour,
       COUNT(*) AS order_count
FROM orders
GROUP BY order_hour
ORDER BY order_hour;

-- Join relevant tables to find the category-wise distribution of pizzas.

select category ,count(name) from pizza_types
group by category

-- Group the orders by date and calculate the average
-- number of pizzas ordered per day.

select round(avg(quantity),0) from
(select orders.order_date, sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id =order_details.order_id
group by orders.order_date) as  order_quantity ;

-- Determine the top 3 most ordered pizza types based on revenue.

SELECT pt.name AS pizza_type,
       SUM(od.quantity * p.price) AS revenue
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pizza_type
ORDER BY revenue DESC
LIMIT 3;

-- advanced level question

-- Calculate the percentage contribution of each 
-- pizza type to total revenue.

select pizza_types.category,
sum(order_details.quantity* pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;

-- Analyze the cumulative revenue generated over time.

select order_date,
 sum(revenue) over(order by order_date) as cum_revenue
 from
(select orders.order_date,
sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.order_date) as sales   ;

 -- Determine the top 3 most ordered pizza types
 -- based on revenue for each pizza category.

select name,revenue from
(select category,name,revenue,
rank() over(partition by category order by revenue desc) as rn
from 
(select pizza_types.category,pizza_types.name,
sum((order_details.quantity) * pizzas.price) as revenue
from pizza_types join pizzas 
on  pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on order_details.pizza_id  = pizzas.pizza_id
group by pizza_types.category,pizza_types.name) as a) as b; 
where rn <= 3;




