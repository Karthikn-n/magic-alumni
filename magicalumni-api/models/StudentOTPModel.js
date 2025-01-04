const mongoose = require("mongoose");

const studentOTPSchema = new mongoose.Schema({
  student_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "AlumniMember",
    required: true,
  },
  mobile_number: {
    type: String,
    required: true,
  },
  otp: {
    type: String,
    required: true,
  },
  expiresAt: {
    type: Date,
    required: true,
  },
});

module.exports = mongoose.model("StudentOTP", studentOTPSchema);
