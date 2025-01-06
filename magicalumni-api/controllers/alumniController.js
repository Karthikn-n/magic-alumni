const AlumniMember = require("../models/AlumniMember");
const AlumniCollege = require("../models/AlumniCollege");
const StudentCollege = require("../models/StudentCollege");
const College = require("../models/College");
const Department = require("../models/Department");
const Student = require("../models/Student");
const mongoose = require("mongoose");
const otpGenerator = require("otp-generator");
const { sendOtp } = require("../services/otpService");
const OTPModel = require("../models/OTPModel");
// const registerAlumni = async (req, res) => {
//   try {
//     const {
//       name,
//       college_name,
//       department_name,
//       linkedin_url,
//       completed_year,
//     } = req.body;

//     const existingAlumni = await AlumniMember.findOne({
//       name,
//       college_name,
//       department_name,
//       linkedin_url,
//       completed_year,
//     });

//     if (existingAlumni) {
//       return res.status(400).json({ message: "Alumni member already exists" });
//     }

//     const newAlumni = new AlumniMember({
//       name,
//       college_name,
//       department_name,
//       linkedin_url,
//       completed_year,
//     });

//     await newAlumni.save();
//     res
//       .status(201)
//       .json({ message: "Alumni registered successfully", alumni: newAlumni });
//   } catch (error) {
//     res.status(500).json({
//       message: "Error registering alumni member",
//       error: error.message,
//     });
//   }
// };

const registerMember = async (req, res) => {
  try {
    const {
      name,
      // department_name,
      linkedin_url,
      completed_year,
      current_year,
      college_id,
      mobile_number,
      designation,
      email,
      position,
      department_id,
    } = req.body;

    let existingMember,
      newMember,
      mappedColleges = [];

    if (position) {
      existingMember = await Student.findOne({ name });

      if (existingMember) {
        return res.status(400).json({ message: "Student already exists" });
      }

      newMember = new Student({
        name,
        // department_name,
        linkedin_url,
        current_year,
        mobile_number,
        email,
      });

      await newMember.save();

      const college = await College.findById(college_id);
      if (!college) {
        return res
          .status(404)
          .json({ message: `College not found for ID: ${college_id}` });
      }

      const studentCollege = new StudentCollege({
        student_id: newMember._id,
        college_id,
        department_id,
      });

      await studentCollege.save();
      mappedColleges.push(college);
    } else {
      existingMember = await AlumniMember.findOne({
        name,
        // department_name,
        linkedin_url,
        completed_year,
      });

      if (existingMember) {
        return res
          .status(400)
          .json({ message: "Alumni member already exists" });
      }

      newMember = new AlumniMember({
        name,
        // department_name,
        linkedin_url,
        completed_year,
        mobile_number,
        designation,
        email,
      });

      await newMember.save();

      const college = await College.findById(college_id);
      if (!college) {
        return res
          .status(404)
          .json({ message: `College not found for ID: ${college_id}` });
      }

      const alumniCollege = new AlumniCollege({
        alumni_id: newMember._id,
        college_id,
        department_id,
      });

      await alumniCollege.save();
      mappedColleges.push(college);
    }

    res.status(201).json({
      message: `Registered successfully`,
      status: "Okay",
      member: newMember,
      colleges: mappedColleges,
    });
  } catch (error) {
    res.status(500).json({
      message: "Error registering member",
      error: error.message,
    });
  }
};

const getAllAlumni = async (req, res) => {
  try {
    const alumniMembers = await AlumniMember.find({ status: "approved" });
    if (alumniMembers.length === 0) {
      return res
        .status(200)
        .json({ message: "No approved alumni members found" });
    }
    res.status(200).json(alumniMembers);
  } catch (error) {
    res.status(500).json({
      message: "Error retrieving alumni members",
      error: error.message,
    });
  }
};

const getAlumniById = async (req, res) => {
  try {
    const { alumni_id } = req.body;

    if (!alumni_id || !mongoose.Types.ObjectId.isValid(alumni_id)) {
      return res.status(400).json({
        message: "Invalid or missing alumni_id",
      });
    }

    const alumniCollegeData = await AlumniCollege.find({
      alumni_id,
      status: "approved",
    });

    if (alumniCollegeData.length === 0) {
      return res.status(200).json({
        message: "No approved alumni member found for this alumni_id",
      });
    }

    const alumni = await AlumniMember.findOne({ _id: alumni_id });

    if (!alumni) {
      return res.status(200).json({
        message: "No alumni member found with this ID",
      });
    }

    const collegeDetails = await Promise.all(
      alumniCollegeData.map(async (record) => {
        const college = await College.findOne({ _id: record.college_id });
        const departments = await Department.find({
          _id: record.department_id,
        });
        return {
          ...college._doc,
          departments,
        };
      })
    );

    res.status(200).json({
      alumni,
      colleges: collegeDetails,
    });
  } catch (error) {
    res.status(500).json({
      message: "Error retrieving alumni member and college data",
      error: error.message,
    });
  }
};

const updateAlumni = async (req, res) => {
  const {
    id,
    name,
    college_name,
    department_name,
    linkedin_url,
    completed_year,
    mobile_number,
    email,
    status,
  } = req.body;

  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        message: "Invalid or missing alumni_id",
      });
    }

    const updatedAlumni = await AlumniMember.findByIdAndUpdate(
      id,
      {
        name,
        college_name,
        department_name,
        linkedin_url,
        completed_year,
        mobile_number,
        email,
        status,
      },
      { new: true }
    );

    if (!updatedAlumni) {
      return res.status(404).json({ message: "Alumni member not found" });
    }

    res
      .status(200)
      .json({ message: "Alumni updated successfully", alumni: updatedAlumni });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error updating alumni member", error: error.message });
  }
};

const deleteAlumni = async (req, res) => {
  const { id } = req.body;

  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        message: "Invalid or missing alumni_id",
      });
    }

    const deletedAlumni = await AlumniMember.findByIdAndDelete(id);

    if (!deletedAlumni) {
      return res.status(404).json({ message: "Alumni member not found" });
    }

    res
      .status(200)
      .json({ message: "Alumni deleted successfully", alumni: deletedAlumni });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error deleting alumni member", error: error.message });
  }
};

const alumnimembersList = async (req, res) => {
  try {
    const alumniMembers = await AlumniCollege.find({ status: "not approved" });

    if (alumniMembers.length === 0) {
      return res
        .status(200)
        .json({ message: "No unapproved alumni members found" });
    }

    res.status(200).json({ alumni: alumniMembers });
  } catch (error) {
    res.status(500).json({
      message: "Error retrieving alumni members list",
      error: error.message,
    });
  }
};

const updateAlumniStatus = async (req, res) => {
  const { alumni_id, college_id, status } = req.body;

  try {
    if (!alumni_id || !college_id || !status) {
      return res.status(400).json({
        message: "alumni_id, college_id, and status are required",
      });
    }

    if (
      !mongoose.Types.ObjectId.isValid(alumni_id) ||
      !mongoose.Types.ObjectId.isValid(college_id)
    ) {
      return res.status(400).json({
        message: "Invalid alumni_id or college_id",
      });
    }

    const updatedAlumniCollege = await AlumniCollege.findOneAndUpdate(
      { alumni_id, college_id },
      { status },
      { new: true }
    );

    if (!updatedAlumniCollege) {
      return res.status(404).json({
        message: "No alumni-college mapping found with the provided IDs",
      });
    }

    res.status(200).json({
      message: "Alumni status updated successfully",
      alumniCollege: updatedAlumniCollege,
    });
  } catch (error) {
    res.status(500).json({
      message: "Error updating alumni status",
      error: error.message,
    });
  }
};

const loginAlumni = async (req, res) => {
  try {
    const { mobile_number } = req.body;

    if (!mobile_number) {
      return res.status(400).json({ message: "Mobile number is required" });
    }

    const alumni = await AlumniMember.findOne({ mobile_number });

    if (!alumni) {
      return res.status(404).json({ message: "Alumni member not found" });
    }

    const otp = otpGenerator.generate(6, {
      upperCase: false,
      specialChars: false,
    });

    const otpRecord = new OTPModel({
      alumni_id: alumni._id,
      mobile_number,
      otp,
      expiresAt: Date.now() + 5 * 60 * 1000,
    });

    await otpRecord.save();

    console.log(`OTP for ${mobile_number}: ${otp}`);

    res.status(200).json({
      message: "OTP generated and stored successfully",
      mobile_number: alumni.mobile_number,
    });
  } catch (error) {
    console.error("Error processing login request:", error.message);
    res.status(500).json({
      message: "Error processing login request",
      error: error.message,
    });
  }
};

const verifyOtp = async (req, res) => {
  try {
    const { mobile_number, otp } = req.body;

    if (!mobile_number || !otp) {
      return res
        .status(400)
        .json({ message: "Mobile number and OTP are required" });
    }

    const otpRecord = await OTPModel.findOne({
      mobile_number,
      otp,
      expiresAt: { $gt: Date.now() },
    });

    if (!otpRecord) {
      return res.status(400).json({ message: "Invalid or expired OTP" });
    }

    const alumni = await AlumniMember.findOne({ mobile_number });

    if (!alumni) {
      return res.status(404).json({ message: "Alumni member not found" });
    }

    await OTPModel.deleteOne({ _id: otpRecord._id });

    res.status(200).json({
      message: "OTP verified successfully",
      alumni_id: alumni._id,
      name: alumni.name,
    });
  } catch (error) {
    console.error("Error verifying OTP:", error.message);
    res.status(500).json({
      message: "Error verifying OTP",
      error: error.message,
    });
  }
};

const alumniAddCollege = async (req, res) => {
  try {
    const { college_id, alumni_id, department_id } = req.body;

    if (
      !mongoose.Types.ObjectId.isValid(alumni_id) ||
      !mongoose.Types.ObjectId.isValid(college_id) ||
      !mongoose.Types.ObjectId.isValid(department_id)
    ) {
      return res.status(400).json({
        message: "Invalid alumni_id, college_id, or department_id",
      });
    }

    const newCollege = new AlumniCollege({
      college_id,
      alumni_id,
      department_id,
    });

    await newCollege.save();

    res.status(201).json({
      message: "College added successfully",
      college: newCollege,
    });
  } catch (error) {
    res.status(500).json({
      message: "Error adding college",
      error: error.message,
    });
  }
};

module.exports = {
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
};
