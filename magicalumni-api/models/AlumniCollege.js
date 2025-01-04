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
  status: {
    type: String,
    default: "not approved",
  },
});

module.exports = mongoose.model("AlumniCollege", AlumniCollegeSchema);
