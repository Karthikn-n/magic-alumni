import express from "express";
import College from "../models/College.js";
import Department from "../models/Department.js";
const router = express.Router();

router.post("/register", async (req, res) => {
  try {
    const { name, address, city } = req.body;
    if (!name || !address || !city) {
      return res.status(400).json({
        status: "not ok",
        message: "All required fields must be filled",
      });
    }

    const existingCollege = await College.findOne({
      name,
      address,
      city,
    });

    if (existingCollege) {
      return res.status(400).json({
        status: "not ok",
        message: "College created already",
      });
    }
    const newCollege = new College({
      name,
      address,
      city,
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

router.get("/", async (req, res) => {
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

router.put("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const updatedUser = await College.findByIdAndUpdate(id, req.body, {
      new: true,
    });
    res
      .status(200)
      .json({ message: "User updated successfully", user: updatedUser });
  } catch (error) {
    res.status(400).json({ message: "Error updating user", error });
  }
});

router.delete("/:id", async (req, res) => {
  try {
    const { id } = req.params;
    await College.findByIdAndDelete(id);
    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    res.status(400).json({ message: "Error deleting user", error });
  }
});

export default router;
