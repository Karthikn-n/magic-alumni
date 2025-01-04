"use strict";

var axios = require("axios");

var fs = require("fs");

var News = require("../models/News");

var mongoose = require("mongoose");

var path = require("path");

var createNews = function createNews(req, res) {
  var _req$body, alumni_id, college_id, title, description, news_posted, creator_name, image, news_link, imagePath, newNews, savedNews;

  return regeneratorRuntime.async(function createNews$(_context) {
    while (1) {
      switch (_context.prev = _context.next) {
        case 0:
          _context.prev = 0;
          _req$body = req.body, alumni_id = _req$body.alumni_id, college_id = _req$body.college_id, title = _req$body.title, description = _req$body.description, news_posted = _req$body.news_posted, creator_name = _req$body.creator_name, image = _req$body.image, news_link = _req$body.news_link;
          imagePath = req.file ? "/uploads/news/".concat(req.file.filename) : image;

          if (!(!alumni_id || !college_id)) {
            _context.next = 5;
            break;
          }

          return _context.abrupt("return", res.status(400).json({
            message: "All required fields must be filled"
          }));

        case 5:
          newNews = new News({
            alumni_id: alumni_id,
            college_id: college_id,
            title: title,
            description: description,
            news_posted: news_posted,
            creator_name: creator_name,
            image: imagePath,
            news_link: news_link
          });
          _context.next = 8;
          return regeneratorRuntime.awrap(newNews.save());

        case 8:
          savedNews = _context.sent;
          res.status(201).json({
            message: "News created successfully",
            news: savedNews
          });
          _context.next = 15;
          break;

        case 12:
          _context.prev = 12;
          _context.t0 = _context["catch"](0);
          res.status(500).json({
            message: "Error creating news",
            error: _context.t0
          });

        case 15:
        case "end":
          return _context.stop();
      }
    }
  }, null, null, [[0, 12]]);
};

var getNewsByID = function getNewsByID(req, res) {
  var _req$body2, alumni_id, college_id, alumniCollegeData, newsList;

  return regeneratorRuntime.async(function getNewsByID$(_context2) {
    while (1) {
      switch (_context2.prev = _context2.next) {
        case 0:
          _context2.prev = 0;
          _req$body2 = req.body, alumni_id = _req$body2.alumni_id, college_id = _req$body2.college_id;

          if (!(!alumni_id || !college_id || !mongoose.Types.ObjectId.isValid(alumni_id) || !mongoose.Types.ObjectId.isValid(college_id))) {
            _context2.next = 4;
            break;
          }

          return _context2.abrupt("return", res.status(400).json({
            message: "Invalid or missing alumni_id or college_id"
          }));

        case 4:
          _context2.next = 6;
          return regeneratorRuntime.awrap(News.findOne({
            alumni_id: alumni_id,
            college_id: college_id
          }));

        case 6:
          alumniCollegeData = _context2.sent;

          if (alumniCollegeData) {
            _context2.next = 9;
            break;
          }

          return _context2.abrupt("return", res.status(404).json({
            message: "No data found for the provided alumni_id and college_id"
          }));

        case 9:
          _context2.next = 11;
          return regeneratorRuntime.awrap(News.find({
            college_id: alumniCollegeData.college_id
          }));

        case 11:
          newsList = _context2.sent;

          if (!(newsList.length === 0)) {
            _context2.next = 14;
            break;
          }

          return _context2.abrupt("return", res.status(200).json({
            message: "No news found for this college"
          }));

        case 14:
          res.status(200).json({
            message: "News retrieved successfully",
            newsList: newsList
          });
          _context2.next = 20;
          break;

        case 17:
          _context2.prev = 17;
          _context2.t0 = _context2["catch"](0);
          res.status(500).json({
            message: "Error retrieving news data",
            error: _context2.t0.message
          });

        case 20:
        case "end":
          return _context2.stop();
      }
    }
  }, null, null, [[0, 17]]);
};

module.exports = {
  createNews: createNews,
  getNewsByID: getNewsByID
};