select
	string_agg(value, '') as "message"
from (
	select
		id,
		chr(value) as value
	from (
			select id, value
			from letters_a
			union
			select id, value
			from letters_b
		)
	where (
		value >= ascii('a')
	and
		value <= ascii('z')
	) or (
		value >= ascii('A')
	and
		value <= ascii('Z')
	) or (
		value in (
			ascii(' '),
			ascii('!'),
			ascii('"'),
			ascii(''''),
			ascii('('),
			ascii(')'),
			ascii(','),
			ascii('-'),
			ascii('.'),
			ascii(':'),
			ascii(';'),
			ascii('?')
		)
	)
	order by
		id
);
