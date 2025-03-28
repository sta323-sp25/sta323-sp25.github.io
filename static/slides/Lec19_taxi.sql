## Demo

# https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
# https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv

### Basics
.timer on

SELECT count(*) FROM read_parquet("/data/nyctaxi/yellow_*.parquet");

DESCRIBE SELECT * FROM read_parquet("/data/nyctaxi/yellow_*.parquet");

CREATE VIEW taxi AS SELECT * FROM read_parquet("/data/nyctaxi/yellow_*.parquet");

### Tip percentage

SELECT avg(tip_amount / fare_amount) AS mean_tip_frac, payment_type 
  FROM taxi
  GROUP BY payment_type
  ORDER BY payment_type;


SELECT min(fare_amount), max(fare_amount) 
  FROM read_parquet("/data/nyctaxi/yellow_*.parquet");

SUMMARIZE SELECT fare_amount FROM FROM read_parquet("/data/nyctaxi/yellow_*.parquet");

SELECT round(avg(tip_amount / fare_amount),4) AS mean_tip_frac, payment_type 
  FROM taxi
  WHERE tip_amount >= 0 AND fare_amount > 0 
  GROUP BY payment_type 
  ORDER BY payment_type;


### Cost per mile

SELECT 
    PULocationID pickup_zone,
    AVG(fare_amount / trip_distance) fare_per_mile,
    COUNT(*) num_rides 
FROM taxi
WHERE trip_distance > 0
GROUP BY PULocationID
ORDER BY PULocationID;


SELECT * FROM (
  SELECT 
    PULocationID pickup_zone,
    AVG(fare_amount / trip_distance) fare_per_mile,
    COUNT(*) num_rides 
  FROM taxi
  WHERE trip_distance > 0
  GROUP BY PULocationID
  ORDER BY PULocationID
) NATURAL LEFT JOIN (
 SELECT LocationID AS pickup_zone, * FROM read_csv("/data/nyctaxi/taxi_zone_lookup.csv")
) ORDER BY fare_per_mile DESC;
