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

    if (!college_id || !job_title || !last_date) {
      return res.status(400).json({
        status: "not ok",
        message: "All required fields must be filled",
      });
    }
    const existingJob = await Job.findOne({
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
        type: "jobs",
        headings: { en: "New Job Created!" },
        contents: { en: `${job_title} vacancy at ${company_name}.` },
        location: location,
        actions: [{ id: "apply", title: "Apply Job", url: job_url }],
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
              Authorization: `Basic ${process.env.ONSIGNAL_API_KEY}`,
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
      } catch (error) {
        console.error(
          "Error sending OneSignal notification:",
          error.response?.data || error.message
        );
      }
    }

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

    if (reportList.length === 0) {
      return res.status(404).json({
        status: "not ok",
        message: "No reports found",
      });
    }

    const alumniDetailsPromises = reportList.map(async (report) => {
      const alumni = await Member.findById(report.alumni_id);
      return { ...report._doc, alumni };
    });

    const reportListWithAlumni = await Promise.all(alumniDetailsPromises);

    console.log(reportListWithAlumni);
    res.status(200).json({
      status: "ok",
      message: "Reports retrieved successfully",
      reportList: reportListWithAlumni,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving job",
      error: error.message,
    });
  }
});

router.post("/jobsCount", async (req, res) => {
  try {
    const { college_id } = req.body;
    if (!college_id) {
      return res
        .status(400)
        .json({ status: "not ok", message: "College ID is required" });
    }
    const jobsCount = await Job.find({
      college_id,
    });
    const jobsCountOff = jobsCount.length;
    res.status(200).json({
      status: "ok",
      message: "Data generated",
      jobsCount: jobsCount,
      jobsCountOff: jobsCountOff,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating status",
      error: error.message,
    });
  }
});

router.post("/delete", async (req, res) => {
  const { id } = req.body;
  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing job ID",
      });
    }

    const deletedJob = await Job.findByIdAndDelete(id);

    if (!deletedJob) {
      return res
        .status(404)
        .json({ status: "not found", message: "Job not found" });
    }
    res.status(200).json({
      status: "ok",
      message: "Job deleted successfully",
      job: deletedJob,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error deleting job",
      error: error.message,
    });
  }
});

router.post("/update", async (req, res) => {
  const {
    id,
    job_title,
    job_type,
    last_date,
    company_name,
    location,
    job_url,
    email,
    tag,
  } = req.body;

  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing Job ID",
      });
    }

    const updatedJob = await Job.findByIdAndUpdate(
      id,
      {
        job_title,
        job_type,
        last_date,
        company_name,
        location,
        job_url,
        email,
        tag,
      },
      { new: true }
    );

    if (!updatedJob) {
      return res.status(404).json({ message: "Job not found" });
    }

    res.status(200).json({
      status: "ok",
      message: "Updated successfully",
      job: updatedJob,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating data",
      error: error.message,
    });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const job = await Job.findById(req.params.id);
    if (!job) {
      return res
        .status(404)
        .json({ status: "not ok", message: "Job not found" });
    }
    res.status(200).json({ status: "ok", job: job });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error fetching job details",
      error: error.message,
    });
  }
});

export default router;
