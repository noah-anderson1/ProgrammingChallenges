-- QUESTION 1 STARTS AT LINE 54

create table marketing_data (
 date datetime,
 campaign_id varchar(50),
 geo varchar(50),
 cost float,
 impressions float,
 clicks float,
 conversions float
);

create table website_revenue (
 date datetime,
 campaign_id varchar(50),
 state varchar(2),
 revenue float
);


create table campaign_info (
 id int not null primary key auto_increment,
 name varchar(50),
 status varchar(50),
 last_updated_date datetime
);


LOAD DATA INFILE '/Users/noahanderson/Downloads/website_revenue.csv'
INTO TABLE website_revenue
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;



LOAD DATA INFILE '/Users/noahanderson/Downloads/marketing_performance.csv'
INTO TABLE marketing_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA INFILE '/Users/noahanderson/Downloads/campaign_info.csv'
INTO TABLE campaign_info
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


select * from marketing_data;

select * from website_revenue;

select * from campaign_info;

-- Question 1: Write a query to get the sum of impressions by day.

select date, sum(impressions) as Daily_Impressions 
from marketing_data 
group by date
order by date;

-- Question 2: Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?

select
  state,
  concat('$', format(sum(revenue), 2)) AS Total_Revenue
from website_revenue
group by state
order by sum(revenue) desc
limit 3;

-- Pt 2 of Q2 - The third best state, Ohio, generated $37,577 in revenue

select
  concat('The third best state, ', state, ', generated $', format(revenue, 2)) as result
from (
  select
    state,
    sum(revenue) as revenue
  from website_revenue
  group by state
  order by revenue desc
  limit 3
) as top_states
order by revenue
limit 1;

-- Question 3: Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.

select
  c.id as Campaign_id,
  c.name as Campaign_Name,
  concat('$', format(md.total_cost, 2)) as Total_Cost,
  md.total_impressions as Total_Impressions,
  md.total_clicks as Total_Clicks,
  concat('$', format(wr.total_revenue, 0)) as Total_Revenue
from campaign_info c
join (
  select
    campaign_id,
    sum(cost) as Total_Cost,
    sum(impressions) as Total_Impressions,
    sum(clicks) as Total_Clicks
  from marketing_data
  group by campaign_id
) md on c.id = md.campaign_id
join (
  select
    campaign_id,
    sum(revenue) as Total_Revenue
  from website_revenue
  group by campaign_id
) wr on c.id = wr.campaign_id
order by Total_Revenue desc;

-- Question 4: Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?

select substring(geo, -2) AS State, 
sum(conversions) as Conversions
from marketing_data
where campaign_id = 99058240
group by State;

-- Georgia generated the most conversions for Campaign5.

-- Question 5: Which campaign was the most effecient, and why?
-- revenues by campaign
select 
c.name, sum(wr.revenue) as revenue
from website_revenue wr
join campaign_info c on c.id = wr.campaign_id
group by campaign_id
order by c.name;

-- costs
select c.name,
sum(md.cost)
from marketing_data md
join campaign_info c on md.campaign_id = c.id
group by campaign_id
order by c.name;

-- conversions/ impressions --> Conversion rate
select c.name,
sum(md.conversions)/sum(md.impressions) as Conversion_Rate
from marketing_data md
join campaign_info c on md.campaign_id = c.id
group by campaign_id
order by c.name;


-- Costs per campaign 
-- Campaign1 $1,390
-- Campaign2 $679
-- Campaign3 $1,976
-- Campaign4 $662 
-- Campaign5 $582

-- profit per campaign 
-- Campaign1 $17,583.83 
-- Campaign2 $38,147.75 
-- Campaign3 $48,175.87 
-- Campaign4 $40,187.31 
-- Campaign5 $44,885.55 

-- Conversion rate Per Campaign
-- Campaign1 .211
-- Campaign2 .222
-- Campaign3 .225
-- Campaign4 .196
-- Campaign5 .304


-- Campaign5 demonstrates the highest level of efficiency, and it warrants additional budget allocation.
-- Despite not achieving the highest overall profit, Campaign5 comes in second place in terms of profit, with Campaign3 leading in this regard. However, it significantly outperforms all other campaigns with the highest conversion rate.
-- Campaign5 has maintained the lowest costs while achieving the second-highest profit and the top conversion rate. Expanding the investment in this campaign is poised to further enhance profitability.

-- Bonus Question #6: Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.

select
  dayname(md.date) as Day_Of_The_Week,
  format(avg(md.conversions / md.impressions), 4) as Conversion_Rate
from marketing_data md
join campaign_info c on md.campaign_id = c.id
group by Day_Of_The_Week
order by conversion_rate desc;



