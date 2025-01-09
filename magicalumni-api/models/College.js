import mongoose from "mongoose";

const collegeSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    address: {
      type: String,
    },
    city: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

export default mongoose.model("College", collegeSchema);
