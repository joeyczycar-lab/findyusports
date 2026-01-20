-- Railway 数据库迁移脚本
-- 在 Railway 数据库控制台执行以下 SQL 语句

-- 1. 添加场地数量字段
ALTER TABLE venue ADD COLUMN IF NOT EXISTS court_count INTEGER;

-- 2. 添加场地设施字段
ALTER TABLE venue ADD COLUMN IF NOT EXISTS floor_type VARCHAR(50);
ALTER TABLE venue ADD COLUMN IF NOT EXISTS open_hours VARCHAR(200);
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_lighting BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_air_conditioning BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_parking BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_rest_area BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS supports_walk_in BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS supports_full_court BOOLEAN;

