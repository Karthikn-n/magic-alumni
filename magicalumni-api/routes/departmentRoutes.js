const express = require("express");

const { createDepartment } = require("../controllers/departmentController");
const router = express.Router();

router.post("/department/create", createDepartment);
module.exports = router;
