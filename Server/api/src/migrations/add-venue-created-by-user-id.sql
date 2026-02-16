-- 记录场地创建者，用于「仅展示我的账号上传的场地」
-- 执行: psql $DATABASE_URL -f src/migrations/add-venue-created-by-user-id.sql

ALTER TABLE venue ADD COLUMN IF NOT EXISTS created_by_user_id integer NULL;
COMMENT ON COLUMN venue.created_by_user_id IS '创建该场地的用户 id，NULL 表示历史数据或未登录创建';
