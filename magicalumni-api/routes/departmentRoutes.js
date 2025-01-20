import express from "express";
import Department from "../models/Department.js";

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

export default router;
