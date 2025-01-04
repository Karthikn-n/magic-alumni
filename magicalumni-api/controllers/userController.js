const User = require('../models/User');

const getUsers = async (req, res) => {
    const users = await User.find();
    res.json(users);
};

const addUser = async (req, res) => {
    const newUser = new User(req.body);
    await newUser.save();
    res.status(201).json(newUser);
};

module.exports = { getUsers, addUser };
