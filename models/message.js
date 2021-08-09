const mongoose = require("mongoose");
const Joi = require("joi");
const jwt = require("jsonwebtoken");

const messageSchema = new mongoose.Schema({
  sender: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
  msg: {
    type: String,
    required: true,
  },
  date: {
    type: Date,
    default: Date.now,
  },
  recepient: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
  },
});

const Message = mongoose.model("Message", messageSchema);

function validateMessage(message) {
  const schema = Joi.object({
    sender: Joi.string().required(),
    msg: Joi.string().required(),
    recepient: Joi.string().required(),
  });

  return schema.validate(message);
}

exports.Message = Message;
exports.validate = validateMessage;
