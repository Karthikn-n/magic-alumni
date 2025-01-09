import mongoose from "mongoose";

const requestSchema = new mongoose.Schema(
  {
    sender: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Member",
      required: true,
    },
    receiver: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Member",
      required: true,
    },
    status: {
      type: String,
      default: "Pending",
    },
  },
  { timestamps: true }
);

export default mongoose.model("Request", requestSchema);
