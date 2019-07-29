-- Store hosts, groups and group children
CREATE TABLE MyGroups (
        ID SERIAL PRIMARY KEY NOT NULL,
        grp TEXT,
        name TEXT,
        type TEXT
);

-- Store variables
CREATE TABLE vars (
	id SERIAL PRIMARY KEY NOT NULL,
	name TEXT,
	type TEXT,
	key TEXT,
	value TEXT
);
