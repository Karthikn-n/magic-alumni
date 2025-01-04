"use strict";

var AlumniMember = require("../models/AlumniMember");

var AlumniCollege = require("../models/AlumniCollege");

var College = require("../models/College");

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


var registerAlumni = function registerAlumni(req, res) {
  var _req$body, name, department_name, linkedin_url, completed_year, college_ids, existingAlumni, newAlumni, mappedColleges, _iteratorNormalCompletion, _didIteratorError, _iteratorError, _iterator, _step, college_id, college, alumniCollege;

  return regeneratorRuntime.async(function registerAlumni$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          _context.prev = 0;
          _req$body = req.body, name = _req$body.name, department_name = _req$body.department_name, linkedin_url = _req$body.linkedin_url, completed_year = _req$body.completed_year, college_ids = _req$body.college_ids;
          _context.next = 4;
          return regeneratorRuntime.awrap(AlumniMember.findOne({
            name: name,
            department_name: department_name,
            designation: designation,
            mobile_number: mobile_number,
            email: email,
            linkedin_url: linkedin_url,
            completed_year: completed_year
          }));

        case 4:
          existingAlumni = _context.sent;

          if (!existingAlumni) {
            _context.next = 7;
            break;
          }

          return _context.abrupt("return", res.status(400).json({
            message: "Alumni member already exists"
          }));

        case 7:
          newAlumni = new AlumniMember({
            name: name,
            department_name: department_name,
            designation: designation,
            mobile_number: mobile_number,
            email: email,
            linkedin_url: linkedin_url,
            completed_year: completed_year
          });
          _context.next = 10;
          return regeneratorRuntime.awrap(newAlumni.save());

        case 10:
          mappedColleges = [];
          _iteratorNormalCompletion = true;
          _didIteratorError = false;
          _iteratorError = undefined;
          _context.prev = 14;
          _iterator = college_ids[Symbol.iterator]();

        case 16:
          if (_iteratorNormalCompletion = (_step = _iterator.next()).done) {
            _context.next = 30;
            break;
          }

          college_id = _step.value;
          _context.next = 20;
          return regeneratorRuntime.awrap(College.findById(college_id));

        case 20:
          college = _context.sent;

          if (college) {
            _context.next = 23;
            break;
          }

          return _context.abrupt("return", res.status(404).json({
            message: "College not found for ID: ".concat(college_id)
          }));

        case 23:
          alumniCollege = new AlumniCollege({
            alumni_id: newAlumni._id,
            college_id: college_id
          });
          _context.next = 26;
          return regeneratorRuntime.awrap(alumniCollege.save());

        case 26:
          mappedColleges.push(college);

        case 27:
          _iteratorNormalCompletion = true;
          _context.next = 16;
          break;

        case 30:
          _context.next = 36;
          break;

        case 32:
          _context.prev = 32;
          _context.t0 = _context["catch"](14);
          _didIteratorError = true;
          _iteratorError = _context.t0;

        case 36:
          _context.prev = 36;
          _context.prev = 37;

          if (!_iteratorNormalCompletion && _iterator["return"] != null) {
            _iterator["return"]();
          }

        case 39:
          _context.prev = 39;

          if (!_didIteratorError) {
            _context.next = 42;
            break;
          }

          throw _iteratorError;

        case 42:
          return _context.finish(39);

        case 43:
          return _context.finish(36);

        case 44:
          res.status(201).json({
            message: "Alumni registered successfully",
            alumni: newAlumni,
            colleges: mappedColleges
          });
          _context.next = 50;
          break;

        case 47:
          _context.prev = 47;
          _context.t1 = _context["catch"](0);
          res.status(500).json({
            message: "Error registering alumni member",
            error: _context.t1.message
          });

        case 50:
        case "end":
          return _context.stop();
      }
    }
  }, null, null, [[0, 47], [14, 32, 36, 44], [37,, 39, 43]]);
};

var getAllAlumni = function getAllAlumni(req, res) {
  var alumniMembers;
  return regeneratorRuntime.async(function getAllAlumni$(_context2) {
    while (1) {
      switch (_context2.prev = _context2.next) {
        case 0:
          _context2.prev = 0;
          _context2.next = 3;
          return regeneratorRuntime.awrap(AlumniMember.find({
            status: "approved"
          }));

        case 3:
          alumniMembers = _context2.sent;

          if (!(alumniMembers.length === 0)) {
            _context2.next = 6;
            break;
          }

          return _context2.abrupt("return", res.status(200).json({
            message: "No approved alumni members found"
          }));

        case 6:
          res.status(200).json(alumniMembers);
          _context2.next = 12;
          break;

        case 9:
          _context2.prev = 9;
          _context2.t0 = _context2["catch"](0);
          res.status(500).json({
            message: "Error retrieving alumni members",
            error: _context2.t0.message
          });

        case 12:
        case "end":
          return _context2.stop();
      }
    }
  }, null, null, [[0, 9]]);
};

var getAlumniById = function getAlumniById(req, res) {
  var alumni_id, alumniCollegeData, alumni, collegeDetails;
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

          if (!(alumniCollegeData.length === 0)) {
            _context4.next = 9;
            break;
          }

          return _context4.abrupt("return", res.status(200).json({
            message: "No approved alumni member found for this alumni_id"
          }));

        case 9:
          _context4.next = 11;
          return regeneratorRuntime.awrap(AlumniMember.findOne({
            _id: alumni_id
          }));

        case 11:
          alumni = _context4.sent;

          if (alumni) {
            _context4.next = 14;
            break;
          }

          return _context4.abrupt("return", res.status(200).json({
            message: "No alumni member found with this ID"
          }));

        case 14:
          _context4.next = 16;
          return regeneratorRuntime.awrap(Promise.all(alumniCollegeData.map(function _callee(record) {
            return regeneratorRuntime.async(function _callee$(_context3) {
              while (1) {
                switch (_context3.prev = _context3.next) {
                  case 0:
                    _context3.next = 2;
                    return regeneratorRuntime.awrap(College.findOne({
                      _id: record.college_id
                    }));

                  case 2:
                    return _context3.abrupt("return", _context3.sent);

                  case 3:
                  case "end":
                    return _context3.stop();
                }
              }
            });
          })));

        case 16:
          collegeDetails = _context4.sent;
          res.status(200).json({
            alumni: alumni,
            colleges: collegeDetails
          });
          _context4.next = 23;
          break;

        case 20:
          _context4.prev = 20;
          _context4.t0 = _context4["catch"](0);
          res.status(500).json({
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
  var _req$body2, id, name, college_name, department_name, linkedin_url, completed_year, mobile_number, email, status, updatedAlumni;

  return regeneratorRuntime.async(function updateAlumni$(_context5) {
    while (1) {
      switch (_context5.prev = _context5.next) {
        case 0:
          _req$body2 = req.body, id = _req$body2.id, name = _req$body2.name, college_name = _req$body2.college_name, department_name = _req$body2.department_name, linkedin_url = _req$body2.linkedin_url, completed_year = _req$body2.completed_year, mobile_number = _req$body2.mobile_number, email = _req$body2.email, status = _req$body2.status;
          _context5.prev = 1;

          if (!(!id || !mongoose.Types.ObjectId.isValid(id))) {
            _context5.next = 4;
            break;
          }

          return _context5.abrupt("return", res.status(400).json({
            message: "Invalid or missing alumni_id"
          }));

        case 4:
          _context5.next = 6;
          return regeneratorRuntime.awrap(AlumniMember.findByIdAndUpdate(id, {
            name: name,
            college_name: college_name,
            department_name: department_name,
            linkedin_url: linkedin_url,
            completed_year: completed_year,
            mobile_number: mobile_number,
            email: email,
            status: status
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
            message: "Alumni updated successfully",
            alumni: updatedAlumni
          });
          _context5.next = 15;
          break;

        case 12:
          _context5.prev = 12;
          _context5.t0 = _context5["catch"](1);
          res.status(500).json({
            message: "Error updating alumni member",
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
            message: "Alumni member not found"
          }));

        case 9:
          res.status(200).json({
            message: "Alumni deleted successfully",
            alumni: deletedAlumni
          });
          _context6.next = 15;
          break;

        case 12:
          _context6.prev = 12;
          _context6.t0 = _context6["catch"](1);
          res.status(500).json({
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
  var alumniMembers;
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
            message: "No unapproved alumni members found"
          }));

        case 6:
          res.status(200).json({
            alumni: alumniMembers
          });
          _context7.next = 12;
          break;

        case 9:
          _context7.prev = 9;
          _context7.t0 = _context7["catch"](0);
          res.status(500).json({
            message: "Error retrieving alumni members list",
            error: _context7.t0.message
          });

        case 12:
        case "end":
          return _context7.stop();
      }
    }
  }, null, null, [[0, 9]]);
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
            message: "alumni_id, college_id, and status are required"
          }));

        case 4:
          if (!(!mongoose.Types.ObjectId.isValid(alumni_id) || !mongoose.Types.ObjectId.isValid(college_id))) {
            _context8.next = 6;
            break;
          }

          return _context8.abrupt("return", res.status(400).json({
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
            message: "No alumni-college mapping found with the provided IDs"
          }));

        case 11:
          res.status(200).json({
            message: "Alumni status updated successfully",
            alumniCollege: updatedAlumniCollege
          });
          _context8.next = 17;
          break;

        case 14:
          _context8.prev = 14;
          _context8.t0 = _context8["catch"](1);
          res.status(500).json({
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

var loginAlumni = function loginAlumni(req, res) {
  var _mobile_number, alumni, otp, otpRecord;

  return regeneratorRuntime.async(function loginAlumni$(_context9) {
    while (1) {
      switch (_context9.prev = _context9.next) {
        case 0:
          _context9.prev = 0;
          _mobile_number = req.body.mobile_number;

          if (_mobile_number) {
            _context9.next = 4;
            break;
          }

          return _context9.abrupt("return", res.status(400).json({
            message: "Mobile number is required"
          }));

        case 4:
          _context9.next = 6;
          return regeneratorRuntime.awrap(AlumniMember.findOne({
            mobile_number: _mobile_number
          }));

        case 6:
          alumni = _context9.sent;

          if (alumni) {
            _context9.next = 9;
            break;
          }

          return _context9.abrupt("return", res.status(404).json({
            message: "Alumni member not found"
          }));

        case 9:
          otp = otpGenerator.generate(6, {
            upperCase: false,
            specialChars: false
          });
          otpRecord = new OTPModel({
            alumni_id: alumni._id,
            mobile_number: _mobile_number,
            otp: otp,
            expiresAt: Date.now() + 5 * 60 * 1000
          });
          _context9.next = 13;
          return regeneratorRuntime.awrap(otpRecord.save());

        case 13:
          console.log("OTP for ".concat(_mobile_number, ": ").concat(otp));
          res.status(200).json({
            message: "OTP generated and stored successfully",
            mobile_number: alumni.mobile_number
          });
          _context9.next = 21;
          break;

        case 17:
          _context9.prev = 17;
          _context9.t0 = _context9["catch"](0);
          console.error("Error processing login request:", _context9.t0.message);
          res.status(500).json({
            message: "Error processing login request",
            error: _context9.t0.message
          });

        case 21:
        case "end":
          return _context9.stop();
      }
    }
  }, null, null, [[0, 17]]);
};

var verifyOtp = function verifyOtp(req, res) {
  var _req$body4, _mobile_number2, otp, otpRecord, alumni;

  return regeneratorRuntime.async(function verifyOtp$(_context10) {
    while (1) {
      switch (_context10.prev = _context10.next) {
        case 0:
          _context10.prev = 0;
          _req$body4 = req.body, _mobile_number2 = _req$body4.mobile_number, otp = _req$body4.otp;

          if (!(!_mobile_number2 || !otp)) {
            _context10.next = 4;
            break;
          }

          return _context10.abrupt("return", res.status(400).json({
            message: "Mobile number and OTP are required"
          }));

        case 4:
          _context10.next = 6;
          return regeneratorRuntime.awrap(OTPModel.findOne({
            mobile_number: _mobile_number2,
            otp: otp,
            expiresAt: {
              $gt: Date.now()
            }
          }));

        case 6:
          otpRecord = _context10.sent;

          if (otpRecord) {
            _context10.next = 9;
            break;
          }

          return _context10.abrupt("return", res.status(400).json({
            message: "Invalid or expired OTP"
          }));

        case 9:
          _context10.next = 11;
          return regeneratorRuntime.awrap(AlumniMember.findOne({
            mobile_number: _mobile_number2
          }));

        case 11:
          alumni = _context10.sent;

          if (alumni) {
            _context10.next = 14;
            break;
          }

          return _context10.abrupt("return", res.status(404).json({
            message: "Alumni member not found"
          }));

        case 14:
          _context10.next = 16;
          return regeneratorRuntime.awrap(OTPModel.deleteOne({
            _id: otpRecord._id
          }));

        case 16:
          res.status(200).json({
            message: "OTP verified successfully",
            alumni_id: alumni._id,
            name: alumni.name
          });
          _context10.next = 23;
          break;

        case 19:
          _context10.prev = 19;
          _context10.t0 = _context10["catch"](0);
          console.error("Error verifying OTP:", _context10.t0.message);
          res.status(500).json({
            message: "Error verifying OTP",
            error: _context10.t0.message
          });

        case 23:
        case "end":
          return _context10.stop();
      }
    }
  }, null, null, [[0, 19]]);
};

module.exports = {
  registerAlumni: registerAlumni,
  getAllAlumni: getAllAlumni,
  updateAlumni: updateAlumni,
  deleteAlumni: deleteAlumni,
  alumnimembersList: alumnimembersList,
  updateAlumniStatus: updateAlumniStatus,
  getAlumniById: getAlumniById,
  loginAlumni: loginAlumni,
  verifyOtp: verifyOtp
};