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
    department_name: {
      type: String,
      required: true,
    },
    designation: {
      type: String,
      required: true,
    },
    linkedin_url: {
      type: String,
      required: true,
    },
    completed_year: {
      type: Number,
      required: true,
    },
    mobile_number: {
      type: Number,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("AlumniMember", alumniMemberSchema);
