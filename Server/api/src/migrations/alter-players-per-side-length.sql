-- 几人制多选时如 "5人制、7人制、8人制、9人制、11人制" 超过 varchar(20)，导致 value too long
-- 将 players_per_side 扩展为 varchar(120)
ALTER TABLE venue
  ALTER COLUMN players_per_side TYPE character varying(120);

\echo 'Migration OK: players_per_side 已改为 varchar(120)'
