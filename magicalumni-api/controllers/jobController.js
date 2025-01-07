const axios = require("axios");
const fs = require("fs");
const Job = require("../models/Job");
const mongoose = require("mongoose");

const path = require("path");

const createJob = async (req, res) => {
  try {
    const {
      alumni_id,
      college_id,
      job_title,
      job_type,
      last_date,
      company_name,
      location,
      job_url,
      email,
      // job_image,
      // status,
      tag,
    } = req.body;

    // const imagePath = req.file
    //   ? `/uploads/jobs/${req.file.filename}`
    //   : job_image;

    if (!alumni_id || !college_id || !job_title || !last_date) {
      return res.status(400).json({
        status: "not ok",
        message: "All required fields must be filled",
      });
    }
    const existingJob = await Job.findOne({
      alumni_id,
      college_id,
      job_title,
      last_date,
      // status: "Approved",
    });

    if (existingJob) {
      return res
        .status(400)
        .json({ status: "not ok", message: "Already exists" });
    }

    const tagArray = Array.isArray(tag)
      ? tag.filter(Boolean)
      : tag
      ? [tag]
      : [];

    const newJob = new Job({
      alumni_id,
      college_id,
      job_title,
      job_type,
      last_date,
      company_name,
      location,
      job_url,
      email,
      // job_image: imagePath,
      // status,
      tag: tagArray,
    });

    const savedJob = await newJob.save();
    res.status(201).json({
      status: "ok",
      message: "Job created successfully",
      job: savedJob,
    });
  } catch (error) {
    console.error("Error creating job:", error);
    res
      .status(500)
      .json({ status: "error", message: "Error creating job", error });
  }
};

const getAllJob = async (req, res) => {
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

    filter.last_date = { $gte: today };

    const jobList = await Job.find(filter);

    if (jobList.length === 0) {
      return res.status(200).json({
        status: "ok",
        message: "No data found for this college",
      });
    }

    res.status(200).json({ status: "ok", jobList: jobList });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving job lists",
      error: error.message,
    });
  }
};

module.exports = { createJob, getAllJob };
