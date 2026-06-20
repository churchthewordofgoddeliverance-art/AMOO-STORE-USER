-- Create rider_orders table for tracking orders assigned to riders
CREATE TABLE IF NOT EXISTS rider_orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id BIGINT NOT NULL,
  rider_id VARCHAR(255) NOT NULL,
  customer_name VARCHAR(255),
  customer_phone VARCHAR(20),
  customer_email VARCHAR(255),
  delivery_address TEXT,
  delivery_city VARCHAR(100),
  delivery_state VARCHAR(100),
  order_total DECIMAL(15, 2),
  order_items JSONB,
  status VARCHAR(50) DEFAULT 'assigned',
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  picked_at TIMESTAMP,
  on_way_at TIMESTAMP,
  delivered_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES orders(id),
  CONSTRAINT fk_rider FOREIGN KEY (rider_id) REFERENCES riders(id)
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_rider_orders_order_id ON rider_orders(order_id);
CREATE INDEX IF NOT EXISTS idx_rider_orders_rider_id ON rider_orders(rider_id);
CREATE INDEX IF NOT EXISTS idx_rider_orders_status ON rider_orders(status);
CREATE INDEX IF NOT EXISTS idx_rider_orders_assigned_at ON rider_orders(assigned_at DESC);

-- Add RLS (Row Level Security) policy for riders to see only their orders
ALTER TABLE rider_orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Riders can view their assigned orders"
  ON rider_orders FOR SELECT
  USING (rider_id = auth.uid()::text);

CREATE POLICY "Admins can view all rider orders"
  ON rider_orders FOR ALL
  USING (auth.role() = 'authenticated');
