import express from "express";
import mongoose from "mongoose";
import AdminJS from "adminjs";
import cors from "cors";
import AdminJSExpress from "@adminjs/express";
import * as AdminJSMongoose from "@adminjs/mongoose";
import { ComponentLoader } from "adminjs";
import dotenv from "dotenv";
import path from "path";
import User from "./models/User.js";
import College from "./models/College.js";
import Member from "./models/Member.js";
import Notification from "./models/Notification.js";
import Department from "./models/Department.js";
import News from "./models/News.js";
import Event from "./models/Event.js";
import Request from "./models/Request.js";
import Job from "./models/Job.js";
import { fileURLToPath } from "url";
import bodyParser from "body-parser";
import multer from "multer";
import session from "express-session";
import bcrypt from "bcrypt";
import userRoutes from "./routes/userRoutes.js";
import collegeRoutes from "./routes/collegeRoutes.js";
import departmentRoutes from "./routes/departmentRoutes.js";
import newsRoutes from "./routes/newsRoutes.js";
import memberRoutes from "./routes/memberRoutes.js";
import eventRoutes from "./routes/eventRoutes.js";
import jobRoutes from "./routes/jobRoutes.js";
import notificationRoutes from "./routes/NotificationRoutes.js";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/news");
  },
  filename: (req, file, cb) => {
    cb(
      null,
      `${file.fieldname}-${Date.now()}${path.extname(file.originalname)}`
    );
  },
});

const upload = multer({
  storage: storage,
  limits: { fileSize: 1000000 },
  fileFilter: (req, file, cb) => {
    const filetypes = /jpeg|jpg|png|gif/;
    const mimetype = filetypes.test(file.mimetype);
    const extname = filetypes.test(
      path.extname(file.originalname).toLowerCase()
    );

    if (mimetype && extname) {
      return cb(null, true);
    } else {
      cb("Error: Images Only!");
    }
  },
}).single("image");

app.use(bodyParser.json());
app.use("/api/users", userRoutes);
app.use("/api/colleges", collegeRoutes);
app.use("/api/department", departmentRoutes);
app.use("/api/news", newsRoutes);
app.use("/api/member", memberRoutes);
app.use("/api/event", eventRoutes);
app.use("/api/job", jobRoutes);
app.use("/api/notification", notificationRoutes);
app.use("/uploads", express.static("uploads"));

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

AdminJS.registerAdapter({
  Resource: AdminJSMongoose.Resource,
  Database: AdminJSMongoose.Database,
});

const componentLoader = new ComponentLoader();

const authenticate = async (email, password) => {
  try {
    const user = await User.findOne({ email }).exec();
    if (user && (await bcrypt.compare(password, user.password))) {
      return user;
    }
    return null;
  } catch (err) {
    console.error("Authentication error:", err);
    return null;
  }
};

const admin = new AdminJS({
  resources: [
    User,
    College,
    Department,
    News,
    Member,
    Event,
    Job,
    Request,
    Notification,
  ],
  rootPath: "/admin",
  branding: {
    companyName: "Magic Alumni",
  },
});

const adminRouter = AdminJSExpress.buildAuthenticatedRouter(
  admin,
  {
    authenticate,
    cookieName: "adminjs",
    cookiePassword: "supersecret",
  },
  null,
  {
    resave: false,
    saveUninitialized: true,
    secret: "supersecret",
    store: new session.MemoryStore(),
  }
);

app.use(admin.options.rootPath, adminRouter);

mongoose
  .connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB connected"))
  .catch((err) => console.log(err));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(
    `AdminJS running at http://localhost:${PORT}${admin.options.rootPath}`
  );
  console.log(`API running at http://localhost:${PORT}/api/users`);
  console.log(`API running at http://localhost:${PORT}/api/colleges`);
  console.log(`API running at http://localhost:${PORT}/api/department`);
  console.log(`API running at http://localhost:${PORT}/api/news`);
  console.log(`API running at http://localhost:${PORT}/api/member`);
  console.log(`API running at http://localhost:${PORT}/api/event`);
  console.log(`API running at http://localhost:${PORT}/api/job`);
});
