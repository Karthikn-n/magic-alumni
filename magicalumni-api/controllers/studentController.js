const Student = require("../models/Student");
const College = require("../models/College");
const StudentCollege = require("../models/StudentCollege");
const Department = require("../models/Department");
const mongoose = require("mongoose");
const otpGenerator = require("otp-generator");
const StudentOTP = require("../models/StudentOTPModel");
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
      return res.status(400).json({ message: "Student data already exists" });
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
      message: "Student registered successfully",
      student: newStudent,
    });
  } catch (error) {
    res.status(500).json({
      message: "Error registering student data",
      error: error.message,
    });
  }
};

const getAllStudent = async (req, res) => {
  try {
    const { college_id } = req.body;

    if (college_id && !mongoose.Types.ObjectId.isValid(college_id)) {
      return res.status(400).json({
        message: "Invalid college_id format",
      });
    }

    let filter = {};
    if (college_id) {
      filter.college_id = college_id;
    }

    const studentList = await Student.find(filter);

    if (studentList.length === 0) {
      return res.status(200).json({
        message: "No data found for this college",
      });
    }

    res.status(200).json(studentList);
  } catch (error) {
    res.status(500).json({
      message: "Error retrieving student lists",
      error: error.message,
    });
  }
};

const updateStudent = async (req, res) => {
  const {
    id,
    name,
    college_name,
    college_id,
    mobile_number,
    email,
    department_name,
    linkedin_url,
    current_year,
  } = req.body;

  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        message: "Invalid or missing student_id",
      });
    }

    const updatedStudent = await Student.findByIdAndUpdate(
      id,
      {
        name,
        college_name,
        college_id,
        mobile_number,
        email,
        department_name,
        linkedin_url,
        current_year,
      },
      { new: true }
    );

    if (!updatedStudent) {
      return res.status(404).json({ message: "Student member not found" });
    }

    res.status(200).json({
      message: "Student updated successfully",
      student: updatedStudent,
    });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error updating student member", error: error.message });
  }
};

const deleteStudent = async (req, res) => {
  const { id } = req.body;

  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        message: "Invalid or missing student_id",
      });
    }

    const deletedStudent = await Student.findByIdAndDelete(id);

    if (!deletedStudent) {
      return res.status(404).json({ message: "Student member not found" });
    }

    res.status(200).json({
      message: "Student deleted successfully",
      student: deletedStudent,
    });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Error deleting student member", error: error.message });
  }
};

const loginStudent = async (req, res) => {
  try {
    const { mobile_number } = req.body;

    if (!mobile_number) {
      return res.status(400).json({ message: "Mobile number is required" });
    }

    const student = await Student.findOne({ mobile_number });

    if (!student) {
      return res.status(404).json({ message: "Student member not found" });
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
      message: "OTP generated and stored successfully",
      mobile_number: student.mobile_number,
    });
  } catch (error) {
    console.error("Error processing login request:", error.message);
    res.status(500).json({
      message: "Error processing login request",
      error: error.message,
    });
  }
};

const verifyStudentOtp = async (req, res) => {
  try {
    const { mobile_number, otp } = req.body;

    if (!mobile_number || !otp) {
      return res
        .status(400)
        .json({ message: "Mobile number and OTP are required" });
    }

    const otpRecord = await StudentOTP.findOne({
      mobile_number,
      otp,
      expiresAt: { $gt: Date.now() },
    });

    if (!otpRecord) {
      return res.status(400).json({ message: "Invalid or expired OTP" });
    }

    const student = await Student.findOne({ mobile_number });

    if (!student) {
      return res.status(404).json({ message: "Student not found" });
    }

    await StudentOTP.deleteOne({ _id: otpRecord._id });

    res.status(200).json({
      message: "OTP verified successfully",
      student_id: student._id,
      name: student.name,
    });
  } catch (error) {
    console.error("Error verifying OTP:", error.message);
    res.status(500).json({
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
        message: "Invalid or missing student_id",
      });
    }

    const studentCollegeData = await StudentCollege.find({
      student_id,
      status: "approved",
    });

    if (studentCollegeData.length === 0) {
      return res.status(200).json({
        message: "No approved student member found for this student_id",
      });
    }

    const student = await Student.findOne({ _id: student_id });

    if (!student) {
      return res.status(200).json({
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
      student,
      colleges: collegeDetails,
    });
  } catch (error) {
    res.status(500).json({
      message: "Error retrieving student and college data",
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
};
