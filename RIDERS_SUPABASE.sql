-- ========================================
-- RIDERS TABLE FOR SUPABASE
-- Run this in Supabase SQL Editor to create the riders table
-- ========================================

-- Create riders table
CREATE TABLE riders (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  phone TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  vehicle_type TEXT NOT NULL,
  license_plate TEXT NOT NULL,
  bank_name TEXT NOT NULL,
  account_number TEXT NOT NULL,
  account_name TEXT NOT NULL,
  join_date TIMESTAMP DEFAULT NOW(),
  rating DECIMAL(3,2) DEFAULT 5.0,
  total_deliveries INTEGER DEFAULT 0,
  month_deliveries INTEGER DEFAULT 0,
  month_earnings DECIMAL(12,2) DEFAULT 0.00,
  total_earnings DECIMAL(12,2) DEFAULT 0.00,
  is_online BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create index on email for faster queries
CREATE INDEX riders_email_idx ON riders(email);

-- Create index on is_online for filtering online riders
CREATE INDEX riders_online_idx ON riders(is_online);

-- Create orders_riders junction table (if not using foreign key in orders table)
CREATE TABLE order_riders (
  id TEXT PRIMARY KEY,
  order_id TEXT NOT NULL,
  rider_id TEXT NOT NULL,
  assigned_at TIMESTAMP DEFAULT NOW(),
  picked_up_at TIMESTAMP,
  delivered_at TIMESTAMP,
  delivery_code TEXT,
  status TEXT DEFAULT 'assigned',
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT order_id_fk FOREIGN KEY (order_id) REFERENCES orders(id),
  CONSTRAINT rider_id_fk FOREIGN KEY (rider_id) REFERENCES riders(id)
);

-- Create index on rider_id
CREATE INDEX order_riders_rider_idx ON order_riders(rider_id);

-- Create index on order_id
CREATE INDEX order_riders_order_idx ON order_riders(order_id);

-- Create index on status for filtering
CREATE INDEX order_riders_status_idx ON order_riders(status);

-- Enable Row Level Security (RLS)
ALTER TABLE riders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_riders ENABLE ROW LEVEL SECURITY;

-- Create policies for public read access (modify based on your needs)
-- Allow everyone to read riders (for displaying available riders info)
CREATE POLICY "Allow public read riders" 
  ON riders FOR SELECT 
  USING (true);

-- Allow backend service to insert riders (for server-side registration)
CREATE POLICY "Allow backend insert riders" 
  ON riders FOR INSERT 
  WITH CHECK (true);

-- Allow riders to update their own data
CREATE POLICY "Allow riders update own data" 
  ON riders FOR UPDATE 
  USING (auth.uid()::text = id);

-- Allow everyone to read order_riders assignments
CREATE POLICY "Allow public read order_riders" 
  ON order_riders FOR SELECT 
  USING (true);

-- Allow backend service to insert order_riders (for server-side assignment)
CREATE POLICY "Allow backend insert order_riders" 
  ON order_riders FOR INSERT 
  WITH CHECK (true);

-- Allow riders to update their own assignments
CREATE POLICY "Allow riders update own assignments" 
  ON order_riders FOR UPDATE 
  USING (auth.uid()::text = rider_id);

-- Optional: Create a view for active riders
CREATE VIEW active_riders AS
SELECT 
  id,
  name,
  email,
  phone,
  vehicle_type,
  license_plate,
  rating,
  total_deliveries,
  month_deliveries,
  month_earnings,
  is_online,
  join_date
FROM riders
WHERE is_online = TRUE
ORDER BY rating DESC;

-- Optional: Create a view for rider statistics
CREATE VIEW rider_statistics AS
SELECT 
  r.id,
  r.name,
  r.email,
  COUNT(CASE WHEN ord.status = 'delivered' THEN 1 END) as completed_deliveries,
  COUNT(CASE WHEN ord.status IN ('assigned', 'picked', 'on-way', 'arrived') THEN 1 END) as active_deliveries,
  AVG(CASE WHEN ord.status = 'delivered' THEN 1 ELSE 0 END) as completion_rate,
  r.rating,
  r.total_earnings,
  r.is_online,
  r.join_date
FROM riders r
LEFT JOIN order_riders ord ON r.id = ord.rider_id
GROUP BY r.id, r.name, r.email, r.rating, r.total_earnings, r.is_online, r.join_date;

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_riders_updated_at BEFORE UPDATE ON riders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_order_riders_updated_at BEFORE UPDATE ON order_riders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ========================================
-- MIGRATION: If you have existing riders.json data, import it here
-- ========================================
-- Run this after creating the tables if you want to seed initial data:

-- INSERT INTO riders (id, name, email, phone, password_hash, vehicle_type, license_plate, bank_name, account_number, account_name, join_date, rating, total_deliveries, month_deliveries, month_earnings, total_earnings, is_online)
-- VALUES (
--   'R1716123456789',
--   'Sample Rider',
--   'rider@example.com',
--   '08012345678',
--   'hashed_password_here',
--   'Motorcycle',
--   'ABC-123-XY',
--   'First Bank',
--   '1234567890',
--   'Sample Rider Name',
--   NOW(),
--   5.0,
--   0,
--   0,
--   0.00,
--   0.00,
--   FALSE
-- );

-- ========================================
-- NOTES:
-- ========================================
-- 1. Update RLS policies based on your authentication method (Supabase Auth, JWT, etc.)
-- 2. Password should be hashed on the server using bcrypt before inserting
-- 3. Modify the views and triggers as needed for your use case
-- 4. Test the policies before deploying to production
-- 5. For production, consider adding more comprehensive indexes based on query patterns
