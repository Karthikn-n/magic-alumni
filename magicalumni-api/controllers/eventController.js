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
      return res.status(400).json({
        status: "not ok",
        message: "All required fields must be filled",
      });
    }

    const rsvpArray = Array.isArray(rsvp_options)
      ? rsvp_options
      : [rsvp_options || "no"];

    const newEvent = new Event({
      alumni_id,
      college_id,
      event_image: imagePath,
      event_title,
      date,
      approval_status,
      event_type,
      rsvp_options: rsvpArray,
      location,
      criteria,
    });

    const savedEvent = await newEvent.save();

    // const students = await StudentCollege.find({ college_id });
    // const alumni = await AlumniCollege.find({ college_id });

    // const recipients = [
    //   ...students.map((s) => s.student_id.toString()),
    //   ...alumni.map((a) => a.alumni_id.toString()),
    // ];

    // recipients.forEach((userId) => {
    //   const socketId = connectedUsers[userId];
    //   if (socketId) {
    //     io.to(socketId).emit("new_event", {
    //       message: `New event "${event_title}" has been created by your college.`,
    //       event: savedEvent,
    //     });
    //   }
    // });

    res.status(201).json({
      status: "ok",
      message: "Event created successfully",
      event: savedEvent,
    });
  } catch (error) {
    res
      .status(500)
      .json({ status: "error", message: "Error creating event", error });
  }
};

const getAllEvent = async (req, res) => {
  try {
    const { college_id } = req.body;

    if (college_id && !mongoose.Types.ObjectId.isValid(college_id)) {
      return res.status(400).json({
        status: "not ok",
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
        status: "ok",
        message: "No data found for this college",
      });
    }

    res.status(200).json({ status: "ok", eventList: eventList });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving event lists",
      error: error.message,
    });
  }
};

module.exports = { createEvent, getAllEvent };
