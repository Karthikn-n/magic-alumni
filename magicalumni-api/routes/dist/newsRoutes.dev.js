"use strict";

var express = require("express");

var multer = require("multer");

var _require = require("../controllers/newsController"),
    createNews = _require.createNews,
    getNewsByID = _require.getNewsByID;

var router = express.Router();
var storage = multer.diskStorage({
  destination: function destination(req, file, cb) {
    cb(null, "uploads/news/");
  },
  filename: function filename(req, file, cb) {
    cb(null, "".concat(Date.now(), "_").concat(file.originalname));
  }
});
var upload = multer({
  storage: storage
});
router.post("/create", upload.single("image"), createNews);
router.post("/list", getNewsByID);
module.exports = router;