const axios = require("axios");
const fs = require("fs");
const College = require("../models/College");
const mongoose = require("mongoose");

const path = require("path");

const createCollege = async (req, res) => {
  try {
    const { name, address, city } = req.body;

    if (!name || !address || !city) {
      return res
        .status(400)
        .json({ message: "All required fields must be filled" });
    }

    const newCollege = new College({
      name,
      address,
      city,
    });

    const savedCollege = await newCollege.save();
    res
      .status(201)
      .json({ message: "College created successfully", college: savedCollege });
  } catch (error) {
    res.status(500).json({ message: "Error creating college", error });
  }
};

const getCollege = async (req, res) => {
  try {
    // Fetch all colleges from the College model
    const collegeList = await College.find();

    // If no colleges are found, return a message
    if (collegeList.length === 0) {
      return res.status(200).json({
        message: "No colleges found",
      });
    }

    // Return the list of colleges
    res.status(200).json(collegeList);
  } catch (error) {
    res.status(500).json({
      message: "Error retrieving college lists",
      error: error.message,
    });
  }
};
module.exports = { createCollege, getCollege };
