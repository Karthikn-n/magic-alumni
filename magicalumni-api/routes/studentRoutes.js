const express = require("express");

const {
  registerStudent,
  getAllStudent,
  updateStudent,
  deleteStudent,
  loginStudent,
  verifyStudentOtp,
  getStudentById,
  studentAddCollege,
} = require("../controllers/studentController");
const router = express.Router();

router.post("/student/register", registerStudent);
router.post("/student", getAllStudent);
router.post("/student/update", updateStudent);
router.post("/student/delete", deleteStudent);
router.post("/student/login", loginStudent);
router.post("/student/verifyStudentOtp", verifyStudentOtp);
router.post("/student/data", getStudentById);
router.post("/student/addcollege", studentAddCollege);
module.exports = router;
