SELECT * FROM pizzahut.pizza_types;

create table orders (
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id) );

