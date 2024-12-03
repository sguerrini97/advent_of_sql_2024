select
	c.country,
	c.city,
	count(distinct c.child_id) as "children",
	avg(c.naughty_nice_score) as "nns"
from
	children c
join
	christmaslist cl on c.child_id = cl.child_id -- must have received a gift
group by
	c.country, c.city
having
	count(distinct c.child_id) >= 5 -- at least 5 children in the city
order by
	nns desc
limit 5;
