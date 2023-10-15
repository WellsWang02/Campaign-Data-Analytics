-- =================== 
-- Preprocessing  
-- ===================
-- problems occur trying to load the downloaded csv file into mysql workbench 
-- (saved as comma separated file by default but name columns have comma)

update
	campaign
set 
	`name` =  "Mad About Trivia™ MOVIES Edition, Board Game",
  sub_category_id = 14,
  country_id = 2, 
  currency_id = 2,
  launched = "2012-03-16 00:00:00",
  deadline = "2012-04-15 00:00:00",
  goal = 25000,
  pledged = 28083,
  backers = 20,
  outcome = "successful"
where 
	id = 2800;

update
	campaign
set 
	`name` =  "lifeleash Tourniquets™. Easy to use, built-in medical device",
  sub_category_id = 92,
  country_id = 2, 
  currency_id = 2,
  launched = "2015-08-08 00:00:00",
  deadline = "2015-09-07 00:00:00",
  goal = 100000,
  pledged = 266,
  backers = 6,
  outcome = "suspended"
where 
	id = 6232;
  
update
	campaign
set 
	`name` =  "Rockz!™, an Earbud Accessory",
  sub_category_id = 15,
  country_id = 2, 
  currency_id = 2,
  launched = "2015-05-28 00:00:00",
  deadline = "2015-06-27 00:00:00",
  goal = 1000,
  pledged = 2865,
  backers = 184,
  outcome = "successful"
where 
	id = 13192;
  
update
	campaign
set 
	`name` =  "frames4canvas™ - One piece, slip-on frames for canvas art",
  sub_category_id = 8,
  country_id = 3, 
  currency_id = 3,
  launched = "2016-04-06 00:00:00",
  deadline = "2016-06-05 00:00:00",
  goal = 39221.84,
  pledged = 977.41,
  backers = 10,
  outcome = "failed"
where 
	id = 14760; 
  
-- Insert into campaign
-- values 
-- 	(2800, "Mad About Trivia™ MOVIES Edition, Board Game", 14, 2, 2, "2012-03-16 00:00:00", "2012-04-15 00:00:00", 25000, 28083, 20, "successful"),
-- 	(6232, "lifeleash Tourniquets™. Easy to use, built-in medical device", 92, 2, 2, "2015-08-08 00:00:00", "2015-09-07 00:00:00", 100000, 266, 6, "suspended"),
--   (13192, "Rockz!™, an Earbud Accessory", 15, 2, 2, "2015-05-28 00:00:00", "2015-06-27 00:00:00", 1000, 2865, 184, "successful"),
--   (14760, "frames4canvas™ - One piece, slip-on frames for canvas art", 8, 3, 3, "2016-04-06 00:00:00", "2016-06-05 00:00:00", 39221.84, 977.41, 10, "failed")
-- ;



-- =================== 
--  Preliminary Data Analysis
-- ===================

-- 1. Are the goals for dollars raised significantly different between campaigns that are successful and unsuccessful?

-- Avg_goal_by_campaign_success
select 
    case 
        when outcome = "successful" then 1
        else 0
        end as Success,
    round(avg(goal),2) as avg_goal
from campaign
group by 1
;

-- Avg_goal_by_outcome
select 
    outcome,
    round(avg(goal),2) as avg_goal
from campaign
group by 1
;


-- 2. What are the top/bottom 3 categories with the most backers? 
	-- What are the top/bottom 3 subcategories by backers?

-- Top/Bottom3_category_by_backers

with cte as(
select 
	a.*,
	b.name as sub_category,
	c.name as category
from campaign a
left join sub_category b on
	a.sub_category_id = b.id
left join category c on
	b.category_id = c.id
)

select 
	category,
	sum(backers) as n_backers
from cte
group by 1
order by 2 desc
;

-- Top/Bottom3_sub-category_by_backers

with cte as(
select 
	a.*,
	b.name as sub_category,
	c.name as category
from campaign a
left join sub_category b on
	a.sub_category_id = b.id
left join category c on
	b.category_id = c.id
)

select 
	sub_category,
  round(sum(pledged),2) as total_pledged,
	sum(backers) as n_backers, 
  count(distinct id) as n_campaigns
from cte
group by 1
order by 2 desc
;

-- 3. What are the top/bottom 3 categories that have raised the most money? 
	-- What are the top/bottom 3 subcategories that have raised the most money?

-- Top/Bottom3_category_by_pledged
with cte as(
select 
	a.*,
	b.name as sub_category,
	c.name as category
from campaign a
left join sub_category b on
	a.sub_category_id = b.id
left join category c on
	b.category_id = c.id
)

select 
	category,
	round(sum(pledged),2) as total_pledged
from cte
group by 1
order by 2 desc
;


-- Top/Bottom3_sub_category_by_pledged
with cte as(
select 
	a.*,
	b.name as sub_category,
	c.name as category
from campaign a
left join sub_category b on
	a.sub_category_id = b.id
left join category c on
	b.category_id = c.id
)

select 
	sub_category,
	round(sum(pledged),2) as total_pledged
from cte
group by 1
order by 2 desc
;

-- 4. What was the amount the most successful board game company raised? 
	-- How many backers did they have?


-- Assuming "most successful" is determined by amount of money raised

-- Top10_successful_game
with cte as(
select 
	a.*,
	b.name as sub_category,
	c.name as category
from campaign a
left join sub_category b on
	a.sub_category_id = b.id
left join category c on
	b.category_id = c.id
)

select `name`, goal, pledged, backers
from cte
where outcome = 'successful' and
	sub_category = 'Tabletop Games'
order by pledged desc
limit 3
;

-- 5. Rank the top three countries with the most successful campaigns: 
	-- in terms of dollars (total amount pledged)
	-- in terms of the number of campaigns backed.

-- Top3_country_by_dollars
with cte as(
select 
	a.*,
	b.name as sub_category,
	c.name as category,
	d.name as country
from campaign a
left join sub_category b on
	a.sub_category_id = b.id
left join category c on
	b.category_id = c.id
left join country d on
	a.country_id = d.id
)
, rnk_pledged as(
select 
	country,
	round(sum(pledged),2) as total_pledged, 
  rank()over(order by sum(pledged) desc) as rnk 
from cte
where outcome = 'successful'
group by 1
order by 2 desc
)
select * 
from rnk_pledged
where rnk <=3
;

-- Top3_country_by_Ncampaigns
with cte as(
select 
	a.*,
	b.name as sub_category,
	c.name as category,
	d.name as country
from campaign a
left join sub_category b on
	a.sub_category_id = b.id
left join category c on
	b.category_id = c.id
left join country d on
	a.country_id = d.id
)

select 
	country,
	count(distinct id) as n_campaigns
from cte
where outcome = 'successful'
group by 1
order by 2 desc
;


-- 6. Do longer, or shorter campaigns tend to raise more money? Why?

-- Since functions like datediff, timestampdiff can't be used in this interface, the below approximation was made to determine the duration of the campaign in days
with cte as(
select 
    id, name,
    date(launched) as start, date(deadline) as end,
    365*(strftime('%Y', deadline) - strftime('%Y', launched)) +
    30*(strftime('%m', deadline) - strftime('%m', launched)) +
    strftime('%d', deadline) - strftime('%d', launched) as duration,
    pledged
from campaign
where outcome = 'successful'
)
select 
    case 
        when duration <=30 then '1 month'
        when duration <=60 then '2 months'
        else '3 months'
        end as length,
    round(avg(pledged),2) as avg_pledged
from cte
group by 1 
;

-- using datediff in mysql 
with campaign_length as(
select 
	*,
	cast(datediff(deadline, launched) as char) as duration
from campaign
), 
campaign_length2 as(
select 
	*,
  case
    when duration <= 31 then "1 month"
    when duration <= 62 then "2 months"
    else "3 months"
    end as duration_segment
from campaign_length
)
select 
	duration_segment,
  round(avg(goal),2) as avg_goals,
  round(avg(pledged),2) as avg_raised,
  round(avg(backers)) as avg_backers,
  round(avg(pledged/backers), 2) as cost_per_backers,
  avg(case when outcome = 'successful' then 1 else 0 end ) as success_rate,
  count(distinct id) as n_campaign
from campaign_length2
where 
	-- (outcome = 'successful' or outcome = 'failed') and 
	sub_category_id = 14 and
  goal >= 15000 
	and goal <= 40000
group by 1
order by 1
;

-- Success Rate with Goals
with cte as(
select 
	a.*,
	b.name as sub_category,
	c.name as category,
	d.name as country
from campaign a
left join sub_category b on
	a.sub_category_id = b.id
left join category c on
	b.category_id = c.id
left join country d on
	a.country_id = d.id
)

select 
	case 
		-- when goal < 20000 then "15k"
    when goal < 25000 then "15-20k"
    -- when goal < 30000 then "25k"
    when goal < 35000 then "25-30k"
    -- when goal < 40000 then "35k"
    when goal < 45000 then "35-40k"
    -- when goal < 50000 then "45k"
    else "40k up"
    end as goal_segment,
	round(avg(goal),2) as avg_goals,
  round(avg(pledged),2) as avg_raised,
  round(avg(backers)) as avg_backers,
  round(avg(pledged)/avg(backers), 2) as cost_per_backers,
  avg(case when outcome = 'successful' then 1 else 0 end ) as success_rate,
  count(distinct id) as n_campaign
from cte
where 
	goal >= 15000 and
  sub_category_id = 14
group by 1
order by 1
;

-- Overall success rate
select
	avg(case when outcome = 'successful' then 1 else 0 end ) as success_rate
from campaign
where 
	sub_category_id = 14 
	and goal >= 15000
;



































