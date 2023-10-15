create schema kickstarter;
use kickstarter;


drop table campaign;
create table if not exists campaign(
	id INT not null,
  `name` VARCHAR(255),
  sub_category_id INT,
  country_id INT,
	currency_id INT,
  launched datetime,
  deadline datetime,
  goal float,
  pledged float,
  backers int,
  outcome varchar(255),
  primary key (id)
);

desc campaign;

LOAD DATA LOCAL INFILE '/Users/wells_wang/Library/Mobile Documents/com~apple~CloudDocs/BrainStation/DS/AdmissionChallenge/Data/campaign.csv'
INTO TABLE campaign
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

drop table country;
create table if not exists country(
	id int not null,
  `name` varchar(10),
  primary key (id)
);



LOAD DATA LOCAL INFILE '/Users/wells_wang/Library/Mobile Documents/com~apple~CloudDocs/BrainStation/DS/AdmissionChallenge/Data/country.csv'
INTO TABLE country
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


drop table currency;
create table if not exists currency(
	id int not null,
  `name` varchar(10),
  primary key (id)
);


LOAD DATA LOCAL INFILE '/Users/wells_wang/Library/Mobile Documents/com~apple~CloudDocs/BrainStation/DS/AdmissionChallenge/Data/currency.csv'
INTO TABLE currency
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

drop table category;
create table if not exists category(
	id int not null,
  `name` varchar(50),
  primary key (id)
);


LOAD DATA LOCAL INFILE '/Users/wells_wang/Library/Mobile Documents/com~apple~CloudDocs/BrainStation/DS/AdmissionChallenge/Data/category.csv'
INTO TABLE category
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

drop table sub_category;
create table if not exists sub_category(
	id int not null,
  `name` varchar(50),
  category_id int not null,
  primary key (id)
);


LOAD DATA LOCAL INFILE '/Users/wells_wang/Library/Mobile Documents/com~apple~CloudDocs/BrainStation/DS/AdmissionChallenge/Data/sub_category.csv'
INTO TABLE sub_category
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

