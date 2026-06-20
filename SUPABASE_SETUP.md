# Supabase Setup Guide

## Create Messages Table

Run this SQL in Supabase SQL Editor to create the messages table:

```sql
-- Create messages table
CREATE TABLE IF NOT EXISTS messages (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  sender_email VARCHAR(255) NOT NULL,
  sender_name VARCHAR(255),
  recipient_emails TEXT[] NOT NULL,
  subject VARCHAR(500) NOT NULL,
  message_content TEXT NOT NULL,
  status VARCHAR(50) DEFAULT 'sent',
  recipient_count INT,
  sent_count INT DEFAULT 0,
  failed_count INT DEFAULT 0
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_status ON messages(status);
```

## Steps to Execute:

1. Go to [Supabase Dashboard](https://supabase.com)
2. Select your project
3. Click **SQL Editor** (left sidebar)
4. Click **New Query**
5. Copy and paste the SQL above
6. Click **Run**
7. You should see: "Successfully executed 2 queries"

## Verify Table Creation:

1. Go to **Table Editor** (left sidebar)
2. You should see `messages` table in the list
3. Click on it to view columns

## What Each Column Does:

- `id` - Unique message ID (auto-generated)
- `created_at` - When message was sent
- `sender_email` - Admin email who sent the message
- `sender_name` - Admin name
- `recipient_emails` - Array of all recipient emails
- `subject` - Message subject line
- `message_content` - Full message text
- `status` - 'sent', 'pending', 'failed'
- `recipient_count` - Total recipients
- `sent_count` - Successfully sent to count
- `failed_count` - Failed to send count

## Features Working:

✅ Orders fetch from Supabase
✅ Users fetch from Supabase
✅ Messages fetch from Supabase
✅ Products fetch from Supabase
✅ Admin can see all registered emails at `/api/registered-emails`
✅ Messages stored with full history
✅ Fallback to local JSON if Supabase fails
