-- 创建页面访问统计表
CREATE TABLE IF NOT EXISTS page_view (
  id SERIAL PRIMARY KEY,
  path VARCHAR(200) NOT NULL,
  page_type VARCHAR(50),
  referer VARCHAR(200),
  user_agent VARCHAR(50),
  ip VARCHAR(45),
  user_id VARCHAR(50),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_page_view_path ON page_view(path);
CREATE INDEX IF NOT EXISTS idx_page_view_created_at ON page_view(created_at);
CREATE INDEX IF NOT EXISTS idx_page_view_page_type ON page_view(page_type);

