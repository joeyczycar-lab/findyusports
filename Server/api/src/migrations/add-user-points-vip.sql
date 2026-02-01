-- 用户积分与 VIP 字段
ALTER TABLE "user" ADD COLUMN IF NOT EXISTS points integer DEFAULT 0;
ALTER TABLE "user" ADD COLUMN IF NOT EXISTS is_vip boolean DEFAULT false;
