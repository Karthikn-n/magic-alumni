const express = require("express");
const {
  registerAlumni,
  getAllAlumni,
  updateAlumni,
  deleteAlumni,
  alumnimembersList,
  updateAlumniStatus,
  getAlumniById,
  loginAlumni,
  verifyOtp,
} = require("../controllers/alumniController");
const router = express.Router();

router.get("/test", (req, res) => {
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
