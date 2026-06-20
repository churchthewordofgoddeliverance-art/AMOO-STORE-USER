const twilio = require('twilio');

// Initialize Twilio client
const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const twilioPhoneNumber = process.env.TWILIO_PHONE_NUMBER;

let twilioClient = null;

// Initialize Twilio if credentials are available
if (accountSid && authToken && twilioPhoneNumber) {
  twilioClient = twilio(accountSid, authToken);
  console.log('✅ Twilio WhatsApp service initialized');
} else {
  console.log('⚠️  Twilio credentials not configured. WhatsApp notifications will be logged only.');
}

/**
 * Send registration confirmation via WhatsApp
 * @param {string} phoneNumber - Customer's phone number (include country code, e.g., +234...)
 * @param {string} customerName - Customer's name
 * @returns {Promise<boolean>} - Success status
 */
async function sendRegistrationWhatsApp(phoneNumber, customerName) {
  if (!phoneNumber) {
    console.error('❌ No phone number provided for WhatsApp');
    return false;
  }

  try {
    const message = `Welcome to AMOO STORE, ${customerName}! 👔\n\nYour account has been successfully created. You can now shop our premium fashion collection for men, women, couples, and children.\n\nNeed help? We're here to assist!\n\nThank you for choosing AMOO STORE!`;

    if (twilioClient) {
      const result = await twilioClient.messages.create({
        body: message,
        from: `whatsapp:${twilioPhoneNumber}`,
        to: `whatsapp:${phoneNumber}`
      });
      console.log(`✅ Registration WhatsApp sent to ${phoneNumber}. SID: ${result.sid}`);
      return true;
    } else {
      console.log(`📱 [WhatsApp LOG] Registration to ${phoneNumber}: ${message}`);
      return true;
    }
  } catch (error) {
    console.error(`❌ Failed to send registration WhatsApp to ${phoneNumber}:`, error.message);
    return false;
  }
}

/**
 * Send order confirmation via WhatsApp
 * @param {string} phoneNumber - Customer's phone number
 * @param {string} customerName - Customer's name
 * @param {string} orderId - Order ID
 * @param {number} total - Order total amount
 * @param {string} address - Delivery address
 * @returns {Promise<boolean>} - Success status
 */
async function sendOrderConfirmationWhatsApp(phoneNumber, customerName, orderId, total, address) {
  if (!phoneNumber) {
    console.error('❌ No phone number provided for WhatsApp');
    return false;
  }

  try {
    const message = `Hi ${customerName}! 👋\n\n✅ Your order has been received!\n\n📦 *Order Details:*\nOrder ID: #${orderId}\nTotal: ₦${total.toLocaleString()}\nStatus: PENDING PAYMENT\nDelivery Address: ${address}\n\n💳 *Next Step:*\nPlease transfer the amount to our bank account and send proof. We will confirm your order immediately upon payment verification.\n\n🏦 Bank Details will be provided separately.\n\nQuestions? Feel free to ask!\n\nThank you for shopping with AMOO STORE! 🙏`;

    if (twilioClient) {
      const result = await twilioClient.messages.create({
        body: message,
        from: `whatsapp:${twilioPhoneNumber}`,
        to: `whatsapp:${phoneNumber}`
      });
      console.log(`✅ Order confirmation WhatsApp sent to ${phoneNumber}. SID: ${result.sid}`);
      return true;
    } else {
      console.log(`📱 [WhatsApp LOG] Order confirmation to ${phoneNumber}: ${message}`);
      return true;
    }
  } catch (error) {
    console.error(`❌ Failed to send order confirmation WhatsApp to ${phoneNumber}:`, error.message);
    return false;
  }
}

/**
 * Send order status update via WhatsApp
 * @param {string} phoneNumber - Customer's phone number
 * @param {string} customerName - Customer's name
 * @param {string} orderId - Order ID
 * @param {string} status - New order status (confirmed, shipped, delivered, cancelled)
 * @returns {Promise<boolean>} - Success status
 */
async function sendOrderStatusWhatsApp(phoneNumber, customerName, orderId, status) {
  if (!phoneNumber) {
    console.error('❌ No phone number provided for WhatsApp');
    return false;
  }

  try {
    let statusMessage = '';
    let emoji = '';

    switch (status.toLowerCase()) {
      case 'confirmed':
        statusMessage = 'Payment verified! Your order is confirmed. We are preparing your items for shipment.';
        emoji = '✅';
        break;
      case 'shipped':
        statusMessage = 'Great news! Your order has been shipped and is on its way to you.';
        emoji = '📦';
        break;
      case 'delivered':
        statusMessage = 'Your order has been delivered! We hope you enjoy your purchase. Thank you for shopping with us! 🎉';
        emoji = '📍';
        break;
      case 'cancelled':
        statusMessage = 'Your order has been cancelled. Please contact us if you have any questions.';
        emoji = '❌';
        break;
      default:
        statusMessage = `Your order status has been updated to: ${status}`;
        emoji = '📝';
    }

    const message = `Hi ${customerName}!\n\n${emoji} *Order #${orderId} Update*\n\n${statusMessage}\n\nNeed help? Let us know!\n\nThank you!`;

    if (twilioClient) {
      const result = await twilioClient.messages.create({
        body: message,
        from: `whatsapp:${twilioPhoneNumber}`,
        to: `whatsapp:${phoneNumber}`
      });
      console.log(`✅ Order status WhatsApp sent to ${phoneNumber}. SID: ${result.sid}`);
      return true;
    } else {
      console.log(`📱 [WhatsApp LOG] Order status to ${phoneNumber}: ${message}`);
      return true;
    }
  } catch (error) {
    console.error(`❌ Failed to send order status WhatsApp to ${phoneNumber}:`, error.message);
    return false;
  }
}

/**
 * Send bulk WhatsApp message to multiple customers
 * @param {string[]} phoneNumbers - Array of phone numbers
 * @param {string} messageText - Message to send
 * @returns {Promise<object>} - Stats of sent/failed messages
 */
async function sendBulkWhatsApp(phoneNumbers, messageText) {
  if (!Array.isArray(phoneNumbers) || phoneNumbers.length === 0) {
    console.error('❌ No phone numbers provided for bulk WhatsApp');
    return { sent: 0, failed: 0 };
  }

  let sent = 0;
  let failed = 0;

  for (const phoneNumber of phoneNumbers) {
    try {
      if (twilioClient) {
        const result = await twilioClient.messages.create({
          body: messageText,
          from: `whatsapp:${twilioPhoneNumber}`,
          to: `whatsapp:${phoneNumber}`
        });
        console.log(`✅ Bulk WhatsApp sent to ${phoneNumber}. SID: ${result.sid}`);
        sent++;
      } else {
        console.log(`📱 [WhatsApp LOG] Bulk message to ${phoneNumber}: ${messageText}`);
        sent++;
      }
    } catch (error) {
      console.error(`❌ Failed to send bulk WhatsApp to ${phoneNumber}:`, error.message);
      failed++;
    }
  }

  console.log(`📊 Bulk WhatsApp Summary: ${sent} sent, ${failed} failed`);
  return { sent, failed };
}

module.exports = {
  sendRegistrationWhatsApp,
  sendOrderConfirmationWhatsApp,
  sendOrderStatusWhatsApp,
  sendBulkWhatsApp
};
