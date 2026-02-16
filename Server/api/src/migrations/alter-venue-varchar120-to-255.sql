-- 解决 "value too long for type character varying(120)" 错误
-- 将 venue 表中长度为 120 的字符串列扩展为 255，避免用户输入较长内容时报错
-- 执行方式: psql $DATABASE_URL -f src/migrations/alter-venue-varchar120-to-255.sql

ALTER TABLE venue ALTER COLUMN name TYPE character varying(255);
ALTER TABLE venue ALTER COLUMN price_display TYPE character varying(255);
ALTER TABLE venue ALTER COLUMN walk_in_price_display TYPE character varying(255);
ALTER TABLE venue ALTER COLUMN full_court_price_display TYPE character varying(255);
ALTER TABLE venue ALTER COLUMN players_per_side TYPE character varying(255);
