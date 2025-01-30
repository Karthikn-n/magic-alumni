import express from "express";
// import Notification from "../models/Notification";
import Notification from "../models/Notification.js";
import mongoose from "mongoose";
const router = express.Router();

router.post("/list", async (req, res) => {
  try {
    const { alumni_id } = req.body;

    if (alumni_id && !mongoose.Types.ObjectId.isValid(alumni_id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid alumni_id format",
      });
    }

    const notificationList = await Notification.find({
      user_id: alumni_id,
    });

    if (notificationList.length === 0) {
      return res.status(200).json({
        status: "ok",
        message: "No notification found for this alumni",
      });
    }

    res.status(200).json({ status: "ok", notificationList: notificationList });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving notifications lists",
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

    const deletedNotification = await Notification.findByIdAndDelete(id);

    if (!deletedNotification) {
      return res
        .status(404)
        .json({ status: "not found", message: "Notification not found" });
    }
    res.status(200).json({
      status: "ok",
      message: "Notification deleted successfully",
      deletedNotification: deletedNotification,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error deleting notification",
      error: error.message,
    });
  }
});

export default router;
