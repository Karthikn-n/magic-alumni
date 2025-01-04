const { Vonage } = require("@vonage/server-sdk");

const vonage = new Vonage({
  apiKey: "YOUR_API_KEY",
  apiSecret: "YOUR_API_SECRET",
});

const sendOtp = (to, otp) => {
  const from = "Vonage";
  const text = `Your OTP code is ${otp}`;

  vonage.sms
    .send({ to, from, text })
    .then((resp) => {
      console.log("Message sent successfully:", resp);
    })
    .catch((err) => {
      console.error("Error sending message:", err);
    });
};

module.exports = { sendOtp };
