const express = require("express");
const Joi = require("joi");
const router = express.Router();
const { User } = require("../models/user");
const bcrypt = require("bcrypt");
const jwt = require('jsonwebtoken');

router.post("/", async (req, res) => {
  const { error } = validateUser(req.body);
  if (error) {
    return res.status(400).send(error.details[0].message);
  }

  let user = await User.findOne({ phone: req.body.phone });

  if (!user) {
    return res.status(400).send("Phone number or password is incorrect");
  }

  isPwdCorrect = await bcrypt.compare(req.body.password, user.password);
  if (!isPwdCorrect) {
    return res.status(400).send("Phone number or password is incorrect");
  }

  let token = user.generateAuthToken();

  res.send(token);
});


router.get("/", async (req, res) => {
  let user = await User.find().select(["-_id"]);

  res.send(user);
});

function validateUser(user) {
  const schema = Joi.object({
    phone: Joi.string().required(),
    password: Joi.string().required(),
  });
  return schema.validate(user);
}

module.exports = router;
