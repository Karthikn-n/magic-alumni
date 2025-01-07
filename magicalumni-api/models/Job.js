const mongoose = require("mongoose");

const jobSchema = new mongoose.Schema(
  {
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
    job_image: {
      type: String,
      required: true,
    },
    job_title: {
      type: String,
      required: true,
    },
    last_date: {
      type: Date,
      required: true,
    },
    company_name: {
      type: String,
      required: true,
    },
    location: {
      type: String,
      required: true,
    },
    job_url: {
      type: String,
      required: true,
    },
    tag: {
      type: String,
      required: true,
    },
    status: {
      type: String,
      default: "Active",
    },
  },
  { timestamps: true }
);

const Job = mongoose.models.Job || mongoose.model("Job", jobSchema);

module.exports = Job;
