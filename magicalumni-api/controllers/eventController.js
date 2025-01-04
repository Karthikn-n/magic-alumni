const axios = require("axios");
const fs = require("fs");
const Event = require("../models/Event");
const mongoose = require("mongoose");
const path = require("path");

const createEvent = async (req, res) => {
  try {
    const {
      alumni_id,
      college_id,
      event_title,
      date,
      approval_status,
      event_type,
      rsvp_options,
      location,
      criteria,
      event_image,
    } = req.body;

    const imagePath = req.file ? `/uploads/${req.file.filename}` : event_image;

    if (!alumni_id || !college_id || !event_title || !date || !imagePath) {
      return res
        .status(400)
        .json({ message: "All required fields must be filled" });
    }

    const newEvent = new Event({
      alumni_id,
      college_id,
      event_image: imagePath,
      event_title,
      date,
      approval_status,
      event_type,
      rsvp_options,
      location,
      criteria,
    });

    const savedEvent = await newEvent.save();
    res
      .status(201)
      .json({ message: "Event created successfully", event: savedEvent });
  } catch (error) {
    res.status(500).json({ message: "Error creating event", error });
  }
};

const getAllEvent = async (req, res) => {
  try {
    const { college_id } = req.body;

    if (college_id && !mongoose.Types.ObjectId.isValid(college_id)) {
      return res.status(400).json({
        message: "Invalid college_id format",
      });
    }

    let filter = {};
    if (college_id) {
      filter.college_id = college_id;
    }

    const eventList = await Event.find(filter);

    if (eventList.length === 0) {
      return res.status(200).json({
        message: "No data found for this college",
      });
    }

    res.status(200).json(eventList);
  } catch (error) {
    res.status(500).json({
      message: "Error retrieving event lists",
      error: error.message,
    });
  }
};

module.exports = { createEvent, getAllEvent };
