-- View to convert catalogue data to report data
create view toy_catalogue_improved
as
	select
		toy_name,
		case category
			when 'outdoor' then 'Outside Workshop'
			when 'educational' then 'Learning Workshop'
			else 'General Workshop'
		end as "workshop",
		case difficulty_to_make
			when 1 then 'Simple Gift'
			when 2 then 'Moderate Gift'
			else 'Complex Gift'
		end as "difficulty"
from
	toy_catalogue;

-- View to extract relevant information from JSON
create view wish_lists_improved
as
	select
		list_id,
		child_id,
		wishes::jsonb->'colors'->0 #>> '{}' as "color",
		wishes::jsonb->'first_choice' #>> '{}' as "primary",
		wishes::jsonb->'second_choice' #>> '{}' as "backup",
		jsonb_array_length(wishes::jsonb->'colors') as "color_count"
from
	wish_lists;

-- report query
-- name,primary_wish,backup_wish,favorite_color,color_count,gift_complexity,workshop_assignment
select
	c.name,
	wl.primary,
	wl.backup,
	wl.color,
	wl.color_count,
	tc_p.difficulty,
	tc_p.workshop
from
	children c
join
	wish_lists_improved wl on wl.child_id = c.child_id
left join
	toy_catalogue_improved tc_p on tc_p.toy_name = wl.primary
left join
	toy_catalogue_improved tc_b on tc_b.toy_name = wl.backup
order by
	c.name
limit 5;
