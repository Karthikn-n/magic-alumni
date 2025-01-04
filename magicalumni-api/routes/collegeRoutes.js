const express = require("express");

const {
  createCollege,
  getCollege,
} = require("../controllers/collegeController");
const router = express.Router();

router.post("/college/register", createCollege);
router.get("/college", getCollege);

module.exports = router;
