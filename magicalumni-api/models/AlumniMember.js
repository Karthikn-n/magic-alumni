const mongoose = require("mongoose");
const alumniMemberSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    // college_name: {
    //   type: String,
    //   required: true,
    // },
    // department_name: {
    //   type: String,
    //   required: false,
    // },
    designation: {
      type: String,
      required: false,
    },
    linkedin_url: {
      type: String,
      required: true,
    },
    completed_year: {
      type: Number,
      required: false,
    },
    current_year: {
      type: Number,
      required: false,
    },
    mobile_number: {
      type: Number,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
    role: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("AlumniMember", alumniMemberSchema);
