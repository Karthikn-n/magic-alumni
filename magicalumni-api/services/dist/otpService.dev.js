"use strict";

var _require = require("@vonage/server-sdk"),
    Vonage = _require.Vonage;

var vonage = new Vonage({
  apiKey: "YOUR_API_KEY",
  apiSecret: "YOUR_API_SECRET"
});

var sendOtp = function sendOtp(to, otp) {
  var from = "Vonage";
  var text = "Your OTP code is ".concat(otp);
  vonage.sms.send({
    to: to,
    from: from,
    text: text
  }).then(function (resp) {
    console.log("Message sent successfully:", resp);
  })["catch"](function (err) {
    console.error("Error sending message:", err);
  });
};

module.exports = {
  sendOtp: sendOtp
};