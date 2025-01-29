import mongoose from "mongoose";

const notificationSchema = new mongoose.Schema(
  {
    user_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Member",
      required: true, // The user receiving the notification
    },
    type: {
      type: String,
      required: true, // Type of notification (e.g., request, message, alert)
    },
    title: {
      type: String,
      required: true, // Title of the notification
    },
    message: {
      type: String,
      required: true, // Notification message content
    },
    data: {
      type: Object, // Additional data related to the notification (e.g., request details)
    },
    status: {
      type: String,
      enum: ["unread", "read"], // Status of the notification
      default: "unread",
    },
    created_at: {
      type: Date,
      default: Date.now, // Timestamp when the notification was created
    },
  },
  { timestamps: true } // Adds `createdAt` and `updatedAt` fields automatically
);

export default mongoose.model("Notification", notificationSchema);
