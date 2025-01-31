import express from "express";
import College from "../models/College.js";
import Department from "../models/Department.js";
import bcrypt from "bcrypt";
import axios from "axios";
import Member from "../models/Member.js";
import multer from "multer";
import path from "path";
import mongoose from "mongoose";
const router = express.Router();

router.post("/register", async (req, res) => {
  try {
    const { name, address, city, password, description } = req.body;

    if (!name || !address || !city || !password) {
      return res.status(400).json({
        status: "not ok",
        message: "All required fields must be filled",
      });
    }

    const existingCollege = await College.findOne({ name, address, city });
    if (existingCollege) {
      return res.status(400).json({
        status: "not ok",
        message: "College already exists",
      });
    }

    const newCollege = new College({
      name,
      address,
      city,
      password,
      description,
    });

    const savedCollege = await newCollege.save();

    res.status(201).json({
      status: "ok",
      message: "College created successfully",
      college: savedCollege,
    });
  } catch (error) {
    res
      .status(500)
      .json({ status: "error", message: "Error creating college", error });
  }
});

router.post("/login", async (req, res) => {
  try {
    const { name, password } = req.body;

    if (!name || !password) {
      return res.status(400).json({
        status: "not ok",
        message: "Name and password are required",
      });
    }

    const college = await College.findOne({ name });
    if (!college) {
      return res.status(404).json({
        status: "not ok",
        message: "College not found",
      });
    }

    const isMatch = await bcrypt.compare(password, college.password);
    if (!isMatch) {
      return res.status(401).json({
        status: "not ok",
        message: "Invalid password",
      });
    }

    res.status(200).json({
      status: "ok",
      message: "Login successful",
      college,
    });
  } catch (error) {
    res
      .status(500)
      .json({ status: "error", message: "Error logging in", error });
  }
});

router.get("/allCollegeList", async (req, res) => {
  try {
    const collegeList = await College.find();

    if (collegeList.length === 0) {
      return res.status(200).json({
        status: "ok",
        message: "No colleges found",
      });
    }

    const collegeWithDepartments = await Promise.all(
      collegeList.map(async (college) => {
        const departments = await Department.find({ college_id: college._id });
        return {
          ...college._doc,
          departments,
        };
      })
    );

    res.status(200).json({
      status: "Ok",
      collegeWithDepartments: collegeWithDepartments,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving college lists",
      error: error.message,
    });
  }
});

router.post("/collegedetail", async (req, res) => {
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

    const collegeList = await College.findOne({
      _id: college_id,
    });

    if (collegeList.length === 0) {
      return res.status(200).json({
        status: "ok",
        message: "No data found",
      });
    }

    res.status(200).json({
      status: "ok",
      collegeList: collegeList,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving college",
      error: error.message,
    });
  }
});

router.post("/update", async (req, res) => {
  const { id, name, address, description, city } = req.body;

  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing college ID",
      });
    }

    const updatedCollege = await College.findByIdAndUpdate(
      id,
      {
        name,
        address,
        description,
        city,
      },
      { new: true }
    );

    if (!updatedCollege) {
      return res.status(404).json({ message: "College not found" });
    }

    res.status(200).json({
      status: "ok",
      message: "Updated successfully",
      college: updatedCollege,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating data",
      error: error.message,
    });
  }
});

router.post("/requestRole", async (req, res) => {
  const { college_id, alumni_id } = req.body;
  try {
    if (!college_id || !alumni_id) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing college ID or alumni ID",
      });
    }

    const collegeId = await College.findById(college_id);
    const collegeName = collegeId.name;
    const alumniId = await Member.findById(alumni_id);
    const alumniName = alumniId.name;

    const members = await Member.find({ _id: { $in: alumni_id } }).select(
      "external_id"
    );
    console.log("Member records found:", members);

    const externalUserIds = members.map((m) => m._id).filter(Boolean);
    console.log("External User IDs:", externalUserIds);

    if (externalUserIds.length > 0) {
      const oneSignalConfig = {
        app_id: `${process.env.ONESIGNAL_APP_ID}`,
        include_external_user_ids: ["6799e782b1efb0c856e4f0f1"],
        type: "role request",
        headings: { en: `Request from ${collegeName}` },
        contents: {
          en: `${collegeName} has requested you to accept Alumni Co-ordinator role`,
        },
        data: {
          type: "role request",
          alumni_id: alumni_id,
          title: "role request",
          content: `${collegeName} has requested you to accept Alumni Co-ordinator role`,
          request_body:
            "${collegeName} has requested you to accept Alumni Co-ordinator role for the alumni co-ordinating",
        },
        actions: [{ id: "role request", title: "Role Request" }],
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
          _id: { $in: alumni_id },
          status: "approved",
        }).select("external_id");
        const externalUserIds = members
          .map((m) => m.external_id)
          .filter(Boolean);

        console.log("Notification sent:", oneSignalResponse.data);

        console.log("Notification sent successfully");

        await Promise.all(
          externalUserIds.map((externalId) => {
            const notification = new Notification({
              user_id: alumni_id[externalUserIds.indexOf(externalId)],
              type: "role request",
              title: `Role Request from ${collegeName}`,
              message: `Role Request from ${collegeName} to ${alumniName} to accept the alumni-co-oridnator role`,
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

    res.status(200).json({
      status: "ok",
      message: "Sent successfully",
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error sending data",
      error: error.message,
    });
  }
});

export default router;
