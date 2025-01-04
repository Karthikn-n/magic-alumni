"use strict";

var mongoose = require("mongoose");

var newsSchema = new mongoose.Schema({
  alumni_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "AlumniMember",
    required: true
  },
  college_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "College",
    required: true
  },
  image: {
    type: String,
    required: true
  },
  title: {
    type: String,
    required: true
  },
  description: {
    type: String,
    required: true
  },
  news_posted: {
    type: Date,
    required: true
  },
  creator_name: {
    type: String,
    required: true
  },
  news_link: {
    type: String,
    required: true
  }
}, {
  timestamps: true
});
var News = mongoose.model("News", newsSchema);
module.exports = News;