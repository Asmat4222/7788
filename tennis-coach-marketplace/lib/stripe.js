const isDummyMode = !process.env.STRIPE_SECRET_KEY || process.env.STRIPE_SECRET_KEY === 'dummy';

let stripe = null;
if (!isDummyMode) {
  const Stripe = require('stripe');
  stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
}

async function createPaymentIntent(amount, currency = 'usd', metadata = {}) {
  if (isDummyMode) {
    return {
      id: `pi_dummy_${Date.now()}`,
      client_secret: `pi_dummy_secret_${Date.now()}`,
      amount,
      currency,
      status: 'succeeded',
      dummy: true,
    };
  }
  return stripe.paymentIntents.create({ amount, currency, metadata });
}

async function confirmPayment(paymentIntentId) {
  if (isDummyMode) {
    return { id: paymentIntentId, status: 'succeeded', dummy: true };
  }
  return stripe.paymentIntents.retrieve(paymentIntentId);
}

module.exports = { stripe, createPaymentIntent, confirmPayment, isDummyMode };
