import express from "express";
import Department from "../models/Department.js";
import mongoose from "mongoose";
const router = express.Router();

router.post("/create", async (req, res) => {
  try {
    const { college_id, name } = req.body;

    const existingDepartment = await Department.findOne({
      college_id,
      name,
    });

    if (existingDepartment) {
      return res.status(400).json({
        status: "not ok",
        message: "Department already exists for this college",
      });
    }

    const newDepartment = new Department({
      college_id,
      name,
    });

    await newDepartment.save();

    res.status(201).json({
      status: "ok",
      message: "Department created successfully",
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error creating department",
      error: error.message,
    });
  }
});

router.post("/departmentCount", async (req, res) => {
  try {
    const { college_id } = req.body;
    if (!college_id) {
      return res
        .status(400)
        .json({ status: "not ok", message: "College ID is required" });
    }
    const departmentPeople = await Department.find({ college_id });
    const departmentPeopleCountOff = departmentPeople.length;
    res.status(200).json({
      status: "ok",
      message: "Data generated",
      departmentPeople: departmentPeople,
      departmentPeopleCountOff: departmentPeopleCountOff,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating status",
      error: error.message,
    });
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

    const departmentList = await Department.find({ college_id });

    if (departmentList.length === 0) {
      return res.status(200).json({
        status: "ok",
        message: "No data found for this college",
      });
    }

    res.status(200).json({ status: "ok", departmentList: departmentList });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving department lists",
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
        message: "Invalid or missing departement ID",
      });
    }

    const deletedDepartment = await Department.findByIdAndDelete(id);

    if (!deletedDepartment) {
      return res
        .status(404)
        .json({ status: "not found", message: "Alumni member not found" });
    }
    res.status(200).json({
      status: "ok",
      message: "Department deleted successfully",
      department: deletedDepartment,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error deleting department",
      error: error.message,
    });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const departement = await Department.findById(req.params.id);
    if (!departement) {
      return res
        .status(404)
        .json({ status: "not ok", message: "Departement not found" });
    }
    res.status(200).json({ status: "ok", departement: departement });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error fetching departement details",
      error: error.message,
    });
  }
});

router.post("/update", async (req, res) => {
  const { id, name } = req.body;

  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing department ID",
      });
    }

    const updatedDepartment = await Department.findByIdAndUpdate(
      id,
      {
        name,
      },
      { new: true }
    );

    if (!updatedDepartment) {
      return res.status(404).json({ message: "Department not found" });
    }

    res.status(200).json({
      status: "ok",
      message: "Updated successfully",
      department: updatedDepartment,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating data",
      error: error.message,
    });
  }
});

export default router;
