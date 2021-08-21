const express = require("express");
const jwt = require("jsonwebtoken");
const config = require("config");
const router = express.Router();
const { User, validate } = require("../models/user");
const _ = require("lodash");
const auth = require("../middleware/auth");
const bcrypt = require("bcrypt");

const saltRounds = 10;

router.post("/register", async (req, res) => {
  const { error } = validate(req.body);
  if (error) {
    return res.status(400).send(error.details[0].message);
  }

  let user = await User.findOne({ phone: req.body.phone });

  if (user) {
    return res.status(400).send("User  with phone number already registered");
  }

  user = new User({
    username: req.body.username,
    phone: req.body.phone,
    password: req.body.password,
    friendList: [],
  });
  user.password = await bcrypt.hash(req.body.password, saltRounds);

  await user.save();

  let token = user.generateAuthToken();

  res
    .header("x-auth-token", token)
    .send(_.pick(user, ["_id", "username", "phone"]));
});

router.get("/", auth, async (req, res) => {
  const token = req.header("x-auth-token");

  if (!token) {
    return res.status(401).send("Access denied. No token provided");
  }
 let user = await User.findById(req.user._id);

 res.send(_.pick(user, ["_id", "username", "phone"]));
});

router.get("/friends", auth, async (req, res) => {
  let user = await User.findById(req.user._id)
    .populate("friendList")
    .select("friendList");
  res.send(user);
});

module.exports = router;
