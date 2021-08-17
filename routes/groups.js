const express = require("express");
const auth = require("../middleware/auth");
const { Group, validate } = require("../models/group");
const router = express.Router();

router.post("/", auth, async (req, res) => {
    const { error } = validate(req.body);
    if (error) {
        return res.status(400).send(error.details[0].message);
    }
    console.log(req.body);
 /*  let group = new Group({
    name: req.body.name,
    participant: [],
  });

  group.save();
  res.send(group); */
});

router.get("/", auth, async (req, res) => {
    let user = await User.findById();
  Group.findById(req.body._id);
});

module.exports = router;
