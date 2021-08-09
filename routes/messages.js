const express = require("express");
const auth = require("../middleware/auth");
const {Message, validate} = require('../models/message');
const router = express.Router();

router.post("/", auth, async (req, res) => {
     const { error } = validate(req.body);
     if (error) {
       return res.status(400).send(error.details[0].message);
     }
    let message = new Message({
        sender: req.body.sender,
        msg: req.body.msg,
        recepient:  req.body.recepient
    });

    message.save();
    res.send(message);
});

router.get("/", auth, async (req, res) => {
  res.send("user");
});

module.exports = router;
