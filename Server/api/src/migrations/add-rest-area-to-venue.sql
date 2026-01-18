-- 添加休息区字段到 venue 表
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_rest_area BOOLEAN;
