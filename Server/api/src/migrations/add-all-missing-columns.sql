-- 完整的数据库迁移脚本（含 price_display / walk_in_price_display / full_court_price_display）
-- 在数据库控制台执行此脚本，添加所有可能缺失的列
-- 使用 IF NOT EXISTS 确保不会重复添加已存在的列

-- 1. 添加场地数量字段
ALTER TABLE venue ADD COLUMN IF NOT EXISTS court_count INTEGER;

-- 2. 添加场地设施字段
ALTER TABLE venue ADD COLUMN IF NOT EXISTS floor_type VARCHAR(50);
ALTER TABLE venue ADD COLUMN IF NOT EXISTS open_hours VARCHAR(200);
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_lighting BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_air_conditioning BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_parking BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_rest_area BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_fence BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_shower BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_locker BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS has_shop BOOLEAN;

-- 3. 添加价格文字列（主价格、散客、包场）
ALTER TABLE venue ADD COLUMN IF NOT EXISTS price_display VARCHAR(120) NULL;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS walk_in_price_display VARCHAR(120) NULL;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS full_court_price_display VARCHAR(120) NULL;

-- 4. 添加散客和包场相关字段
ALTER TABLE venue ADD COLUMN IF NOT EXISTS supports_walk_in BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS supports_full_court BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS walk_in_price_min INTEGER;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS walk_in_price_max INTEGER;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS full_court_price_min INTEGER;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS full_court_price_max INTEGER;

-- 5. 添加预约相关字段
ALTER TABLE venue ADD COLUMN IF NOT EXISTS requires_reservation BOOLEAN;
ALTER TABLE venue ADD COLUMN IF NOT EXISTS reservation_method VARCHAR(200);

-- 6. 添加几人制字段
ALTER TABLE venue ADD COLUMN IF NOT EXISTS players_per_side VARCHAR(20);

-- 验证：查询所有列，确认已添加
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'venue' 
AND column_name IN (
  'court_count', 'floor_type', 'open_hours',
  'has_lighting', 'has_air_conditioning', 'has_parking',
  'has_rest_area', 'has_fence', 'has_shower', 'has_locker', 'has_shop',
  'price_display', 'walk_in_price_display', 'full_court_price_display',
  'supports_walk_in', 'supports_full_court',
  'walk_in_price_min', 'walk_in_price_max',
  'full_court_price_min', 'full_court_price_max',
  'requires_reservation', 'reservation_method', 'players_per_side'
)
ORDER BY column_name;
