import express from "express";
import Job from "../models/Job.js";
import JobReport from "../models/JobReport.js";
import Member from "../models/Member.js";
import mongoose from "mongoose";
const router = express.Router();

router.post("/create", async (req, res) => {
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
      tag,
    } = req.body;

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
});

router.post("/list", async (req, res) => {
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
});

router.post("/report", async (req, res) => {
  try {
    const { job_id, alumni_id, reason } = req.body;

    if (
      !mongoose.Types.ObjectId.isValid(alumni_id) ||
      !mongoose.Types.ObjectId.isValid(job_id)
    ) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid alumni_id, job id",
      });
    }

    const alumni = await Member.findById(alumni_id);

    if (!alumni) {
      return res.status(404).json({
        status: "not found",
        message: "Alumni member not found",
      });
    }

    const report = new JobReport({
      job_id,
      alumni_id,
      reason,
    });

    await report.save();

    res.status(201).json({
      status: "ok",
      message: "Reported successfully",
      report: report,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error reporting job",
      error: error.message,
    });
  }
});

router.post("/reportList", async (req, res) => {
  try {
    const { job_id } = req.body;

    if (!mongoose.Types.ObjectId.isValid(job_id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid Job ID",
      });
    }

    const reportList = await JobReport.find({
      job_id: job_id,
    });

    res.status(200).json({
      status: "ok",
      message: "Reports retrieved successfully",
      reportList: reportList,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving job",
      error: error.message,
    });
  }
});
export default router;
