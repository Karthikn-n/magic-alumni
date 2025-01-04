"use strict";

var express = require("express");

var dotenv = require("dotenv");

var connectDB = require("./config/db");

var userRoutes = require("./routes/userRoutes");

var alumniRoutes = require("./routes/alumniRoutes");

var studentRoutes = require("./routes/studentRoutes");

var eventRoutes = require("./routes/eventRoutes");

var JobRoutes = require("./routes/jobRoutes");

var NewsRoutes = require("./routes/newsRoutes");

var CollegeRoutes = require("./routes/collegeRoutes");

var path = require("path");

dotenv.config();
connectDB();
var app = express();
app.use(express.json());
app.use(express.urlencoded({
  extended: true
}));
app.use("/uploads", express["static"](path.join(__dirname, "/uploads")));
app.use("/api/users", userRoutes);
app.use("/api", alumniRoutes);
app.use("/api", studentRoutes);
app.use("/api/events", eventRoutes);
app.use("/api/jobs", JobRoutes);
app.use("/api", CollegeRoutes);
app.use("/api/news", NewsRoutes);
console.log("Routes registered");
var PORT = process.env.PORT || 5000;
app.listen(PORT, function () {
  return console.log("Server running on port ".concat(PORT));
});