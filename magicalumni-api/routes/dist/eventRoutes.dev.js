"use strict";

var express = require("express");

var multer = require("multer");

var _require = require("../controllers/eventController"),
    createEvent = _require.createEvent,
    getAllEvent = _require.getAllEvent;

var router = express.Router();
var storage = multer.diskStorage({
  destination: function destination(req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function filename(req, file, cb) {
    cb(null, "".concat(Date.now(), "_").concat(file.originalname));
  }
});
var upload = multer({
  storage: storage
}); // Event Routes

router.post("/create", upload.single("event_image"), createEvent);
router.post("/", getAllEvent);
module.exports = router;