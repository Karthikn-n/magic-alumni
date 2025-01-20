const express = require("express");
const multer = require("multer");
const {
  createEvent,
  getAllEvent,
  updateEventStatus,
  eventPeople,
  eventPeopleCount,
} = require("../controllers/eventController");

const router = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}_${file.originalname}`);
  },
});
const upload = multer({ storage: storage });

router.post("/create", upload.single("event_image"), createEvent);
router.post("/", getAllEvent);
router.post("/updateStatus", updateEventStatus);
router.post("/updatePeople", eventPeople);
router.post("/eventpeople", eventPeopleCount);
module.exports = router;
