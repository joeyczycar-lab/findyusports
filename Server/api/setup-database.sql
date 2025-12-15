-- 创建数据库（如果不存在）
SELECT 'CREATE DATABASE venues'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'venues')\gexec

-- 连接到 venues 数据库
\c venues

-- 启用 PostGIS 扩展
CREATE EXTENSION IF NOT EXISTS postgis;

-- 验证 PostGIS 是否安装成功
SELECT PostGIS_version();


