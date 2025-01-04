"use strict";

var express = require("express");

var _require = require("../controllers/alumniController"),
    registerAlumni = _require.registerAlumni,
    getAllAlumni = _require.getAllAlumni,
    updateAlumni = _require.updateAlumni,
    deleteAlumni = _require.deleteAlumni,
    alumnimembersList = _require.alumnimembersList,
    updateAlumniStatus = _require.updateAlumniStatus,
    getAlumniById = _require.getAlumniById,
    loginAlumni = _require.loginAlumni,
    verifyOtp = _require.verifyOtp;

var router = express.Router();
router.get("/test", function (req, res) {
  res.status(200).send("Test route is working");
});
router.post("/alumni/register", registerAlumni);
router.get("/alumni", getAllAlumni);
router.post("/alumni/update", updateAlumni);
router.post("/alumni/delete", deleteAlumni);
router.get("/alumnimemberslist", alumnimembersList);
router.post("/alumni/updatestatus", updateAlumniStatus);
router.post("/alumni/member", getAlumniById);
router.post("/alumni/login", loginAlumni);
router.post("/alumni/verifyOtp", verifyOtp);
module.exports = router;