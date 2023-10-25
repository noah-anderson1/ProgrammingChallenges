`marketing_performance` contains daily ad spend and performance metrics -- impression, clicks, and conversions -- by campaign_id and location:
```sql
create table marketing_data (
 date datetime,
 campaign_id varchar(50),
 geo varchar(50),
 cost float,
 impressions float,
 clicks float,
 conversions float
);
```

`website_revenue` contains daily website revenue data by campaign_id and state:
```sql
create table website_revenue (
 date datetime,
 campaign_id varchar(50),
 state varchar(2),
 revenue float
);
```

`campaign_info` contains attributes for each campaign:
```sql
create table campaign_info (
 id int not null primary key auto_increment,
 name varchar(50),
 status varchar(50),
 last_updated_date datetime
);
```


