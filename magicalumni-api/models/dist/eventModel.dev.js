"use strict";

var mongoose = require("mongoose");

var eventSchema = new mongoose.Schema({
  alumni_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "AlumniMember",
    // Assuming 'AlumniMember' is the alumni model
    required: true
  },
  college_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "College",
    // This will be linked later when you have the College model
    "default": "60b8d29560c72c001f9db4f6" // Example default ObjectId

  },
  event_image: {
    type: String
  },
  event_title: {
    type: String,
    required: true
  },
  event_date: {
    type: Date,
    required: true
  },
  event_type: {
    type: String,
    required: true
  },
  recp_options: {
    type: String,
    required: true
  },
  location: {
    type: String,
    required: true
  },
  criteria: {
    type: String,
    required: true
  }
}, {
  timestamps: true
} // Adds createdAt and updatedAt automatically
);
module.exports = mongoose.model("Event", eventSchema);