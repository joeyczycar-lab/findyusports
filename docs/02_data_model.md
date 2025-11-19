## 数据模型与表结构（草案）

说明：建议使用 PostgreSQL + PostGIS。若用 MySQL，也需空间索引（POINT、SRID=4326）。

### 实体
- user（用户）
  - id, phone, wechat_openid, nickname, avatar_url, role, status, created_at, updated_at

- venue（场地）
  - id, name, sport_type (basketball|football), description, city_code, district, address,
    location POINT(纬度,经度), price_min, price_max, charging_mode (per_hour|per_session|free),
    open_hours JSON, indoor BOOLEAN, facilities JSON（灯光、停车、淋浴、更衣室等）, surface (wood|turf|concrete|rubber|other),
    images JSON, average_rating, rating_count, audit_status (pending|approved|rejected), audit_reason,
    created_by, created_at, updated_at

- review（点评）
  - id, venue_id, user_id, rating(1-5), content, images JSON, tags JSON, status, created_at

- favorite（收藏）
  - id, user_id, venue_id, created_at

- upload_task（上传任务/媒体）
  - id, user_id, venue_id?, file_key, file_url, status, created_at, width, height, mime

- audit_log（审核日志）
  - id, entity_type (venue|review|media), entity_id, action, operator_id, reason, created_at

### 索引建议
- venue(location) 空间索引 + city_code 普通索引
- review(venue_id), review(user_id)
- favorite(user_id, venue_id) 唯一索引

### 示例DDL（PostgreSQL）
```sql
CREATE TABLE app_user (
  id BIGSERIAL PRIMARY KEY,
  phone VARCHAR(20) UNIQUE,
  wechat_openid VARCHAR(64) UNIQUE,
  nickname VARCHAR(50),
  avatar_url TEXT,
  role VARCHAR(20) DEFAULT 'user',
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE venue (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  sport_type VARCHAR(20) NOT NULL,
  description TEXT,
  city_code VARCHAR(6) NOT NULL,
  district VARCHAR(50),
  address VARCHAR(200),
  location GEOGRAPHY(Point, 4326) NOT NULL,
  price_min INT,
  price_max INT,
  charging_mode VARCHAR(20),
  open_hours JSONB,
  indoor BOOLEAN,
  facilities JSONB,
  surface VARCHAR(20),
  images JSONB,
  average_rating NUMERIC(3,2) DEFAULT 0,
  rating_count INT DEFAULT 0,
  audit_status VARCHAR(20) DEFAULT 'pending',
  audit_reason TEXT,
  created_by BIGINT REFERENCES app_user(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_venue_city ON venue(city_code);
CREATE INDEX idx_venue_loc ON venue USING GIST(geography(location));

CREATE TABLE review (
  id BIGSERIAL PRIMARY KEY,
  venue_id BIGINT REFERENCES venue(id),
  user_id BIGINT REFERENCES app_user(id),
  rating INT CHECK (rating BETWEEN 1 AND 5),
  content TEXT,
  images JSONB,
  tags JSONB,
  status VARCHAR(20) DEFAULT 'visible',
  created_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_review_venue ON review(venue_id);
CREATE INDEX idx_review_user ON review(user_id);

CREATE TABLE favorite (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES app_user(id),
  venue_id BIGINT REFERENCES venue(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, venue_id)
);
```


