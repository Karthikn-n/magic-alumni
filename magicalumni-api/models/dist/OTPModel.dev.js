"use strict";

var mongoose = require("mongoose");

var otpSchema = new mongoose.Schema({
  alumni_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "AlumniMember",
    required: true
  },
  mobile_number: {
    type: String,
    required: true
  },
  otp: {
    type: String,
    required: true
  },
  expiresAt: {
    type: Date,
    required: true
  }
});
module.exports = mongoose.model("OTP", otpSchema);