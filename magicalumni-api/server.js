const express = require("express");
const dotenv = require("dotenv");
const connectDB = require("./config/db");
const userRoutes = require("./routes/userRoutes");
const alumniRoutes = require("./routes/alumniRoutes");
const studentRoutes = require("./routes/studentRoutes");
const eventRoutes = require("./routes/eventRoutes");
const JobRoutes = require("./routes/jobRoutes");
const NewsRoutes = require("./routes/newsRoutes");
const CollegeRoutes = require("./routes/collegeRoutes");
const path = require("path");
dotenv.config();
connectDB();

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/uploads", express.static(path.join(__dirname, "/uploads")));

app.use("/api/users", userRoutes);
app.use("/api", alumniRoutes);
app.use("/api", studentRoutes);
app.use("/api/events", eventRoutes);
app.use("/api/jobs", JobRoutes);
app.use("/api", CollegeRoutes);
app.use("/api/news", NewsRoutes);

console.log("Routes registered");

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
