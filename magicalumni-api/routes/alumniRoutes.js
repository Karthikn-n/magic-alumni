const express = require("express");
const {
  registerMember,
  getAllAlumni,
  updateAlumni,
  deleteAlumni,
  alumnimembersList,
  updateAlumniStatus,
  getAlumniById,
  loginAlumni,
  verifyOtp,
  alumniAddCollege,
} = require("../controllers/alumniController");
const router = express.Router();

router.get("/test", (req, res) => {
  res.status(200).send("Test route is working");
});

router.post("/member/register", registerMember);
router.get("/alumni", getAllAlumni);
router.post("/alumni/update", updateAlumni);
router.post("/alumni/delete", deleteAlumni);
router.get("/alumnimemberslist", alumnimembersList);
router.post("/alumni/updatestatus", updateAlumniStatus);
router.post("/alumni/member", getAlumniById);
router.post("/alumni/login", loginAlumni);
router.post("/alumni/verifyOtp", verifyOtp);
router.post("/alumni/addCollege", alumniAddCollege);

module.exports = router;
