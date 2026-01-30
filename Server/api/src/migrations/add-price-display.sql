-- 为 venue 表增加 price_display 列，用于存储价格文字描述（如 "50元/小时"、"面议"）
-- 执行方式：在 Railway 数据库控制台或本地 psql 中执行此文件

ALTER TABLE venue
ADD COLUMN IF NOT EXISTS price_display VARCHAR(120) NULL;

COMMENT ON COLUMN venue.price_display IS '价格文字描述，如 50元/小时、面议';
