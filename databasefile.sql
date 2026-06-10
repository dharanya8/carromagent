-- create table users(
-- userid int primary key,
-- name varchar(250) not null,
-- dateofbirth date not null,
-- mobilenumber varchar(200),
-- )
-- alter table users add column sportsregistrered varchar(200)

create table userdetails(
userid serial primary key,
name varchar(250) not null,
dateofbirth date not null,
mobilenumber varchar(200),
sportregsitered varchar(200)
)