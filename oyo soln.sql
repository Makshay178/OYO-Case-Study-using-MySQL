create database oyo;
use oyo;

create table oyo_hotels(
booking_id int,
customer_id int,
status_ varchar(100),
check_in char(50),
check_out char(50),
no_of_rooms int,
hotel_id int,
amount int,
discount int,
date_of_booking char(50)
);

create table oyo_city(
Hotel_id int,
City varchar(50)
);
select * from oyo_hotels;

alter table oyo_hotels add column newcheck_in date;
update oyo_hotels set newcheck_in = str_to_date(check_in,"%d-%m-%Y");

alter table oyo_hotels add column newcheck_out date;
update oyo_hotels set newcheck_out = str_to_date(check_out,"%d-%m-%Y");

alter table oyo_hotels add column newdate_of_booking date;
update oyo_hotels set newdate_of_booking = str_to_date(date_of_booking,"%d-%m-%Y");

alter table oyo_hotels
drop column date_of_booking;

alter table oyo_hotels
drop column check_in;

alter table oyo_hotels
drop column check_out;

/*No of hotels in the dataset*/

select count(distinct(hotel_id)) from oyo_city;

/* No of cities in the dataset*/

select count(distinct(city)) from oyo_city;

/* No of hotels in different cities*/
select city,count(distinct(hotel_id)) from oyo_city
group by city
order by count(distinct(hotel_id)) desc;


alter table oyo_hotels add column price int; 
update oyo_hotels set price = amount+discount;

alter table oyo_hotels add column no_of_nights int;
update oyo_hotels set no_of_nights=datediff(newcheck_out,newcheck_in);

/* new column rate addedd*/

alter table oyo_hotels add column rate float;
update oyo_hotels set rate = round(if(no_of_rooms=1,price/no_of_nights,(price/no_of_nights)/no_of_rooms),2);

select * from oyo_hotels;

/*average room rate per city*/

select city,round(avg(rate),2) avg_rate from oyo_hotels inner join oyo_city 
on
oyo_hotels.Hotel_id = oyo_city.Hotel_id
group by city
order by 2 desc;

/*cancellation rate per city*/
select city,count(*) cancellation_rate from oyo_hotels inner join oyo_city 
on oyo_hotels.Hotel_id = oyo_city.Hotel_id
where status_ = "Cancelled"
group by city
order by 2 desc;

/*booking by months jan feb,march*/

select city,monthname(newdate_of_booking) as month,count(booking_id) as count from oyo_hotels inner join oyo_city on oyo_hotels.Hotel_id = oyo_city.Hotel_id
where month(newdate_of_booking) in (1,2,3)
group by city, monthname(newdate_of_booking)
order by city,month(newdate_of_booking);

select count(customer_id) from oyo_hotels 
where no_of_nights>5;

/* how many days prior bookings were made */

select datediff(newcheck_in,newdate_of_booking) as date_diff,count(*) as count from oyo_hotels 
group by 1
order by 1; 

