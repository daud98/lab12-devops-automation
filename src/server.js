const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Log incoming requests
app.use((req, res, next) => {
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);
    next();
});

// Root route
app.get('/', (req, res) => {
    res.json({
        status: "Success",
        message: "Welcome to the DevOps Automation Lab application!",
        environment: process.env.NODE_ENV || "development"
    });
});

// Health check endpoint required by your Docker Compose healthcheck configuration
app.get('/health', (req, res) => {
    res.status(200).json({ 
        status: "UP",
        timestamp: new Date().toISOString()
    });
});

// Start the server
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Application successfully bound and listening on port ${PORT}`);
});