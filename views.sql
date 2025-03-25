---Cleaning up country data ,triming data values
update a1phra.country_year_indicators set country = trim(country);
update a1phra.countryscores set country = trim(country);

--Creating a view of country_year_indicators for 
CREATE VIEW LAST_10_COUNTRYINDICATOR AS SELECT * FROM A1PHRA.COUNTRY_YEAR_INDICATORS_PART where YEAR > 2010 AND YEAR <=2020;

---creating datascore view
CREATE VIEW DATASCORE AS SELECT * FROM A1PHRA.countryscores;

--created view on diabetes on data cleaning
