-- 为 venue 表增加价格文字列（主价格、散客、包场）
-- 执行方式：在 Railway 数据库控制台或本地 psql 中执行此文件

ALTER TABLE venue
ADD COLUMN IF NOT EXISTS price_display VARCHAR(120) NULL;

ALTER TABLE venue
ADD COLUMN IF NOT EXISTS walk_in_price_display VARCHAR(120) NULL;

ALTER TABLE venue
ADD COLUMN IF NOT EXISTS full_court_price_display VARCHAR(120) NULL;

COMMENT ON COLUMN venue.price_display IS '价格文字描述，如 50元/小时、面议';
COMMENT ON COLUMN venue.walk_in_price_display IS '散客价格文字，如 50元/小时、面议';
COMMENT ON COLUMN venue.full_court_price_display IS '包场价格文字，如 面议';
