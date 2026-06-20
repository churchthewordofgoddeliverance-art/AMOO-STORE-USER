# 🚀 AMOO STORE - COMPLETE RENDER DEPLOYMENT GUIDE

## 📋 TABLE OF CONTENTS
1. Prerequisites
2. Supabase Setup
3. Rider System Configuration
4. Render Deployment
5. Environment Variables
6. Testing After Deployment
7. Troubleshooting

---

## 1️⃣ PREREQUISITES

### Required Accounts:
- ✅ Render.com account (free tier available)
- ✅ Supabase account (PostgreSQL database)
- ✅ Email service (Gmail, SendGrid, or similar)
- ✅ GitHub account (for code repository)

### Required Skills:
- Basic Git knowledge
- Understanding of environment variables
- Familiarity with databases

---

## 2️⃣ SUPABASE SETUP - RIDERS TABLE

### Step 1: Create Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. Click "New Project"
3. Fill in project details:
   - **Project Name:** amoostore-riders
   - **Database Password:** Create a strong password
   - **Region:** Choose closest to your users
4. Click "Create new project" and wait 2-3 minutes

### Step 2: Create Riders Table
1. Go to **SQL Editor** in Supabase dashboard
2. Click **"New Query"**
3. Copy and paste the contents of `RIDERS_SUPABASE.sql` file from your project
4. Click **"Run"** button
5. Verify tables are created: Go to **Table Editor** and confirm `riders`, `order_riders`, and views are visible

### Step 3: Get Supabase Credentials
1. Go to **Settings → API**
2. Copy these values and save them:
   - `Project URL` → This is your `SUPABASE_URL`
   - `anon public` key → This is your `SUPABASE_ANON_KEY`
   - `service_role` (secret) key → This is your `SUPABASE_SERVICE_ROLE_KEY`

**Example:**
```
SUPABASE_URL=https://abc123.supabase.co
SUPABASE_ANON_KEY=eyJhbGc... (long string)
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc... (long string)
```

### Step 4: Configure Row Level Security (RLS)
- The SQL file already includes RLS policies
- Modify policies in **Auth Policies** section if needed for your use case

---

## 3️⃣ RIDER SYSTEM CONFIGURATION

### Files in Your Project:
```
rider-web/
  ├── rider.html      (Rider dashboard interface)
  ├── rider.css       (Responsive styling)
  └── rider.js        (Frontend logic + API calls)

admin/
  ├── admin.html      (Admin dashboard - NOW with Riders section)
  ├── admin.css       (Admin styling)
  └── admin.js        (Admin logic - includes loadRiders())

server.js             (Express backend - Supabase integration)
RIDERS_SUPABASE.sql   (Database schema)
```

### Admin Dashboard Updates:
- ✅ New **"Riders"** menu item in sidebar
- ✅ Display all registered riders with status
- ✅ Show rider statistics (deliveries, earnings, rating)
- ✅ Toggle rider online/offline status
- ✅ View detailed rider information

### How Rider System Works:
```
1. Rider registers at http://your-domain.com/rider
   ↓
2. Registration data saved to Supabase `riders` table
   ↓
3. Admin marks order as "SHIPPED"
   ↓
4. System fetches online riders from Supabase
   ↓
5. Email sent to each online rider about new order
   ↓
6. Rider sees order in "Available Orders"
   ↓
7. Rider accepts order → status becomes "assigned"
   ↓
8. Rider updates: picked → on-way → arrived
   ↓
9. 4-digit code generated and sent to customer email
   ↓
10. Customer gives code to rider
    ↓
11. Rider enters code → order marked "delivered"
    ↓
12. Confirmation emails sent to customer + all admins
```

---

## 4️⃣ RENDER DEPLOYMENT

### Step 1: Push Code to GitHub
```bash
git init
git add .
git commit -m "AMOO Store with Rider System"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/amoostore.git
git push -u origin main
```

### Step 2: Connect Render to GitHub
1. Go to [render.com](https://render.com)
2. Click **"New +"** → **"Web Service"**
3. Select **"Connect a repository"**
4. Authorize GitHub
5. Find and select `amoostore` repository
6. Click **"Connect"**

### Step 3: Configure Render Service
Fill in the following:

| Field | Value |
|-------|-------|
| **Name** | amoostore |
| **Environment** | Node |
| **Region** | Virginia (USA) or closest to you |
| **Branch** | main |
| **Build Command** | `npm install` |
| **Start Command** | `node server.js` |

### Step 4: Add Environment Variables
1. Scroll to **"Environment"** section
2. Click **"Add Environment Variable"** for each:

```
SUPABASE_URL=https://abc123.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...
PORT=3000
NODE_ENV=production
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password
ADMIN_EMAILS=admin1@example.com,admin2@example.com
```

### Step 5: Deploy
1. Click **"Create Web Service"**
2. Wait 5-10 minutes for deployment
3. Your site will be live at: `https://amoostore.onrender.com`

---

## 5️⃣ ENVIRONMENT VARIABLES REFERENCE

### Required Variables:
```bash
# Supabase Database
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...

# Server Configuration
PORT=3000
NODE_ENV=production

# Email Service
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password  # For Gmail: use App Password, not regular password
EMAIL_FROM=noreply@amoostore.com

# Admin Management
ADMIN_EMAILS=admin@amoostore.com,manager@amoostore.com

# Optional: SMS Service
TWILIO_ACCOUNT_SID=your_sid
TWILIO_AUTH_TOKEN=your_token
TWILIO_PHONE_NUMBER=+1234567890
```

### How to Get Gmail App Password:
1. Go to [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)
2. Select: App = Mail, Device = Windows/Mac
3. Click "Generate"
4. Copy the 16-character password
5. Use this as `EMAIL_PASS` in environment variables

---

## 6️⃣ TESTING AFTER DEPLOYMENT

### Test 1: Access the Application
- **Customer Site:** https://amoostore.onrender.com
- **Admin Dashboard:** https://amoostore.onrender.com/admin
- **Rider Dashboard:** https://amoostore.onrender.com/rider

### Test 2: Register a Test Rider
1. Go to https://amoostore.onrender.com/rider
2. Click "Create Account"
3. Fill in test data:
   - Name: "Test Rider"
   - Email: "testrider@test.com"
   - Phone: "08012345678"
   - Password: "test1234"
   - Vehicle: "Motorcycle"
   - License Plate: "ABC-123-XY"
   - Bank: "Test Bank"
   - Account: "1234567890"
   - Account Name: "Test Rider"
4. Click "Register"
5. Confirm rider appears in Supabase: **Table Editor → riders table**

### Test 3: Admin Marks Order as Shipped
1. Go to https://amoostore.onrender.com/admin
2. Login with admin credentials
3. Go to **Orders** tab
4. Click **"Shipped"** on any order
5. Should see message: "✓ Riders notified!"

### Test 4: Verify Rider Notification
1. Go to **Riders** tab in admin dashboard
2. Should see your test rider listed
3. Click **"View Details"** to see rider information

### Test 5: Check Supabase Data
1. Go to Supabase dashboard
2. **Table Editor → riders:** Confirm test rider is registered
3. **Table Editor → orders:** Confirm order shows rider assignment

### Test 6: Email Notifications
1. Check email inbox for:
   - Rider registration confirmation
   - New order available notification
   - Order delivery confirmation
2. If not receiving emails, check:
   - Email service configuration
   - Spam/Junk folder
   - Email address is correct

---

## 7️⃣ TROUBLESHOOTING

### Issue: "Database Connection Error"
**Solution:**
- Verify `SUPABASE_URL` and `SUPABASE_ANON_KEY` are correct
- Check Supabase project is active
- Restart Render service: Settings → Restart Instance

### Issue: "Rider data not loading"
**Solution:**
- Check SQL script ran successfully
- Verify `riders` table exists in Supabase
- Check browser console for API errors (F12)
- Make sure `node_modules` includes `@supabase/supabase-js`

### Issue: "Emails not sending"
**Solution:**
- Verify email credentials in environment variables
- Use Gmail App Password, not regular password
- Check admin emails are correct format
- Look at Render logs: Dashboard → Logs tab

### Issue: "404 Page Not Found at /rider"
**Solution:**
- Verify `rider-web` folder exists in GitHub
- Check `server.js` has routes:
  - `app.get(['/rider', '/rider/'], ...)`
  - `app.use('/rider', express.static(...)`
- Restart Render service

### Issue: "Riders not appearing in Admin panel"
**Solution:**
- Confirm riders table exists in Supabase
- Check that `GET /api/riders` endpoint works
- Verify admin.js has `loadRiders()` function
- Check browser console (F12) for errors

### View Render Logs:
1. Go to https://dashboard.render.com
2. Click your service
3. Click **"Logs"** tab
4. Look for error messages

---

## 📊 ADMIN RIDERS PANEL FEATURES

### What You'll See:
✅ All registered riders with status (ONLINE/OFFLINE)
✅ Rider statistics (deliveries, earnings, rating)
✅ Vehicle information (type, license plate)
✅ Bank details for payments
✅ Join date and tenure
✅ Monthly and total earnings

### Actions Available:
🟢 **Set Online** - Make rider available for orders
🔴 **Set Offline** - Rider goes offline
👁️ **View Details** - See full rider information
🔄 **Refresh** - Update riders list

---

## 🎯 NEXT STEPS

1. **Deploy to Render** ← You are here
2. **Test all features** (see Testing section above)
3. **Configure email service** properly
4. **Train riders** on how to use the app
5. **Monitor logs** for any issues
6. **Optimize performance** based on real usage

---

## 📞 SUPPORT RESOURCES

- **Render Documentation:** https://render.com/docs
- **Supabase Documentation:** https://supabase.com/docs
- **Express.js Guide:** https://expressjs.com/
- **Troubleshooting Issues:** Check Render logs and browser console

---

## ✅ DEPLOYMENT CHECKLIST

- [ ] Supabase project created
- [ ] Riders table SQL executed
- [ ] Supabase credentials saved
- [ ] Code pushed to GitHub
- [ ] Render service created
- [ ] Environment variables configured
- [ ] Application deployed successfully
- [ ] Test rider registered
- [ ] Admin can see riders in dashboard
- [ ] Email notifications working
- [ ] All endpoints responding
- [ ] Admin panel working
- [ ] Rider dashboard working
- [ ] Customer site working

---

**🎉 Congratulations! Your AMOO STORE with Rider Management System is now live!**

For questions or issues, check the logs and troubleshooting section above.
