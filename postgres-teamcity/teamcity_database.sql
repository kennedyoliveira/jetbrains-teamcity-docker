-- Creates the teamcity user
create role teamcity with login password 'teamcity';

-- Creates the teamcity database
create database teamcity owner teamcity;