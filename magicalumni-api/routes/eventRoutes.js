import express from "express";
import Member from "../models/Member.js";
import Event from "../models/Event.js";
import MemberCollege from "../models/MemberCollege.js";
import EventPeople from "../models/EventPeople.js";
import multer from "multer";
import Notification from "../models/Notification.js";
import path from "path";
import axios from "axios";
import mongoose from "mongoose";
import { type } from "os";

const router = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/events");
  },
  filename: (req, file, cb) => {
    cb(
      null,
      `${file.fieldname}-${Date.now()}${path.extname(file.originalname)}`
    );
  },
});

const upload = multer({
  storage: storage,
  limits: { fileSize: 1000000 },
  fileFilter: (req, file, cb) => {
    const filetypes = /jpeg|jpg|png|gif/;
    const mimetype = filetypes.test(file.mimetype);
    const extname = filetypes.test(
      path.extname(file.originalname).toLowerCase()
    );

    if (mimetype && extname) {
      return cb(null, true);
    } else {
      cb("Error: Images Only!");
    }
  },
}).single("event_image");

router.post("/create", upload, async (req, res) => {
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
      created_by,
    } = req.body;

    const imagePath = req.file
      ? `/uploads/events/${req.file.filename}`
      : req.body.event_image;

    if (!alumni_id || !college_id || !event_title || !date || !imagePath) {
      return res.status(400).json({
        status: "not ok",
        message: "All required fields must be filled",
      });
    }

    const rsvpArray = Array.isArray(rsvp_options)
      ? rsvp_options
      : [rsvp_options || "yes", "no", "maybe"];

    const creator = await Member.findById(alumni_id);
    const createdBy = creator?.name || "Unknown";

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

    const memberColleges = await MemberCollege.find({ college_id }).select(
      "alumni_id"
    );
    console.log(memberColleges);
    const alumniIds = memberColleges.map((mc) => mc.alumni_id);
    console.log("Alumni IDs:", alumniIds);

    const members = await Member.find({ _id: { $in: alumniIds } }).select(
      "external_id"
    );
    console.log("Member records found:", members);

    const externalUserIds = members.map((m) => m._id).filter(Boolean);
    console.log("External User IDs:", externalUserIds);

    if (externalUserIds.length > 0) {
      const oneSignalConfig = {
        app_id: "b1793826-5d51-49a9-822c-ff0dcda804f1",
        include_external_user_ids: externalUserIds,
        type: "event",
        headings: { en: "New Event Created!" },
        contents: { en: `${event_title} is happening soon! Check it out.` },
        data: {
          type: "event",
          event_id: savedEvent._id,
          title: event_title,
          content: `${event_title} is happening soon! Check it out.`,
          created_by: createdBy,
          date,
          location,
        },
        actions: [{ id: "view", title: "View Event" }],
      };

      try {
        console.log(
          "Sending notification to OneSignal with config:",
          oneSignalConfig
        );
        const oneSignalResponse = await axios.post(
          "https://onesignal.com/api/v1/notifications",
          oneSignalConfig,
          {
            headers: {
              Authorization: `Basic ${process.env.ONESIGNAL_API_KEY}`,
              "Content-Type": "application/json",
            },
          }
        );
        const members = await Member.find({
          _id: { $in: alumniIds },
          status: "active",
        }).select("external_id");
        const externalUserIds = members
          .map((m) => m.external_id)
          .filter(Boolean);

        console.log("Notification sent:", oneSignalResponse.data);

        console.log("Notification sent successfully");

        await Promise.all(
          externalUserIds.map((externalId) => {
            const notification = new Notification({
              user_id: alumniIds[externalUserIds.indexOf(externalId)],
              type: "event",
              title: `New Event Created: ${event_title}`,
              message: `${event_title} is happening soon! Check it out.`,
              data: {
                event_id: savedEvent._id,
                event_title,
                created_by: createdBy,
                date,
                location,
              },
            });
            return notification.save();
          })
        );

        console.log("Notifications saved successfully");
      } catch (error) {
        console.error(
          "Error sending OneSignal notification:",
          error.response?.data || error.message
        );
      }
    }

    res.status(201).json({
      status: "ok",
      message: "Event created successfully and notifications sent",
      event: savedEvent,
    });
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({
      status: "error",
      message: "Error creating event",
      error,
    });
  }
});

router.post("/list", upload, async (req, res) => {
  try {
    const { college_id } = req.body;

    if (!college_id) {
      return res.status(404).json({
        status: "not found",
        message: "College ID required",
      });
    }

    if (college_id && !mongoose.Types.ObjectId.isValid(college_id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid college_id format",
      });
    }

    const eventList = await Event.find({
      college_id,
      approval_status: "approved",
    });

    if (eventList.length === 0) {
      return res.status(200).json({
        status: "ok",
        message: "No data found for this college",
      });
    }

    const eventsWithAlumni = await Promise.all(
      eventList.map(async (event) => {
        const alumni = await Member.findById(event.alumni_id).select("name");
        const formattedDate = new Date(event.date).toLocaleDateString("en-US");
        return {
          ...event._doc,
          alumni_name: alumni ? alumni.name : "Unknown Alumni",
          date: formattedDate,
        };
      })
    );

    res.status(200).json({
      status: "ok",
      eventList: eventsWithAlumni,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving event lists",
      error: error.message,
    });
  }
});

router.post("/unapprovedlist", upload, async (req, res) => {
  try {
    const { college_id } = req.body;

    if (!college_id) {
      return res.status(404).json({
        status: "not found",
        message: "College ID required",
      });
    }

    if (college_id && !mongoose.Types.ObjectId.isValid(college_id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid college_id format",
      });
    }

    const eventList = await Event.find({
      college_id,
      approval_status: "not approved",
    });

    if (eventList.length === 0) {
      return res.status(200).json({
        status: "ok",
        message: "No data found for this college",
      });
    }

    const eventsWithAlumni = await Promise.all(
      eventList.map(async (event) => {
        const alumni = await Member.findById(event.alumni_id).select("name");
        const formattedDate = new Date(event.date).toLocaleDateString("en-US");
        return {
          ...event._doc,
          alumni_name: alumni ? alumni.name : "Unknown Alumni",
          date: formattedDate,
        };
      })
    );

    res.status(200).json({
      status: "ok",
      eventList: eventsWithAlumni,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving event lists",
      error: error.message,
    });
  }
});

router.post("/unApprovedEventCount", upload, async (req, res) => {
  try {
    const { college_id } = req.body;
    if (!college_id) {
      return res
        .status(400)
        .json({ status: "not ok", message: "Event ID is required" });
    }
    const eventCount = await Event.find({
      college_id,
      approval_status: "not approved",
    });
    const eventCountOff = eventCount.length;
    res.status(200).json({
      status: "ok",
      message: "Data generated",
      eventCountOff: eventCountOff,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating status",
      error: error.message,
    });
  }
});

router.post("/coordinatorList", upload, async (req, res) => {
  try {
    const { college_id } = req.body;
    if (!college_id) {
      return res.status(404).json({
        status: "not found",
        message: "College ID required",
      });
    }

    if (college_id && !mongoose.Types.ObjectId.isValid(college_id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid college_id format",
      });
    }

    const eventList = await MemberCollege.find({ college_id });
    const alumniIds = eventList.map((event) => event.alumni_id);
    console.log(alumniIds);
    const alumniList = await Member.find({
      _id: { $in: alumniIds },
      role: "Alumni co-ordinator",
    });

    if (alumniList.length === 0) {
      return res.status(200).json({
        status: "ok",
        message: "No data found",
      });
    }

    res.status(200).json({ status: "ok", alumniList: alumniList });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving list",
      error: error.message,
    });
  }
});

router.post("/updateStatus", upload, async (req, res) => {
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
});

router.post("/eventPeople", upload, async (req, res) => {
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
});

router.post("/eventPeopleCount", upload, async (req, res) => {
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
});

router.post("/eventPeopleStatus", upload, async (req, res) => {
  try {
    const { event_id, alumni_id } = req.body;

    const eventPeople = await EventPeople.findOne({
      event_id,
      alumni_id,
    });

    res.status(200).json({
      status: "ok",
      message: "Status retrieved successfully",
      eventPeople: eventPeople.interested,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating status",
      error: error.message,
    });
  }
});

router.post("/eventPeopleStatusEdit", upload, async (req, res) => {
  try {
    const { event_id, alumni_id, interested } = req.body;

    const updatedEventStatus = await EventPeople.findOneAndUpdate(
      { event_id, alumni_id },
      { interested: interested },
      { new: true }
    );

    res.status(200).json({
      status: "ok",
      message: "Status Updated successfully",
      updatedEventStatus: updatedEventStatus,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating status",
      error: error.message,
    });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const event = await Event.findById(req.params.id);
    if (!event) {
      return res
        .status(404)
        .json({ status: "not ok", message: "Event not found" });
    }
    res.status(200).json({ status: "ok", event: event });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error fetching event details",
      error: error.message,
    });
  }
});

export default router;
