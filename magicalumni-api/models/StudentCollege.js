const mongoose = require("mongoose");

const StudentCollegeSchema = new mongoose.Schema({
  student_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "AlumniMember",
    required: true,
  },
  college_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "College",
    required: true,
  },
  department_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Department",
    required: true,
  },
  current_year: {
    type: String,
    required: false,
  },
  status: {
    type: String,
    default: "approved",
  },
});

module.exports = mongoose.model("StudentCollege", StudentCollegeSchema);
