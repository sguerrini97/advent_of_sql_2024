-- View for previous tags
create view previous_toy_tags
as
	select
		toy_id,
		unnest(previous_tags) as "tag"
	from
		toy_production;

-- View for new tags
create view new_toy_tags
as
	select
		toy_id,
		unnest(new_tags) as "tag"
	from
		toy_production;

-- View for unchanged tags
create view unchanged_tags
as
	select
		ptt.toy_id,
		array_agg(ptt.tag) as tags
	from
		previous_toy_tags ptt
	join
		new_toy_tags ntt on ptt.toy_id = ntt.toy_id and ptt.tag = ntt.tag
	group by
		ptt.toy_id;

-- View for added tags
create view added_tags
as
	select
		ntt.toy_id,
		array_agg(ntt.tag) as tags
	from
		new_toy_tags ntt
	left join
		previous_toy_tags ptt on ptt.toy_id = ntt.toy_id and ptt.tag = ntt.tag
	where
		ptt.tag is null
	group by
		ntt.toy_id;

-- View for removed tags
create view removed_tags
as
	select
		ptt.toy_id,
		array_agg(ptt.tag) as tags
	from
		previous_toy_tags ptt
	left join
		new_toy_tags ntt on ptt.toy_id = ntt.toy_id and ptt.tag = ntt.tag
	where
		ntt.tag is null
	group by
		ptt.toy_id;

-- Report query
select
	tp.toy_id,
	tp.toy_name,
	at.tags as "added_tags",
	ut.tags as "unchanged_tags",
	rt.tags as "removed_tags"
from
	toy_production tp
left join
	added_tags at on at.toy_id = tp.toy_id
left join
	unchanged_tags ut on ut.toy_id = tp.toy_id
left join
	removed_tags rt on rt.toy_id = tp.toy_id;

-- Query for the answer
select
	tp.toy_id,
	tp.toy_name,
	coalesce(cardinality(at.tags), 0) as "added_tags",
	coalesce(cardinality(ut.tags), 0) as "unchanged_tags",
	coalesce(cardinality(rt.tags), 0) as "removed_tags"
from
	toy_production tp
left join
	added_tags at on at.toy_id = tp.toy_id
left join
	unchanged_tags ut on ut.toy_id = tp.toy_id
left join
	removed_tags rt on rt.toy_id = tp.toy_id
order
	added_tags desc
limit 1;
