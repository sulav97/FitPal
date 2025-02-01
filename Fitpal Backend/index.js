const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const cors = require('cors');
const multer = require('multer');  // Import multer for handling file uploads
const path = require('path');      // To handle file paths

const app = express();

// Middleware to parse JSON bodies and limit body size for larger payloads
app.use(cors());
app.use(bodyParser.json({ limit: '50mb' }));  // Increase the body size limit
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

// Multer setup for handling image uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, './uploads/');  // Folder where images will be stored
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));  // Append timestamp to filename
  }
});

const upload = multer({ storage: storage });

// MongoDB connection (adjust connection string as needed)
mongoose
  .connect('mongodb://localhost:27017/userauthdb')
  .then(() => console.log('MongoDB connected'))
  .catch((err) => console.error('MongoDB connection error:', err));

// Define the User Schema
const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  image: { type: String },  // URL or file path
  dob: { type: Date, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  height: { type: Number, required: true },
  weight: { type: Number, required: true },
});

// Hash the password before saving the user document
userSchema.pre('save', async function (next) {
  if (this.isModified('password')) {
    try {
      const salt = await bcrypt.genSalt(10);
      this.password = await bcrypt.hash(this.password, salt);
    } catch (err) {
      return next(err);
    }
  }
  next();
});

const User = mongoose.model('User', userSchema);

/**
 * @route   POST /signup
 * @desc    Register a new user with image upload
 * @access  Public
 */
app.post('/signup', upload.single('image'), async (req, res) => {
  try {
    const { name, dob, email, password, height, weight } = req.body;

    // Check if user already exists
    let existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Image file is available in req.file (due to multer)
    const image = req.file ? req.file.path : '';  // Save file path

    // Create new user
    const newUser = new User({
      name,
      image,
      dob,
      email,
      password,
      height,
      weight,
    });

    await newUser.save();
    return res.status(201).json({ message: 'User created successfully' });
  } catch (error) {
    console.error('Error in /signup:', error);
    return res.status(500).json({ message: 'Server error' });
  }
});

/**
 * @route   POST /login
 * @desc    Login a user
 * @access  Public
 */
app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user by email
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // Compare provided password with hashed password in the database
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    // Step 3: If login is successful, send user info including their name
    const userInfo = {
        name: user.name,
        email: user.email,
        // Optionally, you can also return a token
        // token: jwt.sign({ userId: user._id }, 'your_secret_key', { expiresIn: '1h' })
      };
  
      return res.status(200).json({
        message: 'Login successful',
        user: userInfo,  // Send back user information (including name)
      });
  } catch (error) {
    console.error('Error in /login:', error);
    return res.status(500).json({ message: 'Server error' });
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
