"use strict";

var axios = require("axios");

var fs = require("fs");

var College = require("../models/College");

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
  var collegeList;
  return regeneratorRuntime.async(function getCollege$(_context2) {
    while (1) {
      switch (_context2.prev = _context2.next) {
        case 0:
          _context2.prev = 0;
          _context2.next = 3;
          return regeneratorRuntime.awrap(College.find());

        case 3:
          collegeList = _context2.sent;

          if (!(collegeList.length === 0)) {
            _context2.next = 6;
            break;
          }

          return _context2.abrupt("return", res.status(200).json({
            message: "No colleges found"
          }));

        case 6:
          // Return the list of colleges
          res.status(200).json(collegeList);
          _context2.next = 12;
          break;

        case 9:
          _context2.prev = 9;
          _context2.t0 = _context2["catch"](0);
          res.status(500).json({
            message: "Error retrieving college lists",
            error: _context2.t0.message
          });

        case 12:
        case "end":
          return _context2.stop();
      }
    }
  }, null, null, [[0, 9]]);
};

module.exports = {
  createCollege: createCollege,
  getCollege: getCollege
};