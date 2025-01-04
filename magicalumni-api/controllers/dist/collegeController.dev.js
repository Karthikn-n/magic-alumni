"use strict";

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(source, true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(source).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

var axios = require("axios");

var fs = require("fs");

var College = require("../models/College");

var Department = require("../models/Department");

var mongoose = require("mongoose");

var path = require("path");

var createCollege = function createCollege(req, res) {
  var _req$body, name, address, city, newCollege, savedCollege;

  return regeneratorRuntime.async(function createCollege$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          _context.prev = 0;
          _req$body = req.body, name = _req$body.name, address = _req$body.address, city = _req$body.city;

          if (!(!name || !address || !city)) {
            _context.next = 4;
            break;
          }

          return _context.abrupt("return", res.status(400).json({
            message: "All required fields must be filled"
          }));

        case 4:
          newCollege = new College({
            name: name,
            address: address,
            city: city
          });
          _context.next = 7;
          return regeneratorRuntime.awrap(newCollege.save());

        case 7:
          savedCollege = _context.sent;
          res.status(201).json({
            message: "College created successfully",
            college: savedCollege
          });
          _context.next = 14;
          break;

        case 11:
          _context.prev = 11;
          _context.t0 = _context["catch"](0);
          res.status(500).json({
            message: "Error creating college",
            error: _context.t0
          });

        case 14:
        case "end":
          return _context.stop();
      }
    }
  }, null, null, [[0, 11]]);
};

var getCollege = function getCollege(req, res) {
  var collegeList, collegeWithDepartments;
  return regeneratorRuntime.async(function getCollege$(_context3) {
    while (1) {
      switch (_context3.prev = _context3.next) {
        case 0:
          _context3.prev = 0;
          _context3.next = 3;
          return regeneratorRuntime.awrap(College.find());

        case 3:
          collegeList = _context3.sent;

          if (!(collegeList.length === 0)) {
            _context3.next = 6;
            break;
          }

          return _context3.abrupt("return", res.status(200).json({
            message: "No colleges found"
          }));

        case 6:
          _context3.next = 8;
          return regeneratorRuntime.awrap(Promise.all(collegeList.map(function _callee(college) {
            var departments;
            return regeneratorRuntime.async(function _callee$(_context2) {
              while (1) {
                switch (_context2.prev = _context2.next) {
                  case 0:
                    _context2.next = 2;
                    return regeneratorRuntime.awrap(Department.find({
                      college_id: college._id
                    }));

                  case 2:
                    departments = _context2.sent;
                    return _context2.abrupt("return", _objectSpread({}, college._doc, {
                      departments: departments
                    }));

                  case 4:
                  case "end":
                    return _context2.stop();
                }
              }
            });
          })));

        case 8:
          collegeWithDepartments = _context3.sent;
          res.status(200).json({
            success: "Success",
            collegeWithDepartments: collegeWithDepartments
          });
          _context3.next = 15;
          break;

        case 12:
          _context3.prev = 12;
          _context3.t0 = _context3["catch"](0);
          res.status(500).json({
            message: "Error retrieving college lists",
            error: _context3.t0.message
          });

        case 15:
        case "end":
          return _context3.stop();
      }
    }
  }, null, null, [[0, 12]]);
};

module.exports = {
  createCollege: createCollege,
  getCollege: getCollege
};