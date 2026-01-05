-- 添加区级代码字段到 venue 表
ALTER TABLE venue ADD COLUMN IF NOT EXISTS district_code VARCHAR(6);
