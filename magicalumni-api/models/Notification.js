import mongoose from "mongoose";

const notificationSchema = new mongoose.Schema(
  {
    user_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Member",
      required: true,
    },
    type: {
      type: String,
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    message: {
      type: String,
      required: true,
    },
    data: {
      type: Object,
    },
    status: {
      type: String,
      enum: ["unread", "read"],
      default: "unread",
    },
    created_at: {
      type: Date,
      default: Date.now,
    },
  },
  { timestamps: true }
);

export default mongoose.model("Notification", notificationSchema);
