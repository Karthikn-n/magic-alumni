import mongoose from "mongoose";
import { type } from "os";

const eventSchema = new mongoose.Schema(
  {
    alumni_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Member",
      required: true,
    },
    college_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "College",
      required: true,
    },
    event_image: {
      type: String,
      required: true,
    },
    event_title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    approval_status: {
      type: String,
      default: "not approved",
    },
    date: {
      type: Date,
      required: true,
    },
    event_type: {
      type: String,
      required: false,
    },
    rsvp_options: {
      type: [String],
      default: ["yes", "no", "maybe"],
    },
    location: {
      type: String,
      required: true,
    },
    cheif_guest: {
      type: String,
      required: false,
    },
    criteria: {
      type: String,
      required: true,
    },
    status: {
      type: String,
      required: true,
    },
    created_by: {
      type: String,
      required: false,
    },
  },
  { timestamps: true }
);

export default mongoose.model("Event", eventSchema);
