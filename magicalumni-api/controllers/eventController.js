const axios = require("axios");
const fs = require("fs");
const Event = require("../models/Event");
const EventPeople = require("../models/EventPeople");
const mongoose = require("mongoose");
const AlumniMember = require("../models/AlumniMember");
const path = require("path");

const createEvent = async (req, res) => {
  try {
    const {
      alumni_id,
      college_id,
      event_title,
      description,
      date,
      approval_status,
      event_type,
      rsvp_options,
      location,
      criteria,
      event_image,
      created_by,
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
    const creatorName = await AlumniMember.findById(alumni_id);

    const createdBy = creatorName.name;
    const newEvent = new Event({
      alumni_id,
      college_id,
      event_image: imagePath,
      event_title,
      description,
      date,
      approval_status,
      event_type,
      rsvp_options: rsvpArray,
      location,
      criteria,
      created_by: createdBy,
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

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    filter.date = { $gte: today };

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

const updateEventStatus = async (req, res) => {
  const { event_id, college_id, status } = req.body;

  try {
    if (!event_id || !college_id || !status) {
      return res.status(400).json({
        status: "not ok",
        message: "event_id, college_id, and status are required",
      });
    }

    if (
      !mongoose.Types.ObjectId.isValid(event_id) ||
      !mongoose.Types.ObjectId.isValid(college_id)
    ) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid event_id or college_id",
      });
    }

    const updatedEventStatus = await Event.findOneAndUpdate(
      { _id: event_id, college_id },
      { approval_status: status },
      { new: true }
    );

    if (!updatedEventStatus) {
      return res.status(404).json({
        status: "not found",
        message: "No event-college mapping found with the provided IDs",
      });
    }

    res.status(200).json({
      status: "ok",
      message: "Event status updated successfully",
      eventStatus: updatedEventStatus,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating event status",
      error: error.message,
    });
  }
};

const eventPeople = async (req, res) => {
  try {
    const { event_id, alumni_id, interested } = req.body;

    // if (
    //   !mongoose.Types.ObjectId.isValid(alumni_id) ||
    //   !mongoose.Types.ObjectId.isValid(event_id) ||
    //   !mongoose.Types.ObjectId.isValid(interested)
    // ) {
    //   return res.status(400).json({
    //     status: "not ok",
    //     message: "Invalid alumni_id, event_id, or interested",
    //   });
    // }

    const newEventPeople = new EventPeople({
      event_id,
      alumni_id,
      interested,
    });

    await newEventPeople.save();

    res.status(201).json({
      status: "ok",
      message: "Status updated successfully",
      newPeople: newEventPeople,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating status",
      error: error.message,
    });
  }
};

const eventPeopleCount = async (req, res) => {
  try {
    const { event_id } = req.body;
    if (!event_id) {
      return res
        .status(400)
        .json({ status: "not ok", message: "Event ID is required" });
    }
    const eventPeople = await EventPeople.find({ event_id, interested: "yes" });
    const eventPeopleCountOff = eventPeople.length;
    res.status(200).json({
      status: "ok",
      message: "Data generated",
      eventPeople: eventPeople,
      eventPeopleCountOff: eventPeopleCountOff,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating status",
      error: error.message,
    });
  }
};

module.exports = {
  createEvent,
  getAllEvent,
  updateEventStatus,
  eventPeople,
  eventPeopleCount,
};
