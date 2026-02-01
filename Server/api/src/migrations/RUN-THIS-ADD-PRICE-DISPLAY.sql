-- 立即执行：修复 "column venue.price_display does not exist"
-- 在 Railway 数据库 → Data → Query 中粘贴并执行（或本地 psql 执行此文件）

ALTER TABLE venue ADD COLUMN IF NOT EXISTS price_display VARCHAR(120) NULL;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS walk_in_price_display VARCHAR(120) NULL;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS full_court_price_display VARCHAR(120) NULL;
