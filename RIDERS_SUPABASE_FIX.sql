-- ========================================
-- FIX: Drop old RLS policies and create new ones
-- Run this in Supabase SQL Editor to fix permissions
-- ========================================

-- Drop old restrictive policies
DROP POLICY IF EXISTS "Allow riders read own data" ON riders;
DROP POLICY IF EXISTS "Allow riders read own assignments" ON order_riders;

-- Create new backend-friendly policies for INSERT operations
-- Allow backend service to insert riders without auth context
CREATE POLICY "Allow backend insert riders" 
  ON riders FOR INSERT 
  WITH CHECK (true);

-- Allow backend service to insert order_riders without auth context
CREATE POLICY "Allow backend insert order_riders" 
  ON order_riders FOR INSERT 
  WITH CHECK (true);

-- ========================================
-- Verify policies are in place
-- ========================================
-- SELECT schemaname, tablename, policyname 
-- FROM pg_policies 
-- WHERE tablename IN ('riders', 'order_riders');
