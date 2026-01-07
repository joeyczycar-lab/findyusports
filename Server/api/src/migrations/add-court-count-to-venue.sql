-- 添加场地数量字段到 venue 表
ALTER TABLE venue ADD COLUMN IF NOT EXISTS court_count INTEGER;

