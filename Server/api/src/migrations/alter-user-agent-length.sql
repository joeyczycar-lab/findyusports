-- 修改 user_agent 字段长度以支持更长的 User-Agent 字符串
ALTER TABLE page_view ALTER COLUMN user_agent TYPE VARCHAR(500);


