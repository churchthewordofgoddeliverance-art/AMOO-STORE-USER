-- ========================================
-- ALTERNATIVE FIX: Disable RLS for testing
-- Run this if the policy-based approach doesn't work
-- ========================================

-- Temporarily disable RLS on both tables to allow backend inserts
ALTER TABLE riders DISABLE ROW LEVEL SECURITY;
ALTER TABLE order_riders DISABLE ROW LEVEL SECURITY;

-- Once testing is complete, you can re-enable with:
-- ALTER TABLE riders ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE order_riders ENABLE ROW LEVEL SECURITY;
