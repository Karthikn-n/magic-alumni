import mongoose from "mongoose";

const memberSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    designation: {
      type: String,
      required: false,
    },
    linkedin_url: {
      type: String,
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
    role: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

export default mongoose.model("Member", memberSchema);
