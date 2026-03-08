-- 创建预订表（在线预订功能）
CREATE TABLE IF NOT EXISTS booking (
  id SERIAL PRIMARY KEY,
  venue_id INT NOT NULL,
  user_id INT NOT NULL,
  booking_date DATE NOT NULL,
  time_slot VARCHAR(50) NOT NULL,
  note VARCHAR(500),
  status VARCHAR(20) NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_booking_venue_id ON booking(venue_id);
CREATE INDEX IF NOT EXISTS idx_booking_user_id ON booking(user_id);
CREATE INDEX IF NOT EXISTS idx_booking_booking_date ON booking(booking_date);
