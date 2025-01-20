"use strict";

var express = require("express");

var _require = require("../controllers/collegeController"),
    createCollege = _require.createCollege,
    getCollege = _require.getCollege;

var router = express.Router();
router.post("/college/register", createCollege);
router.get("/college", getCollege);
module.exports = router;