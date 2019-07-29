-- Store hosts, groups and group children
CREATE TABLE MyGroups (
	`id` INTEGER NOT NULL AUTO_INCREMENT,
	`group` TEXT,
	`name` TEXT,
	`type` TEXT,
	PRIMARY KEY (`id`)
);

-- Store variables
CREATE TABLE vars (
	`id` INTEGER NOT NULL AUTO_INCREMENT,
	`name` TEXT,
	`type` TEXT,
	`key` TEXT,
	`value` TEXT,
	PRIMARY KEY (`id`)
);
