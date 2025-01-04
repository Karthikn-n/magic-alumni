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
      last_date,
      company_name,
      location,
      job_image,
      tag,
    } = req.body;

    const imagePath = req.file
      ? `/uploads/jobs/${req.file.filename}`
      : job_image;

    if (!alumni_id || !college_id || !job_title || !last_date || !imagePath) {
      return res
        .status(400)
        .json({ message: "All required fields must be filled" });
    }

    const newJob = new Job({
      alumni_id,
      college_id,
      job_title,
      last_date,
      company_name,
      location,
      job_image: imagePath,
      tag,
    });

    const savedJob = await newJob.save();
    res
      .status(201)
      .json({ message: "Job created successfully", job: savedJob });
  } catch (error) {
    res.status(500).json({ message: "Error creating job", error });
  }
};

const getAllJob = async (req, res) => {
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

    const jobList = await Job.find(filter);

    if (jobList.length === 0) {
      return res.status(200).json({
        message: "No data found for this college",
      });
    }

    res.status(200).json(jobList);
  } catch (error) {
    res.status(500).json({
      message: "Error retrieving job lists",
      error: error.message,
    });
  }
};

module.exports = { createJob, getAllJob };
