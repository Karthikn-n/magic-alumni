"use strict";

var express = require("express");

var multer = require("multer");

var _require = require("../controllers/jobController"),
    createJob = _require.createJob,
    getAllJob = _require.getAllJob;

var router = express.Router();
var storage = multer.diskStorage({
  destination: function destination(req, file, cb) {
    cb(null, "uploads/jobs/");
  },
  filename: function filename(req, file, cb) {
    cb(null, "".concat(Date.now(), "_").concat(file.originalname));
  }
});
var upload = multer({
  storage: storage
});
router.post("/create", upload.single("job_image"), createJob);
router.post("/", getAllJob);
module.exports = router;