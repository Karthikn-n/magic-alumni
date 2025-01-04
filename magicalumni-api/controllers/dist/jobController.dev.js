"use strict";

var axios = require("axios");

var fs = require("fs");

var Job = require("../models/Job");

var mongoose = require("mongoose");

var path = require("path");

var createJob = function createJob(req, res) {
  var _req$body, alumni_id, college_id, job_title, last_date, company_name, location, job_image, tag, imagePath, newJob, savedJob;

  return regeneratorRuntime.async(function createJob$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          _context.prev = 0;
          _req$body = req.body, alumni_id = _req$body.alumni_id, college_id = _req$body.college_id, job_title = _req$body.job_title, last_date = _req$body.last_date, company_name = _req$body.company_name, location = _req$body.location, job_image = _req$body.job_image, tag = _req$body.tag;
          imagePath = req.file ? "/uploads/jobs/".concat(req.file.filename) : job_image;

          if (!(!alumni_id || !college_id || !job_title || !last_date || !imagePath)) {
            _context.next = 5;
            break;
          }

          return _context.abrupt("return", res.status(400).json({
            message: "All required fields must be filled"
          }));

        case 5:
          newJob = new Job({
            alumni_id: alumni_id,
            college_id: college_id,
            job_title: job_title,
            last_date: last_date,
            company_name: company_name,
            location: location,
            job_image: imagePath,
            tag: tag
          });
          _context.next = 8;
          return regeneratorRuntime.awrap(newJob.save());

        case 8:
          savedJob = _context.sent;
          res.status(201).json({
            message: "Job created successfully",
            job: savedJob
          });
          _context.next = 15;
          break;

        case 12:
          _context.prev = 12;
          _context.t0 = _context["catch"](0);
          res.status(500).json({
            message: "Error creating job",
            error: _context.t0
          });

        case 15:
        case "end":
          return _context.stop();
      }
    }
  }, null, null, [[0, 12]]);
};

var getAllJob = function getAllJob(req, res) {
  var college_id, filter, jobList;
  return regeneratorRuntime.async(function getAllJob$(_context2) {
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
          return regeneratorRuntime.awrap(Job.find(filter));

        case 8:
          jobList = _context2.sent;

          if (!(jobList.length === 0)) {
            _context2.next = 11;
            break;
          }

          return _context2.abrupt("return", res.status(200).json({
            message: "No data found for this college"
          }));

        case 11:
          res.status(200).json(jobList);
          _context2.next = 17;
          break;

        case 14:
          _context2.prev = 14;
          _context2.t0 = _context2["catch"](0);
          res.status(500).json({
            message: "Error retrieving job lists",
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
  createJob: createJob,
  getAllJob: getAllJob
};