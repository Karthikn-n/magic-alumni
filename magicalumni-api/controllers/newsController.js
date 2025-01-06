const axios = require("axios");
const fs = require("fs");
const News = require("../models/News");
const mongoose = require("mongoose");

const path = require("path");

const createNews = async (req, res) => {
  try {
    const {
      alumni_id,
      college_id,
      title,
      description,
      news_posted,
      creator_name,
      image,
      news_link,
    } = req.body;

    const imagePath = req.file ? `/uploads/news/${req.file.filename}` : image;

    if (!alumni_id || !college_id) {
      return res.status(400).json({
        status: "not ok",
        message: "All required fields must be filled",
      });
    }

    const newNews = new News({
      alumni_id,
      college_id,
      title,
      description,
      news_posted,
      creator_name,
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
};

const getNewsByID = async (req, res) => {
  try {
    const { alumni_id, college_id } = req.body;

    if (
      !alumni_id ||
      !college_id ||
      !mongoose.Types.ObjectId.isValid(alumni_id) ||
      !mongoose.Types.ObjectId.isValid(college_id)
    ) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing alumni_id or college_id",
      });
    }

    const alumniCollegeData = await News.findOne({
      alumni_id,
      college_id,
    });

    if (!alumniCollegeData) {
      return res.status(404).json({
        status: "not found",
        message: "No data found for the provided alumni_id and college_id",
      });
    }

    const newsList = await News.find({
      college_id: alumniCollegeData.college_id,
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
};

module.exports = { createNews, getNewsByID };
