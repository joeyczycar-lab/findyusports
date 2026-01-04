-- 添加是否对外开放字段到 venue 表
ALTER TABLE venue ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT true;

