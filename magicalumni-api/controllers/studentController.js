const Student = require("../models/Student");
const College = require("../models/College");
const StudentCollege = require("../models/StudentCollege");
const Department = require("../models/Department");
const mongoose = require("mongoose");
const otpGenerator = require("otp-generator");
const StudentOTP = require("../models/StudentOTPModel");
const AlumniMember = require("../models/AlumniMember");
const registerStudent = async (req, res) => {
  try {
    const {
      name,
      college_name,
      college_id,
      mobile_number,
      email,
      department_name,
      linkedin_url,
      current_year,
    } = req.body;

    const existingStudent = await Student.findOne({
      name,
      college_name,
      college_id,
      mobile_number,
      email,
      department_name,
      linkedin_url,
      current_year,
    });

    if (existingStudent) {
      return res
        .status(400)
        .json({ status: "not ok", message: "Student data already exists" });
    }

    const newStudent = new Student({
      name,
      college_name,
      college_id,
      mobile_number,
      email,
      department_name,
      linkedin_url,
      current_year,
    });

    await newStudent.save();
    res.status(201).json({
      status: "ok",
      message: "Student registered successfully",
      student: newStudent,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error registering student data",
      error: error.message,
    });
  }
};

const getAllStudent = async (req, res) => {
  try {
    const { college_id } = req.body;

    if (!college_id || !mongoose.Types.ObjectId.isValid(college_id)) {
      return res.status(400).json({
        status: "error",
        message: "Invalid or missing college_id",
      });
    }

    const studentMembers = await StudentCollege.find({
      college_id,
    });

    if (studentMembers.length === 0) {
      return res.status(200).json({
        status: "ok",
        message: "No approved students found for this college",
      });
    }

    const studentIds = studentMembers.map((member) => member.student_id);
    const studentDetails = await AlumniMember.find({
      _id: { $in: studentIds },
    });

    res.status(200).json({
      status: "ok",
      studentDetails: studentDetails,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving students",
      error: error.message,
    });
  }
};

const updateStudent = async (req, res) => {
  const { id, name, mobile_number, email, linkedin_url, current_year } =
    req.body;

  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing student_id",
      });
    }

    const updatedStudent = await AlumniMember.findByIdAndUpdate(
      id,
      {
        name,
        mobile_number,
        email,
        linkedin_url,
        current_year,
      },
      { new: true }
    );

    if (!updatedStudent) {
      return res
        .status(404)
        .json({ status: "not found", message: "Student member not found" });
    }

    res.status(200).json({
      status: "ok",
      message: "Student updated successfully",
      student: updatedStudent,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating student member",
      error: error.message,
    });
  }
};

const deleteStudent = async (req, res) => {
  const { id } = req.body;

  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing student_id",
      });
    }

    const deletedStudent = await Student.findByIdAndDelete(id);

    if (!deletedStudent) {
      return res
        .status(404)
        .json({ status: "not found", message: "Student member not found" });
    }

    res.status(200).json({
      status: "ok",
      message: "Student deleted successfully",
      student: deletedStudent,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error deleting student member",
      error: error.message,
    });
  }
};

const loginStudent = async (req, res) => {
  try {
    const { mobile_number } = req.body;

    if (!mobile_number) {
      return res
        .status(400)
        .json({ status: "not ok", message: "Mobile number is required" });
    }

    const student = await Student.findOne({ mobile_number });

    if (!student) {
      return res
        .status(404)
        .json({ status: "not found", message: "Student member not found" });
    }

    const otp = otpGenerator.generate(6, {
      upperCase: false,
      specialChars: false,
    });

    const otpRecord = new StudentOTP({
      student_id: student._id,
      mobile_number,
      otp,
      expiresAt: Date.now() + 5 * 60 * 1000,
    });

    await otpRecord.save();

    console.log(`OTP for ${mobile_number}: ${otp}`);

    res.status(200).json({
      status: "ok",
      message: "OTP generated and stored successfully",
      mobile_number: student.mobile_number,
    });
  } catch (error) {
    console.error("Error processing login request:", error.message);
    res.status(500).json({
      status: "error",
      message: "Error processing login request",
      error: error.message,
    });
  }
};

const verifyStudentOtp = async (req, res) => {
  try {
    const { mobile_number, otp } = req.body;

    if (!mobile_number || !otp) {
      return res.status(400).json({
        status: "not ok",
        message: "Mobile number and OTP are required",
      });
    }

    const otpRecord = await StudentOTP.findOne({
      mobile_number,
      otp,
      expiresAt: { $gt: Date.now() },
    });

    if (!otpRecord) {
      return res
        .status(400)
        .json({ status: "not ok", message: "Invalid or expired OTP" });
    }

    const student = await Student.findOne({ mobile_number });

    if (!student) {
      return res
        .status(404)
        .json({ status: "not found", message: "Student not found" });
    }

    await StudentOTP.deleteOne({ _id: otpRecord._id });

    res.status(200).json({
      status: "ok",
      message: "OTP verified successfully",
      student_id: student._id,
      name: student.name,
    });
  } catch (error) {
    console.error("Error verifying OTP:", error.message);
    res.status(500).json({
      status: "error",
      message: "Error verifying OTP",
      error: error.message,
    });
  }
};

const getStudentById = async (req, res) => {
  try {
    const { student_id } = req.body;

    if (!student_id || !mongoose.Types.ObjectId.isValid(student_id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing student_id",
      });
    }

    const studentCollegeData = await StudentCollege.find({
      student_id,
    });

    // if (studentCollegeData.length === 0) {
    //   return res.status(200).json({
    //     status: "ok",
    //     message: "No approved student member found for this student_id",
    //   });
    // }

    const student = await AlumniMember.findOne({ _id: student_id });

    if (!student) {
      return res.status(200).json({
        status: "ok",
        message: "No student found with this ID",
      });
    }

    const collegeDetails = await Promise.all(
      studentCollegeData.map(async (record) => {
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
      status: "ok",
      student: student,
      colleges: collegeDetails,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving student and college data",
      error: error.message,
    });
  }
};

const studentAddCollege = async (req, res) => {
  try {
    const { college_id, student_id, department_id } = req.body;

    if (
      !mongoose.Types.ObjectId.isValid(student_id) ||
      !mongoose.Types.ObjectId.isValid(college_id) ||
      !mongoose.Types.ObjectId.isValid(department_id)
    ) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid student_id, college_id, or department_id",
      });
    }

    const newCollege = new StudentCollege({
      college_id,
      student_id,
      department_id,
    });

    await newCollege.save();

    res.status(201).json({
      status: "ok",
      message: "College added successfully",
      college: newCollege,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error adding college",
      error: error.message,
    });
  }
};

module.exports = {
  registerStudent,
  getAllStudent,
  updateStudent,
  deleteStudent,
  loginStudent,
  verifyStudentOtp,
  getStudentById,
  studentAddCollege,
};
