-- List all possible event versions
select distinct
	(xpath('name(/*)', menu_data))[1]::text as "event",
	(xpath('/*/@version', menu_data))[1]::text as "version"
from
	christmas_menus;

/**
 * Possible events:
 *
 *        event        | version
 * --------------------+---------
 *  christmas_feast    | 2.0
 *  polar_celebration  | 3.0
 *  northpole_database | 1.0
 */

/**
 * Events structure:
 *
 * northpole_database 1.0
 *  seat count:
 *    - /northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count
 *  food item id:
 *    - /northpole_database/annual_celebration/event_metadata/menu_items/food_category/food_category/dish/food_item_id
 *
 * christmas_feast 2.0
 *  seat count:
 *    - /christmas_feast/organizational_details/attendance_record/total_guests
 *  food item id:
 *    - /christmas_feast/organizational_details/menu_registry/course_details/dish_entry/food_item_id
 *
 * polar_celebration 3.0
 *  seat count:
 *    - /polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present
 *  food item id:
 *    - /polar_celebration/event_administration/culinary_records/menu_analysis/item_performance/food_item_id
 */

-- View for v1.0 events
create view christmas_menu_1
as
	select
		id,
		(xpath('/northpole_database/annual_celebration/event_metadata/dinner_details/guest_registry/total_count/text()', menu_data))[1]::text::integer as "guests",
		(xpath('/northpole_database/annual_celebration/event_metadata/menu_items/food_category/food_category/dish/food_item_id/text()', menu_data))::text[]::integer[] as "food_item_ids"
	from
		christmas_menus
	where
		(xpath('name(/*)', menu_data))[1]::text = 'northpole_database';

-- View for v2.0 events
create view christmas_menu_2
as
	select
		id,
		(xpath('/christmas_feast/organizational_details/attendance_record/total_guests/text()', menu_data))[1]::text::integer as "guests",
		(xpath('/christmas_feast/organizational_details/menu_registry/course_details/dish_entry/food_item_id/text()', menu_data))::text[]::integer[] as "food_item_ids"
	from
		christmas_menus
	where
		(xpath('name(/*)', menu_data))[1]::text = 'christmas_feast';

-- View for v3.0 events
create view christmas_menu_3
as
	select
		id,
		(xpath('/polar_celebration/event_administration/participant_metrics/attendance_details/headcount/total_present/text()', menu_data))[1]::text::integer as "guests",
		(xpath('/polar_celebration/event_administration/culinary_records/menu_analysis/item_performance/food_item_id/text()', menu_data))::text[]::integer[] as "food_item_ids"
	from
		christmas_menus
	where
		(xpath('name(/*)', menu_data))[1]::text = 'polar_celebration';

-- Analyze food_item_id frequency for dinners with more than 78 guests
select
	food_item_id,
	count(*) as "frequency"
from (
	select
		id,
		guests,
		unnest(food_item_ids) as "food_item_id"
	from
		christmas_menu_1
union
	select
		id,
		guests,
		unnest(food_item_ids) as "food_item_id"
	from
		christmas_menu_2
union
	select
		id,
		guests,
		unnest(food_item_ids) as "food_item_id"
	from
		christmas_menu_3
) christmas_menus
where
	guests > 78
group by
	food_item_id
order by
	frequency desc;

