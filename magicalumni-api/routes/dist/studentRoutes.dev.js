"use strict";

var express = require("express");

var _require = require("../controllers/studentController"),
    registerStudent = _require.registerStudent,
    getAllStudent = _require.getAllStudent,
    updateStudent = _require.updateStudent,
    deleteStudent = _require.deleteStudent,
    loginStudent = _require.loginStudent,
    verifyStudentOtp = _require.verifyStudentOtp;

var router = express.Router();
router.post("/student/register", registerStudent);
router.post("/student", getAllStudent);
router.post("/student/update", updateStudent);
router.post("/student/delete", deleteStudent);
router.post("/student/login", loginStudent);
router.post("/student/verifyStudentOtp", verifyStudentOtp);
module.exports = router;