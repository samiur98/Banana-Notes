const express = require('express')
const app = express()
const current_port = 3020 || process.ENV.port
const user_router = require('./routes/users')
app.use('/users', user_router)

app.listen(current_port, () => {
    console.log(`Listening on port ${current_port}.`)

})