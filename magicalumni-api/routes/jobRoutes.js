const express = require("express");
const multer = require("multer");
const { createJob, getAllJob } = require("../controllers/jobController");

const router = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/jobs/");
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}_${file.originalname}`);
  },
});
const upload = multer({ storage: storage });

router.post("/create", upload.single("job_image"), createJob);
router.post("/", getAllJob);
module.exports = router;
