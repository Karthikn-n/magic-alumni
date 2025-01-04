"use strict";

var Student = require("../models/Student");

var mongoose = require("mongoose");

var otpGenerator = require("otp-generator");

var StudentOTP = require("../models/StudentOTPModel");

var registerStudent = function registerStudent(req, res) {
  var _req$body, name, college_name, college_id, mobile_number, email, department_name, linkedin_url, current_year, existingStudent, newStudent;

  return regeneratorRuntime.async(function registerStudent$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          _context.prev = 0;
          _req$body = req.body, name = _req$body.name, college_name = _req$body.college_name, college_id = _req$body.college_id, mobile_number = _req$body.mobile_number, email = _req$body.email, department_name = _req$body.department_name, linkedin_url = _req$body.linkedin_url, current_year = _req$body.current_year;
          _context.next = 4;
          return regeneratorRuntime.awrap(Student.findOne({
            name: name,
            college_name: college_name,
            college_id: college_id,
            mobile_number: mobile_number,
            email: email,
            department_name: department_name,
            linkedin_url: linkedin_url,
            current_year: current_year
          }));

        case 4:
          existingStudent = _context.sent;

          if (!existingStudent) {
            _context.next = 7;
            break;
          }

          return _context.abrupt("return", res.status(400).json({
            message: "Student data already exists"
          }));

        case 7:
          newStudent = new Student({
            name: name,
            college_name: college_name,
            college_id: college_id,
            mobile_number: mobile_number,
            email: email,
            department_name: department_name,
            linkedin_url: linkedin_url,
            current_year: current_year
          });
          _context.next = 10;
          return regeneratorRuntime.awrap(newStudent.save());

        case 10:
          res.status(201).json({
            message: "Student registered successfully",
            student: newStudent
          });
          _context.next = 16;
          break;

        case 13:
          _context.prev = 13;
          _context.t0 = _context["catch"](0);
          res.status(500).json({
            message: "Error registering student data",
            error: _context.t0.message
          });

        case 16:
        case "end":
          return _context.stop();
      }
    }
  }, null, null, [[0, 13]]);
};

var getAllStudent = function getAllStudent(req, res) {
  var college_id, filter, studentList;
  return regeneratorRuntime.async(function getAllStudent$(_context2) {
    while (1) {
      switch (_context2.prev = _context2.next) {
        case 0:
          _context2.prev = 0;
          college_id = req.body.college_id;

          if (!(college_id && !mongoose.Types.ObjectId.isValid(college_id))) {
            _context2.next = 4;
            break;
          }

          return _context2.abrupt("return", res.status(400).json({
            message: "Invalid college_id format"
          }));

        case 4:
          filter = {};

          if (college_id) {
            filter.college_id = college_id;
          }

          _context2.next = 8;
          return regeneratorRuntime.awrap(Student.find(filter));

        case 8:
          studentList = _context2.sent;

          if (!(studentList.length === 0)) {
            _context2.next = 11;
            break;
          }

          return _context2.abrupt("return", res.status(200).json({
            message: "No data found for this college"
          }));

        case 11:
          res.status(200).json(studentList);
          _context2.next = 17;
          break;

        case 14:
          _context2.prev = 14;
          _context2.t0 = _context2["catch"](0);
          res.status(500).json({
            message: "Error retrieving student lists",
            error: _context2.t0.message
          });

        case 17:
        case "end":
          return _context2.stop();
      }
    }
  }, null, null, [[0, 14]]);
};

var updateStudent = function updateStudent(req, res) {
  var _req$body2, id, name, college_name, college_id, mobile_number, email, department_name, linkedin_url, current_year, updatedStudent;

  return regeneratorRuntime.async(function updateStudent$(_context3) {
    while (1) {
      switch (_context3.prev = _context3.next) {
        case 0:
          _req$body2 = req.body, id = _req$body2.id, name = _req$body2.name, college_name = _req$body2.college_name, college_id = _req$body2.college_id, mobile_number = _req$body2.mobile_number, email = _req$body2.email, department_name = _req$body2.department_name, linkedin_url = _req$body2.linkedin_url, current_year = _req$body2.current_year;
          _context3.prev = 1;

          if (!(!id || !mongoose.Types.ObjectId.isValid(id))) {
            _context3.next = 4;
            break;
          }

          return _context3.abrupt("return", res.status(400).json({
            message: "Invalid or missing student_id"
          }));

        case 4:
          _context3.next = 6;
          return regeneratorRuntime.awrap(Student.findByIdAndUpdate(id, {
            name: name,
            college_name: college_name,
            college_id: college_id,
            mobile_number: mobile_number,
            email: email,
            department_name: department_name,
            linkedin_url: linkedin_url,
            current_year: current_year
          }, {
            "new": true
          }));

        case 6:
          updatedStudent = _context3.sent;

          if (updatedStudent) {
            _context3.next = 9;
            break;
          }

          return _context3.abrupt("return", res.status(404).json({
            message: "Student member not found"
          }));

        case 9:
          res.status(200).json({
            message: "Student updated successfully",
            student: updatedStudent
          });
          _context3.next = 15;
          break;

        case 12:
          _context3.prev = 12;
          _context3.t0 = _context3["catch"](1);
          res.status(500).json({
            message: "Error updating student member",
            error: _context3.t0.message
          });

        case 15:
        case "end":
          return _context3.stop();
      }
    }
  }, null, null, [[1, 12]]);
};

var deleteStudent = function deleteStudent(req, res) {
  var id, deletedStudent;
  return regeneratorRuntime.async(function deleteStudent$(_context4) {
    while (1) {
      switch (_context4.prev = _context4.next) {
        case 0:
          id = req.body.id;
          _context4.prev = 1;

          if (!(!id || !mongoose.Types.ObjectId.isValid(id))) {
            _context4.next = 4;
            break;
          }

          return _context4.abrupt("return", res.status(400).json({
            message: "Invalid or missing student_id"
          }));

        case 4:
          _context4.next = 6;
          return regeneratorRuntime.awrap(Student.findByIdAndDelete(id));

        case 6:
          deletedStudent = _context4.sent;

          if (deletedStudent) {
            _context4.next = 9;
            break;
          }

          return _context4.abrupt("return", res.status(404).json({
            message: "Student member not found"
          }));

        case 9:
          res.status(200).json({
            message: "Student deleted successfully",
            student: deletedStudent
          });
          _context4.next = 15;
          break;

        case 12:
          _context4.prev = 12;
          _context4.t0 = _context4["catch"](1);
          res.status(500).json({
            message: "Error deleting student member",
            error: _context4.t0.message
          });

        case 15:
        case "end":
          return _context4.stop();
      }
    }
  }, null, null, [[1, 12]]);
};

var loginStudent = function loginStudent(req, res) {
  var mobile_number, student, otp, otpRecord;
  return regeneratorRuntime.async(function loginStudent$(_context5) {
    while (1) {
      switch (_context5.prev = _context5.next) {
        case 0:
          _context5.prev = 0;
          mobile_number = req.body.mobile_number;

          if (mobile_number) {
            _context5.next = 4;
            break;
          }

          return _context5.abrupt("return", res.status(400).json({
            message: "Mobile number is required"
          }));

        case 4:
          _context5.next = 6;
          return regeneratorRuntime.awrap(Student.findOne({
            mobile_number: mobile_number
          }));

        case 6:
          student = _context5.sent;

          if (student) {
            _context5.next = 9;
            break;
          }

          return _context5.abrupt("return", res.status(404).json({
            message: "Student member not found"
          }));

        case 9:
          otp = otpGenerator.generate(6, {
            upperCase: false,
            specialChars: false
          });
          otpRecord = new StudentOTP({
            student_id: student._id,
            mobile_number: mobile_number,
            otp: otp,
            expiresAt: Date.now() + 5 * 60 * 1000
          });
          _context5.next = 13;
          return regeneratorRuntime.awrap(otpRecord.save());

        case 13:
          console.log("OTP for ".concat(mobile_number, ": ").concat(otp));
          res.status(200).json({
            message: "OTP generated and stored successfully",
            mobile_number: student.mobile_number
          });
          _context5.next = 21;
          break;

        case 17:
          _context5.prev = 17;
          _context5.t0 = _context5["catch"](0);
          console.error("Error processing login request:", _context5.t0.message);
          res.status(500).json({
            message: "Error processing login request",
            error: _context5.t0.message
          });

        case 21:
        case "end":
          return _context5.stop();
      }
    }
  }, null, null, [[0, 17]]);
};

var verifyStudentOtp = function verifyStudentOtp(req, res) {
  var _req$body3, mobile_number, otp, otpRecord, student;

  return regeneratorRuntime.async(function verifyStudentOtp$(_context6) {
    while (1) {
      switch (_context6.prev = _context6.next) {
        case 0:
          _context6.prev = 0;
          _req$body3 = req.body, mobile_number = _req$body3.mobile_number, otp = _req$body3.otp;

          if (!(!mobile_number || !otp)) {
            _context6.next = 4;
            break;
          }

          return _context6.abrupt("return", res.status(400).json({
            message: "Mobile number and OTP are required"
          }));

        case 4:
          _context6.next = 6;
          return regeneratorRuntime.awrap(StudentOTP.findOne({
            mobile_number: mobile_number,
            otp: otp,
            expiresAt: {
              $gt: Date.now()
            }
          }));

        case 6:
          otpRecord = _context6.sent;

          if (otpRecord) {
            _context6.next = 9;
            break;
          }

          return _context6.abrupt("return", res.status(400).json({
            message: "Invalid or expired OTP"
          }));

        case 9:
          _context6.next = 11;
          return regeneratorRuntime.awrap(Student.findOne({
            mobile_number: mobile_number
          }));

        case 11:
          student = _context6.sent;

          if (student) {
            _context6.next = 14;
            break;
          }

          return _context6.abrupt("return", res.status(404).json({
            message: "Student not found"
          }));

        case 14:
          _context6.next = 16;
          return regeneratorRuntime.awrap(StudentOTP.deleteOne({
            _id: otpRecord._id
          }));

        case 16:
          res.status(200).json({
            message: "OTP verified successfully",
            student_id: student._id,
            name: student.name
          });
          _context6.next = 23;
          break;

        case 19:
          _context6.prev = 19;
          _context6.t0 = _context6["catch"](0);
          console.error("Error verifying OTP:", _context6.t0.message);
          res.status(500).json({
            message: "Error verifying OTP",
            error: _context6.t0.message
          });

        case 23:
        case "end":
          return _context6.stop();
      }
    }
  }, null, null, [[0, 19]]);
};

module.exports = {
  registerStudent: registerStudent,
  getAllStudent: getAllStudent,
  updateStudent: updateStudent,
  deleteStudent: deleteStudent,
  loginStudent: loginStudent,
  verifyStudentOtp: verifyStudentOtp
};