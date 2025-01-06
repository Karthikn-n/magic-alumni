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
    approval_status: {
      type: String,
      default: "not approved",
    },
    date: {
      type: Date,
      required: true,
    },
    event_type: {
      type: [String],
      enum: ["seminar", "workshop", "meetup"],
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
  },
  { timestamps: true }
);

const Event = mongoose.model("Event", eventSchema);
module.exports = Event;
