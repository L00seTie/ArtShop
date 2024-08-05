/*
Robin Johnson
4/29/24

This script creates the store's database
*/

IF EXISTS (SELECT 1
FROM sys.databases
WHERE name = 'may2151868')
    PRINT 'Database exists.';
ELSE
    CREATE DATABASE may2151868;