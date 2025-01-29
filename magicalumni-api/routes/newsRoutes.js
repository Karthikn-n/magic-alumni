import express from "express";
import News from "../models/News.js";
import multer from "multer";
import path from "path";
import mongoose from "mongoose";
const router = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/news");
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
}).single("image");

// Documented
router.post("/create", upload, async (req, res) => {
  try {
    const {
      college_id,
      title,
      description,
      news_posted,
      creator_name,
      location,
      news_link,
    } = req.body;

    const imagePath = req.file
      ? `/uploads/news/${req.file.filename}`
      : req.body.image;

    if (!college_id) {
      return res.status(400).json({
        status: "not ok",
        message: "All required fields must be filled",
      });
    }

    const newNews = new News({
      college_id,
      title,
      description,
      news_posted,
      creator_name,
      location,
      image: imagePath,
      news_link,
    });

    const savedNews = await newNews.save();
    res.status(201).json({
      status: "ok",
      message: "News created successfully",
      news: savedNews,
    });
  } catch (error) {
    res
      .status(500)
      .json({ status: "error", message: "Error creating news", error });
  }
});

// Documented
router.post("/list", async (req, res) => {
  try {
    const { college_id } = req.body;

    if (!college_id || !mongoose.Types.ObjectId.isValid(college_id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing college_id",
      });
    }

    const collegeData = await News.findOne({
      college_id,
    });

    if (!collegeData) {
      return res.status(404).json({
        status: "not found",
        message: "No news found for the provided college_id",
      });
    }

    const newsList = await News.find({
      college_id: collegeData.college_id,
    });

    if (newsList.length === 0) {
      return res.status(200).json({
        status: "ok",
        message: "No news found for this college",
      });
    }

    res.status(200).json({
      status: "ok",
      message: "News retrieved successfully",
      newsList: newsList,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving news data",
      error: error.message,
    });
  }
});

export default router;
