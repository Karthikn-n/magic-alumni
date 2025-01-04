"use strict";

var express = require("express");

var router = express.Router();

var _require = require("../controllers/dashboardController"),
    getDashboardData = _require.getDashboardData;

router.get("/", getDashboardData);
module.exports = router;