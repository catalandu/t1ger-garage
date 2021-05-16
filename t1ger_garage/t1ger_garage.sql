ALTER TABLE `owned_vehicles`
ADD `state` tinyint(1) NOT NULL DEFAULT 1 AFTER `owner`, 
ADD `fuel` decimal(11, 2) NOT NULL DEFAULT 50 AFTER `vehicle`,
ADD `garage` varchar(50) NULL DEFAULT NULL AFTER `fuel`;

ALTER TABLE `users`
ADD `garageID` INT(11) NOT NULL DEFAULT 0;

CREATE TABLE `t1ger_garage` (
	`garageID` INT(11),
    `vehicles` longtext NOT NULL DEFAULT '[{"id":1,"plate":false},{"id":2,"plate":false},{"id":3,"plate":false},{"id":4,"plate":false},{"id":5,"plate":false},{"id":6,"plate":false},{"id":7,"plate":false},{"id":8,"plate":false},{"id":9,"plate":false},{"id":10,"plate":false}]',
	PRIMARY KEY (`garageID`)
);
