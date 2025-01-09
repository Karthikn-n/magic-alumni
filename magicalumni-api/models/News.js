import mongoose from "mongoose";

const newsSchema = new mongoose.Schema(
  {
    college_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "College",
      required: true,
    },
    image: {
      type: String,
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    news_posted: {
      type: Date,
      required: true,
    },
    creator_name: {
      type: String,
      required: true,
    },
    location: {
      type: String,
      required: true,
    },
    news_link: {
      type: String,
      required: true,
    },
  },
  { timestamps: true }
);

export default mongoose.model("News", newsSchema);
