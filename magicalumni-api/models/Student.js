const mongoose = require("mongoose");
const studentSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    // college_id: {
    //   type: mongoose.Schema.Types.ObjectId,
    //   ref: "College",
    //   required: true,
    // },
    department_name: {
      type: String,
      required: true,
    },
    linkedin_url: {
      type: String,
      required: true,
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
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Student", studentSchema);
