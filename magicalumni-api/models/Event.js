const mongoose = require("mongoose");

const eventSchema = new mongoose.Schema(
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
      default: ["no"],
    },
    location: {
      type: String,
      required: true,
    },
    criteria: {
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

const Event = mongoose.model("Event", eventSchema);
module.exports = Event;
