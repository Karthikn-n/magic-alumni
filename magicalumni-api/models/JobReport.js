import mongoose from "mongoose";

const jobReportSchema = new mongoose.Schema(
  {
    alumni_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Member",
      required: true,
    },
    job_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Job",
      required: true,
    },
    reason: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

export default mongoose.model("JobReport", jobReportSchema);
