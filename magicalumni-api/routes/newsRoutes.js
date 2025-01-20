const express = require("express");
const multer = require("multer");
const { createNews, getNewsByID } = require("../controllers/newsController");

const router = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/news/");
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}_${file.originalname}`);
  },
});
const upload = multer({ storage: storage });

router.post("/create", upload.single("image"), createNews);
router.post("/list", getNewsByID);
module.exports = router;
