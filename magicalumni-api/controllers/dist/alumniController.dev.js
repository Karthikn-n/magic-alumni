"use strict";

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(source, true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(source).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

var AlumniMember = require("../models/AlumniMember");

var AlumniCollege = require("../models/AlumniCollege");

var StudentCollege = require("../models/StudentCollege");

var College = require("../models/College");

var Department = require("../models/Department");

var Student = require("../models/Student");

var mongoose = require("mongoose");

var otpGenerator = require("otp-generator");

var _require = require("../services/otpService"),
    sendOtp = _require.sendOtp;

var OTPModel = require("../models/OTPModel"); // const registerAlumni = async (req, res) => {
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


var registerMember = function registerMember(req, res) {
  var _req$body, name, linkedin_url, completed_year, current_year, college_id, mobile_number, designation, email, role, department_id, existingMember, newMember, mappedColleges, college, studentCollege, _college, alumniCollege, approvalStatus;

  return regeneratorRuntime.async(function registerMember$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          _context.prev = 0;
          _req$body = req.body, name = _req$body.name, linkedin_url = _req$body.linkedin_url, completed_year = _req$body.completed_year, current_year = _req$body.current_year, college_id = _req$body.college_id, mobile_number = _req$body.mobile_number, designation = _req$body.designation, email = _req$body.email, role = _req$body.role, department_id = _req$body.department_id;
          mappedColleges = [];

          if (!role) {
            _context.next = 23;
            break;
          }

          _context.next = 6;
          return regeneratorRuntime.awrap(AlumniMember.findOne({
            name: name,
            email: email,
            mobile_number: mobile_number
          }));

        case 6:
          existingMember = _context.sent;

          if (!existingMember) {
            _context.next = 9;
            break;
          }

          return _context.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "Already exists"
          }));

        case 9:
          newMember = new AlumniMember({
            name: name,
            // department_name,
            linkedin_url: linkedin_url,
            // current_year,
            mobile_number: mobile_number,
            email: email,
            role: role
          });
          _context.next = 12;
          return regeneratorRuntime.awrap(newMember.save());

        case 12:
          _context.next = 14;
          return regeneratorRuntime.awrap(College.findById(college_id));

        case 14:
          college = _context.sent;

          if (college) {
            _context.next = 17;
            break;
          }

          return _context.abrupt("return", res.status(404).json({
            status: "not found",
            message: "College not found for ID: ".concat(college_id)
          }));

        case 17:
          studentCollege = AlumniCollege({
            alumni_id: newMember._id,
            college_id: college_id,
            department_id: department_id,
            current_year: current_year
          });
          _context.next = 20;
          return regeneratorRuntime.awrap(studentCollege.save());

        case 20:
          mappedColleges.push(college);
          _context.next = 40;
          break;

        case 23:
          _context.next = 25;
          return regeneratorRuntime.awrap(AlumniMember.findOne({
            name: name,
            // department_name,
            linkedin_url: linkedin_url,
            completed_year: completed_year
          }));

        case 25:
          existingMember = _context.sent;

          if (!existingMember) {
            _context.next = 28;
            break;
          }

          return _context.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "Alumni member already exists"
          }));

        case 28:
          newMember = new AlumniMember({
            name: name,
            // department_name,
            linkedin_url: linkedin_url,
            // completed_year,
            mobile_number: mobile_number,
            designation: designation,
            email: email,
            role: "Alumni"
          });
          _context.next = 31;
          return regeneratorRuntime.awrap(newMember.save());

        case 31:
          _context.next = 33;
          return regeneratorRuntime.awrap(College.findById(college_id));

        case 33:
          _college = _context.sent;

          if (_college) {
            _context.next = 36;
            break;
          }

          return _context.abrupt("return", res.status(404).json({
            status: "not found",
            message: "College not found for ID: ".concat(college_id)
          }));

        case 36:
          alumniCollege = new AlumniCollege({
            alumni_id: newMember._id,
            college_id: college_id,
            department_id: department_id,
            completed_year: completed_year
          });
          _context.next = 39;
          return regeneratorRuntime.awrap(alumniCollege.save());

        case 39:
          mappedColleges.push(_college);

        case 40:
          approvalStatus = role ? "approved" : "not approved";
          res.status(201).json({
            status: "ok",
            message: "".concat(role ? "Student" : "Alumni", " registered successfully"),
            _id: newMember._id,
            college_id: college_id,
            role: newMember.role,
            approvalStatus: approvalStatus
          });
          _context.next = 47;
          break;

        case 44:
          _context.prev = 44;
          _context.t0 = _context["catch"](0);
          res.status(500).json({
            status: "error",
            message: "Error registering member",
            error: _context.t0.message
          });

        case 47:
        case "end":
          return _context.stop();
      }
    }
  }, null, null, [[0, 44]]);
};

var getAllAlumni = function getAllAlumni(req, res) {
  var alumniMembers, alumniIds, alumniDetails;
  return regeneratorRuntime.async(function getAllAlumni$(_context2) {
    while (1) {
      switch (_context2.prev = _context2.next) {
        case 0:
          _context2.prev = 0;
          _context2.next = 3;
          return regeneratorRuntime.awrap(AlumniCollege.find({
            status: "approved"
          }));

        case 3:
          alumniMembers = _context2.sent;

          if (!(alumniMembers.length === 0)) {
            _context2.next = 6;
            break;
          }

          return _context2.abrupt("return", res.status(200).json({
            status: "ok",
            message: "No approved alumni members found"
          }));

        case 6:
          alumniIds = alumniMembers.map(function (member) {
            return member.alumni_id;
          });
          _context2.next = 9;
          return regeneratorRuntime.awrap(AlumniMember.find({
            _id: alumniIds
          }));

        case 9:
          alumniDetails = _context2.sent;
          res.status(200).json({
            status: "ok",
            alumniDetails: alumniDetails
          });
          _context2.next = 16;
          break;

        case 13:
          _context2.prev = 13;
          _context2.t0 = _context2["catch"](0);
          res.status(500).json({
            status: "error",
            message: "Error retrieving alumni members",
            error: _context2.t0.message
          });

        case 16:
        case "end":
          return _context2.stop();
      }
    }
  }, null, null, [[0, 13]]);
};

var getAlumniById = function getAlumniById(req, res) {
  var alumni_id, alumniCollegeData, alumniProfile, collegeDetails;
  return regeneratorRuntime.async(function getAlumniById$(_context4) {
    while (1) {
      switch (_context4.prev = _context4.next) {
        case 0:
          _context4.prev = 0;
          alumni_id = req.body.alumni_id;

          if (!(!alumni_id || !mongoose.Types.ObjectId.isValid(alumni_id))) {
            _context4.next = 4;
            break;
          }

          return _context4.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "Invalid or missing alumni_id"
          }));

        case 4:
          _context4.next = 6;
          return regeneratorRuntime.awrap(AlumniCollege.find({
            alumni_id: alumni_id,
            status: "approved"
          }));

        case 6:
          alumniCollegeData = _context4.sent;
          _context4.next = 9;
          return regeneratorRuntime.awrap(AlumniMember.findOne({
            _id: alumni_id
          }));

        case 9:
          alumniProfile = _context4.sent;

          if (!(alumniCollegeData.length === 0)) {
            _context4.next = 12;
            break;
          }

          return _context4.abrupt("return", res.status(200).json({
            status: "ok",
            message: "No approved colleges for this alumni",
            alumniProfile: alumniProfile,
            colleges: []
          }));

        case 12:
          if (alumniProfile) {
            _context4.next = 14;
            break;
          }

          return _context4.abrupt("return", res.status(200).json({
            status: "ok",
            message: "No alumni member found with this ID"
          }));

        case 14:
          _context4.next = 16;
          return regeneratorRuntime.awrap(Promise.all(alumniCollegeData.map(function _callee(record) {
            var college, departments;
            return regeneratorRuntime.async(function _callee$(_context3) {
              while (1) {
                switch (_context3.prev = _context3.next) {
                  case 0:
                    _context3.next = 2;
                    return regeneratorRuntime.awrap(College.findOne({
                      _id: record.college_id
                    }));

                  case 2:
                    college = _context3.sent;
                    _context3.next = 5;
                    return regeneratorRuntime.awrap(Department.find({
                      _id: record.department_id
                    }));

                  case 5:
                    departments = _context3.sent;
                    return _context3.abrupt("return", _objectSpread({}, college._doc, {
                      completed_year: record.completed_year,
                      approvalStatus: record.status,
                      departments: departments
                    }));

                  case 7:
                  case "end":
                    return _context3.stop();
                }
              }
            });
          })));

        case 16:
          collegeDetails = _context4.sent;
          res.status(200).json({
            status: "ok",
            alumniProfile: alumniProfile,
            colleges: collegeDetails
          });
          _context4.next = 23;
          break;

        case 20:
          _context4.prev = 20;
          _context4.t0 = _context4["catch"](0);
          res.status(500).json({
            status: "error",
            message: "Error retrieving alumni member and college data",
            error: _context4.t0.message
          });

        case 23:
        case "end":
          return _context4.stop();
      }
    }
  }, null, null, [[0, 20]]);
};

var updateAlumni = function updateAlumni(req, res) {
  var _req$body2, id, name, linkedin_url, completed_year, current_year, mobile_number, email, designation, updatedAlumni;

  return regeneratorRuntime.async(function updateAlumni$(_context5) {
    while (1) {
      switch (_context5.prev = _context5.next) {
        case 0:
          _req$body2 = req.body, id = _req$body2.id, name = _req$body2.name, linkedin_url = _req$body2.linkedin_url, completed_year = _req$body2.completed_year, current_year = _req$body2.current_year, mobile_number = _req$body2.mobile_number, email = _req$body2.email, designation = _req$body2.designation;
          _context5.prev = 1;

          if (!(!id || !mongoose.Types.ObjectId.isValid(id))) {
            _context5.next = 4;
            break;
          }

          return _context5.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "Invalid or missing alumni_id"
          }));

        case 4:
          _context5.next = 6;
          return regeneratorRuntime.awrap(AlumniMember.findByIdAndUpdate(id, {
            name: name,
            linkedin_url: linkedin_url,
            completed_year: completed_year,
            current_year: current_year,
            mobile_number: mobile_number,
            email: email,
            designation: designation
          }, {
            "new": true
          }));

        case 6:
          updatedAlumni = _context5.sent;

          if (updatedAlumni) {
            _context5.next = 9;
            break;
          }

          return _context5.abrupt("return", res.status(404).json({
            message: "Alumni member not found"
          }));

        case 9:
          res.status(200).json({
            status: "ok",
            message: "Updated successfully",
            alumni: updatedAlumni
          });
          _context5.next = 15;
          break;

        case 12:
          _context5.prev = 12;
          _context5.t0 = _context5["catch"](1);
          res.status(500).json({
            status: "error",
            message: "Error updating data",
            error: _context5.t0.message
          });

        case 15:
        case "end":
          return _context5.stop();
      }
    }
  }, null, null, [[1, 12]]);
};

var deleteAlumni = function deleteAlumni(req, res) {
  var id, deletedAlumni;
  return regeneratorRuntime.async(function deleteAlumni$(_context6) {
    while (1) {
      switch (_context6.prev = _context6.next) {
        case 0:
          id = req.body.id;
          _context6.prev = 1;

          if (!(!id || !mongoose.Types.ObjectId.isValid(id))) {
            _context6.next = 4;
            break;
          }

          return _context6.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "Invalid or missing alumni_id"
          }));

        case 4:
          _context6.next = 6;
          return regeneratorRuntime.awrap(AlumniMember.findByIdAndDelete(id));

        case 6:
          deletedAlumni = _context6.sent;

          if (deletedAlumni) {
            _context6.next = 9;
            break;
          }

          return _context6.abrupt("return", res.status(404).json({
            status: "not found",
            message: "Alumni member not found"
          }));

        case 9:
          res.status(200).json({
            status: "ok",
            message: "Alumni deleted successfully",
            alumni: deletedAlumni
          });
          _context6.next = 15;
          break;

        case 12:
          _context6.prev = 12;
          _context6.t0 = _context6["catch"](1);
          res.status(500).json({
            status: "error",
            message: "Error deleting alumni member",
            error: _context6.t0.message
          });

        case 15:
        case "end":
          return _context6.stop();
      }
    }
  }, null, null, [[1, 12]]);
};

var alumnimembersList = function alumnimembersList(req, res) {
  var alumniMembers, alumniIds, alumniDetails;
  return regeneratorRuntime.async(function alumnimembersList$(_context7) {
    while (1) {
      switch (_context7.prev = _context7.next) {
        case 0:
          _context7.prev = 0;
          _context7.next = 3;
          return regeneratorRuntime.awrap(AlumniCollege.find({
            status: "not approved"
          }));

        case 3:
          alumniMembers = _context7.sent;

          if (!(alumniMembers.length === 0)) {
            _context7.next = 6;
            break;
          }

          return _context7.abrupt("return", res.status(200).json({
            status: "ok",
            message: "No unapproved alumni members found"
          }));

        case 6:
          alumniIds = alumniMembers.map(function (member) {
            return member.alumni_id;
          });
          _context7.next = 9;
          return regeneratorRuntime.awrap(AlumniMember.find({
            _id: alumniIds
          }));

        case 9:
          alumniDetails = _context7.sent;
          res.status(200).json({
            status: "ok",
            alumni: alumniDetails
          });
          _context7.next = 16;
          break;

        case 13:
          _context7.prev = 13;
          _context7.t0 = _context7["catch"](0);
          res.status(500).json({
            status: "error",
            message: "Error retrieving alumni members list",
            error: _context7.t0.message
          });

        case 16:
        case "end":
          return _context7.stop();
      }
    }
  }, null, null, [[0, 13]]);
};

var updateAlumniStatus = function updateAlumniStatus(req, res) {
  var _req$body3, alumni_id, college_id, status, updatedAlumniCollege;

  return regeneratorRuntime.async(function updateAlumniStatus$(_context8) {
    while (1) {
      switch (_context8.prev = _context8.next) {
        case 0:
          _req$body3 = req.body, alumni_id = _req$body3.alumni_id, college_id = _req$body3.college_id, status = _req$body3.status;
          _context8.prev = 1;

          if (!(!alumni_id || !college_id || !status)) {
            _context8.next = 4;
            break;
          }

          return _context8.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "alumni_id, college_id, and status are required"
          }));

        case 4:
          if (!(!mongoose.Types.ObjectId.isValid(alumni_id) || !mongoose.Types.ObjectId.isValid(college_id))) {
            _context8.next = 6;
            break;
          }

          return _context8.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "Invalid alumni_id or college_id"
          }));

        case 6:
          _context8.next = 8;
          return regeneratorRuntime.awrap(AlumniCollege.findOneAndUpdate({
            alumni_id: alumni_id,
            college_id: college_id
          }, {
            status: status
          }, {
            "new": true
          }));

        case 8:
          updatedAlumniCollege = _context8.sent;

          if (updatedAlumniCollege) {
            _context8.next = 11;
            break;
          }

          return _context8.abrupt("return", res.status(404).json({
            status: "not found",
            message: "No alumni-college mapping found with the provided IDs"
          }));

        case 11:
          res.status(200).json({
            status: "ok",
            message: "Alumni status updated successfully",
            alumniCollege: updatedAlumniCollege
          });
          _context8.next = 17;
          break;

        case 14:
          _context8.prev = 14;
          _context8.t0 = _context8["catch"](1);
          res.status(500).json({
            status: "error",
            message: "Error updating alumni status",
            error: _context8.t0.message
          });

        case 17:
        case "end":
          return _context8.stop();
      }
    }
  }, null, null, [[1, 14]]);
};

var updateRole = function updateRole(req, res) {
  var _req$body4, alumni_id, role, updatedAlumniRole;

  return regeneratorRuntime.async(function updateRole$(_context9) {
    while (1) {
      switch (_context9.prev = _context9.next) {
        case 0:
          _req$body4 = req.body, alumni_id = _req$body4.alumni_id, role = _req$body4.role;
          _context9.prev = 1;

          if (!(!alumni_id || !role)) {
            _context9.next = 4;
            break;
          }

          return _context9.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "alumni_id, and role are required"
          }));

        case 4:
          if (mongoose.Types.ObjectId.isValid(alumni_id)) {
            _context9.next = 6;
            break;
          }

          return _context9.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "Invalid alumni_id"
          }));

        case 6:
          _context9.next = 8;
          return regeneratorRuntime.awrap(AlumniMember.findOneAndUpdate({
            _id: alumni_id
          }, {
            role: role
          }, {
            "new": true
          }));

        case 8:
          updatedAlumniRole = _context9.sent;

          if (updatedAlumniRole) {
            _context9.next = 11;
            break;
          }

          return _context9.abrupt("return", res.status(404).json({
            status: "not found",
            message: "No alumni found with the provided ID"
          }));

        case 11:
          res.status(200).json({
            status: "ok",
            message: "Alumni role updated successfully",
            alumniRole: updatedAlumniRole
          });
          _context9.next = 17;
          break;

        case 14:
          _context9.prev = 14;
          _context9.t0 = _context9["catch"](1);
          res.status(500).json({
            status: "error",
            message: "Error updating alumni role",
            error: _context9.t0.message
          });

        case 17:
        case "end":
          return _context9.stop();
      }
    }
  }, null, null, [[1, 14]]);
};

var loginAlumni = function loginAlumni(req, res) {
  var mobile_number, alumni, otp, otpRecord;
  return regeneratorRuntime.async(function loginAlumni$(_context10) {
    while (1) {
      switch (_context10.prev = _context10.next) {
        case 0:
          _context10.prev = 0;
          mobile_number = req.body.mobile_number;

          if (mobile_number) {
            _context10.next = 4;
            break;
          }

          return _context10.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "Mobile number is required"
          }));

        case 4:
          _context10.next = 6;
          return regeneratorRuntime.awrap(AlumniMember.findOne({
            mobile_number: mobile_number
          }));

        case 6:
          alumni = _context10.sent;

          if (alumni) {
            _context10.next = 9;
            break;
          }

          return _context10.abrupt("return", res.status(404).json({
            status: "not found",
            message: "Alumni member not found"
          }));

        case 9:
          otp = otpGenerator.generate(6, {
            upperCase: false,
            specialChars: false
          });
          _context10.next = 12;
          return regeneratorRuntime.awrap(OTPModel.findOne({
            alumni_id: alumni._id,
            mobile_number: mobile_number,
            otp: otp
          }));

        case 12:
          existingOTP = _context10.sent;

          if (!existingOTP) {
            _context10.next = 15;
            break;
          }

          return _context10.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "OTP Already Sent"
          }));

        case 15:
          otpRecord = new OTPModel({
            alumni_id: alumni._id,
            mobile_number: mobile_number,
            otp: otp,
            expiresAt: Date.now() + 5 * 60 * 1000
          });
          _context10.next = 18;
          return regeneratorRuntime.awrap(otpRecord.save());

        case 18:
          console.log("OTP for ".concat(mobile_number, ": ").concat(otp));
          res.status(200).json({
            status: "ok",
            message: "OTP generated and stored successfully",
            mobile_number: alumni.mobile_number
          });
          _context10.next = 26;
          break;

        case 22:
          _context10.prev = 22;
          _context10.t0 = _context10["catch"](0);
          console.error("Error processing login request:", _context10.t0.message);
          res.status(500).json({
            status: "error",
            message: "Error processing login request",
            error: _context10.t0.message
          });

        case 26:
        case "end":
          return _context10.stop();
      }
    }
  }, null, null, [[0, 22]]);
};

var verifyOtp = function verifyOtp(req, res) {
  var _req$body5, mobile_number, otp, otpRecord, alumni, approvedAlumni, approvalStatus;

  return regeneratorRuntime.async(function verifyOtp$(_context11) {
    while (1) {
      switch (_context11.prev = _context11.next) {
        case 0:
          _context11.prev = 0;
          _req$body5 = req.body, mobile_number = _req$body5.mobile_number, otp = _req$body5.otp;

          if (!(!mobile_number || !otp)) {
            _context11.next = 4;
            break;
          }

          return _context11.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "Mobile number and OTP are required"
          }));

        case 4:
          _context11.next = 6;
          return regeneratorRuntime.awrap(OTPModel.findOne({
            mobile_number: mobile_number,
            otp: otp,
            expiresAt: {
              $gt: Date.now()
            }
          }));

        case 6:
          otpRecord = _context11.sent;

          if (otpRecord) {
            _context11.next = 9;
            break;
          }

          return _context11.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "Invalid or expired OTP"
          }));

        case 9:
          _context11.next = 11;
          return regeneratorRuntime.awrap(AlumniMember.findOne({
            mobile_number: mobile_number
          }));

        case 11:
          alumni = _context11.sent;

          if (alumni) {
            _context11.next = 14;
            break;
          }

          return _context11.abrupt("return", res.status(404).json({
            status: "not found",
            message: "Alumni member not found"
          }));

        case 14:
          _context11.next = 16;
          return regeneratorRuntime.awrap(AlumniCollege.findOne({
            alumni_id: alumni._id,
            status: "approved"
          }));

        case 16:
          approvedAlumni = _context11.sent;
          // console.log(approvedAlumni);
          approvalStatus = approvedAlumni ? "approved" : "not approved";
          _context11.next = 20;
          return regeneratorRuntime.awrap(OTPModel.deleteOne({
            _id: otpRecord._id
          }));

        case 20:
          res.status(200).json({
            status: "ok",
            message: "OTP verified successfully",
            alumni_id: alumni._id,
            college_id: approvedAlumni ? approvedAlumni.college_id : null,
            name: alumni.name,
            role: alumni.role,
            approvalStatus: approvalStatus
          });
          _context11.next = 27;
          break;

        case 23:
          _context11.prev = 23;
          _context11.t0 = _context11["catch"](0);
          console.error("Error verifying OTP:", _context11.t0.message);
          res.status(500).json({
            status: "error",
            message: "Error verifying OTP",
            error: _context11.t0.message
          });

        case 27:
        case "end":
          return _context11.stop();
      }
    }
  }, null, null, [[0, 23]]);
};

var alumniAddCollege = function alumniAddCollege(req, res) {
  var _req$body6, college_id, alumni_id, department_id, alumni, collegeStatus, newCollege;

  return regeneratorRuntime.async(function alumniAddCollege$(_context12) {
    while (1) {
      switch (_context12.prev = _context12.next) {
        case 0:
          _context12.prev = 0;
          _req$body6 = req.body, college_id = _req$body6.college_id, alumni_id = _req$body6.alumni_id, department_id = _req$body6.department_id;

          if (!(!mongoose.Types.ObjectId.isValid(alumni_id) || !mongoose.Types.ObjectId.isValid(college_id) || !mongoose.Types.ObjectId.isValid(department_id))) {
            _context12.next = 4;
            break;
          }

          return _context12.abrupt("return", res.status(400).json({
            status: "not ok",
            message: "Invalid alumni_id, college_id, or department_id"
          }));

        case 4:
          _context12.next = 6;
          return regeneratorRuntime.awrap(AlumniMember.findById(alumni_id));

        case 6:
          alumni = _context12.sent;

          if (alumni) {
            _context12.next = 9;
            break;
          }

          return _context12.abrupt("return", res.status(404).json({
            status: "not found",
            message: "Alumni member not found"
          }));

        case 9:
          collegeStatus = alumni.role === "Student" ? "approved" : "not approved";
          newCollege = new AlumniCollege({
            college_id: college_id,
            alumni_id: alumni_id,
            department_id: department_id,
            status: collegeStatus
          });
          _context12.next = 13;
          return regeneratorRuntime.awrap(newCollege.save());

        case 13:
          res.status(201).json({
            status: "ok",
            message: "College added successfully",
            college: newCollege
          });
          _context12.next = 19;
          break;

        case 16:
          _context12.prev = 16;
          _context12.t0 = _context12["catch"](0);
          res.status(500).json({
            status: "error",
            message: "Error adding college",
            error: _context12.t0.message
          });

        case 19:
        case "end":
          return _context12.stop();
      }
    }
  }, null, null, [[0, 16]]);
};

module.exports = {
  registerMember: registerMember,
  getAllAlumni: getAllAlumni,
  updateAlumni: updateAlumni,
  deleteAlumni: deleteAlumni,
  alumnimembersList: alumnimembersList,
  updateAlumniStatus: updateAlumniStatus,
  getAlumniById: getAlumniById,
  loginAlumni: loginAlumni,
  verifyOtp: verifyOtp,
  alumniAddCollege: alumniAddCollege,
  updateRole: updateRole
};