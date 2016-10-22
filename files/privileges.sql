-- public
GRANT USAGE on SCHEMA public to gislabusers;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO gislabusers;

-- dibavod
GRANT USAGE on SCHEMA dibavod to gislabusers;
GRANT SELECT ON ALL TABLES IN SCHEMA dibavod TO gislabusers;

-- osm
GRANT USAGE on SCHEMA osm to gislabusers;
GRANT SELECT ON ALL TABLES IN SCHEMA osm TO gislabusers;

-- rastry
GRANT USAGE on SCHEMA rastry to gislabusers;
GRANT SELECT ON ALL TABLES IN SCHEMA rastry TO gislabusers;

-- ruian
GRANT USAGE on SCHEMA ruian to gislabusers;
GRANT SELECT ON ALL TABLES IN SCHEMA ruian TO gislabusers;

-- ruian_praha
GRANT USAGE on SCHEMA ruian_praha to gislabusers;
GRANT SELECT ON ALL TABLES IN SCHEMA ruian_praha TO gislabusers;

-- csu_sldb
GRANT USAGE on SCHEMA csu_sldb to gislabusers;
GRANT SELECT ON ALL TABLES IN SCHEMA csu_sldb TO gislabusers;

-- slhp
GRANT USAGE on SCHEMA slhp to gislabusers;
GRANT SELECT ON ALL TABLES IN SCHEMA slhp TO gislabusers;

-- ochrana_uzemi
GRANT USAGE on SCHEMA ochrana_uzemi to gislabusers;
GRANT SELECT ON ALL TABLES IN SCHEMA ochrana_uzemi TO gislabusers;

-- jizera
GRANT USAGE on SCHEMA jizera to gislabusers;
GRANT SELECT ON ALL TABLES IN SCHEMA jizera TO gislabusers;

-- revoke priviliges on public
REVOKE CREATE ON SCHEMA public FROM gislabusers;
REVOKE CREATE ON DATABASE gismentors FROM gislabusers;
REVOKE ALL ON SCHEMA public FROM gislabusers;
