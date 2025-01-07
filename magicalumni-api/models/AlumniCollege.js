const mongoose = require("mongoose");

const AlumniCollegeSchema = new mongoose.Schema({
  alumni_id: {
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
  completed_year: {
    type: String,
    required: false,
  },
  status: {
    type: String,
    default: "not approved",
  },
});

module.exports = mongoose.model("AlumniCollege", AlumniCollegeSchema);
