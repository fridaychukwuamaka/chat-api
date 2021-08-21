const express = require("express");
const auth = require("../middleware/auth");
const { Group, validate } = require("../models/group");
const { User, validateUser } = require("../models/user");
const router = express.Router();

//create group
router.post("/", auth, async (req, res) => {
  console.log(req.body);
  const { error } = validate(req.body);
  if (error) {
    return res.status(400).send(error.details[0].message);
  }
  let group = new Group({
    name: req.body.name,
    participant: req.body.participant,
  });
  group.save();

  await User.updateOne(
    { _id: req.user._id },
    {
      $push: {
        groupList: group._id,
      },
    }
  );

  group.participant.forEach(async (e) => {
    await User.updateOne(
      { _id: e },
      {
        $push: {
          groupList: group._id,
        },
      }
    );
  });

  res.send(group);
});

router.get("/registered-group", auth, async (req, res) => {
  let user = await User.findById(req.user._id)
    .populate("groupList")
    .select("groupList");
  res.send(user);
});

router.get("/", auth, async (req, res) => {
  /*  let user = await User.findById();
  Group.findById(req.user._id); */
});

module.exports = router;
