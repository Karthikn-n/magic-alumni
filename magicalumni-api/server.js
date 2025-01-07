const express = require("express");
const dotenv = require("dotenv");
const connectDB = require("./config/db");
const userRoutes = require("./routes/userRoutes");
const alumniRoutes = require("./routes/alumniRoutes");
const studentRoutes = require("./routes/studentRoutes");
const eventRoutes = require("./routes/eventRoutes");
const JobRoutes = require("./routes/jobRoutes");
const DepartmentRoutes = require("./routes/departmentRoutes");
const NewsRoutes = require("./routes/newsRoutes");
const CollegeRoutes = require("./routes/collegeRoutes");
const path = require("path");
const http = require("http");
// const socketIo = require("socket.io");
dotenv.config();
connectDB();

const app = express();

const server = http.createServer(app);
// const io = socketIo(server, {
//   cors: {
//     origin: "*",
//     methods: ["GET", "POST"],
//   },
// });
// let connectedUsers = {};
// io.on("connection", (socket) => {
//   const userId = socket.handshake.query.user_id;
//   if (userId) {
//     connectedUsers[userId] = socket.id;
//   }

//   socket.on("disconnect", () => {
//     delete connectedUsers[userId];
//   });
// });
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
app.use("/api", DepartmentRoutes);
console.log("Routes registered");

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
