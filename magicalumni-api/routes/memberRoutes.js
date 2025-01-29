import express from "express";
import Member from "../models/Member.js";
import MemberCollege from "../models/MemberCollege.js";
import College from "../models/College.js";
import Request from "../models/Request.js";
import Department from "../models/Department.js";
import mongoose from "mongoose";
import Notification from "../models/Notification.js";
import otpGenerator from "otp-generator";
import OTPModel from "../models/OTPModel.js";
import axios from "axios";

const router = express.Router();

router.post("/register", async (req, res) => {
  try {
    const {
      name,
      linkedin_url,
      completed_year,
      current_year,
      college_id,
      mobile_number,
      designation,
      email,
      role,
      department_id,
    } = req.body;

    let existingMember,
      newMember,
      mappedColleges = [];

    if (role) {
      existingMember = await Member.findOne({
        $or: [{ linkedin_url }, { mobile_number }, { email }],
      });

      if (existingMember) {
        return res
          .status(400)
          .json({ status: "not ok", message: "Already exists" });
      }

      newMember = new Member({
        name,
        linkedin_url,
        current_year,
        mobile_number,
        email,
        role: "Student",
      });

      await newMember.save();

      const college = await College.findById(college_id);
      if (!college) {
        return res.status(404).json({
          status: "not found",
          message: `College not found for ID: ${college_id}`,
        });
      }

      const studentCollege = MemberCollege({
        alumni_id: newMember._id,
        college_id,
        department_id,
        current_year,
        status: "approved",
      });

      await studentCollege.save();
      mappedColleges.push(college);
    } else {
      existingMember = await Member.findOne({
        $or: [{ linkedin_url }, { mobile_number }, { email }],
      });
      if (existingMember) {
        return res
          .status(400)
          .json({ status: "not ok", message: "Alumni member already exists" });
      }

      newMember = new Member({
        name,
        linkedin_url,
        mobile_number,
        designation,
        email,
        role: "Alumni",
      });

      await newMember.save();

      const college = await College.findById(college_id);
      if (!college) {
        return res.status(404).json({
          status: "not found",
          message: `College not found for ID: ${college_id}`,
        });
      }

      const alumniCollege = new MemberCollege({
        alumni_id: newMember._id,
        college_id,
        department_id,
        completed_year,
        status: "not approved",
      });

      await alumniCollege.save();
      mappedColleges.push(college);
    }
    const approvalStatus = role ? "approved" : "not approved";
    res.status(201).json({
      status: "ok",
      message: `${role ? "Student" : "Alumni"} registered successfully`,
      _id: newMember._id,
      college_id: college_id,
      role: newMember.role,
      approvalStatus: approvalStatus,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error registering member",
      error: error.message,
    });
  }
});

router.post("/allMembers", async (req, res) => {
  try {
    const { college_id } = req.body;
    if (!mongoose.Types.ObjectId.isValid(college_id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid college_id format",
      });
    }
    const alumniMembers = await MemberCollege.find({
      college_id: college_id,
      status: "approved",
    });
    // console.log(alumniMembers);
    if (alumniMembers.length === 0) {
      return res
        .status(200)
        .json({ status: "ok", message: "No approved alumni members found" });
    }
    const departmentIds = alumniMembers.map((member) => member.department_id);
    const departmentDetails = await Department.find({
      _id: departmentIds,
    });
    const alumniIds = alumniMembers.map((member) => member.alumni_id);
    const alumniDetails = await Member.find({
      _id: alumniIds,
    });
    // const alumniIds = alumniMembers.map((member) => member.alumni_id);
    // const alumniDetails = await Member.find({
    //   _id: alumniIds,
    //   _id: { $ne: alumni_id },
    // }).select("-alumni_id");

    res.status(200).json({
      status: "ok",
      alumniMembers: alumniMembers,
      alumniDetails: alumniDetails,
      departmentDetails: departmentDetails,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving alumni members",
      error: error.message,
    });
  }
});

router.post("/profile", async (req, res) => {
  try {
    const { alumni_id } = req.body;

    if (!alumni_id || !mongoose.Types.ObjectId.isValid(alumni_id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing alumni_id",
      });
    }

    const alumniCollegeData = await MemberCollege.find({
      alumni_id,
    });

    const alumniProfile = await Member.findOne({ _id: alumni_id });

    // if (alumniCollegeData.length === 0) {
    //   return res.status(200).json({
    //     status: "ok",
    //     message: "No approved colleges for this alumni",
    //     alumniProfile: alumniProfile,
    //     colleges: [],
    //   });
    // }

    // const alumni = await AlumniMember.findOne({ _id: alumni_id });

    if (!alumniProfile) {
      return res.status(200).json({
        status: "ok",
        message: "No alumni member found with this ID",
      });
    }

    const collegeDetails = await Promise.all(
      alumniCollegeData.map(async (record) => {
        const college = await College.findOne({ _id: record.college_id });
        const departments = await Department.find({
          _id: record.department_id,
        });
        return {
          ...college._doc,
          completed_year: record.completed_year,
          current_year: record.current_year,
          approvalStatus: record.status,
          departments,
        };
      })
    );

    res.status(200).json({
      status: "ok",
      alumniProfile: alumniProfile,
      colleges: collegeDetails,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving alumni member and college data",
      error: error.message,
    });
  }
});

router.post("/update", async (req, res) => {
  const {
    id,
    name,
    linkedin_url,
    completed_year,
    current_year,
    mobile_number,
    email,
    designation,
  } = req.body;

  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing alumni_id",
      });
    }

    const updatedAlumni = await Member.findByIdAndUpdate(
      id,
      {
        name,
        linkedin_url,
        completed_year,
        current_year,
        mobile_number,
        email,
        designation,
      },
      { new: true }
    );

    if (!updatedAlumni) {
      return res.status(404).json({ message: "Alumni member not found" });
    }

    res.status(200).json({
      status: "ok",
      message: "Updated successfully",
      alumni: updatedAlumni,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating data",
      error: error.message,
    });
  }
});

router.post("/delete", async (req, res) => {
  const { id } = req.body;
  try {
    if (!id || !mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid or missing alumni_id",
      });
    }

    const deletedAlumni = await Member.findByIdAndDelete(id);

    if (!deletedAlumni) {
      return res
        .status(404)
        .json({ status: "not found", message: "Alumni member not found" });
    }
    await MemberCollege.deleteMany({ alumni_id: id });
    res.status(200).json({
      status: "ok",
      message: "Alumni deleted successfully",
      alumni: deletedAlumni,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error deleting alumni member",
      error: error.message,
    });
  }
});

router.post("/newMemberList", async (req, res) => {
  try {
    const { college_id } = req.body;
    const alumniMembers = await MemberCollege.find({
      college_id,
      status: "not approved",
    });
    if (alumniMembers.length === 0) {
      return res
        .status(200)
        .json({ status: "ok", message: "No unapproved alumni members found" });
    }
    const alumniIds = alumniMembers.map((member) => member.alumni_id);
    const alumniDetails = await Member.find({
      _id: alumniIds,
    });
    res.status(200).json({ status: "ok", alumni: alumniDetails });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error retrieving alumni members list",
      error: error.message,
    });
  }
});

router.post("/updateMemberStatus", async (req, res) => {
  const { alumni_id, college_id, status } = req.body;
  try {
    if (!alumni_id || !college_id || !status) {
      return res.status(400).json({
        status: "not ok",
        message: "alumni_id, college_id, and status are required",
      });
    }

    if (
      !mongoose.Types.ObjectId.isValid(alumni_id) ||
      !mongoose.Types.ObjectId.isValid(college_id)
    ) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid alumni_id or college_id",
      });
    }

    const updatedAlumniCollege = await MemberCollege.findOneAndUpdate(
      { alumni_id, college_id },
      { status },
      { new: true }
    );

    if (!updatedAlumniCollege) {
      return res.status(404).json({
        status: "not found",
        message: "No alumni-college mapping found with the provided IDs",
      });
    }

    res.status(200).json({
      status: "ok",
      message: "Alumni status updated successfully",
      alumniCollege: updatedAlumniCollege,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating alumni status",
      error: error.message,
    });
  }
});

router.post("/updateRole", async (req, res) => {
  const { alumni_id, role } = req.body;
  try {
    if (!alumni_id || !role) {
      return res.status(400).json({
        status: "not ok",
        message: "alumni_id, and role are required",
      });
    }

    if (!mongoose.Types.ObjectId.isValid(alumni_id)) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid alumni_id",
      });
    }

    const updatedAlumniRole = await Member.findOneAndUpdate(
      { _id: alumni_id },
      { role },
      { new: true }
    );

    if (!updatedAlumniRole) {
      return res.status(404).json({
        status: "not found",
        message: "No alumni found with the provided ID",
      });
    }

    res.status(200).json({
      status: "ok",
      message: "Alumni role updated successfully",
      alumniRole: updatedAlumniRole,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating alumni role",
      error: error.message,
    });
  }
});

router.post("/login", async (req, res) => {
  try {
    const { mobile_number } = req.body;

    if (!mobile_number) {
      return res
        .status(400)
        .json({ status: "not ok", message: "Mobile number is required" });
    }

    const alumni = await Member.findOne({ mobile_number });

    if (!alumni) {
      return res
        .status(404)
        .json({ status: "not found", message: "Alumni member not found" });
    }

    const otp = otpGenerator.generate(6, {
      upperCase: false,
      specialChars: false,
    });
    const existingOTP = await OTPModel.findOne({
      alumni_id: alumni._id,
      mobile_number,
      otp,
    });
    if (existingOTP) {
      return res
        .status(400)
        .json({ status: "not ok", message: "OTP Already Sent" });
    }
    const otpRecord = new OTPModel({
      alumni_id: alumni._id,
      mobile_number,
      otp,
      expiresAt: Date.now() + 5 * 60 * 1000,
    });

    await otpRecord.save();

    console.log(`OTP for ${mobile_number}: ${otp}`);

    res.status(200).json({
      status: "ok",
      message: "OTP generated and stored successfully",
      mobile_number: alumni.mobile_number,
    });
  } catch (error) {
    console.error("Error processing login request:", error.message);
    res.status(500).json({
      status: "error",
      message: "Error processing login request",
      error: error.message,
    });
  }
});

router.post("/verifyOtp", async (req, res) => {
  try {
    const { mobile_number, otp } = req.body;

    if (!mobile_number || !otp) {
      return res.status(400).json({
        status: "not ok",
        message: "Mobile number and OTP are required",
      });
    }

    const otpRecord = await OTPModel.findOne({
      mobile_number,
      otp,
      expiresAt: { $gt: Date.now() },
    });

    if (!otpRecord) {
      return res
        .status(400)
        .json({ status: "not ok", message: "Invalid or expired OTP" });
    }

    const alumni = await Member.findOne({ mobile_number });

    if (!alumni) {
      return res
        .status(404)
        .json({ status: "not found", message: "Alumni member not found" });
    }
    const approvedAlumni = await MemberCollege.findOne({
      alumni_id: alumni._id,
      status: "approved",
    });
    // console.log(approvedAlumni);
    const approvalStatus = approvedAlumni ? "approved" : "not approved";
    await OTPModel.deleteOne({ _id: otpRecord._id });

    res.status(200).json({
      status: "ok",
      message: "OTP verified successfully",
      alumni_id: alumni._id,
      college_id: approvedAlumni ? approvedAlumni.college_id : null,
      name: alumni.name,
      role: alumni.role,
      approvalStatus: approvalStatus,
    });
  } catch (error) {
    // console.error("Error verifying OTP:", error.message);
    res.status(500).json({
      status: "error",
      message: "Error verifying OTP",
      error: error.message,
    });
  }
});

router.post("/addCollege", async (req, res) => {
  try {
    const {
      college_id,
      alumni_id,
      department_id,
      completed_year,
      current_year,
    } = req.body;

    if (
      !mongoose.Types.ObjectId.isValid(alumni_id) ||
      !mongoose.Types.ObjectId.isValid(college_id) ||
      !mongoose.Types.ObjectId.isValid(department_id)
    ) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid alumni_id, college_id, or department_id",
      });
    }

    const alumni = await Member.findById(alumni_id);

    if (!alumni) {
      return res.status(404).json({
        status: "not found",
        message: "Alumni member not found",
      });
    }

    const alreadyCollege = await MemberCollege.findOne({
      college_id,
      alumni_id,
      department_id,
    });

    if (alreadyCollege) {
      return res.status(400).json({
        status: "not ok",
        message: "College added already",
      });
    }

    const collegeStatus =
      alumni.role === "Student" ? "approved" : "not approved";

    const newCollege = new MemberCollege({
      college_id,
      alumni_id,
      department_id,
      completed_year,
      current_year,
      status: collegeStatus,
    });

    await newCollege.save();

    res.status(201).json({
      status: "ok",
      message: "College added successfully",
      college: newCollege,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error adding college",
      error: error.message,
    });
  }
});

// router.post("/requestMobile", async (req, res) => {
//   try {
//     const { sender, receiver, status, request_id } = req.body;

//     if (
//       !mongoose.Types.ObjectId.isValid(sender) ||
//       !mongoose.Types.ObjectId.isValid(receiver)
//     ) {
//       return res.status(400).json({
//         status: "not ok",
//         message: "Invalid alumni_id, sender, or receiver ID",
//       });
//     }

//     const fakeRequest = await Request.findOne({
//       request_id,
//     });

//     if (fakeRequest) {
//       res.status(400).json({
//         status: "not ok",
//         message: "Request sent already",
//         request: request,
//       });
//     }

//     const request = new Request({
//       sender,
//       receiver,
//       status,
//       request_id,
//     });

//     await request.save();

//     res.status(201).json({
//       status: "ok",
//       message: "Request sent successfully",
//       request: request,
//     });
//   } catch (error) {
//     res.status(500).json({
//       status: "error",
//       message: "Error sending request",
//       error: error.message,
//     });
//   }
// });

router.post("/requestMobile", async (req, res) => {
  try {
    const { sender, receiver, status, request_id } = req.body;

    if (
      !mongoose.Types.ObjectId.isValid(sender) ||
      !mongoose.Types.ObjectId.isValid(receiver)
    ) {
      return res.status(400).json({
        status: "not ok",
        message: "Invalid sender or receiver ID",
      });
    }

    // Check if the request ID already exists
    const fakeRequest = await Request.findOne({ request_id });
    if (fakeRequest) {
      return res.status(400).json({
        status: "not ok",
        message: "Request sent already",
        request: fakeRequest,
      });
    }

    // Fetch sender data from the database
    const senderData = await Member.findById(sender);
    if (!senderData) {
      return res.status(404).json({
        status: "not ok",
        message: "Sender not found",
      });
    }

    // Create a new request
    const request = new Request({
      sender,
      receiver,
      status,
      request_id,
    });
    await request.save();

    const notification = new Notification({
      user_id: receiver,
      type: "request",
      title: "New Request Received",
      message: `You have a new request from ${senderData.name || "a user"}`,
      data: {
        request_id,
        sender: {
          id: senderData._id,
          name: senderData.name,
          email: senderData.email,
        },
        status,
      },
      status: "unread", // Default status
      created_at: new Date(),
    });

    await notification.save();

    // Prepare OneSignal notification payload
    const oneSignalConfig = {
      app_id: process.env.ONESIGNAL_APP_ID,
      include_external_user_ids: [receiver], // Send to the receiver's external ID
      headings: { en: "New Request Received" },
      contents: {
        en: `You have a new request from ${senderData.name || "a user"}`,
      },
      data: {
        type: "request",
        request_id: request_id,
        sender: {
          id: senderData._id,
          name: senderData.name,
          email: senderData.email,
        },
        status,
      },
      buttons: [
        {
          id: "accept", // Unique ID for the button
          text: "Accept Request", // Button text
          icon: "https://your-app.com/icons/accept.png", // (Optional) Icon URL
        },
        {
          id: "reject", // Unique ID for the button
          text: "Reject Request", // Button text
          icon: "https://your-app.com/icons/reject.png", // (Optional) Icon URL
        },
      ],
    };

    // Send notification through OneSignal
    try {
      const oneSignalResponse = await axios.post(
        "https://onesignal.com/api/v1/notifications",
        oneSignalConfig,
        {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Basic ${process.env.ONESIGNAL_API_KEY}`,
          },
        }
      );
      console.log("Notification sent:", oneSignalResponse.data);
    } catch (notificationError) {
      console.error(
        "Failed to send OneSignal notification:",
        notificationError.response?.data || notificationError.message
      );
    }

    // Respond with success
    res.status(201).json({
      status: "ok",
      message: "Request sent successfully and notification pushed",
      request: request,
      senderData: senderData,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error sending request",
      error: error.message,
    });
  }
});

router.post("/requestStatusUpdate", async (req, res) => {
  try {
    const { request_id, status } = req.body;

    if (!request_id) {
      return res.status(400).json({
        status: "not ok",
        message: "Request ID is required",
      });
    }

    const updateRequestStatus = await Request.findOneAndUpdate(
      { request_id: request_id },
      { status: status },
      { new: true }
    );

    res.status(200).json({
      status: "ok",
      message: "Request status updated successfully",
      updateRequestStatus: updateRequestStatus,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating request status",
      error: error.message,
    });
  }
});

router.post("/requestStatus", async (req, res) => {
  try {
    const { request_id } = req.body;

    if (!request_id) {
      return res.status(400).json({
        status: "not ok",
        message: "Request ID is required",
      });
    }

    const request = await Request.findOne({ request_id });

    if (!request) {
      return res.status(404).json({
        status: "not ok",
        message: "Request not found",
      });
    }

    let response = {
      status: "ok",
      message: "Request status fetched successfully",
      requestStatus: request.status,
    };

    if (request.status === "allowed") {
      const receiverProfile = await Member.findOne({ _id: request.receiver });
      if (receiverProfile) {
        response.receiverMobileNumber = receiverProfile.mobile_number;
      } else {
        console.error(
          `Receiver profile not found for receiver ID: ${request.receiver}`
        );
      }
    }

    res.status(200).json(response);
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error fetching request status",
      error: error.message,
    });
  }
});

router.post("/requestList", async (req, res) => {
  try {
    const { receiver_id } = req.body;

    if (!receiver_id) {
      return res.status(400).json({
        status: "not ok",
        message: "Receiver ID is required",
      });
    }

    const requestList = await Request.find({ receiver: receiver_id });

    const requestsWithSenderProfiles = await Promise.all(
      requestList.map(async (request) => {
        const senderProfile = await Member.findOne({ _id: request.sender });
        return {
          ...request._doc,
          senderProfile,
        };
      })
    );

    res.status(200).json({
      status: "ok",
      message: "Request list retrieved successfully",
      requestList: requestsWithSenderProfiles,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating request status",
      error: error.message,
    });
  }
});

router.post("/membersCount", async (req, res) => {
  try {
    const { college_id } = req.body;
    if (!college_id) {
      return res
        .status(400)
        .json({ status: "not ok", message: "College ID is required" });
    }
    const memberPeople = await MemberCollege.find({
      college_id,
      status: "approved",
    });
    const memberPeopleCountOff = memberPeople.length;
    res.status(200).json({
      status: "ok",
      message: "Data generated",
      memberPeople: memberPeople,
      memberPeopleCountOff: memberPeopleCountOff,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating status",
      error: error.message,
    });
  }
});

router.post("/unApprovedMembersCount", async (req, res) => {
  try {
    const { college_id } = req.body;
    if (!college_id) {
      return res
        .status(400)
        .json({ status: "not ok", message: "College ID is required" });
    }
    const memberPeople = await MemberCollege.find({
      college_id,
      status: "not approved",
    });
    const memberPeopleCountOff = memberPeople.length;
    res.status(200).json({
      status: "ok",
      message: "Data generated",
      memberPeople: memberPeople,
      memberPeopleCountOff: memberPeopleCountOff,
    });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error updating status",
      error: error.message,
    });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const alumni = await Member.findById(req.params.id);

    if (!alumni) {
      return res
        .status(404)
        .json({ status: "not ok", message: "Alumni not found" });
    }

    const alumniID = alumni._id;

    const alumniCollegeData = await MemberCollege.find({ alumni_id: alumniID })
      .populate("college_id")
      .populate("department_id");

    const alumniWithCollegeData = {
      ...alumni.toObject(),
      alumniCollegeData,
    };

    res.status(200).json({ status: "ok", alumni: alumniWithCollegeData });
  } catch (error) {
    res.status(500).json({
      status: "error",
      message: "Error fetching member details",
      error: error.message,
    });
  }
});

export default router;
