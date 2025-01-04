"use strict";

var mongoose = require("mongoose");

var CollegeSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  address: {
    type: String
  },
  city: {
    type: String
  }
});
module.exports = mongoose.model("College", CollegeSchema);