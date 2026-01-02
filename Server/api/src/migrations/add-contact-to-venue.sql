-- 添加联系方式字段到 venue 表
ALTER TABLE venue ADD COLUMN IF NOT EXISTS contact VARCHAR(100);

