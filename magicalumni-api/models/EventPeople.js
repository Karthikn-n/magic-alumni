import mongoose from "mongoose";

const eventPeopleSchema = new mongoose.Schema({
  event_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Event",
    required: true,
  },
  alumni_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Member",
    required: true,
  },
  interested: {
    type: String,
    required: true,
  },
});

export default mongoose.model("EventPeople", eventPeopleSchema);
