"use strict";

var axios = require("axios");

var fs = require("fs");

var Event = require("../models/Event");

var mongoose = require("mongoose");

var path = require("path");

var createEvent = function createEvent(req, res) {
  var _req$body, alumni_id, college_id, event_title, date, approval_status, event_type, rsvp_options, location, criteria, event_image, imagePath, newEvent, savedEvent;

  return regeneratorRuntime.async(function createEvent$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          _context.prev = 0;
          _req$body = req.body, alumni_id = _req$body.alumni_id, college_id = _req$body.college_id, event_title = _req$body.event_title, date = _req$body.date, approval_status = _req$body.approval_status, event_type = _req$body.event_type, rsvp_options = _req$body.rsvp_options, location = _req$body.location, criteria = _req$body.criteria, event_image = _req$body.event_image;
          imagePath = req.file ? "/uploads/".concat(req.file.filename) : event_image;

          if (!(!alumni_id || !college_id || !event_title || !date || !imagePath)) {
            _context.next = 5;
            break;
          }

          return _context.abrupt("return", res.status(400).json({
            message: "All required fields must be filled"
          }));

        case 5:
          newEvent = new Event({
            alumni_id: alumni_id,
            college_id: college_id,
            event_image: imagePath,
            event_title: event_title,
            date: date,
            approval_status: approval_status,
            event_type: event_type,
            rsvp_options: rsvp_options,
            location: location,
            criteria: criteria
          });
          _context.next = 8;
          return regeneratorRuntime.awrap(newEvent.save());

        case 8:
          savedEvent = _context.sent;
          res.status(201).json({
            message: "Event created successfully",
            event: savedEvent
          });
          _context.next = 15;
          break;

        case 12:
          _context.prev = 12;
          _context.t0 = _context["catch"](0);
          res.status(500).json({
            message: "Error creating event",
            error: _context.t0
          });

        case 15:
        case "end":
          return _context.stop();
      }
    }
  }, null, null, [[0, 12]]);
};

var getAllEvent = function getAllEvent(req, res) {
  var college_id, filter, eventList;
  return regeneratorRuntime.async(function getAllEvent$(_context2) {
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
          return regeneratorRuntime.awrap(Event.find(filter));

        case 8:
          eventList = _context2.sent;

          if (!(eventList.length === 0)) {
            _context2.next = 11;
            break;
          }

          return _context2.abrupt("return", res.status(200).json({
            message: "No data found for this college"
          }));

        case 11:
          res.status(200).json(eventList);
          _context2.next = 17;
          break;

        case 14:
          _context2.prev = 14;
          _context2.t0 = _context2["catch"](0);
          res.status(500).json({
            message: "Error retrieving event lists",
            error: _context2.t0.message
          });

        case 17:
        case "end":
          return _context2.stop();
      }
    }
  }, null, null, [[0, 14]]);
};

module.exports = {
  createEvent: createEvent,
  getAllEvent: getAllEvent
};