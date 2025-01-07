const mongoose = require("mongoose");

const eventPeopleSchema = new mongoose.Schema({
  event_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Event",
    required: true,
  },
  alumni_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "AlumniMember",
    required: true,
  },
  interested: {
    type: String,
    required: true,
  },
});

const EventPeople = mongoose.model("EventPeople", eventPeopleSchema);
module.exports = EventPeople;
