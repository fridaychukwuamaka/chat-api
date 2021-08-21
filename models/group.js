const mongoose = require("mongoose");
const Joi = require("joi");
const config = require("config");
const jwt = require("jsonwebtoken");

const groupSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  participant: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  ],
});

groupSchema.methods.generateAuthToken = function () {
  let token = jwt.sign({ _id: this._id }, config.get("jwtPrivateKey"));
  return token;
};

const Group = mongoose.model("Group", groupSchema);

function validateGroup(group) {
  const schema = Joi.object({
    name: Joi.string().required(),
    participant: Joi.array(),
  });

  return schema.validate(group);
}

exports.Group = Group;
exports.validate = validateGroup;
