const express = require("express");
const app = express();
const http = require("http");
const server = http.createServer(app);
const helmet = require("helmet");
const morgan = require("morgan");
const logger = require("./middleware/logger");
const user = require("./routes/users");
const cors = require("cors");
const auth = require("./routes/auth");
const group = require("./routes/groups");
const message = require("./routes/messages");
const { Message, validate } = require("./models/message");
const { User } = require("./models/user");
const mongoose = require("mongoose");
const config = require("config");
const _ = require("lodash");
const io = require("socket.io")(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

if (!config.has("jwtPrivateKey")) {
  console.error("FATAL ERROR: jwtPrivateKey is not defined.");
  process.exit(1);
}

const corsOptions = {
  origin: ["*"],
  credentials: true,
};

app.use(cors(corsOptions));

app.use(express.json());
app.use(helmet());
app.use(morgan("tiny"));
app.use(logger);
app.use("/api/user", user);
app.use("/api/message", message);
app.use("/api/auth", auth);
app.use("/api/group", group);

app.get("/", async (req, res) => {
  let friends = await User.find().populate("friendList");

  res.send(friends);
});

io.on("connection", (socket) => {
  var room_name;

  console.log("client connect...", socket.id);

  socket.on("disconnect", () => {});

  socket.on("typing", (data) => {
    var rooms = socket.adapter.rooms;
    // console.log(room_name);
    socket.broadcast.to(room_name).emit("typing", data);
    // io.broadcast.to(room_name).broadcast.emit();
  });

  socket.on("join-friends-room", async (data) => {
    room_name = `${data.sender}-${data.recepient}`;
    var alt_room_name = `${data.recepient}-${data.sender}`;

    var rooms = socket.adapter.rooms;

    if (rooms[room_name] != null) {
      socket.join(room_name);
    } else if (rooms[alt_room_name] != null) {
      socket.join(alt_room_name);
      room_name = alt_room_name;
    } else {
      socket.join(room_name);
    }

    let messages = await Message.find({
      $where: `(this.sender == '${data.sender}' && this.recepient  == '${data.recepient}') || (this.recepient == '${data.sender}' && this.sender  == '${data.recepient}') `,
    });

    messages = JSON.stringify(messages);
    io.to(room_name).emit("chat-message", messages);
  });

  socket.on("leave-friends-room", async (data) => {
    room_name = `${data.sender}-${data.recepient}`;
    var alt_room_name = `${data.recepient}-${data.sender}`;

    var rooms = socket.adapter.rooms;

    socket.leave(room_name);
    socket.leave(alt_room_name);
  });

  socket.on("get-friends", async (data) => {
    let friends = await User.findById(data)
      .populate("friendList friend")
      .select("friendList");

    friends = JSON.stringify(friends);
    io.emit("clientId", friends);
  });

  socket.on("chat-message", async (data) => {
    let message = new Message({
      sender: data.senderId,
      msg: data.msg,
      recepient: data.recipientId,
    });

    await message.save();

    let messages = await Message.find({
      $where: `(this.sender == '${data.senderId}' && this.recepient  == '${data.recipientId}') || (this.recepient == '${data.senderId}' && this.sender  == '${data.recipientId}') `,
    });

    messages = JSON.stringify(messages);

    io.to(room_name).emit("chat-message", messages);
  });

  socket.on("connect", function () {});
});

mongoose
  .connect("mongodb://localhost/chat")
  .then(() => console.log("Connected to MongoDB"))
  .catch((err) => console.error("Could not connect to MongoDB...", err));

const port = process.env.PORT || 8080;

server.listen(port, "0.0.0.0", () => console.log(`Listing on port ${port}...`));
