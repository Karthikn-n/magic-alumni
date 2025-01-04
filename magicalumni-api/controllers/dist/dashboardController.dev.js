"use strict";

// const Alumni = require("../models/AlumniMember");
var Event = require("../models/Event");

var Job = require("../models/Job");

var getDashboardData = function getDashboardData(req, res) {
  var eventCount, jobCount;
  return regeneratorRuntime.async(function getDashboardData$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          _context.prev = 0;
          _context.next = 3;
          return regeneratorRuntime.awrap(Event.countDocuments());

        case 3:
          eventCount = _context.sent;
          _context.next = 6;
          return regeneratorRuntime.awrap(Job.countDocuments());

        case 6:
          jobCount = _context.sent;
          res.render("dashboard", {
            //   alumniCount,
            eventCount: eventCount,
            jobCount: jobCount
          });
          _context.next = 13;
          break;

        case 10:
          _context.prev = 10;
          _context.t0 = _context["catch"](0);
          res.status(500).send("Error loading dashboard");

        case 13:
        case "end":
          return _context.stop();
      }
    }
  }, null, null, [[0, 10]]);
};

module.exports = {
  getDashboardData: getDashboardData
};