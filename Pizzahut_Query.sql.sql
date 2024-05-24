Basic:
Q1. Retrieve the total number of orders placed.
 
select * from orders;
select count(order_id) as total_orders 
from orders;


Q2. Calculate the total revenue generated from pizza sales.

select round(sum(order_details.quantity * pizzas.price),2) AS total_sales
from order_details
join 
pizzas ON order_details.pizza_id = pizzas.pizza_id; 

Q3. Identify the highest-priced pizza.

select * from pizzas;
select * from pizza_types;
select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc
limit 1;

Q4. Identify the most common pizza size ordered.


select pizzas.size,count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by order_count desc;

Q5. List the top 5 most ordered pizza types along with their quantities.

select pizza_types.name, sum(order_details.quantity) as quantity
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id= pizzas.pizza_id
group by pizza_types.name
order by quantity desc
limit 5;


Intermediate:
Q6. Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity) as quantity
from pizza_types
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id= pizzas.pizza_id
group by pizza_types.category
order by quantity desc;

Q7. Determine the distribution of orders by hour of the day.

select hour(time),count(order_id) as order_count 
from orders
group by hour(time);

Q8. Join relevant tables to find the category-wise distribution of pizzas.


select category, count(name) from pizza_types
group by category;

Q9. Group the orders by date and calculate the average number of pizzas ordered per day.

select avg(order_count) from 
(select orders.date , sum(order_details.quantity) as order_count 
from orders
join order_details
on orders.order_id= order_details.order_id
group by orders.date)as quantity ;

OR

select round(avg(order_count),0) from 
(select orders.date , sum(order_details.quantity) as order_count 
from orders
join order_details
on orders.order_id= order_details.order_id
group by orders.date)as quantity ;


Q10.Determine the top 3 most ordered pizza types based on revenue.


select  pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue
from pizza_types
join pizzas 
on pizzas.pizza_type_id= pizza_types.pizza_type_id 
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by revenue desc limit 3;

Advanced:
Q11. Calculate the percentage contribution of each pizza type to total revenue.

Step for % contribution: each category sale /total sales*100

select pizza_types.category, 
round(sum(order_details.quantity * pizzas.price) / 
(Select ROUND(SUM(order_details.quantity * pizzas.price),
		2)  AS total_sales
FROM order_details
JOIN
pizzas ON order_details.pizza_id = pizzas.pizza_id )* 100,2)as revenue
from pizza_types
join pizzas 
on pizzas.pizza_type_id= pizza_types.pizza_type_id 
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by revenue desc;


OR 

select pizza_types.category, 
sum(order_details.quantity * pizzas.price) /817860.05* 100 as revenue
from pizza_types
join pizzas 
on pizzas.pizza_type_id= pizza_types.pizza_type_id 
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by revenue desc;


Q12. Analyze the cumulative revenue generated over time.

select date, sum(revenue) over (order by date) as cum_revenue 
from
(select orders.date, 
sum(order_details.quantity *pizzas.price)as revenue
from order_details
join pizzas
on order_details.pizza_id=pizzas.pizza_id
join orders
on orders.order_id= order_details.order_id
group by orders.date)as sales;

source:  https://github.com/Ayushi0214/pizza-s...
Thank You!